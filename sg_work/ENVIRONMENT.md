# Sewaghar — Environment Variables Reference

All variables go in `sg_work/backend/.env` (copy `.env.example` as a starting point).  
Variables marked **Required** must be set or the server will refuse to start.  
Variables marked **Optional** are validated if set; the associated feature returns a `503` error if they are absent when called.

---

## Core Server

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `NODE_ENV` | No | `development` | One of `development`, `staging`, `production`. Controls logging verbosity and error detail in responses. |
| `PORT` | No | `4000` | TCP port the Express server listens on. |

---

## Database

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `DATABASE_URL` | **Yes** | — | Full PostgreSQL connection string including credentials and database name. PostGIS must be enabled on the target database. Example: `postgresql://user:pass@localhost:5432/marketplace` |

---

## Redis

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `REDIS_URL` | **Yes** | — | Redis connection URL. Used for OTP caching and session management. Example: `redis://localhost:6379` or `rediss://user:pass@host:6380` for TLS. |

---

## JWT Authentication

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `JWT_ACCESS_SECRET` | **Yes** | — | Secret for signing access tokens. **Minimum 32 characters.** Use a cryptographically random string. |
| `JWT_REFRESH_SECRET` | **Yes** | — | Secret for signing refresh tokens. Must differ from `JWT_ACCESS_SECRET`. **Minimum 32 characters.** |
| `JWT_ACCESS_EXPIRES_IN` | No | `15m` | Access token lifetime. Uses [ms](https://github.com/vercel/ms) format: `15m`, `1h`, `2d`. |
| `JWT_REFRESH_EXPIRES_IN` | No | `7d` | Refresh token lifetime. |

---

## SMS / OTP (Twilio) — Requires Your Own Account

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `TWILIO_ACCOUNT_SID` | Optional | — | Twilio Account SID from the [Twilio Console](https://console.twilio.com). |
| `TWILIO_AUTH_TOKEN` | Optional | — | Twilio Auth Token. |
| `TWILIO_PHONE_NUMBER` | Optional | — | The "From" phone number in E.164 format, e.g. `+977...`. |

> **Without Twilio:** OTP is generated and logged to the console in development mode only. Never deploy this behaviour to production.

---

## File Storage (S3 / Cloudflare R2) — Requires Your Own Account

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `S3_ACCESS_KEY` | Optional | — | AWS or R2 access key ID. |
| `S3_SECRET_KEY` | Optional | — | AWS or R2 secret access key. |
| `S3_REGION` | Optional | — | Bucket region, e.g. `ap-south-1` or `auto` for R2. |
| `S3_BUCKET` | Optional | — | Bucket name for certificate and portfolio uploads. |

> Used for professional certificate and portfolio image uploads.

---

## Frontend URLs (CORS)

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `CLIENT_URL` | No | `http://localhost:3000` | Allowed origin for the customer-facing frontend. Added to CORS whitelist and Socket.IO CORS config. |
| `ADMIN_URL` | No | `http://localhost:3001` | Allowed origin for the admin panel. |

---

## eSewa Payment Gateway — Requires Your Own Account

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `ESEWA_BASE_URL` | Optional | `https://uat.esewa.com.np/api/epay/main/v2` | API base URL. Use `https://esewa.com.np/api/epay/main/v2` for production. |
| `ESEWA_MERCHANT_CODE` | Optional | — | Your merchant code issued by eSewa. |
| `ESEWA_SECRET_KEY` | Optional | — | HMAC secret used to sign payment requests. |

> Missing configuration returns `503 Service Unavailable` when a payment endpoint is called.

---

## Khalti Payment Gateway — Requires Your Own Account

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `KHALTI_BASE_URL` | Optional | `https://a.khalti.com/api/v2` | API base URL. |
| `KHALTI_SECRET_KEY` | Optional | — | Your secret key from the [Khalti Merchant Dashboard](https://merchant.khalti.com). |

> Missing configuration returns `503 Service Unavailable` when a payment endpoint is called.

---

## Bank Transfer Details

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `BANK_NAME` | Optional | — | Name of the bank shown to customers during bank-transfer payment. |
| `BANK_ACCOUNT` | Optional | — | Bank account number. |
| `BANK_ACCOUNT_HOLDER` | Optional | — | Account holder name. |
| `BANK_QR_BASE_URL` | Optional | — | Base URL for the QR code image for bank transfers. |

---

## Firebase Admin SDK — Requires Your Own Account

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `FIREBASE_SERVICE_ACCOUNT` | Optional | — | JSON-stringified Firebase service account key (the full contents of the `.json` file, compacted to a single line). Used for FCM push notifications. Generate one at **Firebase Console → Project Settings → Service accounts → Generate new private key**. |

> To compact: `cat serviceAccount.json | jq -c .`

---

## Google Maps API — Requires Your Own Account

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `GOOGLE_MAPS_API_KEY` | Optional | — | Used by the backend ETA/distance endpoint (`GET /api/v1/search/eta`). Enable the **Directions API** and **Distance Matrix API** in the Google Cloud Console. The Flutter app requires separate Android and iOS keys configured directly in the native project files — see SETUP.md. |

---

## Generating Strong Secrets

```bash
# Generate a 64-character random secret (macOS / Linux)
openssl rand -hex 32

# Or with Node.js
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```
