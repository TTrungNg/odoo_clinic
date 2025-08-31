#!/bin/bash

# Odoo Clinic Development Script
echo "🏥 Odoo Clinic Development Environment"
echo "====================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    print_info "Creating virtual environment..."
    python3 -m venv venv
    print_status "Virtual environment created"
fi

# Activate virtual environment
print_info "Activating virtual environment..."
source venv/bin/activate
print_status "Virtual environment activated"

# Check if Odoo is installed
if ! command -v odoo &> /dev/null; then
    print_warning "Odoo command not found. Installing Odoo..."
    pip install --upgrade pip
    pip install odoo
    print_status "Odoo installed"
fi

# Install/update requirements
print_info "Installing/updating Python dependencies..."
pip install -r requirements.txt --quiet
print_status "Dependencies installed"

# Start PostgreSQL with Docker Compose
print_info "Starting PostgreSQL database..."
if docker-compose up -d postgres; then
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
    sleep 1
done

# Check if odoo.conf exists
if [ ! -f "config/odoo.conf" ]; then
    print_error "Configuration file config/odoo.conf not found!"
    exit 1
fi

print_info "Starting Odoo server..."
print_info "Access your application at: http://localhost:8069"
print_info "PgAdmin available at: http://localhost:5050"
print_info "Press Ctrl+C to stop the server"
echo

# Start Odoo
odoo -c config/odoo.conf
