# Multi-stage build for optimized production image
FROM node:18-alpine AS base

# Install security updates and required packages
RUN apk update && apk upgrade && \
    apk add --no-cache dumb-init && \
    rm -rf /var/cache/apk/*

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S algofi -u 1001

# Set working directory
WORKDIR /app

# Copy package files for dependency installation
COPY package*.json ./
COPY server/package*.json ./server/

# Development stage
FROM base AS development
ENV NODE_ENV=development
RUN npm ci --include=dev
RUN cd server && npm ci --include=dev
COPY . .
EXPOSE 3000 8000
USER algofi
CMD ["npm", "run", "dev"]

# Build stage for production
FROM base AS builder
ENV NODE_ENV=production

# Install dependencies
RUN npm ci --only=production && npm cache clean --force
RUN cd server && npm ci --only=production && npm cache clean --force

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM node:18-alpine AS production

# Install security updates
RUN apk update && apk upgrade && \
    apk add --no-cache dumb-init && \
    rm -rf /var/cache/apk/*

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S algofi -u 1001

# Set working directory
WORKDIR /app

# Copy built application and dependencies
COPY --from=builder --chown=algofi:nodejs /app/dist ./dist
COPY --from=builder --chown=algofi:nodejs /app/server ./server
COPY --from=builder --chown=algofi:nodejs /app/package*.json ./
COPY --from=builder --chown=algofi:nodejs /app/public ./public

# Install production dependencies only
RUN npm ci --only=production && npm cache clean --force

# Set environment variables
ENV NODE_ENV=production
ENV PORT=8000
ENV FRONTEND_PORT=3000

# Expose ports
EXPOSE 8000

# Use non-root user
USER algofi

# Use dumb-init for proper signal handling
ENTRYPOINT ["dumb-init", "--"]

# Start the application
CMD ["node", "server/index.js"]