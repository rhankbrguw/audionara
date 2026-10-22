# AudioNara

High-performance music streaming platform. Go backend, Flutter cross-platform client. PostgreSQL 16 for persistence, Redis 7 for caching, Resend for transactional emails.

---

Clone it, copy `backend/.env.example` to `backend/.env`, then run with Docker or natively.

Backend (Docker): `docker compose up -d` (runs on `:8080`, Postgres on `:5432`, Redis on `:6379`).

Backend (Host): `cd backend && go run ./cmd/server` (requires local Postgres & Redis).

Client (Flutter): `cd frontend && flutter pub get && flutter run`.

Production Build: `cd frontend && flutter build apk --dart-define=API_BASE_URL=https://api-audionara.rhankbrguw.xyz`.

---

Requires Go 1.23+, Flutter 3.24+, Docker, PostgreSQL 16, Redis 7.

