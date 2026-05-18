"""
Azure Integration Module
Handles integration with Azure services
"""

import os
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient
from azure.keyvault.secrets import SecretClient

class AzureIntegration:
    def __init__(self):
        self.credential = DefaultAzureCredential()
        self.storage_account = os.getenv('STORAGE_ACCOUNT_NAME')
        self.keyvault_url = os.getenv('KEYVAULT_URL')
    
    def get_blob_service_client(self):
        """Get Azure Blob Storage client"""
        if not self.storage_account:
            raise ValueError("STORAGE_ACCOUNT_NAME not configured")
        
        return BlobServiceClient(
            account_url=f"https://{self.storage_account}.blob.core.windows.net",
            credential=self.credential
        )
    
    def get_secret(self, secret_name):
        """Get secret from Azure Key Vault"""
        if not self.keyvault_url:
            raise ValueError("KEYVAULT_URL not configured")
        
        client = SecretClient(vault_url=self.keyvault_url, credential=self.credential)
        return client.get_secret(secret_name).value
    
    def upload_blob(self, container_name, blob_name, data):
        """Upload file to Azure Blob Storage"""
        client = self.get_blob_service_client()
        container_client = client.get_container_client(container_name)
        container_client.upload_blob(blob_name, data, overwrite=True)
    
    def download_blob(self, container_name, blob_name):
        """Download file from Azure Blob Storage"""
        client = self.get_blob_service_client()
        blob_client = client.get_blob_client(container=container_name, blob=blob_name)
        return blob_client.download_blob().readall()
