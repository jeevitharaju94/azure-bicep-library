@description('Specifies name of the application, workload, or service that the resource is a part of. Kindly use the small case letters')
param defaultTags object
param location string
param logAnalyticsWorkspaceId string
param appInsightsName string



resource applicationInsightsRes 'Microsoft.insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  tags:defaultTags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Flow_Type: 'Redfield'
    Request_Source: 'IbizaAIExtensionEnablementBlade'
    RetentionInDays: 90
    WorkspaceResourceId: logAnalyticsWorkspaceId
    IngestionMode: 'LogAnalytics'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

resource appInsightsDiagSettRes 'microsoft.insights/diagnosticSettings@2021-05-01-preview' = {
  scope: applicationInsightsRes
  name: 'diag-appinsights'
  properties: {
    workspaceId: logAnalyticsWorkspaceId
   logs: [
      {
        categoryGroup:'allLogs'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

output appinSightsConnectionString string = applicationInsightsRes.properties.ConnectionString
output appinSightsInstrumentationKey string = applicationInsightsRes.properties.InstrumentationKey
