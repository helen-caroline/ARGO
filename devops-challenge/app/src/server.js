const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 8080;

// Middleware para servir arquivos estáticos
app.use(express.static(path.join(__dirname, 'public')));

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'OK',
    timestamp: new Date().toISOString(),
    version: process.env.APP_VERSION || '1.0.0',
    environment: process.env.NODE_ENV || 'development'
  });
});

// Endpoint principal
app.get('/', (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html lang="pt-BR">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>DevOps Challenge - ARGO</title>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                margin: 0;
                padding: 0;
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .container {
                background: rgba(255, 255, 255, 0.95);
                padding: 3rem;
                border-radius: 20px;
                box-shadow: 0 20px 40px rgba(0,0,0,0.1);
                text-align: center;
                max-width: 600px;
                margin: 2rem;
            }
            h1 {
                color: #333;
                margin-bottom: 1rem;
                font-size: 2.5rem;
            }
            .subtitle {
                color: #666;
                font-size: 1.2rem;
                margin-bottom: 2rem;
            }
            .info-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 1rem;
                margin: 2rem 0;
            }
            .info-card {
                background: #f8f9fa;
                padding: 1rem;
                border-radius: 10px;
                border-left: 4px solid #667eea;
            }
            .tech-stack {
                display: flex;
                flex-wrap: wrap;
                justify-content: center;
                gap: 0.5rem;
                margin: 2rem 0;
            }
            .tech-badge {
                background: #667eea;
                color: white;
                padding: 0.5rem 1rem;
                border-radius: 20px;
                font-size: 0.9rem;
                font-weight: bold;
            }
            .status {
                color: #28a745;
                font-weight: bold;
                font-size: 1.1rem;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>🚀 DevOps Challenge</h1>
            <p class="subtitle">Solução completa com Terraform, Docker, Kubernetes e Azure DevOps</p>
            
            <div class="info-grid">
                <div class="info-card">
                    <h3>📅 Data</h3>
                    <p>${new Date().toLocaleDateString('pt-BR')}</p>
                </div>
                <div class="info-card">
                    <h3>🕒 Horário</h3>
                    <p>${new Date().toLocaleTimeString('pt-BR')}</p>
                </div>
                <div class="info-card">
                    <h3>🌍 Ambiente</h3>
                    <p>${process.env.NODE_ENV || 'development'}</p>
                </div>
                <div class="info-card">
                    <h3>📦 Versão</h3>
                    <p>${process.env.APP_VERSION || '1.0.0'}</p>
                </div>
            </div>

            <div class="tech-stack">
                <span class="tech-badge">🏗️ Terraform</span>
                <span class="tech-badge">🐳 Docker</span>
                <span class="tech-badge">☸️ Kubernetes</span>
                <span class="tech-badge">⚡ Azure DevOps</span>
                <span class="tech-badge">📦 Helm</span>
                <span class="tech-badge">🔵 Azure</span>
            </div>

            <p class="status">✅ Aplicação rodando com sucesso!</p>
            <p><a href="/health" target="_blank">🔍 Health Check</a></p>
        </div>
    </body>
    </html>
  `);
});

// Rota de informações da aplicação
app.get('/info', (req, res) => {
  res.json({
    name: 'DevOps Challenge App',
    version: process.env.APP_VERSION || '1.0.0',
    environment: process.env.NODE_ENV || 'development',
    port: PORT,
    timestamp: new Date().toISOString(),
    hostname: process.env.HOSTNAME || 'localhost',
    techStack: ['Node.js', 'Express', 'Docker', 'Kubernetes', 'Terraform', 'Helm', 'Azure DevOps']
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    error: 'Algo deu errado!',
    timestamp: new Date().toISOString()
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    error: 'Página não encontrada',
    path: req.path,
    timestamp: new Date().toISOString()
  });
});

app.listen(PORT, () => {
  console.log(`🚀 Servidor rodando na porta ${PORT}`);
  console.log(`🌍 Ambiente: ${process.env.NODE_ENV || 'development'}`);
  console.log(`📦 Versão: ${process.env.APP_VERSION || '1.0.0'}`);
  console.log(`🕒 Iniciado em: ${new Date().toISOString()}`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('🛑 Recebido SIGTERM, encerrando servidor...');
  process.exit(0);
});

process.on('SIGINT', () => {
  console.log('🛑 Recebido SIGINT, encerrando servidor...');
  process.exit(0);
});
