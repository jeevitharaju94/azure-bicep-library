param location string
param resourceTags object
param workbookJson string


var displayName = 'Monitoring-Workbook'
var description = 'Monitoring Workbook used to monitor the integrations'
var version = '1.0'


resource workbook 'Microsoft.Insights/workbooks@2022-04-01' = {
  name: guid(resourceGroup().id, 'Microsoft.Insights/workbooks', displayName)
  location: location
  tags: resourceTags
  kind: 'shared'
  properties: {
    category: 'workbook'
    description: description
    displayName: displayName
    serializedData: workbookJson
    sourceId: 'Azure Monitor'
    version: version
  }
}



output workbookId string = workbook.id
