---
layout: default
title: Criar Solicitação
permalink: /docs/trip-creation.html
---

# Criação de Solicitações de Transporte

Esta seção detalha o processo completo para criar uma solicitação de transporte (trip) na API.

## 📋 Visão Geral do Processo

A criação de uma solicitação envolve algumas etapas principais:

1. **Buscar Centros de Planejamento** disponíveis
2. **Consultar Tipos de Viagem** (`modes`) do centro de planejamento escolhido escolhido
3. **Preencher dados dos passageiros** (`tripulation`)
4. **Definir timezone da localidade** onde a viagem será executada
5. **Criar a solicitação** com todos os dados necessários

---

## 1️⃣ Buscar Centros de Planejamento

Primeiro, obtenha a lista de centros de planejamento disponíveis.

<div class="endpoint">
  <span class="method get">GET</span>
  <span>/tripee/planning-centers/all</span>
</div>

**Headers:**
```
Authorization: Bearer {ACCESS_TOKEN}
```

**Resposta de Sucesso (200):**
```json
[
  {
    "_id": "507f1f77bcf86cd799439011",
    "name": "REPLAN"
  },
  {
    "_id": "507f1f77bcf86cd799439012",
    "name": "REDUC"
  },
  {
    "_id": "507f1f77bcf86cd799439013",
    "name": "RPBC"
  }
]
```

**💡 O usuário deve escolher um centro de planejamento desta lista.**

---

## 2️⃣ Consultar Tipos de Viagem (Modes)

Após escolher um centro de planejamento, consulte os tipos de viagem disponíveis para aquele centro.

<div class="endpoint">
  <span class="method get">GET</span>
  <span>/tripee/planning-centers/:id/modes</span>
</div>

**Parâmetros:**
- `id` (path): ID do centro de planejamento escolhido

**Headers:**
```
Authorization: Bearer {ACCESS_TOKEN}
```

**Exemplo de Requisição:**
```bash
GET /tripee/planning-centers/507f1f77bcf86cd799439011/modes
```

**Resposta de Sucesso (200):**
```json
[
  "Regime Turno - Entrada",
  "Regime Turno - Saída",
  "Reunião ou Serviço Externo"
]
```

**💡 O usuário deve escolher um tipo de viagem desta lista.**

---

## 3️⃣ Buscar Centros de Custo

Para cada passageiro, é necessário fornecer um centro de custo válido.

<div class="endpoint">
  <span class="method get">GET</span>
  <span>/tripee/cost-centers/names/:name</span>
</div>

**Parâmetros:**
- `name` (path): Nome do centro de custo (deve ter **match EXATO**)

**Headers:**
```
Authorization: Bearer {ACCESS_TOKEN}
```

**Exemplo de Requisição:**
```bash
GET /tripee/cost-centers/names/A003ADMR01
```

**Resposta de Sucesso (200):**
```json
[
  {
    "_id": "707f1f77bcf86cd799439031",
    "name": "A003ADMR01"
  }
]
```

**⚠️ Importante:** 
- A busca deve ser **exata** (case-sensitive)
- Se não houver correspondência exata, o centro de custo não será encontrado
- Cada passageiro pode ter múltiplos centros de custo

---

## 4️⃣ Criar a Solicitação

Agora que você tem todos os dados necessários, pode criar a solicitação.

<div class="endpoint">
  <span class="method post">POST</span>
  <span>/tripee/trips/personnel</span>
</div>

**Content-Type:** `multipart/form-data`

**Headers:**
```
Authorization: Bearer {ACCESS_TOKEN}
Content-Type: multipart/form-data
timezone-offset: -03:00
```

**Campos do Formulário:**

### 📄 Campo `data` (JSON string)

```json
{
  "mode": "Requisição de Transporte",
  "planningCenter": "REPLAN",
  "requestedFor": "2025-11-24T14:30:00.000Z",
  "requestedForLocalTimezone": "-03:00",
  "observations": "Reunião importante com diretoria",
  "tripulation": [
    {
      "name": "JOÃO DA SILVA",
      "registrationNumber": 46145810,
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
}
```

### 📎 Campo `files` (arquivos)

- Até **3 arquivos**
- Tamanho máximo: **5MB por arquivo**
- Formatos aceitos: imagens (JPG, PNG, etc.) e PDF

---

## 📝 Detalhamento dos Campos

### Campos Obrigatórios da Solicitação

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `mode` | string | Nome do tipo de viagem escolhido |
| `planningCenter` | string | Nome do centro de planejamento escolhido |
| `requestedFor` | string (ISO 8601) | Data/hora da viagem em **UTC** |
| `requestedForLocalTimezone` | string | Timezone offset do local da viagem |
| `tripulation` | array | Lista de passageiros (mínimo 1) |

### Campos Opcionais da Solicitação

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `observations` | string | Observações sobre a viagem |
| `files` | files | Anexos (até 3, máx 5MB cada) |

### Campos do Passageiro (tripulation)

#### Obrigatórios:

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `name` | string | Nome completo do passageiro |
| `registrationNumber` | number | Número de matrícula. É a maneira em como iremos relacionar o passageiro enviado na integração com os usuários existentes no nosso banco de dados |
| `email` | string | E-mail do passageiro |
| `phone` | string | Telefone para contato. Deve ter 11 dígitos |
| `costCenter` | string[] | Lista de centros de custo |
| `originAddress` | object | Endereço de origem |
| `destinyAddress` | object | Endereço de destino |

#### Opcionais:

| Campo | Tipo | Descrição | Padrão |
|-------|------|-----------|--------|
| `department` | string | Departamento do passageiro |
| `isVip` | boolean | Se é passageiro VIP ou Alta Administração | false |
| `pcd` | boolean | Se o passageiro é PCD | false |



### Campos do Endereço (originAddress e destinyAddress)

#### Obrigatórios:

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `street` | string | Endereço da rua |
| `city` | string | Cidade |
| `state` | string | Estado completo. Exemplo: "SÃO PAULO" |
| `latitude` | number | Latitude do endereço |
| `longitude` | number | Longitude do endereço |

#### Opcionais:

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `streetNumber` | string | Número da rua ou KM |
| `neighborhood` | string | Bairro |
| `uf` | string | Estado em UF. Exemplo: "SP" |
| `zipcode` | string | CEP | 
| `country` | string | País |

---

## ⏰ Gerenciamento de Timezone

A API trabalha com três conceitos de timezone:

### 1. Data da Viagem (UTC)

O campo `requestedFor` deve ser enviado em **UTC (ISO 8601)**:

```json
{
  "requestedFor": "2024-04-25T14:30:00.000Z"
}
```

### 2. Timezone Local da Viagem

Enviar no corpo da requisição (campo `requestedForLocalTimezone`):

```json
{
  "requestedForLocalTimezone": "-03:00"
}
```

Este é o offset do timezone da **localidade onde a viagem será executada**.

**Exemplos:**
- Brasília: `-03:00`
- Manaus: `-04:00`
- Fernando de Noronha: `-02:00`

### 3. Timezone do Usuário

Enviar no **header** `timezone-offset`:

```
timezone-offset: -03:00
```

Este é o offset do timezone da **localidade onde o usuário está fazendo a requisição**.

### Exemplo usando cURL

```bash
curl -X POST https://api.example.com/tripee/trips/personnel \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "timezone-offset: -03:00" \
  -F 'data={
      "mode": "Requisição de Transporte",
      "planningCenter": "REPLAN",
      "requestedFor": "2025-11-24T14:30:00.000Z",
      "requestedForLocalTimezone": "-03:00",
      "observations": "Reunião importante com diretoria",
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
  -F 'files=@/path/to/sample.pdf' \
  -F 'files=@/path/to/sample.jpeg'
```

---

## ✅ Resposta de Sucesso

**Status:** `201 Created`

```json
{
  "data": {
    "_id": "68e64e2d725f5da3cbc613ed",
    "createdAt": "2025-10-08T11:42:39.474Z",
    "mode": "Requisição de Transporte",
    "observations": "Reunião importante com diretoria",
    "planningCenter": "REPLAN",
    "requestUserTimezone": "-03:00",
    "requestedFor": "2025-11-24T14:30:00.000Z",
    "status": "Aberta",
    "tripId": 4582,
    "updatedAt": "2025-10-08T11:42:39.474Z",
    "files": [
      {
        "url": "https://cicmpetrobras.blob.core.windows.net/trips/fae98393-cd63-4bdb-94a2-bb3f107233e0-sample.jpeg"
      },
      {
        "url": "https://cicmpetrobras.blob.core.windows.net/trips/85e40fcc-3467-4fb8-a0b7-325cc285e2cf-sample.pdf"
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
  "statusCode": 201
},
```

**Possíveis Status após a criação**
- `Em aprovação`: Aguardando aprovação. A grande maioria das solicitações terá esse status inicial.
- `Aberta`: Aprovada e pronta para criação do atendimento. A solicitação fica nesse status quando é aprovada automaticamente.

**Próximo:** [Edição de Solicitações →](trip-edit.md) | [Vínculo com Atendimento →](trip-job-link.md) | [Status da Solicitação →](trip-status.md)  
**Anterior:** [← Autenticação](authentication.md)
