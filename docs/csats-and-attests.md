---
layout: default
title: CSAT e Atestes Pendentes
permalink: /docs/csats-and-attests.html
---

# CSAT e Atestes Pendentes

Esta seção detalha o endpoint para listar atendimentos finalizados com pesquisa de satisfação (CSAT) e/ou ateste pendentes para o usuário autenticado.

> **Importante:** diferente dos demais endpoints Tripee de solicitações, a origem deste retorno é o **atendimento (job)**, e não a solicitação (trip).

---

## 📋 Visão Geral

O endpoint retorna atendimentos em que o usuário autenticado é **passageiro** ou **solicitante** e ainda possui pendências de:

- Pesquisa de satisfação (CSAT)
- Ateste do atendimento

Os itens podem ser filtrados pelo tipo de pendência (`all`, `csat` ou `attest`).

A partir dessa listagem, a Tripee pode:

1. Responder a pesquisa → [Responder CSAT](csat.md)
2. Confirmar ou contestar o ateste → [Ateste e Contestação](attest.md)

O campo `attestationAlertId` retornado em cada item é o identificador do alerta usado nos endpoints de ateste/contestação.

---

## 🔍 Endpoint de Listagem

<div class="endpoint">
  <span class="method get">GET</span>
  <span>/tripee/trips/csats-and-attests</span>
</div>

**Headers:**
```
Authorization: Bearer {ACCESS_TOKEN}
```

---

## 📄 Paginação

A paginação é **obrigatória** e segue o padrão das demais listagens da API.

### Parâmetros

| Parâmetro | Tipo | Obrigatório | Descrição | Exemplo |
|-----------|------|-------------|-----------|---------|
| `page` | number | Não* | Número da página (inicia em 0). Padrão: `0` | `0`, `1`, `2` |
| `limit` | number | Não* | Quantidade de itens por página. Padrão: `50` | `10`, `20`, `50` |
| `searchType` | string | Não | Tipo de pendência a buscar. Padrão: `all` | `all`, `csat`, `attest` |

\* Quando omitidos, a API aplica `page=0` e `limit=50`.

### ⚠️ Limite máximo

O valor máximo de `limit` é **50**. Valores maiores retornam erro de validação.

### Valores de `searchType`

| Valor | Descrição |
|-------|-----------|
| `all` | Retorna atendimentos com CSAT e/ou ateste pendentes |
| `csat` | Retorna apenas atendimentos com CSAT pendente |
| `attest` | Retorna apenas atendimentos com ateste pendente |

### Resposta de Paginação

```json
{
  "count": 12,
  "currentPage": 0,
  "isLastPage": true,
  "data": []
}
```

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `count` | number | Total de atendimentos encontrados |
| `currentPage` | number | Página atual |
| `isLastPage` | boolean | `true` se for a última página |
| `data` | array | Lista de atendimentos da página |

---

## 🔐 Regras de Visualização

A API aplica automaticamente as regras abaixo:

- ✅ Só retorna atendimentos em que o usuário autenticado é **passageiro** (`tripulation._id`) ou **solicitante** (`tripulation.tripRequestedBy._id`)
- ✅ No array `tripulation` de cada item, permanecem apenas os passageiros relacionados ao usuário autenticado (ele próprio ou aqueles em que ele é solicitante)

---

## 📊 Campos Retornados

### Campos do atendimento

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `_id` | string | ID do atendimento |
| `jobId` | number | Número sequencial do atendimento |
| `status` | string | Status do atendimento |
| `startDate` | string (ISO) | Data/hora planejada de início |
| `endDate` | string (ISO) | Data/hora planejada de fim |
| `serviceType` | string | Tipo de serviço (ex.: `DEDICADO`) |
| `contractNumber` | string \| number | Número do contrato |
| `attestationAlertId` | string | ID do alerta de ateste — usar nos endpoints de confirmar/contestar |
| `vehicleStamp.plate` | string | Placa do veículo |
| `vehicleStamp.model` | string | Modelo do veículo |
| `vehicleStamp.color` | string | Cor do veículo |
| `driverStamp.name` | string | Nome do motorista |
| `driverStamp.phone` | string | Telefone do motorista |
| `driverStamp.profilePicture.url` | string | URL da foto do motorista |
| `realizedStartDate` | string (ISO) | Data/hora realizada do início |
| `realizedEndDate` | string (ISO) | Data/hora realizada do fim |
| `hasPendingAttest` | boolean | `true` quando o atendimento ainda está com ateste pendente |
| `hasPendingCsat` | boolean | `true` quando o usuário autenticado ainda não respondeu a pesquisa de satisfação |

### Campos de `tripulation`

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `_id` | string | ID do passageiro |
| `name` | string | Nome do passageiro |
| `registrationNumber` | number | Matrícula |
| `identityKey` | string | Chave de identidade |
| `email` | string | E-mail |
| `registrationKey` | string | Chave de registro |
| `isVip` | boolean | Indica se é VIP |
| `costCenter` | string[] | Centros de custo |
| `tripId` | number | Número da solicitação vinculada |
| `originAddress.*` | object | Endereço de origem (street, streetNumber, neighborhood, city, state, uf, zipCode, latitude, longitude) |
| `destinyAddress.*` | object | Endereço de destino (mesma estrutura) |

---

## 💻 Exemplos

### Exemplo 1: Listar todas as pendências

```bash
curl -X GET "https://api.example.com/tripee/trips/csats-and-attests?page=0&limit=20&searchType=all" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### Exemplo 2: Apenas CSAT pendente

```bash
curl -X GET "https://api.example.com/tripee/trips/csats-and-attests?page=0&limit=50&searchType=csat" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### Exemplo 3: Apenas ateste pendente

```bash
curl -X GET "https://api.example.com/tripee/trips/csats-and-attests?page=0&limit=10&searchType=attest" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

---

## 📦 Exemplo de Resposta

```json
{
  "count": 1,
  "currentPage": 0,
  "isLastPage": true,
  "data": [
    {
      "_id": "68e51d0d1702b4e46af96509",
      "jobId": 2539,
      "status": "Finalizado",
      "startDate": "2025-10-16T06:00:00.000Z",
      "endDate": "2025-10-16T07:00:00.000Z",
      "serviceType": "DEDICADO",
      "contractNumber": 4600559876,
      "attestationAlertId": "68e51d0d1702b4e46af96500",
      "realizedStartDate": "2025-10-16T06:10:00.000Z",
      "realizedEndDate": "2025-10-16T07:15:00.000Z",
      "hasPendingAttest": true,
      "hasPendingCsat": true,
      "vehicleStamp": {
        "plate": "ABC1D23",
        "model": "VAN",
        "color": "Branco"
      },
      "driverStamp": {
        "name": "João da Silva",
        "phone": "11999999999",
        "profilePicture": {
          "url": "https://example.com/driver.png"
        }
      },
      "tripulation": [
        {
          "_id": "6447e3292be7586024ed1ed8",
          "name": "Maria da Silva",
          "registrationNumber": 12345678,
          "identityKey": "ABCD",
          "email": "maria.silva@empresa.com",
          "isVip": false,
          "costCenter": ["A003ADMR01"],
          "tripId": 4582,
          "originAddress": {
            "street": "R. SENA MADUREIRA",
            "streetNumber": "415",
            "neighborhood": "VILA MARIANA",
            "city": "SÃO PAULO",
            "state": "SÃO PAULO",
            "uf": "SP",
            "zipCode": "04021-051",
            "latitude": -23.5937357,
            "longitude": -46.6402032
          },
          "destinyAddress": {
            "street": "AV. PAULISTA",
            "streetNumber": "1000",
            "neighborhood": "BELA VISTA",
            "city": "SÃO PAULO",
            "state": "SÃO PAULO",
            "uf": "SP",
            "zipCode": "01310-100",
            "latitude": -23.561414,
            "longitude": -46.655881
          }
        }
      ]
    }
  ]
}
```

---

## ❌ Erros Possíveis

| Situação | Mensagem / comportamento |
|----------|--------------------------|
| `searchType` inválido | Tipo de busca inválido. Os valores permitidos são: `all`, `csat` e `attest` |
| `limit` > 50 | O limite máximo por página é de 50 elementos |
| Paginação inválida (`page`/`limit` negativos ou não numéricos) | Paginação inválida |
| Token inválido/ausente | `401 Unauthorized` |

---

## 🔗 Fluxo Recomendado

```
1. GET /tripee/trips/csats-and-attests
        │
        ├─ hasPendingCsat = true  → POST /tripee/csats
        │
        └─ hasPendingAttest = true → usar attestationAlertId
                ├─ PATCH /tripee/alerts/:id/attest/confirm
                └─ PATCH /tripee/alerts/:id/attest/contest
```

**Próximo:** [Responder CSAT →](csat.md) | [Ateste e Contestação →](attest.md)
