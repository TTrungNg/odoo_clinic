# Odoo Clinic Development Instructions

This is an Odoo 18 clinic management system running in Docker containers with custom addons for healthcare workflows.

## Architecture Overview

**Docker-First Development**: The project uses official `odoo:18.0` image with PostgreSQL 15, eliminating local Odoo installations. All development happens through volume mounts to `./addons:/mnt/extra-addons`.

**Service Stack**:
- Odoo App (`localhost:8069`) - Main application server
- PostgreSQL (`localhost:5432`) - Database with credentials `odoo/odoo`
- PgAdmin (`localhost:5050`) - Database admin UI (`admin@clinic.com/admin123`)

**Volume Architecture**: Hot-reload enabled through Docker volumes. Code changes in `addons/` are immediately reflected without container restarts.

## Essential Commands

```bash
# Start entire stack
./docker-start.sh

# View live logs
./logs-view.sh

# Stop all services
./docker-stop.sh

# Reset database completely
docker-compose down -v && ./docker-start.sh

# Execute commands in Odoo container
docker-compose exec odoo bash
docker-compose exec odoo odoo scaffold new_module /mnt/extra-addons
```

## Addon Development Patterns

**Module Structure**: Follow standard Odoo structure in `addons/`:
```
clinic_management/
├── __manifest__.py         # Required: dependencies, data files, application=True
├── __init__.py            # Import models package
├── models/__init__.py     # Import individual model files
└── models/patient.py      # Model: _name='clinic.patient', inherit=['mail.thread']
```

**Model Conventions**:
- Use `clinic.` prefix for model names (`clinic.patient`, `clinic.doctor`)
- Inherit `['mail.thread', 'mail.activity.mixin']` for communication features
- Add `tracking=True` to important fields for audit trail

**View Integration**: Reference views in `__manifest__.py` data array. Views auto-reload through Docker volumes.

## Database & Configuration

**Master Password**: `admin123` (configured in `config/odoo.conf`)

**Database Management**: Use PgAdmin UI or direct PostgreSQL commands:
```bash
# Backup/restore through container
docker-compose exec postgres pg_dump -U odoo postgres > backup.sql
docker-compose exec -T postgres psql -U odoo postgres < backup.sql
```

**Config Location**: `config/odoo.conf` mounted to container. Key settings:
- `addons_path = /mnt/extra-addons,/usr/lib/python3/dist-packages/odoo/addons`
- `workers = 0` (development mode)
- Master password and database connection details

## Development Workflow

1. **Start**: `./docker-start.sh` (pulls images, starts stack)
2. **Develop**: Edit files in `addons/` - changes immediately visible
3. **Install/Update**: Use Odoo UI (Apps → Update Apps List)
4. **Debug**: Check `./logs-view.sh` for real-time debugging
5. **Database**: Access via browser at `localhost:8069` or PgAdmin at `localhost:5050`

**Hot Reload**: Odoo automatically detects file changes in mounted `addons/` directory without restarts.

## Key Files to Reference

- `docker-compose.yml` - Service definitions and volume mounts
- `config/odoo.conf` - Odoo configuration including addons_path
- `addons/clinic_management/__manifest__.py` - Example addon structure
- `DEVELOPMENT.md` - Comprehensive Vietnamese documentation
