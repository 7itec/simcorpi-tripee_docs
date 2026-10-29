---
layout: default
title: Webhook de Atualização
permalink: /docs/webhook.html
---

# Webhook de Atualização de Solicitações

Sempre que uma solicitação criada pela Tripee (ou o atendimento vinculado a ela) muda no Simcorpi, o Simcorpi **envia o estado atualizado da solicitação** para um endpoint da Tripee. Assim a Tripee mantém o painel sincronizado sem precisar consultar a API periodicamente.

---

## 📋 Visão Geral

- **Direção:** Simcorpi → Tripee
- **Escopo:** apenas solicitações criadas pela Tripee
- **Conteúdo:** o objeto **completo** da solicitação no momento do envio (não apenas o que mudou)

---

## 🔔 Quando o webhook é enviado

| Situação | `typeContent` |
|----------|---------------|
| Solicitação aprovada, reprovada, editada ou cancelada | `status` |
| Solicitação marcada como **Inviabilidade** ou **Falta de recurso** (ou inviabilidade aprovada) | `status` |
| Atendimento criado, editado ou cancelado para a solicitação | `status` |
| Mudança de status do atendimento (aceito, deslocamento, chegada, atendimento, finalizado etc.) | `status` |
| Motorista desvinculado do atendimento | `status` |
| Nova posição do veículo recebida das integrações de táxi | `position` |

> As posições do **aplicativo do motorista Simcorpi** não usam o webhook: elas são publicadas na [Fila de Posições](positions-queue.md).

---

## 📡 Requisição enviada

<div class="endpoint">
  <span class="method post">POST</span>
  <span>{URL do webhook configurada para a Tripee}</span>
</div>

**Headers:**
```
x-api-token: {TOKEN combinado com a Tripee}
Content-Type: application/json
```

| Item | Valor |
|------|-------|
| Autenticação | Header `x-api-token` com o token combinado entre Simcorpi e Tripee |
| Timeout | 10 segundos |
| Resposta esperada | Qualquer status `2xx` |
| Tentativas | Até **3 tentativas** no total, com intervalo crescente (5 s e depois 10 s) |

**⚠️ Importante:** timeouts e respostas fora da faixa `2xx` são tratados como falha e disparam nova tentativa. Após a terceira falha a notificação é descartada; o estado volta a ser sincronizado no próximo webhook da mesma solicitação.

---

## 📦 Payload

O corpo segue o mesmo formato do item da [listagem de solicitações](trip-list.md#campos-retornados), com campos adicionais de controle na raiz e de execução no atendimento.

```json
{
  "typeContent": "status",
  "simcorpiRideExternalId": 4582,
  "userId": "6447e3292be7586024ed1ed8",
  "_id": "68e64e2d725f5da3cbc613ed",
  "tripId": 4582,
  "status": "Atendida",
  "mode": "Requisição de Transporte",
  "observations": "Reunião importante",
  "planningCenter": "REPLAN",
  "requestUserTimezone": "-03:00",
  "requestedFor": "2025-11-24T14:30:00.000Z",
  "createdAt": "2025-10-08T11:42:39.474Z",
  "updatedAt": "2025-11-24T15:20:10.000Z",
  "files": [
    { "url": "https://cicmpetrobras.blob.core.windows.net/trips/file.pdf" }
  ],
  "requestedBy": {
    "_id": "6447e3292be7586024ed1ed8",
    "name": "Pedro Souza"
  },
  "createdBy": {
    "_id": "6447e3292be7586024ed1ed8",
    "name": "Pedro Souza",
    "registrationNumber": 73465811,
    "companyAcronym": "PETROBRAS"
  },
  "approvedBy": {
    "name": "Aprovador CICM",
    "department": "COMPARTILHADO/SC/SMOB/GT"
  },
  "costEstimate": {
    "value": 89.9,
    "currency": "BRL",
    "estimatedKm": 12.5
  },
  "tripulation": [
    {
      "name": "João Silva",
      "registrationNumber": 46145810,
      "email": "joao.silva@empresa.com",
      "phone": "11999999999",
      "department": "COMPARTILHADO/SC/SMOB/GT",
      "costCenter": ["A003ADMR01"],
      "pcd": false,
      "isVip": false,
      "companyAcronym": "PETROBRAS",
      "identityKey": "PETROBRAS:46145810",
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
      },
      "job": {
        "_id": "68e67340a9168dc169f4db46",
        "jobId": 2539,
        "status": "Finalizado",
        "startDate": "2025-11-24T14:30:00.000Z",
        "endDate": "2025-11-24T15:12:29.000Z",
        "observations": "Passageiro com bagagem volumosa",
        "providerCompanyName": "INFOTEC BRASIL",
        "serviceType": "Táxi",
        "contractNumber": "4600559876",
        "budget": 16.87,
        "executedValue": 18.33,
        "stoppedValue": 1.2,
        "realizedDistanceKm": 13.1,
        "realizedStartDate": "2025-11-24T14:35:02.000Z",
        "realizedEndDate": "2025-11-24T15:18:40.000Z",
        "vehicleStamp": {
          "plate": "ABC1234",
          "model": "GOL 1.0",
          "color": "silver",
          "recentPosition": {
            "latitude": -23.0080502,
            "longitude": -47.1396595
          }
        },
        "driverStamp": {
          "name": "Roberto Souza",
          "phone": "11999999999",
          "profilePicture": {
            "url": "https://example.com/driver.png"
          }
        },
        "route": {
          "polyline": "encoded_polyline_value"
        }
      }
    }
  ]
}
```

> Campos sem valor (ex.: solicitação sem aprovador, passageiro sem atendimento, atendimento ainda não finalizado) **não aparecem** no payload. Trate todos como opcionais.

> O exemplo acima é de uma corrida de táxi e, por isso, não traz `job.providerCompanyLogoUrl`. Em atendimentos nativos (`DEDICADO`, `COLETIVO`, `POOL`, `EVENTUAL`, `DESLOCAMENTO`) cujo veículo pertence a uma empresa com logomarca cadastrada, o `job` inclui esse campo com a URL da logo — veja [Listar Solicitações](trip-list.md#-logomarca-da-empresa-operadora-jobprovidercompanylogourl).

---

## 📚 Campos exclusivos do webhook

Os demais campos têm o mesmo significado descrito em [Listar Solicitações](trip-list.md#campos-retornados).

### Raiz

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `typeContent` | string | Motivo do envio: `status` (mudança de estado) ou `position` (nova posição do veículo) |
| `simcorpiRideExternalId` | number \| string | Identificador da solicitação no Simcorpi |
| `userId` | string \| number | Usuário de referência: ID do solicitante; na falta dele, ID ou matrícula do primeiro passageiro |

### Atendimento (`tripulation[].job`)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `observations` | string | Observações registradas no **atendimento** (diferente de `observations` da raiz, que são as observações da solicitação) |
| `providerCompanyName` | string | Prestador de serviço do atendimento |
| `serviceType` | string | Categoria do serviço: `Táxi`, `Uber` ou `Dedicado` |
| `contractNumber` | string | Número do contrato do atendimento |
| `budget` | number | Valor orçado da estimativa de táxi escolhida (R$) |
| `executedValue` | number | Valor final cobrado na corrida (R$) |
| `stoppedValue` | number | Valor cobrado por tempo parado (R$) |
| `realizedDistanceKm` | number | Distância percorrida em **km** |
| `realizedStartDate` / `realizedEndDate` | string (ISO 8601) | Início/fim reais do atendimento (UTC) |

### Aprovador (`approvedBy`)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `approvedBy.name` | string | Nome de quem aprovou a solicitação |
| `approvedBy.department` | string | Gerência de quem aprovou, registrada no momento da aprovação |

**⚠️ Importante:** solicitações aprovadas automaticamente (sem etapa de aprovação) não possuem `approvedBy`.

---

**Anterior:** [← Listar Solicitações](trip-list.md)  
**Próximo:** [Fila de Posições →](positions-queue.md)
