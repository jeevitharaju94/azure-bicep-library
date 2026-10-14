using '../main.bicep'

param env = 'DEV'
param responsiblity = 'team@example.com'
param confidentiality = 'Internal'
param systemCode = 'SAMPLE'
param logAnalyticsWorkspaceName = 'log-sample-dev'
param logicAppName = 'la-sample-dev'
param logicAppPlanName = 'asp-la-sample-dev'
param logicAppPlanSkuName = 'WS1'
param logicAppPlanSkuTier = 'WorkflowStandard'
param applicationInsightsName = 'appi-sample-dev'
param logicAppIdentityName = 'id-la-sample-dev'
param apimOrganizationName = 'sample'
param apimPublisherEmail = 'team@example.com'
param apimPublisherName = 'Sample Development'
param apimSku = 'Developer'
param apiName = 'sample-api'
param apiDisplayName = 'Sample API (DEV)'
param apiPath = 'sample'
param serviceBusNamespaceName = 'sb-sample-dev'
param serviceBusSku = 'Standard'
param serviceBusCapacity = 1
param serviceBusZoneRedundant = false
// The Service Bus namespace denies network traffic until an IP rule or VNet/subnet rule is supplied.
param serviceBusVnetName = ''
param serviceBusSubnetName = ''
param serviceBusIpRules = []
