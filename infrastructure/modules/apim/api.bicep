@description('Name of the existing API Management service.')
param apiManagementName string

@description('Unique identifier for the API within the API Management service.')
@minLength(1)
@maxLength(80)
param apiName string

@description('Display name for the API.')
param displayName string = apiName

@description('Relative URL path used to access the API.')
param apiPath string = apiName

@description('Protocols on which the API is available.')
param protocols array = [
  'https'
]

@description('Whether a subscription key is required to access the API.')
param subscriptionRequired bool = true

resource apiManagementService 'Microsoft.ApiManagement/service@2022-08-01' existing = {
  name: apiManagementName
}

resource api 'Microsoft.ApiManagement/service/apis@2022-08-01' = {
  parent: apiManagementService
  name: apiName
  properties: {
    apiType: 'http'
    displayName: displayName
    format: 'openapi+json'
    path: apiPath
    protocols: protocols
    subscriptionRequired: subscriptionRequired
    value: loadTextContent('./openapi.json')
  }
}

output apiResourceId string = api.id