# Scripts de Automação para Deploy no Azure
# Execute estes comandos passo-a-passo

# ================================
# PASSO 1: CONFIGURAÇÃO INICIAL
# ================================

Write-Host "🚀 INICIANDO DEPLOY AZURE - CONFIGURAÇÃO ECONÔMICA" -ForegroundColor Green

# Verificar se Azure CLI está instalado
if (!(Get-Command az -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Azure CLI não encontrado. Instale com:" -ForegroundColor Red
    Write-Host "winget install Microsoft.AzureCLI" -ForegroundColor Yellow
    exit 1
}

# Login no Azure
Write-Host "🔐 Fazendo login no Azure..." -ForegroundColor Cyan
az login

# Listar subscriptions disponíveis
Write-Host "📋 Subscriptions disponíveis:" -ForegroundColor Cyan
az account list --output table

# Definir subscription (substitua pelo seu ID)
$subscriptionId = Read-Host "Digite o ID da sua subscription"
az account set --subscription $subscriptionId

# Verificar créditos restantes (se aplicável)
Write-Host "💰 Verificando conta..." -ForegroundColor Cyan
az account show --output table

Write-Host "✅ Configuração inicial concluída!" -ForegroundColor Green
