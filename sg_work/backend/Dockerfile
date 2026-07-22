FROM node:18-alpine

WORKDIR /app

RUN apk add --no-cache openssl

COPY package*.json ./

# Install all packages including devDependencies
RUN npm ci

COPY . .

RUN npx prisma generate

RUN npm run build

CMD ["node", "dist/server.js"]