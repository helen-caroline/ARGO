# ================================
# PASSO 4: LIMPEZA DOS RECURSOS
# ================================

Write-Host "🗑️ SCRIPT DE LIMPEZA DOS RECURSOS AZURE" -ForegroundColor Red

# Confirmar limpeza
$confirm = Read-Host "⚠️ ATENÇÃO: Isso irá DELETAR TODOS os recursos criados. Tem certeza? (digite 'DELETE' para confirmar)"
if ($confirm -ne 'DELETE') {
    Write-Host "❌ Limpeza cancelada" -ForegroundColor Yellow
    exit 0
}

# Ler informações da infraestrutura
if (Test-Path "$PSScriptRoot\..\terraform\infrastructure-info.txt") {
    Get-Content "$PSScriptRoot\..\terraform\infrastructure-info.txt" | ForEach-Object {
        if ($_ -match "^([^=]+)=(.+)$") {
            Set-Variable -Name $matches[1] -Value $matches[2]
        }
    }
} else {
    Write-Host "❌ Arquivo infrastructure-info.txt não encontrado" -ForegroundColor Red
    $RESOURCE_GROUP = Read-Host "Digite o nome do Resource Group para deletar"
}

# Mostrar recursos que serão deletados
Write-Host "📋 Recursos que serão deletados:" -ForegroundColor Yellow
az resource list --resource-group $RESOURCE_GROUP --output table

# Confirmar novamente
$finalConfirm = Read-Host "🤔 Confirma a exclusão de TODOS estes recursos? (y/N)"
if ($finalConfirm -ne 'y' -and $finalConfirm -ne 'Y') {
    Write-Host "❌ Limpeza cancelada" -ForegroundColor Yellow
    exit 0
}

# Método 1: Deletar via Terraform (recomendado)
if (Test-Path "$PSScriptRoot\..\terraform\terraform.tfstate") {
    Write-Host "🏗️ Destruindo infraestrutura via Terraform..." -ForegroundColor Cyan
    Set-Location "$PSScriptRoot\..\terraform"
    terraform destroy -auto-approve
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Infraestrutura destruída via Terraform" -ForegroundColor Green
    } else {
        Write-Host "⚠️ Erro no Terraform destroy, tentando deletar Resource Group..." -ForegroundColor Yellow
    }
}

# Método 2: Deletar Resource Group inteiro (backup)
Write-Host "🗂️ Deletando Resource Group: $RESOURCE_GROUP" -ForegroundColor Cyan
az group delete --name $RESOURCE_GROUP --yes --no-wait

# Verificar se a deleção foi iniciada
Start-Sleep 5
$rgStatus = az group show --name $RESOURCE_GROUP --query "properties.provisioningState" --output tsv 2>$null

if ($rgStatus -eq "Deleting") {
    Write-Host "✅ Deleção do Resource Group iniciada" -ForegroundColor Green
    Write-Host "⏳ A deleção pode levar alguns minutos para completar" -ForegroundColor Yellow
} elseif ($null -eq $rgStatus) {
    Write-Host "✅ Resource Group deletado com sucesso" -ForegroundColor Green
} else {
    Write-Host "⚠️ Status do Resource Group: $rgStatus" -ForegroundColor Yellow
}

# Limpar arquivos locais
Write-Host "🧹 Limpando arquivos locais..." -ForegroundColor Cyan
Remove-Item "$PSScriptRoot\..\terraform\infrastructure-info.txt" -ErrorAction SilentlyContinue
Remove-Item "$PSScriptRoot\..\terraform\terraform.tfstate*" -ErrorAction SilentlyContinue
Remove-Item "$PSScriptRoot\..\terraform\.terraform" -Recurse -ErrorAction SilentlyContinue
Remove-Item "$PSScriptRoot\..\terraform\tfplan" -ErrorAction SilentlyContinue

# Calcular custo estimado (aproximado)
$hoursUsed = Read-Host "🕒 Por quantas horas os recursos ficaram ativos? (digite um número)"
if ($hoursUsed -match '^\d+$') {
    $estimatedCost = [math]::Round(([int]$hoursUsed * 0.01), 2)  # ~$0.01/hora para B1s
    Write-Host "💰 Custo estimado: ~$$$estimatedCost USD" -ForegroundColor Yellow
}

Write-Host "🎉 LIMPEZA CONCLUÍDA!" -ForegroundColor Green
Write-Host "💡 Dica: Verifique no portal Azure se todos os recursos foram removidos" -ForegroundColor Cyan
Write-Host "🌐 Portal: https://portal.azure.com/#view/HubsExtension/BrowseResourceGroups" -ForegroundColor Blue
