param defaultTags object
param appPlanId string
param location string
param logAnalyticsWSId string
param appInsightsKey string
param storageAccountName string
param managedIdentityId string
param logicAppName string


var diagnosticSettingsName = toLower('diag-${logicAppName}')


resource storageAccountResource 'Microsoft.Storage/storageAccounts@2022-05-01' existing = {
  name: storageAccountName
}

resource logicAppResource 'Microsoft.Web/sites@2022-03-01' = {
  name: logicAppName
  location: location
  tags:defaultTags
  kind: 'functionapp,workflowapp'
  identity: {
    type: 'SystemAssigned, UserAssigned'
    userAssignedIdentities: {
      '${managedIdentityId}': {}
    }
  }
  properties: {
    serverFarmId: appPlanId
    vnetRouteAllEnabled: true
    siteConfig: {
      publicNetworkAccess: 'Enabled'
      netFrameworkVersion: 'v4.6'
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountResource.name};AccountKey=${listKeys(storageAccountResource.id, storageAccountResource.apiVersion).keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountResource.name};AccountKey=${listKeys(storageAccountResource.id, storageAccountResource.apiVersion).keys[0].value};EndpointSuffix=core.windows.net'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(logicAppName)
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsightsKey
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'APP_KIND'
          value: 'workflowApp'
        }
        {
          name: 'FUNCTIONS_V2_COMPATIBILITY_MODE'
          value: 'true'
        }
        {
          name: 'WORKFLOWS_LOCATION_NAME'
          value: location
        }
        {
          name: 'WORKFLOWS_RESOURCE_GROUP_NAME'
          value: resourceGroup().name
        }
        {
          name: 'WORKFLOWS_SUBSCRIPTION_ID'
          value: subscription().subscriptionId
        }
        {
          name: 'WORKFLOWS_TENANT_ID'
          value: subscription().tenantId
        }
        {
          name: 'WORKFLOWS_MANAGEMENT_BASE_URI'
          value: environment().resourceManager
        }
        {
          name: 'WEBSITE_CONTENTOVERVNET'
          value: '1'
        }
        {
          name: 'WEBSITE_VNET_ROUTE_ALL'
          value: '1'
        }
      ]
      ftpsState: 'Disabled'
    }
    httpsOnly: true
    storageAccountRequired: true
    clientAffinityEnabled: false
  }
}


resource webConfigWeb 'Microsoft.Web/sites/config@2021-03-01' = {
  name: 'web'
  parent: logicAppResource
  properties: {
    numberOfWorkers: 1
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'Disabled'
    scmIpSecurityRestrictionsUseMain: false
    ipSecurityRestrictions: [
    ]
  }
}


resource logicAppDiagnosticsResource 'microsoft.insights/diagnosticSettings@2021-05-01-preview' = {
  scope: logicAppResource
  name: diagnosticSettingsName
  properties: {
    workspaceId: logAnalyticsWSId
    logs: [
      {
        category: 'WorkflowRuntime'
        enabled: true
      }
      {
        category: 'FunctionAppLogs'
        enabled: false
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




output logicAppPincipalId string = logicAppResource.identity.principalId
output logicAppResourceId string = logicAppResource.id
