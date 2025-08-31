# Odoo Clinic Management System

Hệ thống quản lý phòng khám sử dụng Odoo 18 với Docker.

## Cấu trúc dự án

```
odoo_clinic/
├── addons/              # Custom addons cho dự án
├── config/
│   └── odoo.conf       # File cấu hình Odoo
├── filestore/          # Lưu trữ file uploads (auto-created)
├── logs/               # Log files (auto-created)
├── docker-compose.yml  # Docker services configuration
├── docker-start.sh     # Script khởi động Docker
├── docker-stop.sh      # Script dừng Docker
└── logs-view.sh        # Xem logs real-time
```

## Yêu cầu hệ thống

- Docker Desktop
- Docker Compose (đi kèm với Docker Desktop)

## Cài đặt và chạy

### 🚀 Quick Start

```bash
# Khởi động tất cả services
./docker-start.sh
```

### � Dừng services

```bash
./docker-stop.sh
```

### 📋 Xem logs

```bash
./logs-view.sh
```

### 4. Truy cập ứng dụng

- **Odoo**: http://localhost:8069
- **PgAdmin**: http://localhost:5050 (admin@clinic.com / admin123)

## Services

### Odoo Container
- **Image**: odoo:18.0
- **Port**: 8069
- **Volumes**: Custom addons, config, filestore, logs

### Database Container  
- **Image**: postgres:15
- **Port**: 5432
- **Database**: postgres
- **User/Password**: odoo/odoo

### PgAdmin Container
- **Image**: dpage/pgadmin4
- **Port**: 5050
- **Credentials**: admin@clinic.com / admin123

## Scripts có sẵn

- **`./docker-start.sh`**: Khởi động tất cả Docker containers
- **`./docker-stop.sh`**: Dừng tất cả Docker containers  
- **`./logs-view.sh`**: Xem logs real-time
- **Legacy scripts**: `start.sh`, `dev-start.sh`, `setup.sh` (không cần thiết với Docker)

## Quy trình phát triển

### Hàng ngày:
1. **Khởi động**: `./docker-start.sh`
2. **Phát triển**: Chỉnh sửa code trong `addons/`
3. **Test**: Reload browser (Odoo tự động reload với Docker volumes)
4. **Xem logs**: `./logs-view.sh`
5. **Dừng**: `./docker-stop.sh`

### Lưu ý Docker:
- **Hot reload**: Code changes trong `addons/` sẽ tự động được phản ánh
- **Persistent data**: Database và filestore được lưu trong Docker volumes
- **Reset database**: `docker-compose down -v` để xóa tất cả data

### Xem chi tiết: [`DEVELOPMENT.md`](DEVELOPMENT.md)