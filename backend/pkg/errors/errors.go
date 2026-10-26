package errors

import "net/http"

// Standard error codes aligned with AGENTS.md registry
const (
	CodeValidation   = "VALIDATION_ERROR"
	CodeUnauth       = "UNAUTHENTICATED"
	CodeUnauthorized = "UNAUTHORIZED"
	CodeNotFound     = "NOT_FOUND"
	CodeConflict     = "CONFLICT"
	CodeInternal     = "INTERNAL_ERROR"
	CodeBadRequest   = "BAD_REQUEST"
	CodeOK           = "OK"
)

// AppError represents a structured error response for the API
type AppError struct {
	HTTPStatus int                 `json:"-"`
	Code       string              `json:"code"`
	Message    string              `json:"message"`
	Errors     map[string][]string `json:"errors,omitempty"`
}

// Error implements the error interface
func (e *AppError) Error() string {
	return e.Message
}

// Common industry-grade errors
var (
	ErrInvalidRequestFormat = &AppError{
		HTTPStatus: http.StatusBadRequest,
		Code:       CodeBadRequest,
		Message:    "Invalid request format.",
	}
	ErrInternalServer = &AppError{
		HTTPStatus: http.StatusInternalServerError,
		Code:       CodeInternal,
		Message:    "An unexpected error occurred. Please try again later.",
	}
	ErrUnauthorized = &AppError{
		HTTPStatus: http.StatusUnauthorized,
		Code:       CodeUnauth,
		Message:    "Unauthorized access.",
	}
	ErrForbidden = &AppError{
		HTTPStatus: http.StatusForbidden,
		Code:       CodeUnauthorized,
		Message:    "You do not have permission to perform this action.",
	}
)

// NewAppError creates a custom AppError with automatic code mapping
func NewAppError(httpStatus int, message string) *AppError {
	code := CodeInternal
	switch httpStatus {
	case http.StatusBadRequest:
		code = CodeBadRequest
	case http.StatusUnauthorized:
		code = CodeUnauth
	case http.StatusForbidden:
		code = CodeUnauthorized
	case http.StatusNotFound:
		code = CodeNotFound
	case http.StatusConflict:
		code = CodeConflict
	case http.StatusUnprocessableEntity:
		code = CodeValidation
	}
	return &AppError{
		HTTPStatus: httpStatus,
		Code:       code,
		Message:    message,
	}
}
