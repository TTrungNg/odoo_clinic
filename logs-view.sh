#!/bin/bash

# 🏥 Odoo Clinic Logs Viewer
echo "🏥 Odoo Clinic Logs"
echo "=================="

# Colors for output
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Check if services are running
if ! docker-compose ps | grep -q "Up"; then
    print_info "No containers are running. Start with: ./docker-start.sh"
    exit 1
fi

print_info "Following Odoo logs (Ctrl+C to exit)..."
echo

# Follow logs
docker-compose logs -f odoo
