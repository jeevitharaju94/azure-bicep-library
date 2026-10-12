@description('Specifies the name of the environment.Ex test,prod. Kindly use the small case letters')
param env string
param location string = resourceGroup().location
param utcValue string = utcNow()

@description('Add the responsible email id here, used for tagging purpose')
param responsiblity string

@description('Add the confidentiality level here, used for tagging purpose')
param confidentiality string

@description('Add the System Code here, used for tagging purpose')
param systemCode string

var prefix = json(loadTextContent('./shared/prefixes.json'))

var defaultTags = {
    Environment: toUpper(env)
    Responsibility: responsiblity
    Confidentiality: confidentiality
    DeploymentMethod: 'Bicep'
    SystemCode: systemCode
}


// Below are few examples of how to use the modules for creating resources. You can modify them as per your requirements.

module storageAccount 'modules/storage/storageAccount.bicep' = {
  name: 'storage-account'
  params: {
    env: env
    location: location
    storageAccountName: '${prefix.storageAccount}${env}${utcValue}'
    defaultTags: defaultTags
  }
}

module apiBaseUrl './modules/apim/namedValue.bicep' = {
  name: 'api-base-url'
  params: {
    apiManagementName: 'apim-example'
    namedValueName: 'api-base-url'
    displayName: 'api-base-url'
    value: 'https://api.example.com'
    namedValueType: 'text'
  }
}

module backendKey './modules/apim/namedValue.bicep' = {
  name: 'backend-api-key'
  params: {
    apiManagementName: 'apim-example'
    namedValueName: 'backend-api-key'
    displayName: 'backend-api-key'
    value: ''
    namedValueType: 'secret'
  }
}

module databasePassword './modules/apim/namedValueKeyVault.bicep' = {
  name: 'database-password'
  params: {
    apiManagementName: 'apim-example'
    namedValueName: 'database-password'
    displayName: 'database-password'
    keyVaultSecretIdentifier: 'https://example.vault.azure.net/secrets/database-password'
  }
}


