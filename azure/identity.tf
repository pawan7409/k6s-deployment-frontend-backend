# Managed Identities - Note:
# Managed identities are now configured in the Terraform modules:
# - App Service: modules/app_service/main.tf (SystemAssigned)
# - Function App: modules/function_app/main.tf (SystemAssigned)
# - AKS: modules/aks/main.tf (with kubelet identity)
#
# These identities allow services to authenticate to Azure resources
# without storing credentials in code (using workload identity federation)

# This file is kept for documentation purposes.
# All actual managed identity resources are created via Terraform modules.
