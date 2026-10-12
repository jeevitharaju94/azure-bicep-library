@description('Name of the user-assigned managed identity.')
@minLength(3)
@maxLength(128)
param identityName string

@description('Azure region where the identity will be deployed.')
param location string = resourceGroup().location

@description('Tags to apply to the identity.')
param tags object = {}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: identityName
  location: location
  tags: tags
}

output identityResourceId string = managedIdentity.id
output identityClientId string = managedIdentity.properties.clientId
output identityPrincipalId string = managedIdentity.properties.principalId
output identityTenantId string = managedIdentity.properties.tenantId