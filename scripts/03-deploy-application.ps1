# ================================
# PASSO 3: CONFIGURAR KUBECTL E DEPLOY DA APLICAÇÃO
# ================================

Write-Host "☸️ CONFIGURANDO KUBERNETES E DEPLOYANDO APLICAÇÃO" -ForegroundColor Green

# Ler informações da infraestrutura
if (Test-Path "$PSScriptRoot\..\terraform\infrastructure-info.txt") {
    Get-Content "$PSScriptRoot\..\terraform\infrastructure-info.txt" | ForEach-Object {
        if ($_ -match "^([^=]+)=(.+)$") {
            Set-Variable -Name $matches[1] -Value $matches[2]
        }
    }
} else {
    Write-Host "❌ Arquivo infrastructure-info.txt não encontrado" -ForegroundColor Red
    Write-Host "Execute primeiro o script 02-deploy-infrastructure.ps1" -ForegroundColor Yellow
    exit 1
}

# Configurar kubectl para AKS
Write-Host "🔧 Configurando kubectl para AKS..." -ForegroundColor Cyan
az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_NAME --overwrite-existing

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Erro ao configurar kubectl" -ForegroundColor Red
    exit 1
}

# Verificar conexão com cluster
Write-Host "✅ Verificando conexão com cluster..." -ForegroundColor Cyan
kubectl cluster-info
kubectl get nodes

# Fazer login no ACR
Write-Host "🔐 Fazendo login no ACR..." -ForegroundColor Cyan
az acr login --name $ACR_NAME

# Build e push da imagem Docker
Write-Host "🐳 Fazendo build e push da imagem..." -ForegroundColor Cyan
Set-Location "$PSScriptRoot\..\app"

# Tag da imagem
$imageTag = "v1.0.$(Get-Date -Format 'yyyyMMdd-HHmm')"
$fullImageName = "$ACR_NAME.azurecr.io/devops-challenge-app:$imageTag"

# Build
docker build -t "devops-challenge-app:$imageTag" .
docker tag "devops-challenge-app:$imageTag" $fullImageName

# Push para ACR
docker push $fullImageName

Write-Host "✅ Imagem enviada: $fullImageName" -ForegroundColor Green

# Deploy com Helm
Write-Host "📦 Fazendo deploy com Helm..." -ForegroundColor Cyan
Set-Location "$PSScriptRoot\..\helm"

# Instalar/atualizar aplicação
helm upgrade --install devops-challenge-app . `
    --namespace devops-challenge `
    --create-namespace `
    --set image.repository="$ACR_NAME.azurecr.io/devops-challenge-app" `
    --set image.tag="$imageTag" `
    --wait --timeout=300s

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Erro no deploy com Helm" -ForegroundColor Red
    exit 1
}

# Verificar status do deploy
Write-Host "📊 Verificando status do deploy..." -ForegroundColor Cyan
kubectl get pods -n devops-challenge
kubectl get services -n devops-challenge

# Aguardar pods ficarem prontos
Write-Host "⏳ Aguardando pods ficarem prontos..." -ForegroundColor Cyan
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=devops-challenge-app -n devops-challenge --timeout=300s

# Testar aplicação
Write-Host "🧪 Testando aplicação..." -ForegroundColor Cyan
$podName = kubectl get pods -n devops-challenge -l app.kubernetes.io/name=devops-challenge-app -o jsonpath="{.items[0].metadata.name}"

# Port forward para testar
Start-Job -ScriptBlock {
    kubectl port-forward pod/$using:podName 8080:8080 -n devops-challenge
}

Start-Sleep 5

# Teste básico
try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/health" -TimeoutSec 10
    Write-Host "✅ APLICAÇÃO FUNCIONANDO!" -ForegroundColor Green
    Write-Host "🎉 Health Check: $($response.status)" -ForegroundColor Yellow
} catch {
    Write-Host "⚠️ Erro no teste da aplicação: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Parar port forward
Get-Job | Stop-Job
Get-Job | Remove-Job

Write-Host "🎯 DEPLOY CONCLUÍDO COM SUCESSO!" -ForegroundColor Green
Write-Host "🌐 Para acessar a aplicação use:" -ForegroundColor Cyan
Write-Host "kubectl port-forward service/devops-challenge-app-service 8080:80 -n devops-challenge" -ForegroundColor White
