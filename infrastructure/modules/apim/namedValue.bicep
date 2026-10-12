@description('Name of the existing API Management service.')
param apiManagementName string

@description('Unique identifier for this named value within the API Management service.')
@minLength(1)
@maxLength(80)
param namedValueName string

@description('Display name used to reference this named value in policies.')
@minLength(1)
param displayName string

@description('Value to store in API Management. Supply sensitive values using a secure deployment parameter.')
@secure()
param value string

@description('Select text for a non-secret value or secret for a protected value.')
@allowed([
  'text'
  'secret'
])
param namedValueType string = 'text'

resource apiManagementService 'Microsoft.ApiManagement/service@2022-08-01' existing = {
  name: apiManagementName
}

resource namedValue 'Microsoft.ApiManagement/service/namedValues@2022-08-01' = {
  parent: apiManagementService
  name: namedValueName
  properties: {
    displayName: displayName
    secret: namedValueType == 'secret'
    value: value
  }
}

output namedValueResourceId string = namedValue.id