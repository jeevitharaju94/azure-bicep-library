# Azure Bicep Library

**Reusable Azure Infrastructure as Code | DevOps Automation**

[![Azure](https://img.shields.io/badge/Cloud-Microsoft%20Azure-0078D4?logo=microsoftazure&logoColor=white)](https://azure.microsoft.com/)
[![Bicep](https://img.shields.io/badge/IaC-Bicep-512BD4)](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
[![DevOps](https://img.shields.io/badge/DevOps-Azure%20Pipelines-2560E0?logo=azuredevops&logoColor=white)](https://learn.microsoft.com/en-us/azure/devops/pipelines/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Overview

Welcome to my **Azure Bicep Library** — a collection of reusable Infrastructure as Code (IaC) templates designed to provision, configure, and manage Microsoft Azure resources consistently and securely.

This repository focuses on practical Azure infrastructure automation, modular Bicep development, security best practices, and repeatable deployments across development, test, and production environments.

The goal is to demonstrate how infrastructure can be managed through version-controlled code, reducing manual configuration, improving consistency, and supporting reliable cloud deployments.

## Objectives

- Build reusable and modular Azure Bicep templates.
- Automate Azure resource provisioning using Infrastructure as Code.
- Apply security best practices, including Managed Identities and Azure RBAC.
- Implement consistent resource naming, tagging, and configuration.
- Support environment-specific deployments through parameter files.
- Integrate infrastructure validation and deployment into CI/CD pipelines.
- Document practical Azure infrastructure patterns for real-world scenarios.

## Technology Stack

| Technology | Purpose |
|---|---|
| Microsoft Azure | Cloud infrastructure and platform services |
| Azure Bicep | Declarative Infrastructure as Code |
| Azure CLI | Template validation and deployment |
| Azure DevOps Pipelines | CI/CD automation |


## Repository Structure

Infrastructure modules are grouped by category, with deployment pipelines kept alongside the infrastructure code.

```text
azure-bicep-library/
│
├── infrastructure/
│   ├── main.bicep
│   ├── modules/
│   │   ├── apim/
│   │   ├── database/
│   │   ├── general/
│   │   ├── integration/
│   │   ├── monitoring/
│   │   ├── networking/
│   │   ├── security/
│   │   ├── storage/
│   │   └── web/
│   ├── parameters/
│   ├── shared/
│   └── pipelines/
│       └── <pipeline files>
├── LICENSE
└── README.md
```

Each folder under `modules/` groups related Bicep modules. Azure pipeline definitions are stored in `infrastructure/pipelines/`.

## Getting Started

### Prerequisites

Install or configure the following tools:

- An Azure subscription with permission to deploy the resources.
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Azure Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Bicep VS Code extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)
- Git

### 1. Clone the repository

```bash
git clone https://github.com/jeevitharaju94/azure-bicep-library.git

cd azure-bicep-library
```

### 2. Sign in to Azure

```bash
az login
```

Select the appropriate subscription:

```bash
az account set --subscription "<subscription-id>"
```

### 3. Validate a Bicep template

Run the following command against an existing template:

```bash
az bicep build --file ./infrastructure/modules/storage/storageAccount.bicep
```

This compiles the Bicep file into an ARM template and helps identify compilation errors.

### 4. Validate a deployment

After creating a deployment template and its required parameters, validate the proposed deployment:

```bash
az deployment group validate \
  --resource-group "<resource-group-name>" \
  --template-file "./infrastructure/main.bicep" \
  --parameters "./infrastructure/parameters/main.{env}.bicepparam"
```

### 5. Preview the deployment

Use a what-if deployment to review the expected infrastructure changes:

```bash
az deployment group what-if \
  --resource-group "<resource-group-name>" \
  --template-file "./infrastructure/main.bicep" \
  --parameters "./infrastructure/parameters/main.{env}.bicepparam"
```

### 6. Deploy the infrastructure

After reviewing the proposed changes and confirming the configuration:

```bash
az deployment group create \
  --resource-group "<resource-group-name>" \
  --template-file "./infrastructure/main.bicep" \
  --parameters "./infrastructure/parameters/main.{env}.bicepparam"
```

Replace the example paths and parameter values with those applicable to the module you are deploying. Ensure the target resource group exists and that you have the required permissions.

> **Note:** The commands above are examples. They require a matching Bicep template, parameter file, and appropriate Azure permissions. Deploy only the modules and resources that have been implemented in the repository.

## Infrastructure as Code Best Practices

The library aims to follow these practices as it evolves:

### Modularity and Reusability
- Separate reusable infrastructure components into individual Bicep modules.
- Use parameters to avoid hardcoding environment-specific values.
- Define clear inputs and outputs for module integration.

### Security
- Apply least-privilege access using Azure RBAC.
- Prefer Managed Identities over embedded credentials where supported.
- Store secrets in Azure Key Vault rather than source code.

### Reliability and Monitoring
- Enable diagnostic settings where appropriate.
- Integrate Azure Monitor and Log Analytics where required.
- Configure availability and resilience features based on workload requirements.

### DevOps and Governance
- Keep infrastructure code in Git.
- Validate and review templates before deployment.
- Separate environment-specific configuration from reusable templates.
- Use automated CI/CD pipelines for repeatable deployments.
- Review changes through pull requests before production deployment.


## About Me

I am an Azure Integration Engineer focused on designing secure, scalable enterprise integrations using Microsoft Azure, .NET, Microsoft 365, and DevOps.

My areas of interest include:

- Azure Integration Services and API management
- Infrastructure as Code using Bicep
- Azure Functions, Logic Apps, and Service Bus
- Microsoft 365 and Dynamics 365 integrations
- CI/CD automation and cloud governance
- Secure, observable, and maintainable enterprise solutions

This repository is part of my hands-on Azure portfolio, demonstrating infrastructure automation, cloud architecture, and engineering best practices.

**Connect with me:**

- [LinkedIn](https://www.linkedin.com/in/jeevitharaju/)
- [GitHub](https://github.com/jeevitharaju94)

## Learning and Documentation

Official Microsoft resources:

- [Azure Bicep documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
- [Bicep language reference](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-functions)
- [Azure CLI documentation](https://learn.microsoft.com/en-us/cli/azure/)
- [Azure Verified Modules](https://aka.ms/avm)
- [Azure DevOps Pipelines](https://learn.microsoft.com/en-us/azure/devops/pipelines/)

## License

This project is intended for learning, demonstration, and portfolio purposes. Unless otherwise stated, the code is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
