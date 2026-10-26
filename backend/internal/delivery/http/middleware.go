package http

import (
	"bytes"
	"context"
	"encoding/json"
	"net/http"
	"strings"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/user/audionara/backend/pkg/env"
)

type errorResponseWriter struct {
	http.ResponseWriter
	statusCode int
	body       *bytes.Buffer
}

func (rw *errorResponseWriter) WriteHeader(code int) {
	rw.statusCode = code
	if code < 400 {
		rw.ResponseWriter.WriteHeader(code)
	}
}

func (rw *errorResponseWriter) Write(b []byte) (int, error) {
	if rw.statusCode >= 400 {
		return rw.body.Write(b)
	}
	return rw.ResponseWriter.Write(b)
}

func extractErrorMessage(statusCode int, body []byte) string {
	var original struct {
		Message *string `json:"message"`
		Error   *string `json:"error"`
	}
	msg := http.StatusText(statusCode)
	if err := json.Unmarshal(body, &original); err == nil {
		if original.Message != nil && *original.Message != "" {
			return *original.Message
		}
		if original.Error != nil && *original.Error != "" {
			return *original.Error
		}
	}
	return msg
}

func GlobalErrorMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		rw := &errorResponseWriter{
			ResponseWriter: w,
			statusCode:     200,
			body:           bytes.NewBuffer(nil),
		}

		defer func() {
			if err := recover(); err != nil {
				writeStrictError(w, http.StatusInternalServerError, "Internal Server Error")
			} else if rw.statusCode >= 400 {
				writeStrictError(w, rw.statusCode, extractErrorMessage(rw.statusCode, rw.body.Bytes()))
			}
		}()

		next.ServeHTTP(rw, r)
	})
}

func writeStrictError(w http.ResponseWriter, statusCode int, message string) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(statusCode)
	_ = json.NewEncoder(w).Encode(APIResponse{
		Success: false,
		Code:    mapStatusCodeToErrorCode(statusCode),
		Message: message,
		Meta:    ResponseMeta{Timestamp: time.Now().UTC().Format(time.RFC3339)},
	})
}

func mapStatusCodeToErrorCode(statusCode int) string {
	switch statusCode {
	case http.StatusBadRequest:
		return "BAD_REQUEST"
	case http.StatusUnauthorized:
		return "UNAUTHENTICATED"
	case http.StatusForbidden:
		return "UNAUTHORIZED"
	case http.StatusNotFound:
		return "NOT_FOUND"
	case http.StatusConflict:
		return "CONFLICT"
	case http.StatusUnprocessableEntity:
		return "VALIDATION_ERROR"
	default:
		return "INTERNAL_ERROR"
	}
}

type contextKey string

const UserIDKey contextKey = "user_id"

func AuthMiddleware(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		authHeader := r.Header.Get("Authorization")
		if authHeader == "" {
			writeJSON(w, http.StatusUnauthorized, envelope{Error: strPtr(ErrMissingAuthHeader)})
			return
		}
		parts := strings.Split(authHeader, " ")
		if len(parts) != 2 || parts[0] != "Bearer" {
			writeJSON(w, http.StatusUnauthorized, envelope{Error: strPtr(ErrInvalidAuthFormat)})
			return
		}
		tokenString := parts[1]
		secret := env.GetWithDefault("JWT_SECRET", "super_secret_jwt_key")
		token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
			if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
				return nil, jwt.ErrSignatureInvalid
			}
			return []byte(secret), nil
		})
		if err != nil || !token.Valid {
			writeJSON(w, http.StatusUnauthorized, envelope{Error: strPtr(ErrInvalidOrExpiredToken)})
			return
		}
		claims, ok := token.Claims.(jwt.MapClaims)
		if !ok {
			writeJSON(w, http.StatusUnauthorized, envelope{Error: strPtr(ErrInvalidTokenClaims)})
			return
		}
		userID, ok := claims["sub"].(string)
		if !ok {
			writeJSON(w, http.StatusUnauthorized, envelope{Error: strPtr(ErrInvalidUserIDInToken)})
			return
		}
		ctx := context.WithValue(r.Context(), UserIDKey, userID)
		next.ServeHTTP(w, r.WithContext(ctx))
	}
}
