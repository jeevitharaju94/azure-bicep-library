param virtualNetworks_name string
param addressPrefix string = '0.0.0.0/19'
param location string = resourceGroup().location


resource virtualNetworks_resource 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: virtualNetworks_name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: []
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}
