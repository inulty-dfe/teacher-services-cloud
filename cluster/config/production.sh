ENVIRONMENT=production
CONFIG=production
CONFIG_SHORT=pd
AZ_SUBSCRIPTION=s189-teacher-services-cloud-production
RESOURCE_PREFIX=s189p01
ENV_TAG=Prod
RESOURCE_GROUP_NAME=${RESOURCE_PREFIX}-tsc-${CONFIG_SHORT}-rg
KEYVAULT_NAME=${RESOURCE_PREFIX}-tsc-${CONFIG_SHORT}-kv
STORAGE_ACCOUNT_NAME=${RESOURCE_PREFIX}tsctfstate${CONFIG_SHORT}
