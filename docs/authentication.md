---
layout: default
title: Autenticação
---

# Autenticação

A API Tripee utiliza autenticação via **Azure Active Directory (Azure AD)** e tokens JWT para autorização de requisições.

## 🔐 Fluxo de Autenticação

### 1. Autenticação via Azure AD (SSO)

A autenticação principal é realizada através do Azure Active Directory.

**Endpoint:** `POST /tripee/auth/sso`

**Headers:**
```http
Authorization: Bearer {AZURE_AD_ACCESS_TOKEN}
Content-Type: application/json
```

**Resposta de Sucesso (201):**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "_id": "507f1f77bcf86cd799439011",
    "name": "João Silva",
    "email": "joao.silva@empresa.com",
    "registrationNumber": "123456"
  }
}
```

**Campos da Resposta:**
- `access_token`: Token JWT para autenticação nas requisições (validade: **2 horas**)
- `refresh_token`: Token para renovação do access_token (validade: **8 horas**)
- `user`: Dados básicos do usuário autenticado

**Erros Possíveis:**
- `401 Unauthorized`: Token Azure AD inválido ou expirado

---

## 🔄 Renovação de Token (Refresh)

Antes do `access_token` expirar, você deve renová-lo usando o `refresh_token`.

**Endpoint:** `POST /tripee/auth/refresh`

**Headers:**
```http
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

**Endpoint:** `POST /tripee/auth/logout`

**Headers:**
```http
Authorization: Bearer {REFRESH_TOKEN}
origin-platform: Web
Content-Type: application/json
```

**Valores possíveis para `origin-platform`:**
- `Web`
- `Mobile`

**Resposta de Sucesso (201):**
```json
{
  "message": "Logout successful"
}
```

**Erros Possíveis:**
- `401 Unauthorized`: Token inválido ou já expirado

---

## 📝 Uso do Access Token

Após a autenticação, todas as requisições subsequentes devem incluir o `access_token` no header:

```http
Authorization: Bearer {ACCESS_TOKEN}
```

**Exemplo de requisição autenticada:**
```bash
curl -X GET https://api.example.com/tripee/planning-centers/all \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

---

## ⏱️ Gerenciamento de Expiração

### Recomendações de Implementação

1. **Armazene os tokens de forma segura** (nunca em localStorage para aplicações web sensíveis)
2. **Implemente renovação automática:** 
   - Renove o token ~15 minutos antes de expirar
   - Ou renove ao receber erro `401` em uma requisição
3. **Trate expiração do refresh_token:**
   - Se o refresh_token expirar, redirecione para login
4. **Implemente logout ao fechar a aplicação** (opcional mas recomendado)

### Exemplo de Fluxo Recomendado

```javascript
// Pseudocódigo
async function makeAuthenticatedRequest(url, options) {
  const accessToken = getStoredAccessToken();
  
  // Verifica se o token está próximo de expirar
  if (isTokenExpiringSoon(accessToken)) {
    await refreshAccessToken();
  }
  
  // Faz a requisição
  const response = await fetch(url, {
    ...options,
    headers: {
      ...options.headers,
      'Authorization': `Bearer ${getStoredAccessToken()}`
    }
  });
  
  // Se receber 401, tenta renovar o token uma vez
  if (response.status === 401) {
    const refreshSuccess = await refreshAccessToken();
    if (refreshSuccess) {
      // Retry da requisição
      return makeAuthenticatedRequest(url, options);
    } else {
      // Redireciona para login
      redirectToLogin();
    }
  }
  
  return response;
}
```

---

## 🔒 Segurança

### Boas Práticas

✅ **Faça:**
- Armazene tokens de forma segura (cookies httpOnly ou secure storage)
- Use HTTPS em todas as requisições
- Implemente timeout de sessão no cliente
- Faça logout ao detectar atividade suspeita
- Renove tokens regularmente

❌ **Não faça:**
- Armazenar tokens em localStorage/sessionStorage para aplicações sensíveis
- Compartilhar tokens entre usuários
- Expor tokens em URLs ou logs
- Ignorar erros de autenticação

---

## 📊 Diagrama de Fluxo

```
┌─────────────┐
│   Cliente   │
└──────┬──────┘
       │
       │ 1. POST /auth/sso
       │    Header: Authorization: Bearer {AZURE_AD_TOKEN}
       ▼
┌─────────────┐
│  API Tripee │
└──────┬──────┘
       │
       │ 2. Valida token Azure AD
       │ 3. Retorna access_token + refresh_token
       ▼
┌─────────────┐
│   Cliente   │
└──────┬──────┘
       │
       │ 4. Usa access_token para requisições
       │    Header: Authorization: Bearer {ACCESS_TOKEN}
       │
       │ 5. Antes de expirar (2h), renova
       │    POST /auth/refresh
       │    Header: Authorization: Bearer {REFRESH_TOKEN}
       ▼
┌─────────────┐
│  API Tripee │
└──────┬──────┘
       │
       │ 6. Retorna novo access_token + refresh_token
       ▼
┌─────────────┐
│   Cliente   │
└─────────────┘
```

---

## 🧪 Testando a Autenticação

### Usando cURL

**1. Autenticação SSO:**
```bash
curl -X POST https://api.example.com/tripee/auth/sso \
  -H "Authorization: Bearer YOUR_AZURE_AD_TOKEN" \
  -H "Content-Type: application/json"
```

**2. Refresh Token:**
```bash
curl -X POST https://api.example.com/tripee/auth/refresh \
  -H "Authorization: Bearer YOUR_REFRESH_TOKEN" \
  -H "Content-Type: application/json"
```

**3. Logout:**
```bash
curl -X POST https://api.example.com/tripee/auth/logout \
  -H "Authorization: Bearer YOUR_REFRESH_TOKEN" \
  -H "origin-platform: Web" \
  -H "Content-Type: application/json"
```

---

## ❓ FAQ

**P: O que fazer quando o access_token expira?**  
R: Use o `refresh_token` no endpoint `/auth/refresh` para obter um novo `access_token`.

**P: O que fazer quando o refresh_token expira?**  
R: O usuário precisará fazer login novamente via Azure AD (`/auth/sso`).

**P: Posso usar o mesmo token em múltiplos dispositivos?**  
R: Não é recomendado. Cada dispositivo deve ter sua própria sessão/tokens.

**P: Preciso implementar o logout?**  
R: Não é obrigatório, mas é altamente recomendado para melhor segurança e gestão de sessões.

---

**Próximo:** [Criação de Solicitações →](trip-creation.md)
