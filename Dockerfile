# ==== BUILD ====
FROM node:20-alpine AS build
WORKDIR /app

# Copy package files first (best caching)
COPY package*.json ./
COPY package-lock.json* ./
COPY angular.json tsconfig*.json ./

# Install deps
RUN npm ci --legacy-peer-deps --loglevel=error

# Copy source
COPY src ./src
COPY *.html *.ico *.json ./

# Build production
RUN npm run build -- --configuration production

# ==== RUN ====
FROM nginx:alpine
COPY --from=build /app/dist/HelloAngular/browser /usr/share/nginx/html

# Fix SPA routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80