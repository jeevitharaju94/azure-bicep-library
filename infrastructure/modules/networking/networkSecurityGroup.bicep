param nsgName string
param location string = resourceGroup().location


resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2022-09-01' = {
  name: nsgName
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

output nsgId string = networkSecurityGroup.id
