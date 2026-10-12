
@description('Specifies whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault.')
param enabledForDeployment bool = false

@description('Specifies whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys.')
param enabledForDiskEncryption bool = false

@description('Specifies whether Azure Resource Manager is permitted to retrieve secrets from the key vault.')
param enabledForTemplateDeployment bool = false

@description('Specifies whether Soft delete is enabled from the key vault.')
param enableSoftDelete bool = true

@description('Specifies whether Purge Protection is enabled from the key vault.')
param enablePurgeProtection bool = true


@description('Specifies the Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. Get it by using Get-AzSubscription cmdlet.')
param tenantId string = subscription().tenantId

@description('Specifies the default tags to be added to the resource')
param defaultTags object


@description('Specifies whether the key vault is a standard vault or a premium vault.')
@allowed([
  'standard'
  'premium'
])
param skuName string = 'standard'
param logAnalyticsWorkspaceId string
param keyVaultName string
param location string

resource keyVaultResource 'Microsoft.KeyVault/vaults@2021-10-01' ={
  name: keyVaultName
  location: location
  tags: defaultTags
  properties: {
    enabledForDeployment: enabledForDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enabledForTemplateDeployment: enabledForTemplateDeployment
    enableSoftDelete:enableSoftDelete
    enablePurgeProtection:enablePurgeProtection
    enableRbacAuthorization: true
    tenantId: tenantId
    accessPolicies:[]
    publicNetworkAccess:'Enabled'
    sku: {
      name: skuName
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
    }
  }
}



resource keyVaultDiagnosticsResource 'microsoft.insights/diagnosticSettings@2021-05-01-preview' = {
  scope: keyVaultResource
  name: 'diag-keyvault'
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'AuditEvent'
        enabled: true
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


output keyVaultName string = keyVaultName
