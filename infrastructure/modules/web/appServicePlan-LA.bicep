param location string = resourceGroup().location
param appServicePlanName string
param appServicePlanSkuName string
param appServicePlanSkuTier string

resource appServicePlanName_resource 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  properties: {
    maximumElasticWorkerCount: 1
  }
  sku: {
    name: appServicePlanSkuName
    tier: appServicePlanSkuTier
  }
  kind: 'windows'
}

output appServicePlanName_resource_id string = appServicePlanName_resource.id
output appServicePlanName_resource_name string = appServicePlanName_resource.name
