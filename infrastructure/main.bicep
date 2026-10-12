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


