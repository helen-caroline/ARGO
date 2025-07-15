# Terraform - Infraestrutura como Código

Este diretório contém os arquivos Terraform para provisionar a infraestrutura Azure necessária para o projeto DevOps Challenge.

## 📁 Estrutura de Arquivos

- `main.tf` - Recursos principais (AKS, ACR, VNet, etc.)
- `variables.tf` - Definições de variáveis
- `outputs.tf` - Outputs dos recursos criados
- `terraform.tfvars.example` - Exemplo de arquivo de variáveis

## 🚀 Recursos Provisionados

### Resource Group
- Resource Group principal para organizar todos os recursos

### Azure Container Registry (ACR)
- Registry privado para armazenar imagens Docker
- SKU configurável (Basic/Standard/Premium)
- Admin habilitado para integração com AKS

### Azure Kubernetes Service (AKS)
- Cluster Kubernetes gerenciado
- Pool de nós com auto-scaling habilitado
- Integração com ACR
- Monitoring com Log Analytics
- Azure Policy habilitado

### Rede
- Virtual Network dedicada
- Subnet para os nós do AKS
- Configurações de rede otimizadas

## 📋 Pré-requisitos

1. **Azure CLI** instalado e configurado
   ```bash
   az login
   az account set --subscription "sua-subscription-id"
   ```

2. **Terraform** instalado (versão >= 1.0)
   ```bash
   terraform version
   ```

3. **Permissões necessárias no Azure:**
   - Contributor ou Owner na subscription
   - Permissões para criar Service Principals

## 🔧 Como Usar

### 1. Configurar Variáveis

Copie o arquivo de exemplo e customize:
```bash
cp terraform.tfvars.example terraform.tfvars
```

Edite o arquivo `terraform.tfvars` com seus valores:
```hcl
resource_group_name = "rg-meu-projeto"
acr_name           = "acrmeuprojetodev"
cluster_name       = "aks-meu-projeto"
location           = "East US"
```

### 2. Inicializar Terraform

```bash
terraform init
```

### 3. Validar Configuração

```bash
terraform validate
terraform fmt
```

### 4. Planejar Deploy

```bash
terraform plan
```

### 5. Aplicar Mudanças

```bash
terraform apply
```

### 6. Configurar kubectl

Após o deploy, configure o kubectl:
```bash
az aks get-credentials --resource-group <resource-group-name> --name <cluster-name>
```

## 📊 Outputs Importantes

Após o deploy, você terá acesso aos seguintes outputs:

- **ACR Login Server** - Para push de imagens
- **AKS Cluster Name** - Nome do cluster
- **Kubectl Config Command** - Comando para configurar kubectl
- **Useful Commands** - Comandos úteis para gerenciar os recursos

## 🔐 Segurança

### Boas Práticas Implementadas:
- ✅ Identidade gerenciada para AKS
- ✅ Rede privada com subnets dedicadas
- ✅ RBAC habilitado no AKS
- ✅ Azure Policy habilitado
- ✅ Monitoring com Log Analytics
- ✅ Validações de entrada nas variáveis

## 💰 Otimização de Custos

### Configurações de Baixo Custo:
- **VM Size**: Standard_B2s (2 vCPUs, 4GB RAM)
- **ACR SKU**: Basic
- **Node Count**: 2 nós iniciais
- **Auto-scaling**: Min 1, Max 3

### Para Produção:
```hcl
vm_size = "Standard_D2s_v3"
acr_sku = "Standard"
node_count = 3
```

## 🛠️ Comandos Úteis

### Terraform
```bash
# Ver estado atual
terraform show

# Listar recursos
terraform state list

# Destruir infraestrutura (CUIDADO!)
terraform destroy
```

### Azure CLI
```bash
# Listar clusters AKS
az aks list --output table

# Ver status do cluster
az aks show --resource-group <rg-name> --name <cluster-name>

# Escalar cluster
az aks scale --resource-group <rg-name> --name <cluster-name> --node-count 3
```

### Kubectl
```bash
# Ver nós do cluster
kubectl get nodes

# Ver todos os pods
kubectl get pods --all-namespaces

# Ver serviços
kubectl get services
```

## 🐛 Troubleshooting

### Problemas Comuns:

1. **Nome do ACR já existe**
   - Altere `acr_name` para um valor único globalmente

2. **Cota de CPU excedida**
   - Reduza `node_count` ou `vm_size`

3. **Permissões insuficientes**
   - Verifique se tem permissões de Contributor na subscription

4. **Timeout na criação do AKS**
   - É normal demorar 10-15 minutos

## 📚 Documentação de Referência

- [Terraform AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Kubernetes Service](https://docs.microsoft.com/azure/aks/)
- [Azure Container Registry](https://docs.microsoft.com/azure/container-registry/)

## 🔄 Versionamento

Este código é versionado e testado. Para mudanças:
1. Crie uma branch
2. Teste com `terraform plan`
3. Aplique em ambiente de desenvolvimento primeiro
4. Documente as mudanças
