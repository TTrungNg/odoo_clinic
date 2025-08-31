# 🏥 Hướng dẫn phát triển Odoo Clinic (Docker)

## 🚀 Quy trình phát triển hàng ngày

### 1. Khởi động môi trường phát triển

```bash
# Khởi động tất cả services
./docker-start.sh
```

### 2. Phát triển

```bash
# Chỉnh sửa code trong addons/
# Code sẽ tự động được reload nhờ Docker volumes

# Xem logs real-time
./logs-view.sh
```

### 3. Dừng services

```bash
./docker-stop.sh
```

## 🐳 Docker Commands

### Container Management

```bash
# Xem containers đang chạy
docker-compose ps

# Restart specific service
docker-compose restart odoo
docker-compose restart postgres

# Execute command trong container
docker-compose exec odoo bash
docker-compose exec postgres psql -U odoo

# Xem logs
docker-compose logs odoo
docker-compose logs postgres
docker-compose logs -f odoo  # Follow logs
```

### Database Management

```bash
# Backup database
docker-compose exec postgres pg_dump -U odoo postgres > backup.sql

# Restore database  
docker-compose exec -T postgres psql -U odoo postgres < backup.sql

# Access database directly
docker-compose exec postgres psql -U odoo postgres
```

## 🔧 Phát triển Custom Addons

### Tạo addon mới

```bash
# Vào thư mục addons
cd addons

# Tạo addon mới bằng Odoo scaffold
docker-compose exec odoo odoo scaffold my_new_module /mnt/extra-addons

# Hoặc copy từ addon mẫu
cp -r clinic_management my_new_module
```

### Cấu trúc addon

```
my_module/
├── __init__.py
├── __manifest__.py
├── models/
│   ├── __init__.py
│   └── my_model.py
├── views/
│   ├── my_views.xml
│   └── menu_views.xml
├── security/
│   └── ir.model.access.csv
├── data/
│   └── data.xml
└── static/
    ├── description/
    │   └── icon.png
    └── src/
        ├── css/
        ├── js/
        └── xml/
```

### Cài đặt/Cập nhật addon

1. **Truy cập Odoo**: http://localhost:8069
2. **Apps** → **Update Apps List**
3. Tìm và **Install** addon của bạn
4. Hoặc **Upgrade** nếu đã cài đặt

### Debug Mode

1. **Bật Debug mode**: Thêm `?debug=1` vào URL
2. **Technical menu**: Settings → Technical
3. **View metadata**: Debug → View Metadata

### Hot Reload

Code changes trong `addons/` sẽ tự động được phản ánh nhờ Docker volumes. Không cần restart container.

## 📊 Database Management

### Truy cập PgAdmin
- URL: http://localhost:5050
- Email: admin@clinic.com
- Password: admin123

### Backup/Restore Database

```bash
# Backup
docker-compose exec postgres pg_dump -U odoo odoo_clinic > backup.sql

# Restore
docker-compose exec -T postgres psql -U odoo -d odoo_clinic < backup.sql
```

### Reset Database

```bash
# Dừng Odoo
./stop.sh

# Xóa database
docker-compose down -v

# Khởi động lại
./dev-start.sh
```

## 🛠 Development Best Practices

### 1. Code Structure

```python
# models/patient.py
from odoo import models, fields, api

class Patient(models.Model):
    _name = 'clinic.patient'
    _description = 'Patient Information'
    _inherit = ['mail.thread', 'mail.activity.mixin']

    name = fields.Char('Patient Name', required=True, tracking=True)
    phone = fields.Char('Phone Number')
    email = fields.Char('Email')
    
    @api.model
    def create(self, vals):
        # Custom logic here
        return super().create(vals)
```

### 2. Views Structure

```xml
<!-- views/patient_views.xml -->
<?xml version="1.0" encoding="utf-8"?>
<odoo>
    <record id="view_patient_form" model="ir.ui.view">
        <field name="name">clinic.patient.form</field>
        <field name="model">clinic.patient</field>
        <field name="arch" type="xml">
            <form>
                <sheet>
                    <group>
                        <field name="name"/>
                        <field name="phone"/>
                        <field name="email"/>
                    </group>
                </sheet>
                <div class="oe_chatter">
                    <field name="message_follower_ids"/>
                    <field name="activity_ids"/>
                    <field name="message_ids"/>
                </div>
            </form>
        </field>
    </record>
</odoo>
```

### 3. Security (ir.model.access.csv)

```csv
id,name,model_id:id,group_id:id,perm_read,perm_write,perm_create,perm_unlink
access_clinic_patient,clinic.patient,model_clinic_patient,base.group_user,1,1,1,1
```

## 🔍 Debugging

### Log Files

```bash
# Xem log real-time
tail -f logs/odoo.log

# Xem error logs
grep ERROR logs/odoo.log
```

### Python Debugger

```python
# Thêm vào code Python
import pdb; pdb.set_trace()

# Hoặc dùng ipdb (cài đặt: pip install ipdb)
import ipdb; ipdb.set_trace()
```

### Browser DevTools
- **F12** để mở DevTools
- **Console tab** để xem JavaScript errors
- **Network tab** để debug AJAX calls

## 📱 Testing

### Unit Tests

```python
# tests/__init__.py
from . import test_patient

# tests/test_patient.py
from odoo.tests.common import TransactionCase

class TestPatient(TransactionCase):
    def test_patient_creation(self):
        patient = self.env['clinic.patient'].create({
            'name': 'Test Patient',
            'phone': '123456789'
        })
        self.assertEqual(patient.name, 'Test Patient')
```

### Chạy Tests

```bash
# Chạy tests cho module
odoo -c config/odoo.conf -d odoo_clinic --test-enable --stop-after-init -i clinic_management

# Chạy specific test
odoo -c config/odoo.conf -d odoo_clinic --test-enable --stop-after-init --test-tags clinic_management
```

## 🚀 Production Deployment

### Environment Variables

```bash
# .env file
DB_HOST=your-db-host
DB_PASSWORD=your-secure-password
ADMIN_PASSWD=your-admin-password
```

### Production Config

```ini
# config/production.conf
[options]
# Tắt debug mode
dev_mode = 
log_level = warn

# Security
list_db = False
admin_passwd = your-secure-master-password

# Performance
workers = 4
max_cron_threads = 2
```

## 📚 Useful Resources

- **Odoo Documentation**: https://www.odoo.com/documentation/18.0/
- **OCA Guidelines**: https://github.com/OCA/maintainer-quality-tools
- **Community**: https://github.com/OCA/
- **Local Documentation**: http://localhost:8069/web/static/src/legacy/docs/

## 🆘 Troubleshooting

### Lỗi thường gặp

1. **Port đã được sử dụng**
   ```bash
   # Tìm process đang dùng port 8069
   lsof -i :8069
   # Kill process
   kill -9 <PID>
   ```

2. **Database connection error**
   ```bash
   # Restart PostgreSQL
   docker-compose restart postgres
   ```

3. **Module không load**
   - Kiểm tra `__manifest__.py`
   - Update Apps List
   - Kiểm tra logs để xem error

4. **Asset không load**
   ```bash
   # Clear browser cache
   # Hoặc force reload: Cmd+Shift+R (Mac) / Ctrl+Shift+R (Windows)
   ```

### Logs quan trọng

```bash
# Theo dõi logs khi develop
tail -f logs/odoo.log | grep -E "(ERROR|WARNING|INFO)"

# Chi tiết hơn khi debug
tail -f logs/odoo.log | grep -E "(DEBUG|ERROR)"
```
