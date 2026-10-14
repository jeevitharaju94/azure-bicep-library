
param serviceBusQueueName string
param serviceBusNamespaceName string


resource serviceBusNamespaceResource 'Microsoft.ServiceBus/namespaces@2024-01-01' existing = {
  name: serviceBusNamespaceName
}

resource serviceBusQueueResource 'Microsoft.ServiceBus/namespaces/queues@2024-01-01' = {
  name: serviceBusQueueName
  parent: serviceBusNamespaceResource
  properties: {
    maxMessageSizeInKilobytes: 1024
    lockDuration: 'PT5M'
    maxSizeInMegabytes: 1024
    requiresDuplicateDetection: false
    requiresSession: false
    defaultMessageTimeToLive: 'P7D'
    deadLetteringOnMessageExpiration: true
    enableBatchedOperations: true
    duplicateDetectionHistoryTimeWindow: 'PT10M'
    maxDeliveryCount: 3
    status: 'Active'
    autoDeleteOnIdle: 'P10675199DT2H48M5.4775807S'
    enablePartitioning: false
    enableExpress: false

  }
}
