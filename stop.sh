#!/bin/bash

# Odoo Clinic Stop Script
echo "Stopping Odoo Clinic services..."

# Stop Docker containers
echo "Stopping database..."
docker-compose down

echo "All services stopped."
