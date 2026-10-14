@description('Region location of the resources resource group.')
param location string = resourceGroup().location
//Egress subnet
param egressSubnetAddr string

//Ingress subnet
param ingressSubnetAddr string


@description('Name of the vnet to use.')
param vnetName string

@description('The UDR to use.')
param routeTable string


var shortName = '01'
var egressSubnetAddrPrefix = egressSubnetAddr
var ingressSubnetAddrPrefix = ingressSubnetAddr

resource vnetResource 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  name: vnetName
}

resource routeTableRes 'Microsoft.Network/routeTables@2023-04-01' existing = {
  name: routeTable
}

//Egress NSGs
resource egressNetworkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2022-09-01' = {
  name: 'test-${shortName}-egress-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'DenyAnyCustomAnyInbound'
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          description: 'Deny anything that is not explicitly permitted'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 4096
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

//Egress subnets
resource egressSubnetResource 'Microsoft.Network/virtualNetworks/subnets@2023-04-01' = {
  parent: vnetResource
  name: 'test-${shortName}-egress'
  dependsOn: [
    egressNetworkSecurityGroup
  ]
  properties: {
    addressPrefix: egressSubnetAddrPrefix
    routeTable: {
      id: routeTableRes.id
    }
    networkSecurityGroup: {
      id: resourceId('Microsoft.Network/networkSecurityGroups', 'test-${shortName}-egress-nsg')
    }
    serviceEndpoints: [
      {
        service: 'Microsoft.AzureActiveDirectory'
        locations: [
          '*'
        ]
      }
      {
        service: 'Microsoft.AzureCosmosDB'
        locations: [
          '*'
        ]
      }
      {
        service: 'Microsoft.EventHub'
        locations: [
          '*'
        ]
      }
      {
        service: 'Microsoft.KeyVault'
        locations: [
          '*'
        ]
      }
      {
        service: 'Microsoft.ServiceBus'
        locations: [
          '*'
        ]
      }
      {
        service: 'Microsoft.Sql'
        locations: [
          'westeurope'
        ]
      }
      {
        service: 'Microsoft.Storage'
        locations: [
          'westeurope'
          'northeurope'
        ]
      }
      {
        service: 'Microsoft.Web'
        locations: [
          '*'
        ]
      }
    ]
    delegations: [
      {
        name: 'Microsoft.App.environments'
        properties: {
          serviceName: 'Microsoft.App/environments'
        }
      }
    ]
    privateEndpointNetworkPolicies: 'RouteTableEnabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

//Ingress NSGs
resource ingressNetworkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2022-09-01' = {
  name: 'test-${shortName}-ingress-nsg'
  dependsOn: [
    egressSubnetResource
  ]
  location: location
  properties: {
    securityRules: [
      {
        name: 'DenyAnyCustomAnyInbound'
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          description: 'Deny anything that is not explicitly permitted'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Deny'
          priority: 4096
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'AllowTrafficFromTestAppEgSubnet'
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
        properties: {
          description: 'Allow Traffic from test-${shortName}-egress subnet.'
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: null
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 4001
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: [ egressSubnetAddrPrefix ]
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

//Ingress subnets
resource ingressSubnetResource 'Microsoft.Network/virtualNetworks/subnets@2023-04-01' = {
  parent: vnetResource
  name: 'test-${shortName}-ingress'
  dependsOn: [
    ingressNetworkSecurityGroup
  ]
  properties: {
    addressPrefix: ingressSubnetAddrPrefix
    routeTable: {
      id: routeTableRes.id
    }
    networkSecurityGroup: {
      id: resourceId('Microsoft.Network/networkSecurityGroups', 'test-${shortName}-ingress-nsg')
    }
    serviceEndpoints: [
      {
        service: 'Microsoft.AzureActiveDirectory'
        locations: [
          '*'
        ]
      }
      {
        service: 'Microsoft.AzureCosmosDB'
        locations: [
          '*'
        ]
      }
      {
        service: 'Microsoft.EventHub'
        locations: [
          '*'
        ]
      }
      {
        service: 'Microsoft.KeyVault'
        locations: [
          '*'
        ]
      }
      {
        service: 'Microsoft.ServiceBus'
        locations: [
          '*'
        ]
      }
      {
        service: 'Microsoft.Sql'
        locations: [
          'westeurope'
        ]
      }
      {
        service: 'Microsoft.Storage'
        locations: [
          'westeurope'
          'northeurope'
        ]
      }
      {
        service: 'Microsoft.Web'
        locations: [
          '*'
        ]
      }
    ]
    privateEndpointNetworkPolicies: 'RouteTableEnabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}
