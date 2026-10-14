@description('Specifies the name of the environment.Ex test,prod. Kindly use the small case letters')
param env string
param storageAccName string
param logicAppManagedIdentity string


var role = json(loadTextContent('../../shared/role-definitions.json'))

resource storageAccRes 'Microsoft.Storage/storageAccounts@2022-09-01' existing ={ 
  name:storageAccName
}


// Let Logic App access table
resource managedIdentityRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(logicAppManagedIdentity,storageAccName,env)
  scope:storageAccRes
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', role.storageTableDataContributor)
    principalId: logicAppManagedIdentity
    principalType: 'ServicePrincipal'
  }
}

