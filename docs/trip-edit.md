---
layout: default
title: Editar Solicitação
permalink: /docs/trip-edit.html
---

# Edição de Solicitações de Transporte

Esta seção detalha o processo para editar uma solicitação de transporte (trip) existente na API Tripee.

## 📋 Visão Geral

A edição de solicitações permite atualizar os dados de uma viagem já criada, desde que ela atenda aos critérios de elegibilidade para edição.

### ⚠️ Restrições Importantes

- **Status Permitidos:** A solicitação só pode ser editada se estiver com status:
  - `Em aprovação`
  - `Aberta`
- **Campo Obrigatório:** O campo `updatedAt` é obrigatório e serve como controle de concorrência
- **Transição de Status:** Uma solicitação pode ter seu status alterado entre `Aberta` ↔ `Em aprovação`, dependendo das regras internas de aprovação do sistema Simcorpi

---

## 🔄 Endpoint de Edição

<div class="endpoint">
  <span class="method patch">PATCH</span>
  <span>/tripee/trips/:id/personnel</span>
</div>

**Parâmetros:**
- `id` (path): ID da solicitação a ser editada

**Content-Type:** `multipart/form-data`

**Headers:**
```
Authorization: Bearer {ACCESS_TOKEN}
Content-Type: multipart/form-data
timezone-offset: -03:00
```

---

## 📝 Campos da Requisição

### 📄 Campo `data` (JSON string)

A edição aceita os **mesmos campos da criação**, com a adição obrigatória do campo `updatedAt`.

```json
{
   "updatedAt":"2025-10-08T11:42:39.474Z",
   "mode":"Requisição de Transporte",
   "planningCenter":"REPLAN",
   "requestedFor":"2025-11-24T15:30:00.000Z",
   "requestedForLocalTimezone":"-03:00",
   "observations":"Horário alterado para 15h30",
   "tripulation":[
      {
         "name":"JOÃO DA SILVA",
         "registrationNumber":46145855,
         "email":"joao.da.silva@empresa.com",
         "phone":"11999999999",
         "department":"COMPARTILHADO",
         "pcd":false,
         "costCenter":[
            "A003ADMR01",
            "AB17RPLL15"
         ],
         "originAddress":{
            "street":"RUA SEIS",
            "streetNumber":"2250",
            "neighborhood":"BONFIM",
            "city":"PAULÍNIA",
            "state":"SÃO PAULO",
            "uf":"SP",
            "zipcode":"13147-030",
            "latitude":-22.73217,
            "longitude":-47.13737
         },
         "destinyAddress":{
            "street":"RODOVIA SANTOS DUMONT",
            "streetNumber":"KM 66",
            "neighborhood":"PARQUE VIRACOPOS",
            "city":"CAMPINAS",
            "state":"SÃO PAULO",
            "uf":"SP",
            "zipcode":"13055-900",
            "latitude":-23.0080502,
            "longitude":-47.1396595
         }
      }
   ]
}
```

### 📎 Campo `files` (arquivos)

- Até **3 arquivos**
- Tamanho máximo: **5MB por arquivo**
- Formatos aceitos: imagens (JPG, PNG, etc.) e PDF
- **Nota:** Enviar novos arquivos substituirá os anexos anteriores

---

## 🔒 Controle de Concorrência com `updatedAt`

### ⚠️ Por que o `updatedAt` é obrigatório?

O campo `updatedAt` é usado como **mecanismo de controle de concorrência otimista**. Ele garante que você está editando a versão mais recente da solicitação, evitando sobrescrever alterações feitas por outros usuários.

### Como funciona:

1. Ao buscar uma solicitação, você recebe o valor atual de `updatedAt`
2. Ao editar, você deve enviar esse mesmo valor no campo `updatedAt`
3. Se o valor enviado não coincidir com o valor atual no banco de dados, a edição será rejeitada

### 🚫 Características do `updatedAt`:

- ✅ **Obrigatório** em toda edição
- ❌ **Imutável** - você não pode alterar seu valor manualmente
- 🔄 **Atualizado automaticamente** pelo sistema após cada edição bem-sucedida
- 🛡️ **Previne conflitos** de edição simultânea

---

## 🎯 Status e Transições

### Status Permitidos para Edição

| Status | Pode Editar? | Descrição |
|--------|--------------|-----------|
| `Em aprovação` | ✅ Sim | Aguardando aprovação |
| `Aberta` | ✅ Sim | Aprovada e pronta para atendimento |
| Outros status | ❌ Não | Solicitação não pode ser editada |

### Mudanças de Status Automáticas

Durante a edição, o sistema Simcorpi pode automaticamente alterar o status da solicitação baseado nas suas regras internas de aprovação:

- **`Aberta` → `Em aprovação`**: Quando a edição requer nova aprovação
- **`Em aprovação` → `Aberta`**: Quando a edição é automaticamente aprovada

**💡 Você não controla essa transição - ela é determinada pelas regras de negócio do Simcorpi.**

---

## 📚 Detalhamento dos Campos

### Campo Adicional Obrigatório

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `updatedAt` | string (ISO 8601) | Timestamp da última atualização (controle de concorrência) |

### Demais Campos

Todos os outros campos seguem as mesmas regras da [Criação de Solicitações](trip-creation.md#-detalhamento-dos-campos).

---

## 💻 Exemplo de Requisição

### Usando cURL

```bash
curl -X PATCH https://api.example.com/tripee/trips/68e64e2d725f5da3cbc613ed/personnel \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "timezone-offset: -03:00" \
  -F 'data={
      "updatedAt": "2025-10-08T11:42:39.474Z",
      "mode": "Requisição de Transporte",
      "planningCenter": "REPLAN",
      "requestedFor": "2025-11-24T15:30:00.000Z",
      "requestedForLocalTimezone": "-03:00",
      "observations": "Horário alterado para 15h30",
      "tripulation": [
        {
          "name": "JOÃO DA SILVA",
          "registrationNumber": 46145855,
          "email": "joao.da.silva@empresa.com",
          "phone": "11999999999",
          "department": "COMPARTILHADO",
          "pcd": false,
          "costCenter": [
            "A003ADMR01",
            "AB17RPLL15"
          ],
          "originAddress": {
            "street": "RUA SEIS",
            "streetNumber": "2250",
            "neighborhood": "BONFIM",
            "city": "PAULÍNIA",
            "state": "SÃO PAULO",
            "uf": "SP",
            "zipcode": "13147-030",
            "latitude": -22.73217,
            "longitude": -47.13737
          },
          "destinyAddress": {
            "street": "RODOVIA SANTOS DUMONT",
            "streetNumber": "KM 66",
            "neighborhood": "PARQUE VIRACOPOS",
            "city": "CAMPINAS",
            "state": "SÃO PAULO",
            "uf": "SP",
            "zipcode": "13055-900",
            "latitude": -23.0080502,
            "longitude": -47.1396595
          }
        }
      ]
    }' \
  -F 'files=@/path/to/new-attachment.pdf'
```

---

## ✅ Resposta de Sucesso

**Status:** `200 OK`

```json
{
  "data": {
    "_id": "68e64e2d725f5da3cbc613ed",
    "createdAt": "2025-10-08T11:42:39.474Z",
    "updatedAt": "2025-10-08T13:25:15.892Z",
    "mode": "Requisição de Transporte",
    "observations": "Horário alterado para 15h30",
    "planningCenter": "REPLAN",
    "requestUserTimezone": "-03:00",
    "requestedFor": "2025-11-24T15:30:00.000Z",
    "status": "Em aprovação",
    "tripId": 4582,
    "files": [
      {
        "url": "https://cicmpetrobras.blob.core.windows.net/trips/new-attachment.pdf"
      }
    ],
    "requestedBy": {
      "_id": "6447e3292be7586024ed1f12",
      "name": "Nome do Solicitante"
    },
    "tripulation": [
      {
        "costCenter": [
          "A003ADMR01",
          "AB17RPLL15"
        ],
        "department": "COMPARTILHADO/SC/SMOB/GT",
        "email": "joao.da.silva@empresa.com",
        "isVip": false,
        "name": "JOÃO DA SILVA",
        "pcd": false,
        "phone": "11999999999",
        "registrationNumber": 46145855,
        "destinyAddress": {
          "city": "CAMPINAS",
          "latitude": -23.0080502,
          "longitude": -47.1396595,
          "neighborhood": "PARQUE VIRACOPOS",
          "state": "SÃO PAULO",
          "street": "RODOVIA SANTOS DUMONT",
          "streetNumber": "KM 66",
          "zipcode": "13055-900"
        },
        "originAddress": {
          "city": "PAULÍNIA",
          "latitude": -22.73217,
          "longitude": -47.13737,
          "neighborhood": "BONFIM",
          "state": "SÃO PAULO",
          "street": "RUA SEIS",
          "streetNumber": "2250",
          "zipcode": "13147-030"
        }
      }
    ]
  },
  "statusCode": 200
}
```

**Campos atualizados na resposta:**
- `updatedAt`: Novo timestamp após a edição
- `status`: Pode ter mudado baseado nas regras de aprovação

---

## ❌ Erros Possíveis

### 400 Bad Request - Conflito de concorrência

```json
{
  "statusCode": 409,
  "message": "A solicitação foi modificada por outro usuário. Por favor, busque os dados atualizados e tente novamente."
}
```

**Causa:** O valor de `updatedAt` enviado não corresponde ao valor atual no banco de dados.

**Solução:**
1. Busque novamente a solicitação (GET)
2. Use o novo valor de `updatedAt` retornado
3. Tente editar novamente

---

### 400 Bad Request - Status não permite edição

```json
{
  "statusCode": 400,
  "message": "A solicitação não pode ser editada. Status atual: Cancelada"
}
```

**Causa:** A solicitação não está com status `Em aprovação` ou `Aberta`.

**Solução:** Apenas solicitações com status `Em aprovação` ou `Aberta` podem ser editadas.

---

### 404 Not Found - Solicitação não encontrada

```json
{
  "statusCode": 404,
  "message": "Solicitação não encontrada"
}
```

**Causa:** O ID fornecido não corresponde a nenhuma solicitação existente.

---

### 401 Unauthorized - Token inválido

```json
{
  "statusCode": 401,
  "message": "Token de autenticação inválido ou expirado"
}
```

**Solução:** Renove seu token de acesso usando o endpoint de [refresh](authentication.md#-renovação-de-token-refresh).

---

## 🔍 Buscando uma Solicitação para Editar

Antes de editar, você precisa buscar os dados atuais da solicitação para obter o `updatedAt` correto:

<div class="endpoint">
  <span class="method get">GET</span>
  <span>/tripee/trips/:id</span>
</div>

**Headers:**
```
Authorization: Bearer {ACCESS_TOKEN}
```

**Exemplo:**
```bash
curl -X GET https://api.example.com/tripee/trips/68e64e2d725f5da3cbc613ed \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

**Resposta:**
```json
{
  "_id": "68e64e2d725f5da3cbc613ed",
  "updatedAt": "2025-10-08T11:42:39.474Z",
  "status": "Em aprovação",
  ...
}
```

---

**Próximo:** [Vínculo com Atendimento →](trip-job-link.md) | [Status da Solicitação →](trip-status.md)  
**Anterior:** [← Criação de Solicitações](trip-creation.md)  
**Voltar para:** [Autenticação](authentication.md)
