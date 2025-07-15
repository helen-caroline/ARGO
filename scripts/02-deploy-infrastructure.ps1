# ================================
# PASSO 2: DEPLOY DA INFRAESTRUTURA
# ================================

Write-Host "🏗️ INICIANDO DEPLOY DA INFRAESTRUTURA" -ForegroundColor Green

# Navegar para diretório do Terraform
Set-Location "$PSScriptRoot\..\terraform"

# Copiar configuração econômica
Copy-Item "terraform.tfvars.economico" "terraform.tfvars" -Force
Write-Host "✅ Configuração econômica aplicada" -ForegroundColor Green

# Inicializar Terraform
Write-Host "🔧 Inicializando Terraform..." -ForegroundColor Cyan
terraform init

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Erro na inicialização do Terraform" -ForegroundColor Red
    exit 1
}

# Validar configuração
Write-Host "✅ Validando configuração..." -ForegroundColor Cyan
terraform validate

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Configuração Terraform inválida" -ForegroundColor Red
    exit 1
}

# Planejar mudanças
Write-Host "📋 Planejando infraestrutura..." -ForegroundColor Cyan
terraform plan -out=tfplan

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Erro no planejamento" -ForegroundColor Red
    exit 1
}

# Confirmar deploy
$confirm = Read-Host "🤔 Deseja aplicar as mudanças? (y/N)"
if ($confirm -ne 'y' -and $confirm -ne 'Y') {
    Write-Host "❌ Deploy cancelado pelo usuário" -ForegroundColor Yellow
    exit 0
}

# Aplicar mudanças
Write-Host "🚀 Aplicando infraestrutura... (pode demorar 10-15 minutos)" -ForegroundColor Cyan
terraform apply tfplan

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Erro na aplicação do Terraform" -ForegroundColor Red
    exit 1
}

# Obter outputs importantes
Write-Host "📊 Obtendo informações da infraestrutura..." -ForegroundColor Cyan
$acrName = terraform output -raw acr_name
$aksName = terraform output -raw aks_cluster_name
$rgName = terraform output -raw resource_group_name

Write-Host "✅ INFRAESTRUTURA CRIADA COM SUCESSO!" -ForegroundColor Green
Write-Host "📦 ACR: $acrName" -ForegroundColor Yellow
Write-Host "☸️  AKS: $aksName" -ForegroundColor Yellow
Write-Host "🗂️  RG: $rgName" -ForegroundColor Yellow

# Salvar informações em arquivo
@"
# Informações da Infraestrutura Criada
ACR_NAME=$acrName
AKS_NAME=$aksName
RESOURCE_GROUP=$rgName
"@ | Out-File -FilePath "infrastructure-info.txt" -Encoding UTF8

Write-Host "💾 Informações salvas em infrastructure-info.txt" -ForegroundColor Green
