package main

import (
	"context"
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"time"

	_ "github.com/lib/pq"
	"github.com/redis/go-redis/v9"
	delivery "github.com/user/audionara/backend/internal/delivery/http"
	"github.com/user/audionara/backend/internal/repository"
	"github.com/user/audionara/backend/internal/usecase"
	"github.com/user/audionara/backend/pkg/email"
	"github.com/user/audionara/backend/pkg/env"
)

func main() {
	env.Load()

	// 1. Connect to DB
	dbURL := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
		env.GetWithDefault("DB_HOST", "postgres"),
		env.GetWithDefault("DB_PORT", "5432"),
		env.GetWithDefault("DB_USER", "audionara_user"),
		env.GetWithDefault("DB_PASSWORD", "my_super_secret_password"),
		env.GetWithDefault("DB_NAME", "audionara"),
	)
	db, err := sql.Open("postgres", dbURL)
	if err != nil {
		log.Fatalf("Failed to open DB: %v", err)
	}
	defer db.Close()

	// Wait for DB to be ready
	for i := 0; i < 5; i++ {
		if err = db.Ping(); err == nil {
			break
		}
		log.Printf("Waiting for database... (%d/5)", i+1)
		time.Sleep(2 * time.Second)
	}

	// 2. Run Migrations (Schema initialization)
	if _, err := db.Exec(repository.InitSchema); err != nil {
		log.Fatalf("Failed to initialize database schema: %v", err)
	}

	// 3. Setup Dependencies
	emailSvc := email.NewSMTPEmailService()

	// Connect to Redis
	redisURL := env.GetWithDefault("REDIS_URL", "redis:6379")
	rdb := redis.NewClient(&redis.Options{
		Addr: redisURL,
	})

	cacheRepo := repository.NewCacheRepository(rdb)
	deezerRepo := repository.NewDeezerRepository(cacheRepo)
	historyRepo := repository.NewHistoryRepository(db)
	trackUC := usecase.NewTrackUseCase(deezerRepo, historyRepo, cacheRepo)


	playlistRepo := repository.NewPostgresPlaylistRepository(db)
	playlistUC := usecase.NewPlaylistUseCase(playlistRepo)

	userRepo := repository.NewPostgresUserRepository(db)
	userUC := usecase.NewUserUseCase(userRepo, emailSvc)
	homeUC := usecase.NewHomeUseCase(historyRepo, cacheRepo)

	handler := delivery.NewHandler(trackUC, playlistUC, userUC, homeUC)

	mux := http.NewServeMux()
	mux.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprint(w, `{"status":"ok"}`)
	})

	// Serve static files for uploaded cover arts
	fs := http.FileServer(http.Dir("./uploads"))
	mux.Handle("/uploads/", http.StripPrefix("/uploads/", fs))

	handler.RegisterRoutes(mux)

	go warmCatalog(trackUC)

	port := env.GetWithDefault("APP_PORT", "8080")
	log.Printf("server listening on :%s", port)

	// Chain middlewares: RateLimiter -> GlobalError -> Mux
	handlerChain := delivery.RateLimitMiddleware(delivery.GlobalErrorMiddleware(mux))

	if err := http.ListenAndServe(":"+port, handlerChain); err != nil {
		log.Fatalf("server: %v", err)
	}
}

func warmCatalog(uc *usecase.TrackUseCase) {
	time.Sleep(2 * time.Second)
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()
	if tracks, err := uc.SearchRaw(ctx, "Global Top 50", 4, 0, true, 256); err == nil {
		uc.PreFetchStreamURLs(tracks, 2, true, 256)
	}
}
