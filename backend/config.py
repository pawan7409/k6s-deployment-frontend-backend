"""
Configuration module for environment variables
"""

import os
from dotenv import load_dotenv

load_dotenv()

# Application settings
DEBUG = os.getenv('DEBUG', 'False').lower() == 'true'
ENVIRONMENT = os.getenv('ENVIRONMENT', 'production')
PORT = int(os.getenv('PORT', 5000))

# Azure settings
STORAGE_ACCOUNT_NAME = os.getenv('STORAGE_ACCOUNT_NAME', '')
KEYVAULT_URL = os.getenv('KEYVAULT_URL', '')
APP_SERVICE_NAME = os.getenv('APP_SERVICE_NAME', '')

# Database settings (optional)
DATABASE_URL = os.getenv('DATABASE_URL', '')

# Kubernetes settings
POD_NAME = os.getenv('HOSTNAME', 'localhost')
NAMESPACE = os.getenv('NAMESPACE', 'default')

print(f"Loaded configuration: Environment={ENVIRONMENT}, Debug={DEBUG}")
