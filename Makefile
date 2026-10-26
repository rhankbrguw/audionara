.PHONY: all backend frontend clean help

all: help

help:
	@echo "Usage:"
	@echo "  make up          - Start the backend services (Postgres, Redis, Go Backend) via Docker Compose"
	@echo "  make down        - Stop all backend services"
	@echo "  make logs        - Follow Docker Compose logs"
	@echo "  make flutter-run - Run the Flutter application"
	@echo "  make flutter-get - Install Flutter dependencies"

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

flutter-run:
	cd frontend && flutter run

flutter-get:
	cd frontend && flutter pub get

build-apk:
	cd frontend && flutter build apk --release --android-skip-build-dependency-validation --dart-define=API_BASE_URL=https://api-audionara.rhankbrguw.xyz
	@echo "✅ Build completed: APK generated in frontend/build/app/outputs/flutter-apk/app-release.apk"

