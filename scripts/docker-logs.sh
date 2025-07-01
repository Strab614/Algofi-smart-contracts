#!/bin/bash

# Docker logs script
set -e

SERVICE=${1:-algofi-tracker}
LINES=${2:-100}

echo "📋 Showing logs for $SERVICE (last $LINES lines)..."

case $SERVICE in
  "app"|"algofi-tracker")
    docker-compose logs --tail=$LINES -f algofi-tracker
    ;;
  "nginx")
    docker-compose logs --tail=$LINES -f nginx
    ;;
  "dev")
    docker-compose -f docker-compose.dev.yml logs --tail=$LINES -f algofi-tracker-dev
    ;;
  "all")
    docker-compose logs --tail=$LINES -f
    ;;
  *)
    echo "Usage: $0 [app|nginx|dev|all] [lines]"
    echo "  app   - Show application logs"
    echo "  nginx - Show nginx logs"
    echo "  dev   - Show development logs"
    echo "  all   - Show all logs"
    exit 1
    ;;
esac