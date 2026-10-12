param location string = resourceGroup().location
param env string
param appServicePlanName string
param defaultTags object


resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: appServicePlanName
  tags: defaultTags
  location: location
  kind: 'functionapp'
  sku: {
    tier: 'FlexConsumption'
    name: 'FC1'
  }
  properties: {
    reserved: true
    zoneRedundant: (env == 'PROD')? true: false
    maximumElasticWorkerCount: 2
    isSpot: false
    hyperV: false
  }
}
