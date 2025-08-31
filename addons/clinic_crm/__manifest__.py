{
    'name': 'Clinic Customer Menu',
    'version': '18.0.1.0.0',
    'category': 'Contacts',
    'summary': 'Add Customer menu to main navigation',
    'description': """
        Simple module to add Customer/Partner management to main menu
        - Brings res.partner (Customer) screen to main navigation
        - No custom fields or modifications
        - Uses standard Odoo contact functionality
    """,
    'author': 'Your Company',
    'website': 'https://www.yourcompany.com',
    'depends': ['base', 'contacts'],
    'data': [
        'views/menu_views.xml',
    ],
    'demo': [],
    'installable': True,
    'auto_install': False,
    'application': False,
}
