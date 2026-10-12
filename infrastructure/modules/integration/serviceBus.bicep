param location string = resourceGroup().location
@description('Name of the intended servicebus.')
param serviceBusNamespaceName string

@description('Specifies the messaging units for the Service Bus namespace. For Premium tier, capacity are 1,2 and 4.')
param serviceBusNamespaceCapacity int = 1
@description('Enabling this property creates a Premium Service Bus Namespace in regions supported availability zones.')
param serviceBusNamespaceZoneRedundant bool = false
@allowed([
  'Standard'
  'Premium'
])
param skuName string = 'Premium'

param vnetName string
param subnetName string

param logAnalyticsWorkspaceName string

param ipRules array


resource logAnalyticsWorkspaceRes 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name:logAnalyticsWorkspaceName
}

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: serviceBusNamespaceName
  location: location
  sku: {
    name: skuName
    tier: skuName
    capacity: serviceBusNamespaceCapacity
  }
  properties: {
    disableLocalAuth: true
    zoneRedundant: serviceBusNamespaceZoneRedundant
  }
}

resource namespaceNetworkRuleSets 'Microsoft.ServiceBus/namespaces/networkrulesets@2022-10-01-preview' = {
  name: 'default'
  parent: serviceBusNamespace
  properties: {
    publicNetworkAccess: 'Enabled'
    defaultAction: 'Deny'
    // add any subnets here if needed, for example if you want to allow access from a subnet in your VNET
    virtualNetworkRules: [
      {
        subnet: {
          id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)
        }
        ignoreMissingVnetServiceEndpoint: false
      }

    ]
    ipRules: ipRules
    trustedServiceAccessEnabled: false
  }
}

resource servicebusDiagnosticsResource 'microsoft.insights/diagnosticSettings@2021-05-01-preview' = {
  scope: serviceBusNamespace
  name: 'diag-sb-01'
  properties: {
    workspaceId:  logAnalyticsWorkspaceRes.id
    logAnalyticsDestinationType:'Dedicated'
    logs: [
      {
        categoryGroup:'allLogs'
        enabled: true
      }
      {
        categoryGroup: 'audit'
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
