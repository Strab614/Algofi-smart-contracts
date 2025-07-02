# Multi-stage build for optimized production image
FROM node:18-alpine AS base

# Install security updates and required packages
RUN apk update && apk upgrade && \
    apk add --no-cache dumb-init curl && \
    rm -rf /var/cache/apk/*

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S algofi -u 1001

# Set working directory
WORKDIR /app

# Development stage
FROM base AS development
ENV NODE_ENV=development

# Copy package files first for better caching
COPY package*.json ./
COPY server/package*.json ./server/

# Install all dependencies (including dev dependencies)
RUN npm install && npm cache clean --force
RUN cd server && npm install && npm cache clean --force

# Copy source code
COPY . .

# Change ownership to non-root user
RUN chown -R algofi:nodejs /app

EXPOSE 3000 8000
USER algofi
CMD ["npm", "run", "dev"]

# Build stage for production
FROM base AS builder
ENV NODE_ENV=production

# Copy package files
COPY package*.json ./
COPY server/package*.json ./server/

# Install dependencies using npm install instead of npm ci to avoid lock file issues
RUN npm install --only=production && npm cache clean --force
RUN cd server && npm install --only=production && npm cache clean --force

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM node:18-alpine AS production

# Install security updates and required packages
RUN apk update && apk upgrade && \
    apk add --no-cache dumb-init curl && \
    rm -rf /var/cache/apk/*

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S algofi -u 1001

# Set working directory
WORKDIR /app

# Copy built application and dependencies from builder stage
COPY --from=builder --chown=algofi:nodejs /app/dist ./dist
COPY --from=builder --chown=algofi:nodejs /app/server ./server
COPY --from=builder --chown=algofi:nodejs /app/package*.json ./
COPY --from=builder --chown=algofi:nodejs /app/public ./public
COPY --from=builder --chown=algofi:nodejs /app/node_modules ./node_modules

# Set environment variables
ENV NODE_ENV=production
ENV PORT=8000
ENV FRONTEND_PORT=3000

# Create logs directory
RUN mkdir -p /app/logs && chown -R algofi:nodejs /app/logs

# Expose ports
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:8000/api/health || exit 1

# Use non-root user
USER algofi

# Use dumb-init for proper signal handling
ENTRYPOINT ["dumb-init", "--"]

# Start the application
CMD ["node", "server/index.js"]