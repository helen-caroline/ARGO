# Multi-stage build para otimização
FROM node:20-alpine AS builder

# Metadata
LABEL maintainer="DevOps Challenge"
LABEL description="Aplicação web para desafio DevOps"
LABEL version="1.0.0"

# Configurar diretório de trabalho
WORKDIR /app

# Copiar arquivos de dependências
COPY src/package*.json ./

# Instalar dependências (apenas production)
RUN npm ci --only=production && npm cache clean --force

# Stage de produção
FROM node:20-alpine AS production

# Instalar dumb-init e criar usuário em uma única camada
RUN apk add --no-cache dumb-init && \
    addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# Configurar diretório de trabalho
WORKDIR /app

# Copiar dependências do stage anterior
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules

# Copiar código da aplicação
COPY --chown=nodejs:nodejs src/ ./

# Definir variáveis de ambiente
ENV NODE_ENV=production
ENV PORT=8080
ENV APP_VERSION=1.0.0

# Expor porta
EXPOSE 8080

# Trocar para usuário não-root
USER nodejs

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:8080/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"

# Comando de inicialização usando dumb-init
ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "server.js"]
