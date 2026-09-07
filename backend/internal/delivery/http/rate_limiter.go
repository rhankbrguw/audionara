package http

import (
	"net/http"
	"strings"
	"sync"

	"golang.org/x/time/rate"
)

// Rate limiter variables
var (
	clients = make(map[string]*rate.Limiter)
	mu      sync.Mutex
)

// getVisitorLimiter retrieves or creates a rate limiter for an IP
func getVisitorLimiter(ip string) *rate.Limiter {
	mu.Lock()
	defer mu.Unlock()

	limiter, exists := clients[ip]
	if !exists {
		// 10 requests per second, burst of 20
		limiter = rate.NewLimiter(10, 20)
		clients[ip] = limiter
	}

	return limiter
}

// RateLimitMiddleware blocks IPs that exceed the request limit
func RateLimitMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		ip := r.RemoteAddr
		if strings.Contains(ip, ":") {
			ip = strings.Split(ip, ":")[0]
		}

		limiter := getVisitorLimiter(ip)
		if !limiter.Allow() {
			writeStrictError(w, http.StatusTooManyRequests, "Too Many Requests - Rate Limit Exceeded")
			return
		}

		next.ServeHTTP(w, r)
	})
}
