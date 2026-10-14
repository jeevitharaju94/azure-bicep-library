@description('Specifies the name of the environment.Ex test,prod. Kindly use the small case letters')
param env string
param location string = resourceGroup().location
@description('Add the responsible email id here, used for tagging purpose')
param responsiblity string

@description('Add the confidentiality level here, used for tagging purpose')
param confidentiality string

@description('Add the System Code here, used for tagging purpose')
param systemCode string

@description('Name for the Log Analytics workspace.')
param logAnalyticsWorkspaceName string

@description('Name for the Logic App Standard workflow app.')
param logicAppName string

@description('Name for the Logic App Standard hosting plan.')
param logicAppPlanName string

@description('Name for the Application Insights component.')
param applicationInsightsName string

@description('Name for the user-assigned managed identity used by the Logic App.')
param logicAppIdentityName string

@description('SKU name for the Logic App Standard hosting plan.')
param logicAppPlanSkuName string = 'WS1'

@description('SKU tier for the Logic App Standard hosting plan.')
param logicAppPlanSkuTier string = 'WorkflowStandard'

@description('Organization name used in the API Management service name.')
param apimOrganizationName string

@description('Publisher email registered on the API Management service.')
param apimPublisherEmail string

@description('Publisher name registered on the API Management service.')
param apimPublisherName string

@description('SKU for the API Management service.')
@allowed([
  'Developer'
  'Premium'
])
param apimSku string = 'Developer'

@description('Unique identifier for the API deployed to API Management.')
param apiName string

@description('Display name for the API deployed to API Management.')
param apiDisplayName string

@description('Relative URL path used to access the API.')
param apiPath string

@description('Name for the Service Bus namespace.')
param serviceBusNamespaceName string

@description('SKU for the Service Bus namespace.')
@allowed([
  'Standard'
  'Premium'
])
param serviceBusSku string = 'Standard'

@description('Messaging units for a Premium Service Bus namespace.')
param serviceBusCapacity int = 1

@description('Whether to enable zone redundancy for the Service Bus namespace.')
param serviceBusZoneRedundant bool = false

@description('Optional existing VNet name for the Service Bus firewall rule. Set this together with the subnet name.')
param serviceBusVnetName string = ''

@description('Optional existing subnet name with the Microsoft.ServiceBus service endpoint enabled.')
param serviceBusSubnetName string = ''

@description('Optional Service Bus IP firewall rules, each with ipMask and action properties. The namespace denies traffic when no rules are supplied.')
param serviceBusIpRules array = []

var prefix = json(loadTextContent('./shared/prefixes.json'))

var defaultTags = {
    Environment: toUpper(env)
    Responsibility: responsiblity
    Confidentiality: confidentiality
    DeploymentMethod: 'Bicep'
    SystemCode: systemCode
}


module storageAccount 'modules/storage/storageAccount.bicep' = {
  name: 'storage-account'
  params: {
    env: env
    location: location
    storageAccountName: toLower('${prefix.storageAccount}${env}${uniqueString(resourceGroup().id)}')
    defaultTags: defaultTags
  }
}

module logAnalytics 'modules/monitoring/logAnalyticsWorkspace.bicep' = {
  name: 'log-analytics-workspace'
  params: {
    logAnalyticsNamespaceName: logAnalyticsWorkspaceName
    location: location
  }
}

var logAnalyticsWorkspaceId = resourceId('Microsoft.OperationalInsights/workspaces', logAnalyticsWorkspaceName)

module applicationInsights 'modules/monitoring/applicationInsights.bicep' = {
  name: 'application-insights'
  dependsOn: [
    logAnalytics
  ]
  params: {
    appInsightsName: applicationInsightsName
    defaultTags: defaultTags
    location: location
    logAnalyticsWorkspaceId: logAnalyticsWorkspaceId
  }
}

module logicAppPlan 'modules/web/appServicePlan-LA.bicep' = {
  name: 'logic-app-plan'
  params: {
    appServicePlanName: logicAppPlanName
    appServicePlanSkuName: logicAppPlanSkuName
    appServicePlanSkuTier: logicAppPlanSkuTier
    location: location
  }
}

module logicAppIdentity 'modules/security/managedIdentity.bicep' = {
  name: 'logic-app-identity'
  params: {
    identityName: logicAppIdentityName
    location: location
    tags: defaultTags
  }
}

module logicApp 'modules/integration/logicAppsStandard.bicep' = {
  name: 'logic-app'
  dependsOn: [
    logAnalytics
  ]
  params: {
    appInsightsKey: applicationInsights.outputs.appinSightsInstrumentationKey
    appPlanId: logicAppPlan.outputs.appServicePlanName_resource_id
    defaultTags: defaultTags
    location: location
    logAnalyticsWSId: logAnalyticsWorkspaceId
    logicAppName: logicAppName
    managedIdentityId: logicAppIdentity.outputs.identityResourceId
    storageAccountName: storageAccount.outputs.storageAccountName
  }
}

module apiManagement 'modules/apim/apim.bicep' = {
  name: 'api-management'
  params: {
    availabilityZones: []
    environment: env
    location: location
    orgName: apimOrganizationName
    publisherEmail: apimPublisherEmail
    publisherName: apimPublisherName
    sku: apimSku
  }
}

module api 'modules/apim/api.bicep' = {
  name: 'api'
  dependsOn: [
    apiManagement
  ]
  params: {
    apiManagementName: 'apim-${apimOrganizationName}-${toLower(env)}'
    apiName: apiName
    apiPath: apiPath
    displayName: apiDisplayName
  }
}

module serviceBus 'modules/integration/serviceBus.bicep' = {
  name: 'service-bus'
  dependsOn: [
    logAnalytics
  ]
  params: {
    ipRules: serviceBusIpRules
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    location: location
    serviceBusNamespaceCapacity: serviceBusCapacity
    serviceBusNamespaceName: serviceBusNamespaceName
    serviceBusNamespaceZoneRedundant: serviceBusZoneRedundant
    skuName: serviceBusSku
    subnetName: serviceBusSubnetName
    vnetName: serviceBusVnetName
  }
}
