# 🚀 Guia Completo: Deploy no Azure (Configuração Econômica)

## 📋 **Pré-requisitos**

### **Softwares Necessários:**
- [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli)
- [Terraform](https://www.terraform.io/downloads.html)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/docs/intro/install/)
- [Docker Desktop](https://www.docker.com/products/docker-desktop)

### **Conta Azure:**
- Conta Azure gratuita: https://azure.microsoft.com/free/
- $200 em créditos gratuitos
- Cartão de crédito (apenas para verificação)

## 🎯 **Configuração Econômica Aplicada**

### **💰 Custos Esperados:**
- **VM Standard_B1s**: ~$7-8/mês
- **AKS Control Plane**: GRATUITO
- **ACR Basic**: GRATUITO (dentro dos limites)
- **Storage**: GRATUITO (primeiros 5GB)
- **Load Balancer**: $0 (usando ClusterIP)

**Total estimado: ~$8/mês** (coberto pelos créditos gratuitos por ~25 meses!)

## 📚 **Passo-a-Passo Completo**

### **PASSO 1: Criar Conta Azure Gratuita**

1. **Acesse:** https://azure.microsoft.com/free/
2. **Clique:** "Começar gratuitamente"
3. **Entre:** com conta Microsoft (ou crie uma)
4. **Preencha:** dados pessoais
5. **Adicione:** cartão de crédito (verificação apenas)
6. **Confirme:** por SMS
7. **Aguarde:** aprovação (alguns minutos)

### **PASSO 2: Instalar Ferramentas**

```powershell
# Azure CLI
winget install Microsoft.AzureCLI

# Terraform
winget install Hashicorp.Terraform

# kubectl
winget install Kubernetes.kubectl

# Helm
winget install Helm.Helm

# Verificar instalações
az --version
terraform --version
kubectl version --client
helm version
```

### **PASSO 3: Executar Scripts de Deploy**

```powershell
# Navegar para o projeto
cd "C:\Users\Helen\Documents\Projetos\ARGO\devops-challenge"

# Executar scripts em ordem:

# 1. Configuração inicial do Azure
.\scripts\01-setup-azure.ps1

# 2. Deploy da infraestrutura (10-15 minutos)
.\scripts\02-deploy-infrastructure.ps1

# 3. Deploy da aplicação (5-10 minutos)
.\scripts\03-deploy-application.ps1

# 4. Testar aplicação
kubectl port-forward service/devops-challenge-app-service 8080:80 -n devops-challenge
# Abrir: http://localhost:8080
```

### **PASSO 4: Validar Deploy**

```powershell
# Verificar recursos criados
az resource list --resource-group rg-devops-challenge-free --output table

# Verificar pods
kubectl get pods -n devops-challenge

# Verificar serviços
kubectl get services -n devops-challenge

# Testar health check
kubectl port-forward service/devops-challenge-app-service 8080:80 -n devops-challenge &
curl http://localhost:8080/health
```

### **PASSO 5: Monitorar Custos**

```powershell
# Verificar custos atuais
az consumption usage list --output table

# Configurar alerta de custo
az consumption budget create \
  --budget-name "devops-challenge-budget" \
  --amount 20 \
  --time-grain Monthly \
  --category Cost
```

### **PASSO 6: Limpeza (IMPORTANTE!)**

```powershell
# Quando terminar os testes, execute:
.\scripts\04-cleanup.ps1

# Confirme que recursos foram deletados
az group list --output table
```

## 🛡️ **Segurança e Boas Práticas**

### **✅ Implementadas:**
- Usuário não-root nos containers
- Resource limits configurados
- Security contexts aplicados
- Service accounts dedicados
- Network policies (opcionais)

### **🔐 Credenciais:**
- Azure gerencia identidades automaticamente
- Não há senhas hardcoded
- ACR integrado com AKS via managed identity

## 📊 **Monitoramento**

### **Comandos Úteis:**
```powershell
# Status geral
kubectl get all -n devops-challenge

# Logs da aplicação
kubectl logs -f deployment/devops-challenge-app -n devops-challenge

# Métricas de CPU/Memory
kubectl top pods -n devops-challenge
kubectl top nodes

# Eventos do cluster
kubectl get events -n devops-challenge --sort-by=.metadata.creationTimestamp
```

### **Endpoints da Aplicação:**
- **Health Check:** `/health`
- **Info:** `/info`
- **Main:** `/`

## 🚨 **Troubleshooting**

### **Problemas Comuns:**

#### **1. "Quota exceeded"**
```powershell
# Verificar cotas disponíveis
az vm list-usage --location "East US" --output table

# Reduzir para B1s se necessário
# Editar terraform/terraform.tfvars.economico
vm_size = "Standard_B1s"
```

#### **2. "ACR name already exists"**
```powershell
# Trocar nome do ACR
# Editar terraform/terraform.tfvars.economico
acr_name = "acrdevopschallenge$(Get-Date -Format 'yyMMdd')"
```

#### **3. "Terraform state locked"**
```powershell
# Forçar desbloqueio (cuidado!)
terraform force-unlock <LOCK_ID>
```

#### **4. "kubectl connection refused"**
```powershell
# Reconfigurar kubectl
az aks get-credentials --resource-group rg-devops-challenge-free --name aks-devops-free --overwrite-existing
```

## 📈 **Próximos Passos**

### **1. CI/CD com Azure DevOps:**
- Criar projeto no Azure DevOps (gratuito)
- Configurar service connections
- Executar pipeline azure-pipelines.yml

### **2. Expansão:**
- Adicionar ingress controller
- Configurar SSL/TLS
- Implementar auto-scaling
- Adicionar monitoring com Prometheus

### **3. Produção:**
- Migrar para VMs maiores
- Adicionar multiple availability zones
- Configurar backup e disaster recovery

## 💡 **Dicas Finais**

1. **Sempre execute cleanup** após testes
2. **Configure alertas de custo** antes de começar
3. **Use tags** para rastrear recursos
4. **Documente mudanças** que fizer
5. **Teste localmente** primeiro sempre que possível

## 📞 **Suporte**

- **Azure Support:** https://azure.microsoft.com/support/
- **Terraform Docs:** https://registry.terraform.io/providers/hashicorp/azurerm/
- **Kubernetes Docs:** https://kubernetes.io/docs/
- **Helm Docs:** https://helm.sh/docs/

---

**🎉 Boa sorte com seu deploy!** 🚀
