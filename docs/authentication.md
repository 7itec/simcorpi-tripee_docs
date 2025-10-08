---
layout: default
title: Autenticação
permalink: /docs/authentication.html
---

# Autenticação

A API utiliza autenticação via **Azure Active Directory (Azure AD)** e tokens JWT para autorização de requisições.

## 🔐 Fluxo de Autenticação

### 1. Autenticação via Azure AD (SSO)

A autenticação principal é realizada através do Azure Active Directory.

<div class="endpoint">
  <span class="method post">POST</span>
  <span>/tripee/auth/sso</span>
</div>

**Headers:**
```
Authorization: Bearer {AZURE_AD_ACCESS_TOKEN}
Content-Type: application/json
```

**Resposta de Sucesso (201):**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Campos da Resposta:**
- `access_token`: Token JWT para autenticação nas requisições (validade: **2 horas**)
- `refresh_token`: Token para renovação do access_token (validade: **8 horas**)

**Erros Possíveis:**
- `401 Unauthorized`: Token Azure AD inválido ou expirado

---

## 🔄 Renovação de Token (Refresh)

Antes do `access_token` expirar, você deve renová-lo usando o `refresh_token`.

<div class="endpoint">
  <span class="method post">POST</span>
  <span>/tripee/auth/refresh</span>
</div>

**Headers:**
```
Authorization: Bearer {REFRESH_TOKEN}
Content-Type: application/json
```

**Resposta de Sucesso (201):**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Campos da Resposta:**
- `access_token`: Novo token JWT (validade: **2 horas**)
- `refresh_token`: Novo token de refresh (validade: **8 horas**)

**⚠️ Importante:** Sempre armazene o novo `refresh_token` retornado, pois o anterior será invalidado.

**Erros Possíveis:**
- `401 Unauthorized`: Refresh token inválido ou expirado

---

## 🚪 Logout

Encerra a sessão do usuário e invalida o `refresh_token`.

<div class="endpoint">
  <span class="method post">POST</span>
  <span>/tripee/auth/logout</span>
</div>

**Headers:**
```
Authorization: Bearer {REFRESH_TOKEN}
Content-Type: application/json
```

**Erros Possíveis:**
- `401 Unauthorized`: Token inválido ou já expirado

---

## 📝 Uso do Access Token

Após a autenticação, todas as requisições subsequentes devem incluir o `access_token` no header:

```
Authorization: Bearer {ACCESS_TOKEN}
```

**Exemplo de requisição autenticada:**
```bash
curl -X GET https://api.example.com/tripee/planning-centers/all \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

**Próximo:** [Criação de Solicitações →](trip-creation.md) | [Edição de Solicitações →](trip-edit.md) | [Vínculo com Atendimento →](trip-job-link.md) | [Status da Solicitação →](trip-status.md)
