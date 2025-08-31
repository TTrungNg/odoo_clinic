#!/bin/bash

# 🏥 Odoo Clinic Docker Start Script
echo "🏥 Starting Odoo Clinic with Docker"
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Check if Docker is running
print_info "Checking Docker status..."
if ! docker info &> /dev/null; then
    print_error "Docker is not running. Please start Docker Desktop."
    print_info "Opening Docker Desktop..."
    open /Applications/Docker.app
    exit 1
fi
print_status "Docker is running"

# Create necessary directories
print_info "Creating directories..."
mkdir -p filestore logs
print_status "Directories created"

# Set proper permissions
print_info "Setting permissions..."
chmod 755 filestore logs
print_status "Permissions set"

# Pull latest Odoo image
print_info "Pulling Odoo 18 Docker image..."
docker-compose pull odoo
print_status "Odoo image updated"

# Start services
print_info "Starting all services..."
if docker-compose up -d; then
    print_status "All services started successfully"
else
    print_error "Failed to start services"
    exit 1
fi

# Wait for services to be ready
print_info "Waiting for services to be ready..."
sleep 10

# Check if Odoo is accessible
for i in {1..30}; do
    if curl -s http://localhost:8069 > /dev/null; then
        print_status "Odoo is ready!"
        break
    fi
    if [ $i -eq 30 ]; then
        print_warning "Odoo may still be starting up..."
        break
    fi
    sleep 2
done

echo
print_status "🚀 Odoo Clinic is now running!"
echo
print_info "📱 Access your application:"
print_info "   • Odoo:    http://localhost:8069"
print_info "   • PgAdmin: http://localhost:5050"
echo
print_info "📋 Credentials:"
print_info "   • Master Password: admin123"
print_info "   • PgAdmin: admin@clinic.com / admin123"
echo
print_info "🛠 Development:"
print_info "   • Custom addons: ./addons/"
print_info "   • Logs: ./logs/odoo.log"
print_info "   • Stop: ./docker-stop.sh or Ctrl+C"
echo
print_info "📖 View logs: docker-compose logs -f odoo"
