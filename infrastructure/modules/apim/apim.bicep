@description('The email address of the owner of the service')
@minLength(1)
param publisherEmail string = 'jeevithasaran1994@gmail.com'

@description('The name of the owner of the service')
@minLength(1)
param publisherName string = 'apimPublisher'

@description('The pricing tier of this API Management service')
@allowed([
  'Developer'
  'Premium'
])
param sku string = 'Developer'

@description('Organization name')
param orgName string = 'jeevithabr'

@description('The instance size of this API Management service. This should be a multiple of the number of availability zones getting deployed.')
param skuCount int = 1


@description('Azure region where the resources will be deployed')
param location string = resourceGroup().location

@description('Numbers for availability zones, for example, 1,2,3.')
param availabilityZones array = [
  '1'
  '2'
]

@description('Name for the public IP address used to access the API Management service.')
param publicIpName string = 'pip-apim-${orgName}-${toLower(environment)}'

@description('SKU for the public IP address used to access the API Management service.')
@allowed([
  'Standard'
])
param publicIpSku string = 'Standard'

@description('Allocation method for the Public IP address used to access the API Management service. Standard SKU public IP requires `Static` allocation.')
@allowed([
  'Static'
])
param publicIPAllocationMethod string = 'Static'

@description('Environment of which to create the instance.')
@allowed([
  'DEV'
  'TEST'
  'PROD'
])
param environment string = 'DEV'

@description('Unique DNS name for the public IP address used to access the API Management service.')
param dnsLabelPrefix string = toLower('${publicIpName}-${uniqueString(resourceGroup().id)}')

var apiManagementName = 'apim-${orgName}-${toLower(environment)}'

resource apimPublicIp 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: publicIpName
  location: location
  sku: {
    name: publicIpSku
  }
  properties: {
    publicIPAllocationMethod: publicIPAllocationMethod
    publicIPAddressVersion: 'IPv4'
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix
    }
  }
}

resource apimResource 'Microsoft.ApiManagement/service@2022-08-01' = {
  name: apiManagementName
  location: location
  sku: {
    name: sku
    capacity: skuCount
  }
  identity: {
    type: 'SystemAssigned'
  }
  zones: ((length(availabilityZones) == 0) ? null : availabilityZones)
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
    virtualNetworkType: 'Internal'
    publicIpAddressId: apimPublicIp.id
    customProperties: {
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_GCM_SHA256': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA256': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA256': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_256_CBC_SHA': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TLS_RSA_WITH_AES_128_CBC_SHA': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TripleDes168': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Ssl30': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Ssl30': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Protocols.Server.Http2': 'false'
    }
  }
 
}
