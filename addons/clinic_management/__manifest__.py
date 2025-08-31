{
    'name': 'Clinic Management',
    'version': '18.0.1.0.0',
    'category': 'Healthcare',
    'summary': 'Clinic Management System',
    'description': """
        Complete clinic management system including:
        - Patient management
        - Doctor management
        - Appointment scheduling
        - Medical records
        - Billing and invoicing
    """,
    'author': 'Your Company',
    'website': 'https://www.yourcompany.com',
    'depends': ['base', 'mail', 'calendar'],
    'data': [
        'security/ir.model.access.csv',
        'views/patient_views.xml',
        'views/doctor_views.xml',
        'views/appointment_views.xml',
        'views/menu_views.xml',
    ],
    'demo': [],
    'installable': True,
    'auto_install': False,
    'application': True,
}
