using '../main.bicep'

param env = 'TEST'
param responsiblity = 'team@example.com'
param confidentiality = 'Internal'
param systemCode = 'SAMPLE'
param logAnalyticsWorkspaceName = 'log-sample-test'
param logicAppName = 'la-sample-test'
param logicAppPlanName = 'asp-la-sample-test'
param logicAppPlanSkuName = 'WS1'
param logicAppPlanSkuTier = 'WorkflowStandard'
param applicationInsightsName = 'appi-sample-test'
param logicAppIdentityName = 'id-la-sample-test'
param apimOrganizationName = 'sample'
param apimPublisherEmail = 'team@example.com'
param apimPublisherName = 'Sample Test'
param apimSku = 'Developer'
param apiName = 'sample-api'
param apiDisplayName = 'Sample API (TEST)'
param apiPath = 'sample'
param serviceBusNamespaceName = 'sb-sample-test'
param serviceBusSku = 'Standard'
param serviceBusCapacity = 1
param serviceBusZoneRedundant = false
// The Service Bus namespace denies network traffic until an IP rule or VNet/subnet rule is supplied.
param serviceBusVnetName = ''
param serviceBusSubnetName = ''
param serviceBusIpRules = []
