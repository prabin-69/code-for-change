# Sewaghar — Changelog

All notable changes to this project are documented here.

---

## [Repair Pass 2] — 2026-07-19

### Flutter — Bug Fixes

#### `lib/core/network/api_client.dart` *(created)*
- **Why:** `eta_display.dart` imported `api_client.dart` which did not exist. This caused a compilation error.
- **Fix:** Created `ApiClient` as a thin, injectable wrapper around `DioClient`. Exposes `get`, `post`, `put`, `patch`, and `delete` methods that delegate to the underlying `Dio` instance (with its auth and logging interceptors intact).

#### `lib/core/constants/api_constants.dart` *(modified)*
- **Why:** `eta_display.dart` referenced `ApiConstants.eta` which was not defined, causing a compile-time error.
- **Fix:** Added `static const String eta = '$apiBase/search/eta'` with a documentation comment explaining the expected query parameters and response shape.

### Backend — Bug Fixes

#### `src/types/socket.d.ts` *(created)*
- **Why:** `server.ts` and `chat.socket.ts` attached `userId` and `userRole` to `Socket` instances via unsafe `(socket as any)` casts, bypassing TypeScript's type system entirely.
- **Fix:** Created a module augmentation declaration for `socket.io` that adds `userId?: string` and `userRole?: string` to the `Socket` interface.

#### `src/server.ts` *(modified)*
- **Why:** Socket auth middleware used `(socket as any).userId` and `(socket as any).userRole` — unsafe `as any` casts that bypass type checking.
- **Fix:** Replaced both casts with direct typed property assignments (`socket.userId = ...`, `socket.userRole = ...`) made possible by the new `socket.d.ts` augmentation. Added `import './types/socket'` (side-effect import) to load the augmentation.

#### `src/modules/chat/chat.socket.ts` *(modified)*
- **Why:** Same `(socket as any).userId` cast used when reading the authenticated user ID inside socket event handlers.
- **Fix:** Replaced cast with direct `socket.userId!` access. Added `import '../../types/socket'` side-effect import.

#### `src/modules/professionals/professionals.service.ts` — `acceptRequest` *(modified)*
- **Why:** The original implementation read the `ServiceRequest` status and then updated it in two separate Prisma operations. Under concurrent load two professionals could both observe `status='pending'` and each proceed to create a `Job`, resulting in a duplicate job and an incorrect `total_jobs` count.
- **Fix:** Replaced the two-step read-then-update with a single conditional `updateMany({ where: { id, status: 'pending' }, data: ... })` inside the transaction. This atomically claims the request; if `count === 0` the request was already taken and a `ConflictError` is thrown.

#### `src/modules/payments/gateways/khalti.service.ts` *(modified)*
- **Why:** When `KHALTI_SECRET_KEY` was not configured the gateway silently sent empty-string credentials to Khalti, which responded with a 401. The error propagated as a generic "payment initiation failed" with no actionable message.
- **Fix:** Added `assertConfigured()` guard that throws `AppError(503)` with a clear message before any HTTP call is made. Updated logger calls to structured Pino-compatible `logger.error({ error }, msg)` style.

#### `src/modules/payments/gateways/esewa.service.ts` *(modified)*
- **Why:** Same pattern as Khalti — empty `merchantCode`/`secretKey` produced silent 4xx errors from eSewa. The `merchant_id` field was also missing from the request body.
- **Fix:** Added `assertConfigured()` guard. Added `merchant_id: this.merchantCode` to the payment request payload. Updated logger calls to structured style.

### Documentation *(created)*

| File | Description |
|------|-------------|
| `SETUP.md` | Complete step-by-step installation guide for backend (Docker and bare-metal), Flutter app, admin dashboard, and tests. |
| `ENVIRONMENT.md` | Full reference for every environment variable with type, default, and usage notes. |
| `CHANGELOG.md` (this file) | Running log of all changes across both repair passes. |
| `TEST_REPORT.md` | Static analysis and manual test results. |
| `FINAL_CHECKLIST.md` | Project readiness checklist. |

---

## [Repair Pass 1] — Prior

*(Pre-existing documentation from the original repair pass — contents preserved below.)*

Previous fixes addressed:
- Malformed `package.json` JSON syntax
- Missing Prisma relation fields (`accepted_by` scalar on `ServiceRequest`, etc.)
- Missing Flutter packages (`url_launcher`, `flutter_secure_storage`)
- Flutter `injection/dependency_injection.dart` incomplete registrations
- Backend `auth.events.ts`, `subscriptions.events.ts`, `professionals.events.ts` wiring
- Docker Compose and Nginx configuration validated
- Swagger spec registered at `/api-docs`
