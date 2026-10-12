@description('Name of the existing API Management service.')
param apiManagementName string

@description('Unique identifier for this named value within the API Management service.')
@minLength(1)
@maxLength(80)
param namedValueName string

@description('Display name used to reference this named value in policies.')
@minLength(1)
param displayName string

@description('Versionless URI of the Key Vault secret to reference.')
@minLength(1)
@secure()
param keyVaultSecretIdentifier string

@description('Client ID of the user-assigned managed identity used to access Key Vault. Leave empty to use the API Management system-assigned identity.')
param identityClientId string = ''

resource apiManagementService 'Microsoft.ApiManagement/service@2022-08-01' existing = {
  name: apiManagementName
}

resource namedValue 'Microsoft.ApiManagement/service/namedValues@2022-08-01' = {
  parent: apiManagementService
  name: namedValueName
  properties: {
    displayName: displayName
    secret: true
    keyVault: {
      secretIdentifier: keyVaultSecretIdentifier
      identityClientId: empty(identityClientId) ? null : identityClientId
    }
  }
}

output namedValueResourceId string = namedValue.id
