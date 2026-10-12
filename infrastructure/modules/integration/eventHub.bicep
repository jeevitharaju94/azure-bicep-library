param defaultTags object
param logAnalyticsWorkspaceId string
param eventHubsNamespaceName string





// Creating Event Hubs namespace
resource eventHubsNamespaceRes 'Microsoft.EventHub/namespaces@2025-05-01-preview' = {
  name: eventHubsNamespaceName
  location: resourceGroup().location
  tags: defaultTags
  identity: {
    type: 'SystemAssigned'    
  }
  sku: {
    name: 'Standard'
    tier: 'Standard'
    capacity: 1
  }
  properties:{ 
    minimumTlsVersion: '1.2'
    // publicNetworkAccess: 'Disabled'
    disableLocalAuth: false
    zoneRedundant: true
  }
}


resource namespaces_RootManageSharedAccessKey 'Microsoft.EventHub/namespaces/authorizationrules@2025-05-01-preview' = {
  parent: eventHubsNamespaceRes
  name: 'RootManageSharedAccessKey'
  properties: {
    rights: [
      'Listen'
      'Manage'
      'Send'
    ]
  }
}

//Create default EventHub
resource eventHubres 'Microsoft.EventHub/namespaces/eventhubs@2025-05-01-preview' = {
  parent: eventHubsNamespaceRes
  name: 'default'
  properties: {
    messageRetentionInDays: 7
    partitionCount: 1
    retentionDescription: {
      cleanupPolicy: 'Delete'
      retentionTimeInHours: 168
    }
    captureDescription:{ 
      enabled:false
      encoding:'Avro'
    }
  }
}


resource evhnsDiagnosticsResource 'microsoft.insights/diagnosticSettings@2021-05-01-preview' = {
  scope: eventHubsNamespaceRes
  name: 'diag-evhns-01'
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logAnalyticsDestinationType:'Dedicated'
    logs: [
      {
        category: 'DiagnosticErrorLogs'
        enabled: true
      }
        {
        category: 'EventHubVNetConnectionEvent'
        enabled: true
      }
      {
        category: 'RuntimeAuditLogs'
        enabled: true
      }
      {
        category: 'ApplicationMetricsLogs'
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

output evhnsName string = eventHubsNamespaceName
output eventHubNamespaceManagedIdentity string = eventHubsNamespaceRes.identity.principalId
