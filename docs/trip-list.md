---
layout: default
title: Listar Solicitações
permalink: /docs/trip-list.html
---

# Listagem de Solicitações

Esta seção detalha como listar e filtrar solicitações de transporte na API, incluindo paginação, ordenação, filtros e regras de visualização.

## 📋 Visão Geral

A listagem de solicitações permite buscar, filtrar e ordenar todas as solicitações visíveis para o usuário autenticado, seguindo regras específicas de permissão.

---

## 🔍 Endpoint de Listagem

<div class="endpoint">
  <span class="method get">GET</span>
  <span>/tripee/trips/personnel</span>
</div>

**Headers:**
```
Authorization: Bearer {ACCESS_TOKEN}
```

**Parâmetros Obrigatórios:**
- `page`: Número da página (0 = primeira página)
- `limit`: Quantidade de itens por página
- `orderField`: Campo para ordenação (ex: `_id`, `createdAt`, `tripId`)
- `orderBy`: Tipo de ordenação (`1` = ascendente, `-1` = descendente)
- `requestedFor`: Filtro de data (obrigatório)

---

## 📄 Paginação

A paginação é **obrigatória** e funciona de forma simples e eficiente.

### Parâmetros

| Parâmetro | Tipo | Descrição | Exemplo |
|-----------|------|-----------|---------|
| `page` | number | Número da página (inicia em 0) | `0`, `1`, `2` |
| `limit` | number | Quantidade de itens por página | `10`, `20`, `50` |

**💡 Importante:** `page=0` representa a **primeira página**.

### Resposta

A resposta inclui informações completas sobre a paginação:

```json
{
  "statusCode": 200,
  "data": [
    // Array de solicitações
  ],
  "isLastPage": false,
  "count": 150,
  "currentPage": 0
}
```

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `statusCode` | number | Código HTTP da resposta |
| `data` | array | Array com as solicitações da página |
| `isLastPage` | boolean | `true` se for a última página |
| `count` | number | Total de solicitações encontradas |
| `currentPage` | number | Número da página atual |

### Exemplo de Paginação

```bash
# Primeira página (10 itens)
GET /tripee/trips/personnel?page=0&limit=10&orderField=_id&orderBy=-1&requestedFor=...
```

---

## 🔀 Ordenação

A ordenação é **obrigatória** e permite organizar as solicitações por qualquer campo.

### Parâmetros

| Parâmetro | Tipo | Descrição | Valores |
|-----------|------|-----------|---------|
| `orderField` | string | Campo para ordenar | `_id`, `createdAt`, `tripId`, `status`, `requestedFor` |
| `orderBy` | number | Tipo de ordenação | `1` (ascendente), `-1` (descendente) |

### Exemplos de Ordenação

```bash
# Ordenar por data de criação (mais recente primeiro)
?orderField=createdAt&orderBy=-1

# Ordenar por número da solicitação (crescente)
?orderField=tripId&orderBy=1

# Ordenar por data da viagem (mais próxima primeiro)
?orderField=requestedFor&orderBy=1

# Ordenar por status (alfabético)
?orderField=status&orderBy=1
```

### Campos Comuns para Ordenação

| Campo | Descrição | Uso Recomendado |
|-------|-----------|-----------------|
| `createdAt` | Data de criação da solicitação | Listar mais recentes primeiro |
| `tripId` | Número da solicitação | Busca por número específico |
| `requestedFor` | Data/hora da viagem | Viagens mais próximas |
| `status` | Status da solicitação | Agrupar por status |
| `_id` | ID único do documento | Ordenação padrão |

---

## 🔎 Filtros

Os filtros permitem refinar a busca de solicitações. Todos são enviados como **query parameters** com formato específico.

### ⚠️ Filtro Obrigatório

O filtro por **`requestedFor`** (data da viagem) é **obrigatório**.

### Formato dos Filtros

Os filtros seguem um formato JSON específico:

#### 1. Filtro Simples (Valor Único)

```json
{ "operator": "=", "value": "Aberta" }
```

#### 2. Filtro Múltiplo (Valores Alternativos - OR)

```json
[
  { "operator": "=", "value": "Aberta" },
  { "operator": "=", "value": "Em aprovação" }
]
```

#### 3. Filtro de Range (Intervalo)

```json
[
  { "value": {"date": "2025-01-01", "time": "00:00"}, "operator": ">=" },
  { "value": {"date": "2025-12-31", "time": "23:59"}, "operator": "<=" }
]
```

### Operadores Disponíveis

| Tipo de Campo | Operadores | Descrição |
|---------------|------------|-----------|
| **Número** | `=`, `>=`, `<=` | Igual, maior ou igual, menor ou igual |
| **String** | `=`, `===` | `=` match parcial, `===` match exato |
| **Data** | `=`, `>=`, `<=` | Igual, maior ou igual, menor ou igual |
| **Boolean** | `=` | Igual |

---

## 📝 Filtros Disponíveis

### 1. Filtro por Status (obrigatório: data)

```bash
# Status específico
?status={"operator":"=","value":"Aberta"}

# Múltiplos status (OR)
?status=[{"operator":"=","value":"Aberta"},{"operator":"=","value":"Programada"}]
```

**Exemplo URL Encoded:**
```bash
?status=%7B%22operator%22%3A%22%3D%22%2C%22value%22%3A%22Aberta%22%7D
```

---

### 2. Filtro por Data (requestedFor) - OBRIGATÓRIO

**Formato da data:**
```json
{
  "date": "2025-11-24",  // Formato: YYYY-MM-DD
  "time": "14:30"        // Formato: HH:mm
}
```

#### Exemplo: Data Específica

```bash
?requestedFor={"operator":"=","value":{"date":"2025-11-24","time":"14:30"}}
```

#### Exemplo: Range de Datas

```bash
?requestedFor=[
  {"operator":">=","value":{"date":"2025-11-01","time":"00:00"}},
  {"operator":"<=","value":{"date":"2025-11-30","time":"23:59"}}
]
```

---

### Filtro para propriedades internas de objetos

O acesso é feito via <i>dot notation</i>. Um exemplo abaixo para o array de passageiros:

```bash
# Nome do passageiro (match parcial)
?tripulation.name={"operator":"=","value":"João"}

# Nome completo (match exato)
?tripulation.name={"operator":"===","value":"João da Silva"}

# Matrícula do passageiro
?tripulation.registrationNumber={"operator":"=","value":46145810}
```

---

## 🔐 Regras de Visualização

A API aplica regras automáticas de permissão que determinam quais solicitações o usuário pode visualizar.

### Regra 1: Usuário Comum

**O usuário pode sempre visualizar:**
- ✅ Solicitações onde é o **solicitante** (criou a solicitação)
- ✅ Solicitações onde é **passageiro** (está na lista `tripulation`)

---

### Regra 2: Usuário com permissões de Logística

**Se o usuário tiver permissções de logística, pode visualizar:**
- ✅ Todas as solicitações da **Regra 1** (solicitante ou passageiro)
- ✅ Solicitações de **gerências onde é aprovador ou gestor titular**
- ✅ Solicitações de **centros de planejamento do seu cadastro**

**💡 Controle Interno:** Essas permissões são gerenciadas internamente pelo Simcorpi.

---

### Regra 3: Administrador do Sistema

**Se o usuário for administrador:**
- ✅ **Visualiza todas as solicitações** sem restrições

**💡 Controle Interno:** Função de administrador gerenciada pelo Simcorpi.

---

### Resumo de Permissões

| Tipo de Usuário | Vê Próprias Solicitações | Vê Como Passageiro | Vê Gerências | Vê Centros de Planejamento | Vê Tudo |
|-----------------|-------------------------|-------------------|--------------|---------------------------|---------|
| **Comum** | ✅ Sim | ✅ Sim | ❌ Não | ❌ Não | ❌ Não |
| **Logística** | ✅ Sim | ✅ Sim | ✅ Sim (suas) | ✅ Sim (seus) | ❌ Não |
| **Administrador** | ✅ Sim | ✅ Sim | ✅ Sim (todas) | ✅ Sim (todos) | ✅ Sim |

**⚠️ Importante:** As regras são aplicadas **automaticamente** pela API. Não é necessário enviar parâmetros adicionais de permissão.

---

## 💻 Exemplos Completos

### Exemplo 1: Listagem Básica

```bash
curl -X GET "https://api.example.com/tripee/trips/personnel?\
page=0&\
limit=20&\
orderField=createdAt&\
orderBy=-1&\
requestedFor=%5B%7B%22operator%22%3A%22%3E%3D%22%2C%22value%22%3A%7B%22date%22%3A%222025-11-01%22%2C%22time%22%3A%2200%3A00%22%7D%7D%2C%7B%22operator%22%3A%22%3C%3D%22%2C%22value%22%3A%7B%22date%22%3A%222025-11-30%22%2C%22time%22%3A%2223%3A59%22%7D%7D%5D" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

**Decodificado:**
```
page=0
limit=20
orderField=createdAt
orderBy=-1
requestedFor=[
  {"operator":">=","value":{"date":"2025-11-01","time":"00:00"}},
  {"operator":"<=","value":{"date":"2025-11-30","time":"23:59"}}
]
```

---

## 📊 Resposta Completa

```json
{
  "statusCode": 200,
  "data": [
    {
      "_id": "68e64e2d725f5da3cbc613ed",
      "createdAt": "2025-10-08T11:42:39.474Z",
      "updatedAt": "2025-10-08T14:20:50.433Z",
      "mode": "Requisição de Transporte",
      "observations": "Reunião importante",
      "planningCenter": "REPLAN",
      "requestUserTimezone": "-03:00",
      "requestedFor": "2025-11-24T14:30:00.000Z",
      "status": "Programada",
      "tripId": 4582,
      "files": [
        {
          "url": "https://cicmpetrobras.blob.core.windows.net/trips/file.pdf"
        }
      ],
      "requestedBy": {
        "_id": "6447e3292be7586024ed1ed8",
        "name": "Wilson Jnr"
      },
      "tripulation": [
        {
          "name": "João Silva",
          "registrationNumber": 46145810,
          "email": "joao.silva@empresa.com",
          "phone": "11999999999",
          "status": "Programada",
          "job": {
            "jobId": 2539,
            "status": "Pendente",
            "_id": "68e67340a9168dc169f4db46",
            "vehicleStamp": {
              "plate": "ABC1234",
              "model": "GOL 1.0",
              "color": "silver"
            },
            "driverStamp": {
              "name": "Roberto Souza",
              "phone": "11999999999"
            }
          }
        }
      ]
    }
  ],
  "isLastPage": false,
  "count": 150,
  "currentPage": 0
}
```

---

**Anterior:** [← Status do Atendimento](job-status.md)  
**Voltar para:** [Criação de Solicitações](trip-creation.md) | [Edição de Solicitações](trip-edit.md)
