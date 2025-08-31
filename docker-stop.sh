#!/bin/bash

# 🏥 Odoo Clinic Docker Stop Script
echo "🏥 Stopping Odoo Clinic Docker containers"
echo "========================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Stop all containers
print_info "Stopping Docker containers..."
docker-compose down

print_status "All containers stopped"
echo
print_info "To completely remove data (reset):"
print_info "docker-compose down -v"
