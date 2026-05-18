terraform {
  backend "azurerm" {
    # Configure with environment variables:
    # export ARM_SUBSCRIPTION_ID="..."
    # export ARM_CLIENT_ID="..."
    # export ARM_CLIENT_SECRET="..."
    # export ARM_TENANT_ID="..."
    # 
    # Or use: terraform init -backend-config="..."
  }
}
