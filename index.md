---
layout: default
title: Home
---

<div class="section">
  <h2>🎯 Visão Geral</h2>
  <p>
    A API Tripee permite a integração completa com o sistema de gerenciamento de 
    solicitações de transporte. Utilize Azure Active Directory para autenticação 
    segura e acesse endpoints para criar, consultar e gerenciar viagens.
  </p>

  <div class="features">
    <div class="feature-card">
      <div class="emoji">🔐</div>
      <h3>Autenticação Segura</h3>
      <p>Integração com Azure AD e tokens JWT</p>
    </div>
    <div class="feature-card">
      <div class="emoji">🚀</div>
      <h3>APIs RESTful</h3>
      <p>Endpoints bem documentados e fáceis de usar</p>
    </div>
    <div class="feature-card">
      <div class="emoji">📱</div>
      <h3>Multi-plataforma</h3>
      <p>Suporte para Web e Mobile</p>
    </div>
    <div class="feature-card">
      <div class="emoji">📎</div>
      <h3>Upload de Arquivos</h3>
      <p>Suporte a anexos em solicitações</p>
    </div>
  </div>
</div>

<div class="section">
  <h2>🚀 Início Rápido</h2>
  
  <h3>1. Autenticação</h3>
  <p>Obtenha seus tokens de acesso através do Azure AD:</p>
  <div class="endpoint">
    <span class="method post">POST</span>
    <span>/tripee/auth/sso</span>
  </div>
  <pre><code>curl -X POST https://api.example.com/tripee/auth/sso \
  -H "Authorization: Bearer YOUR_AZURE_AD_TOKEN"</code></pre>

  <h3>2. Buscar Centros de Planejamento</h3>
  <div class="endpoint">
    <span class="method get">GET</span>
    <span>/tripee/planning-centers/all</span>
  </div>

  <h3>3. Criar uma Solicitação</h3>
  <div class="endpoint">
    <span class="method post">POST</span>
    <span>/tripee/trips/personnel</span>
  </div>
  <p>Envie os dados da viagem, passageiros e anexos (multipart/form-data).</p>
</div>

<div class="section">
  <h2>📋 Principais Endpoints</h2>

  <div class="card">
    <h4>Autenticação</h4>
    <ul>
      <li><code>POST /tripee/auth/sso</code> - Login via Azure AD</li>
      <li><code>POST /tripee/auth/refresh</code> - Renovar tokens</li>
      <li><code>POST /tripee/auth/logout</code> - Encerrar sessão</li>
    </ul>
  </div>

  <div class="card">
    <h4>Centros de Planejamento</h4>
    <ul>
      <li><code>GET /tripee/planning-centers/all</code> - Listar todos</li>
      <li><code>GET /tripee/planning-centers/:id/modes</code> - Buscar tipos de viagem</li>
    </ul>
  </div>

  <div class="card">
    <h4>Solicitações de Transporte</h4>
    <ul>
      <li><code>POST /tripee/trips/personnel</code> - Criar solicitação</li>
      <li><code>PATCH /tripee/trips/:id</code> - Atualizar solicitação</li>
      <li><code>GET /tripee/trips/personnel</code> - Listar solicitações</li>
      <li><code>GET /tripee/trips/:id</code> - Buscar por ID</li>
      <li><code>PATCH /tripee/trips/:id/cancel</code> - Cancelar solicitação</li>
    </ul>
  </div>

  <div class="card">
    <h4>Centros de Custo</h4>
    <ul>
      <li><code>GET /tripee/cost-centers/names/:name</code> - Buscar por nome</li>
    </ul>
  </div>
</div>

<div class="section">
  <h2>🔑 Configuração Inicial</h2>
  
  <h3>Pré-requisitos</h3>
  <ul>
    <li>✅ Credenciais do Azure Active Directory</li>
    <li>✅ Token de acesso válido do Azure AD</li>
    <li>✅ URL base da API: <code>https://api.example.com/tripee</code></li>
  </ul>

  <h3>Limites e Restrições</h3>
  <ul>
    <li><strong>Access Token:</strong> Válido por 2 horas</li>
    <li><strong>Refresh Token:</strong> Válido por 8 horas</li>
    <li><strong>Arquivos:</strong> Máximo de 3 arquivos, 5MB cada</li>
    <li><strong>Formatos aceitos:</strong> Imagens (JPG, PNG) e PDF</li>
  </ul>
</div>

<div class="section">
  <h2>📖 Recursos Adicionais</h2>
  <ul>
    <li>📘 <a href="{{ '/docs/authentication' | relative_url }}">Guia Completo de Autenticação</a></li>
    <li>📗 <a href="{{ '/docs/trip-creation' | relative_url }}">Tutorial: Criando sua Primeira Solicitação</a></li>
    <li>📙 <a href="{{ '/docs/examples' | relative_url }}">Exemplos em Múltiplas Linguagens</a></li>
  </ul>
</div>

<div class="section">
  <h2>💡 Suporte</h2>
  <p>
    Para dúvidas, problemas ou sugestões, entre em contato com a equipe de desenvolvimento.
  </p>
</div>
