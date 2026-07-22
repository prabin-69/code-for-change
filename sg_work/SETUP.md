# Sewaghar — Complete Setup Guide

> Step-by-step instructions for running the backend, Flutter app, database, and Docker stack from scratch.

---

## Prerequisites

| Tool | Minimum version | Notes |
|------|-----------------|-------|
| Node.js | 18 LTS | Required for backend |
| pnpm / npm | any | `npm` is bundled with Node |
| Docker & Docker Compose | v2 | Used for Postgres, Redis, Nginx |
| Flutter SDK | 3.10+ | For the mobile app |
| Dart SDK | ≥ 3.0 | Bundled with Flutter |
| Android Studio / Xcode | latest stable | Emulators / simulators |

---

## 1 — Clone & Configure Environment

```bash
# Clone (or extract the ZIP) into your working directory
unzip sewaghar_COMPLETE.zip -d sewaghar
cd sewaghar/sg_work/backend

# Copy the example env file and fill in your values
cp .env.example .env
```

Open `.env` and fill in **at minimum** these required variables before proceeding:

```
DATABASE_URL=postgresql://marketplace:changeme@localhost:5432/marketplace
REDIS_URL=redis://localhost:6379
JWT_ACCESS_SECRET=<random-64-char-string>
JWT_REFRESH_SECRET=<random-64-char-string>
```

All optional third-party keys (Twilio, Firebase, eSewa, Khalti, etc.) can be left blank for now — the server starts cleanly without them but those features will return a 503 error if called.

See [ENVIRONMENT.md](./ENVIRONMENT.md) for the full variable reference.

---

## 2 — Option A: Run with Docker (Recommended)

This starts PostgreSQL (PostGIS), Redis, the backend API, and Nginx in one command.

```bash
cd sg_work/backend

# Build and start all services
docker compose up --build -d

# Check logs
docker compose logs -f backend
```

**Service ports:**
| Service | Host port |
|---------|-----------|
| Backend API | `http://localhost:4000` |
| Nginx proxy | `http://localhost:80` |
| PostgreSQL | `localhost:5432` |
| Redis | `localhost:6379` |

### Run database migrations inside Docker

```bash
docker compose exec backend npx prisma migrate deploy
docker compose exec backend npx prisma db seed
```

### Stop services

```bash
docker compose down            # stop, keep data
docker compose down -v         # stop and delete volumes
```

---

## 3 — Option B: Run without Docker

### 3a. Start Postgres and Redis locally

Install PostgreSQL (≥ 14 with PostGIS) and Redis, then start them. Alternatively use [DBngin](https://dbngin.com/) on macOS.

Create the database:

```sql
CREATE USER marketplace WITH PASSWORD 'changeme';
CREATE DATABASE marketplace OWNER marketplace;
-- Enable PostGIS on the database
\c marketplace
CREATE EXTENSION IF NOT EXISTS postgis;
```

### 3b. Install backend dependencies

```bash
cd sg_work/backend
npm install
```

### 3c. Run Prisma migrations and seed

```bash
npx prisma generate
npx prisma migrate deploy
npx prisma db seed
```

### 3d. Start the backend in development mode

```bash
npm run dev
# → Server starts at http://localhost:4000
# → Swagger UI at http://localhost:4000/api-docs
```

### 3e. Build for production

```bash
npm run build   # TypeScript → dist/
npm start       # runs dist/server.js
```

---

## 4 — Flutter App

### 4a. Set the backend URL

The app defaults to `http://10.0.2.2:4000` for Android emulators (maps to the host machine). To change it:

**Option 1 — Dart define at build time (preferred):**

```bash
flutter run --dart-define=API_BASE_URL=http://<your-backend-ip>:4000
```

**Option 2 — Edit the constant:**

```
lib/core/constants/api_constants.dart → defaultValue
```

### 4b. Add Firebase configuration

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com).
2. Register your Android app (`com.sewaghar.app`) and download `google-services.json` → place in `android/app/`.
3. Register your iOS app and download `GoogleService-Info.plist` → place in `ios/Runner/`.

This is required for push notifications. The app starts without Firebase but notifications will be silently disabled.

### 4c. Add Google Maps API key

1. Enable the **Maps SDK for Android** and **Maps SDK for iOS** in your Google Cloud project.
2. Android: add the key in `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <meta-data android:name="com.google.android.geo.API_KEY"
              android:value="YOUR_KEY_HERE" />
   ```
3. iOS: add the key in `ios/Runner/AppDelegate.swift`:
   ```swift
   GMSServices.provideAPIKey("YOUR_KEY_HERE")
   ```

### 4d. Run the Flutter app

```bash
cd sg_work
flutter pub get
flutter run           # pick a connected device / emulator
```

---

## 5 — Verify the Backend

```bash
# Health check (should return {"status":"ok"})
curl http://localhost:4000/health

# Swagger UI
open http://localhost:4000/api-docs
```

---

## 6 — Admin Dashboard

The admin panel is an embedded React application located at:

```
sg_work/backend/src/modules/admin/src/
```

It is excluded from the main TypeScript build (`tsconfig.json`). To run it separately:

```bash
cd sg_work/backend/src/modules/admin
npm install
npm start   # starts on http://localhost:3001
```

---

## 7 — Running Tests

```bash
cd sg_work/backend
npm test
```

---

## 8 — Deployment Checklist

Before going to production:

- [ ] Change all default passwords and JWT secrets
- [ ] Set `NODE_ENV=production`
- [ ] Configure an SMS provider (Twilio) for OTP delivery
- [ ] Configure Firebase for push notifications
- [ ] Configure eSewa/Khalti keys for payment processing
- [ ] Configure S3 / Cloudflare R2 for file uploads
- [ ] Set `CLIENT_URL` and `ADMIN_URL` to your real domains
- [ ] Configure Nginx SSL certificates
- [ ] Run `prisma migrate deploy` on the production database
