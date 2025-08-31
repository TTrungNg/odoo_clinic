#!/bin/bash

# Odoo Clinic Start Script
echo "Starting Odoo Clinic..."

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install requirements
echo "Installing Python dependencies..."
pip install -r requirements.txt

# Start PostgreSQL with Docker Compose
echo "Starting PostgreSQL database..."
docker-compose up -d postgres

# Wait for database to be ready
echo "Waiting for database to be ready..."
sleep 10

# Start Odoo
echo "Starting Odoo server..."
odoo -c config/odoo.conf
