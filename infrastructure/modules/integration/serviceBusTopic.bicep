
param serviceBusTopicName string
param serviceBusNamespaceName string
param messageTimeToLive string

resource serviceBusNamespaceResource 'Microsoft.ServiceBus/namespaces@2024-01-01' existing = {
  name: serviceBusNamespaceName
}


resource serviceBusTopic 'Microsoft.ServiceBus/namespaces/topics@2024-01-01' = {
  name: serviceBusTopicName
  parent: serviceBusNamespaceResource
  properties: {
    defaultMessageTimeToLive: messageTimeToLive
  }
}
