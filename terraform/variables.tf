# Variáveis gerais
variable "aks_vm_size" {
  default = "Standard_B1s"  # Menor VM possível (~$7/mês)
}

variable "aks_node_count" {
  default = 1  # Apenas 1 node
}


variable "location" {
  description = "Localização dos recursos Azure"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
  default     = "rg-devops-challenge"
}

variable "tags" {
  description = "Tags para os recursos"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "devops-challenge"
    Team        = "argo"
    CreatedBy   = "terraform"
  }
}

# Variáveis do Azure Container Registry
variable "acr_name" {
  description = "Nome do Azure Container Registry"
  type        = string
  default     = "acrdevopschallenge"

  validation {
    condition     = can(regex("^[a-zA-Z0-9]*$", var.acr_name))
    error_message = "O nome do ACR deve conter apenas caracteres alfanuméricos."
  }
}

variable "acr_sku" {
  description = "SKU do Azure Container Registry"
  type        = string
  default     = "Basic"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.acr_sku)
    error_message = "SKU deve ser Basic, Standard ou Premium."
  }
}

# Variáveis do Azure Kubernetes Service
variable "cluster_name" {
  description = "Nome do cluster AKS"
  type        = string
  default     = "aks-devops-challenge"
}

variable "kubernetes_version" {
  description = "Versão do Kubernetes"
  type        = string
  default     = "1.28"
}

variable "node_count" {
  description = "Número de nós no cluster"
  type        = number
  default     = 2

  validation {
    condition     = var.node_count >= 1 && var.node_count <= 10
    error_message = "O número de nós deve estar entre 1 e 10."
  }
}

variable "vm_size" {
  description = "Tamanho das VMs dos nós"
  type        = string
  default     = "Standard_B2s"
}

# Variáveis de rede
variable "vnet_address_space" {
  description = "Espaço de endereços da VNet"
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "subnet_address_prefixes" {
  description = "Prefixos de endereços da subnet"
  type        = list(string)
  default     = ["10.1.1.0/24"]
}

variable "service_cidr" {
  description = "CIDR dos serviços Kubernetes"
  type        = string
  default     = "10.2.0.0/24"
}

variable "dns_service_ip" {
  description = "IP do serviço DNS"
  type        = string
  default     = "10.2.0.10"
}
