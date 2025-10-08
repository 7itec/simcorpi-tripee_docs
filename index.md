---
layout: default
title: Home
---

## 🚀 Começando

Utilize o menu de **Documentação** acima para navegar entre os diferentes recursos da API. Recomendamos começar pela seção de **Autenticação** para entender como obter acesso à API.

---

## 📋 Principais Endpoints

### 🔐 Autenticação

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `POST` | `/tripee/auth/sso` | Login via Azure AD |
| `POST` | `/tripee/auth/refresh` | Renovar tokens de acesso |
| `POST` | `/tripee/auth/logout` | Encerrar sessão do usuário |

### 🗺️ Centros de Planejamento

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/tripee/planning-centers/all` | Listar todos os centros |
| `GET` | `/tripee/planning-centers/:id/modes` | Buscar tipos de viagem disponíveis |

### 🚗 Solicitações de Transporte

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `POST` | `/tripee/trips/personnel` | Criar nova solicitação |
| `PATCH` | `/tripee/trips/:id/personnel` | Editar solicitação existente |
| `GET` | `/tripee/trips/personnel` | Listar solicitações com filtros |
| `GET` | `/tripee/trips/:id` | Buscar solicitação por ID |
| `PATCH` | `/tripee/trips/:id/cancel` | Cancelar solicitação |

### 💰 Centros de Custo

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/tripee/cost-centers/names/:name` | Buscar centro de custo por nome |

---

## 💡 Suporte

Para dúvidas, problemas ou sugestões, entre em contato com a equipe de desenvolvimento.

Essa api é uma solução completa para integração e gerenciamento de solicitações de transporte. Esta documentação fornece todas as informações necessárias para integrar o sistema da Tripee com a plataforma Simcopri.