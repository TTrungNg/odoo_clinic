#!/bin/bash

# 🏥 Odoo Clinic Setup Script
echo "🏥 Setting up Odoo Clinic Development Environment"
echo "=============================================="

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
    print_warning "Docker is not running. Please start Docker Desktop and try again."
    print_info "Opening Docker Desktop..."
    open /Applications/Docker.app
    print_info "Waiting for Docker to start..."
    
    # Wait for Docker to start
    for i in {1..60}; do
        if docker info &> /dev/null; then
            print_status "Docker is now running"
            break
        fi
        if [ $i -eq 60 ]; then
            print_error "Docker startup timeout. Please start Docker Desktop manually."
            exit 1
        fi
        sleep 2
    done
else
    print_status "Docker is running"
fi

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    print_info "Creating virtual environment..."
    python3 -m venv venv
    print_status "Virtual environment created"
fi

# Activate virtual environment
print_info "Activating virtual environment..."
source venv/bin/activate
print_status "Virtual environment activated"

# Upgrade pip
print_info "Upgrading pip..."
pip install --upgrade pip --quiet

# Install/upgrade requirements
print_info "Installing Python dependencies..."
pip install -r requirements.txt --quiet
print_status "Dependencies installed"

# Install Odoo if not available
if ! command -v odoo &> /dev/null; then
    print_info "Installing Odoo..."
    pip install odoo --quiet
    print_status "Odoo installed"
else
    print_status "Odoo is already available"
fi

# Start PostgreSQL database
print_info "Starting PostgreSQL database..."
docker-compose up -d postgres
if [ $? -eq 0 ]; then
    print_status "Database container started"
else
    print_error "Failed to start database container"
    exit 1
fi

# Wait for database to be ready
print_info "Waiting for database to be ready..."
for i in {1..30}; do
    if docker-compose exec -T postgres pg_isready -U odoo &>/dev/null; then
        print_status "Database is ready"
        break
    fi
    if [ $i -eq 30 ]; then
        print_error "Database startup timeout"
        exit 1
    fi
    sleep 2
done

print_status "Setup completed successfully!"
echo
print_info "🚀 Ready to start development!"
print_info "Run: ./dev-start.sh to start Odoo"
print_info "Or run: source venv/bin/activate && odoo -c config/odoo.conf"
print_info "Access: http://localhost:8069"
print_info "PgAdmin: http://localhost:5050"
