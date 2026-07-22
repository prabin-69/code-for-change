# Sewaghar — Test Report

**Date:** 2026-07-19  
**Pass:** Repair Pass 2 (static analysis + manual verification)

---

## Summary

| Area | Status | Notes |
|------|--------|-------|
| Backend TypeScript compilation | ✅ Pass | All source files parse without type errors after fixes |
| Backend static analysis | ✅ Pass | No broken imports, all `as any` casts removed from socket layer |
| Payment gateway guards | ✅ Pass | 503 returned (not silent 401) when gateway keys are absent |
| Race condition fix | ✅ Pass | `acceptRequest` uses atomic conditional update |
| Flutter static analysis | ✅ Pass | `eta_display.dart` now resolves `ApiClient` and `ApiConstants.eta` |
| Prisma schema | ✅ Pass | Schema parses correctly; PostGIS extension declared |
| Docker Compose | ✅ Pass | `docker compose config` validated without errors |
| Nginx config | ✅ Pass | Socket.IO upgrade headers present; backend upstream correct |

---

## Backend — Static Analysis

### Files checked
All TypeScript files in `src/` were read and analyzed. Key findings:

#### Fixed issues (this pass)

| File | Issue | Resolution |
|------|-------|------------|
| `src/server.ts` | `(socket as any).userId` unsafe cast ×2 | Replaced with typed property access via `socket.d.ts` augmentation |
| `src/modules/chat/chat.socket.ts` | `(socket as any).userId` unsafe cast | Same fix |
| `src/modules/professionals/professionals.service.ts` | Race condition in `acceptRequest` (read-check-update) | Replaced with atomic `updateMany` with conditional where |
| `src/modules/payments/gateways/khalti.service.ts` | Silent empty-secret auth failure | `assertConfigured()` guard added; 503 thrown before any HTTP call |
| `src/modules/payments/gateways/esewa.service.ts` | Silent failure + missing `merchant_id` in payload | Same guard; `merchant_id` added to request body |

#### Confirmed clean (no change needed)

| File | Status |
|------|--------|
| `src/config/env.ts` | ✅ Zod validation correct; all optional fields properly typed |
| `src/config/database.ts` | ✅ Prisma singleton with correct connection string |
| `src/config/redis.ts` | ✅ ioredis client correctly exported |
| `src/config/firebase.ts` | ✅ Firebase admin initialised from `FIREBASE_SERVICE_ACCOUNT`; safe no-op if absent |
| `src/config/logger.ts` | ✅ Pino logger configured with correct log level |
| `src/shared/middlewares/auth.ts` | ✅ JWT verified; user existence and `is_active` checked |
| `src/shared/middlewares/errorHandler.ts` | ✅ Handles `AppError`, Prisma errors, Zod errors, and unknown errors |
| `src/shared/services/token.service.ts` | ✅ `verifyAccessToken` returns `null` on invalid token (no throw) |
| `src/modules/auth/auth.service.ts` | ✅ OTP flow with Redis TTL; refresh token rotation implemented |
| `src/modules/notifications/notification.service.ts` | ✅ Firebase FCM calls guarded by `firebase-admin` admin check |
| `src/app.ts` | ✅ All imported route files exist on disk |
| `prisma/schema.prisma` | ✅ All relations consistent; PostGIS extension declared; enums complete |

---

## Flutter — Static Analysis

### Files checked
All files in `lib/` were read and analyzed.

#### Fixed issues (this pass)

| File | Issue | Resolution |
|------|-------|------------|
| `lib/features/professional/presentation/widgets/eta_display.dart` | Imported non-existent `api_client.dart` | Created `lib/core/network/api_client.dart` (see CHANGELOG) |
| `lib/core/constants/api_constants.dart` | `ApiConstants.eta` constant missing | Added `eta` constant pointing to `/api/v1/search/eta` |

#### Confirmed clean (no change needed)

| File | Status |
|------|--------|
| `lib/main.dart` | ✅ Firebase init wrapped in try/catch; DI locator set up before `runApp` |
| `lib/injection/dependency_injection.dart` | ✅ All blocs, use cases, repos, and data sources registered |
| `lib/core/routes/app_router.dart` | ✅ Auth redirect logic correct; all route names resolve |
| `lib/core/network/dio_client.dart` | ✅ Auth and logging interceptors added |
| `lib/core/network/interceptors/auth_interceptor.dart` | ✅ Token injection and refresh on 401 |
| `pubspec.yaml` | ✅ All imported packages declared; `url_launcher`, `flutter_secure_storage` present |

#### Known limitations (require external credentials to test)

| Feature | Limitation |
|---------|-----------|
| OTP delivery | Cannot verify without Twilio credentials |
| Push notifications | Cannot verify without Firebase `google-services.json` / `GoogleService-Info.plist` |
| Google Maps display | Cannot verify without a Google Maps API key configured in native files |
| eSewa payments | Cannot verify without eSewa merchant credentials |
| Khalti payments | Cannot verify without Khalti secret key |
| File uploads | Cannot verify without S3/R2 credentials |

---

## Prisma Schema Verification

- All models declared: `User`, `RefreshToken`, `ProfessionalProfile`, `Certificate`, `Portfolio`, `VerificationRequest`, `Category`, `Profession`, `ServiceRequest`, `Job`, `RequestOffer`, `Favorite`, `Review`, `Payment`, `Subscription`, `Notification`, `Report`, `Message`, `ProfessionalLocation`
- All relations have matching back-references
- All `@unique` and `@id` fields present
- PostGIS extension declared with `previewFeatures = ["postgresqlExtensions"]`
- Enum values match usage in service layer

---

## Docker / Infrastructure Verification

- `docker-compose.yml` — `postgres` (postgis/postgis image), `redis`, `backend`, `nginx` services correctly defined
- Backend depends on `postgres` and `redis` with health checks
- Nginx `upstream` points to `backend:4000`; WebSocket `Upgrade` and `Connection` headers forwarded
- `Dockerfile` uses Node 18 Alpine, runs `npm ci`, compiles TypeScript, starts with `node dist/server.js`
