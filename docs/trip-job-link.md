---
layout: default
title: Vínculo com Atendimento
permalink: /docs/trip-job-link.html
---

# Vínculo da Solicitação com Atendimento

Esta seção explica como funciona o vínculo entre solicitações de transporte e atendimentos, e quais informações são retornadas no `GET /tripee/trips/:id` quando esse vínculo é estabelecido.

## 📋 Visão Geral

### O que é uma Solicitação?
A **solicitação** é o pedido de corrida criado pelo usuário, contendo informações sobre passageiros, origem, destino e data/hora desejada.

### O que é um Atendimento?
O **atendimento** (job) é a **execução concreta** dessa corrida, contendo informações operacionais como:
- 🚗 Veículo alocado
- 👨‍✈️ Motorista designado
- 📅 Datas de início e fim planejadas
- 🗺️ Rota calculada
- 👥 Capacidade e confirmações de presença (rotas fixas / fretamento)

---

## 🔗 Como Funciona o Vínculo

Quando um atendimento é criado e vinculado a uma solicitação, duas mudanças principais ocorrem:

### 1. Mudança de Status da Solicitação

O status da solicitação é automaticamente alterado para **`Programada`**.

**Fluxo de Status:**
```
Aberta → Programada
```

### 2. Inclusão de Informações do Atendimento

As informações do atendimento são incluídas **dentro de cada passageiro** na propriedade `tripulation[].job`.

**💡 Por que dentro de cada passageiro?**

Porque uma solicitação pode ter múltiplos passageiros, e cada passageiro pode ser atendido por um atendimento diferente (embora não seja comum).

**🔒 Privacidade no Tripee**

No `GET /tripee/trips/:id`, a API retorna apenas o(s) passageiro(s) relevantes ao usuário autenticado. Dentro de `job.tripulation`, também permanece **somente o passageiro autenticado** (não a lista completa do veículo). A ocupação geral do atendimento é exposta pelos campos agregados `numberOfPassengersConfirmed` e `vehicleStamp.numberOfPassengers`.

---

## 🔍 Buscando uma Solicitação com Atendimento

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

---

## ✅ Resposta com Atendimento Vinculado

**Status:** `200 OK`

> Os campos de táxi, CSAT, bandas B1/B2, `fixedRoute` e `stops` aparecem conforme o tipo de atendimento. Campos numéricos de distância planejada/percorrida vêm em **quilômetros** (com arredondamento).

```json
{
  "statusCode": 200,
  "data": {
    "_id": "68e64e2d725f5da3cbc613ed",
    "createdAt": "2025-10-08T11:42:39.474Z",
    "mode": "Requisição de Transporte",
    "observations": "Teste de integração",
    "planningCenter": "REPLAN",
    "priceEstimate": {
      "estimatedKm": 12.5,
      "finalPrice": 89.9
    },
    "requestUserTimezone": "-03:00",
    "requestedFor": "2025-11-24T14:30:00.000Z",
    "status": "Programada",
    "tripId": 4582,
    "updatedAt": "2025-10-08T14:20:50.433Z",
    "approvedBy": {
      "_id": "6447e3292be7586024ed1ed9",
      "name": "Aprovador CICM"
    },
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
        "costCenter": ["A003ADMR01", "AB17RPLL15"],
        "department": "COMPARTILHADO/SC/SMOB/GT",
        "email": "joao.da.silva@empresa.com",
        "isVip": false,
        "name": "JOÃO DA SILVA",
        "pcd": false,
        "phone": "11999999999",
        "registrationNumber": 46145810,
        "role": "Analista",
        "status": "Pendente",
        "tripMode": "Requisição de Transporte",
        "tripObservations": "Teste de integração",
        "tripPlanningCenter": "REPLAN",
        "tripCreatedAt": "2025-10-08T11:42:39.474Z",
        "tripRequestedBy": {
          "_id": "6447e3292be7586024ed1f12",
          "name": "Nome do Solicitante"
        },
        "tripApprovedBy": {
          "_id": "6447e3292be7586024ed1ed9",
          "name": "Aprovador CICM"
        },
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
        },
        "job": {
          "_id": "68e67340a9168dc169f4db46",
          "jobId": 2539,
          "status": "Pendente",
          "startDate": "2025-11-24T14:30:00.000Z",
          "endDate": "2025-11-24T15:12:29.000Z",
          "actualStartDate": null,
          "actualEndDate": null,
          "buildingName": "REPLAN",
          "createdAt": "2025-10-08T14:20:50.433Z",
          "requestedByName": "Sistema CICM",
          "createdAtDateFormatted": "08/10/2025",
          "createdAtTimeFormatted": "11:20",
          "startDateFormatted": "24/11/2025",
          "startTimeFormatted": "11:30",
          "endDateFormatted": "24/11/2025",
          "endTimeFormatted": "12:12",
          "actualStartDateFormatted": null,
          "actualStartTimeFormatted": null,
          "actualEndDateFormatted": null,
          "actualEndTimeFormatted": null,
          "observations": "Observação do atendimento",
          "serviceProvider": "INFOTEC BRASIL",
          "serviceType": "COLETIVO",
          "contractStamp": {
            "contract": 4600559876
          },
          "originAddress": {
            "name": "EDISEN",
            "street": "RUA SEIS",
            "streetNumber": "2250",
            "neighborhood": "BONFIM",
            "city": "PAULÍNIA",
            "state": "SÃO PAULO",
            "latitude": -22.73217,
            "longitude": -47.13737,
            "zipcode": "13147-030",
            "uf": "SP"
          },
          "destinyAddress": {
            "name": "EDIHB",
            "street": "RODOVIA SANTOS DUMONT",
            "streetNumber": "KM 66",
            "neighborhood": "PARQUE VIRACOPOS",
            "city": "CAMPINAS",
            "state": "SÃO PAULO",
            "latitude": -23.0080502,
            "longitude": -47.1396595,
            "zipcode": "13055-900",
            "uf": "SP"
          },
          "distancePlanned": 12.45,
          "distanceTraveled": 0,
          "distanceTraveledGps": 0,
          "distanceInDisplacement": 0,
          "distanceInAttendance": 0,
          "numberOfPassengersConfirmed": 8,
          "vehicleStamp": {
            "plate": "DLQ6I12",
            "prefix": "V-012",
            "model": "GOL 1.0  MPI",
            "color": "silver",
            "monthlyWorkRegime": "12x36",
            "dailyWorkRegime": 1,
            "numberOfPassengers": 15,
            "recentPosition": {
              "latitude": -22.73,
              "longitude": -47.13
            }
          },
          "driverStamp": {
            "name": "Roberto Souza",
            "phone": "11999999999",
            "profilePicture": {
              "url": "https://example.com/driver.png"
            }
          },
          "fixedRoute": {
            "title": "Linha REPLAN ↔ Viracopos",
            "isReturn": false
          },
          "stops": [
            {
              "sequence": 1,
              "name": "Portaria Principal",
              "estimatedToArriveAt": "2025-11-24T14:30:00.000Z",
              "arrivedAt": null,
              "isPassengerBoardingStop": true,
              "isPassengerAlightingStop": false,
              "address": {
                "street": "RUA SEIS",
                "streetNumber": "2250",
                "neighborhood": "BONFIM",
                "city": "PAULÍNIA",
                "state": "SÃO PAULO",
                "zipCode": "13147-030",
                "country": "Brasil",
                "latitude": -22.73217,
                "longitude": -47.13737
              }
            }
          ],
          "tripulation": [
            {
              "name": "JOÃO DA SILVA",
              "email": "joao.da.silva@empresa.com",
              "phone": "11999999999",
              "costCenter": ["A003ADMR01", "AB17RPLL15"],
              "pcd": false,
              "isVip": false,
              "registrationNumber": 46145810,
              "department": "COMPARTILHADO/SC/SMOB/GT",
              "role": "Analista",
              "status": "Pendente",
              "tripMode": "Requisição de Transporte",
              "tripObservations": "Teste de integração",
              "tripPlanningCenter": "REPLAN",
              "tripCreatedAt": "2025-10-08T11:42:39.474Z",
              "tripRequestedBy": {
                "_id": "6447e3292be7586024ed1f12",
                "name": "Nome do Solicitante"
              },
              "tripApprovedBy": {
                "_id": "6447e3292be7586024ed1ed9",
                "name": "Aprovador CICM"
              }
            }
          ],
          "route": {
            "polyline": "`{viCvou~Gg@AQHo@BWDQT[lDJfBt@zCCxCwAlR..."
          },
          "routePlannedPolyline": "`{viCvou~Gg@AQHo@BWDQT[lDJfBt@zCCxCwAlR...",
          "routeTraveledPolyline": null,
          "csatScore": "N/A",
          "csatObservation": "N/A",
          "b1Name": "N/A",
          "b1InitialFare": "N/A",
          "b1AdditionalFare": "N/A",
          "b1TotalFare": "N/A",
          "b2Name": "N/A",
          "b2InitialFare": "N/A",
          "b2AdditionalFare": "N/A",
          "b2TotalFare": "N/A"
        }
      }
    ]
  }
}
```

---

## 📚 Detalhamento dos Campos

### Raiz da solicitação (`data`)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `_id` | string | ID único da solicitação |
| `tripId` | number | Número único da solicitação para exibição |
| `status` | string | Status da solicitação |
| `mode` | string | Tipo da viagem |
| `observations` | string | Observações da solicitação |
| `planningCenter` | string | Centro de planejamento |
| `priceEstimate` | object | Estimativa de km e preço (`estimatedKm`, `finalPrice`), quando houver |
| `requestUserTimezone` | string | Fuso horário do solicitante (ex.: `-03:00`) |
| `requestedFor` | string (ISO 8601) | Data/hora solicitada (UTC) |
| `createdAt` / `updatedAt` | string (ISO 8601) | Datas de criação e atualização |
| `approvedBy` | object | Aprovador (`_id`, `name`), quando houver |
| `files` | array | Anexos (`url`) |
| `requestedBy` | object | Solicitante (`_id`, `name`) |
| `tripulation` | array | Passageiro(s) retornados para o usuário autenticado |

### Objeto `tripulation[]` (passageiro na solicitação)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `name` | string | Nome do passageiro |
| `email` | string | E-mail |
| `phone` | string | Telefone |
| `registrationNumber` | number | Matrícula |
| `department` | string | Departamento/Gerência |
| `costCenter` | array | Objeto(s) de custo |
| `pcd` | boolean | Indica se é PCD |
| `isVip` | boolean | Indica se é VIP (Cargo de alta administração) |
| `role` | string | Cargo/função |
| `status` | string | Status do passageiro no fluxo |
| `tripMode` | string | Modo da solicitação (espelho) |
| `tripObservations` | string | Observações da solicitação (espelho) |
| `tripPlanningCenter` | string | Centro de planejamento (espelho) |
| `tripCreatedAt` | string (ISO 8601) | Data de criação da solicitação (espelho) |
| `tripRequestedBy` | object | Solicitante (espelho) |
| `tripApprovedBy` | object | Aprovador (espelho) |
| `originAddress` / `destinyAddress` | object | Endereços do passageiro |
| `job` | object | Atendimento vinculado (quando existir) |

---

### Objeto `tripulation[].job`

Quando um atendimento é vinculado, cada passageiro recebe um objeto `job` com as propriedades abaixo (nem todos os campos existem em todos os tipos de serviço).

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `_id` | string | ID único do atendimento |
| `jobId` | number | Número do atendimento para exibição |
| `status` | string | Status do atendimento (ver [Status do Atendimento](job-status.md)) |
| `startDate` / `endDate` | string (ISO 8601) | Início/fim planejados (UTC) |
| `actualStartDate` / `actualEndDate` | string (ISO 8601) \| null | Início/fim reais (UTC) |
| `*Formatted` | string \| null | Datas/horários formatados (`dd/MM/yyyy`, `HH:mm`) no fuso operacional |
| `buildingName` | string | Imóvel |
| `createdAt` | string (ISO 8601) | Criação do atendimento |
| `requestedByName` | string | Nome de quem solicitou o atendimento |
| `observations` | string | Observações do atendimento |
| `serviceProvider` | string | Prestador de serviço |
| `serviceType` | string | Tipo de serviço (ex.: `COLETIVO`, `EMPRESARIAL`, `TAXI`) |
| `contractStamp` | object | Snapshot do contrato |
| `originAddress` / `destinyAddress` | object | Endereços raiz do atendimento |
| `distancePlanned` | number | Distância planejada em **km** |
| `distanceTraveled` | number | Distância percorrida em **km** |
| `distanceTraveledGps` | number | Distância GPS (km) |
| `distanceInDisplacement` / `distanceInAttendance` | number | Distâncias auxiliares do fluxo operacional |
| `numberOfPassengersConfirmed` | number | Qtd. de passageiros do atendimento com `confirmedPresenceAt` preenchido |
| `vehicleStamp` | object | Snapshot do veículo alocado |
| `driverStamp` | object | Snapshot do motorista designado |
| `fixedRoute` | object | Dados da rota fixa (`title`, `isReturn`), quando aplicável |
| `stops` | array | Paradas (rota fixa), com flags de embarque/desembarque do usuário |
| `tripulation` | array | Dados do **passageiro autenticado** neste atendimento |
| `route` | object | Rota populada (`polyline`) |
| `routePlannedPolyline` / `routeTraveledPolyline` | string | Polylines planejada / executada |
| Campos de táxi / CSAT / B1-B2 | variados | Presentes principalmente em atendimentos de táxi |

#### Capacidade e confirmação de presença

| Campo | Onde | Descrição |
|-------|------|-----------|
| `vehicleStamp.numberOfPassengers` | job | Capacidade máxima de passageiros do veículo |
| `numberOfPassengersConfirmed` | job | Quantidade de passageiros na tripulação do atendimento que já confirmaram presença (`confirmedPresenceAt` diferente de `null`/`''`) |

**Exemplo de uso:** exibir “8 de 15 vagas confirmadas” com `numberOfPassengersConfirmed` / `vehicleStamp.numberOfPassengers`.

---

### 👥 Objeto `tripulation[].job.tripulation`

Esse array **não lista todos os passageiros do veículo** no endpoint Tripee. Por privacidade, ele é filtrado para conter **apenas o usuário autenticado**.

Para saber quantas pessoas já confirmaram presença no atendimento, use `job.numberOfPassengersConfirmed` (e a capacidade em `job.vehicleStamp.numberOfPassengers`).

**Campos projetados do passageiro no job:**

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `name` | string | Nome |
| `email` | string | E-mail |
| `phone` | string | Telefone |
| `registrationNumber` | number | Matrícula |
| `department` | string | Departamento |
| `costCenter` | array | Centro(s) de custo |
| `pcd` / `isVip` | boolean | Flags PCD / VIP |
| `role` | string | Cargo |
| `status` | string | Status no atendimento |
| `tripMode` / `tripObservations` / `tripPlanningCenter` | string | Espelhos da solicitação |
| `tripCreatedAt` | string (ISO 8601) | Criação da solicitação |
| `tripRequestedBy` / `tripApprovedBy` | object | Solicitante / aprovador |

---

### 🚗 Objeto `vehicleStamp`

Snapshot do veículo no atendimento.

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `plate` | string | Placa |
| `prefix` | string | Prefixo operacional |
| `model` | string | Modelo |
| `color` | string | Cor |
| `monthlyWorkRegime` | string | Regime mensal |
| `dailyWorkRegime` | number \| string | Regime diário |
| `numberOfPassengers` | number | Capacidade de passageiros do veículo |
| `recentPosition` | object | Última posição conhecida (`latitude`, `longitude`), quando houver |

**Exemplo:**
```json
{
  "plate": "DLQ6I12",
  "prefix": "V-012",
  "model": "GOL 1.0  MPI",
  "color": "silver",
  "monthlyWorkRegime": "12x36",
  "dailyWorkRegime": 1,
  "numberOfPassengers": 15,
  "recentPosition": {
    "latitude": -22.73,
    "longitude": -47.13
  }
}
```

**💡 Por que "stamp"?**

O sufixo "stamp" indica registro estático do momento da alocação. Alterações posteriores no cadastro do veículo **não** atualizam automaticamente esse snapshot (exceto fluxos operacionais específicos que regeneram o stamp).

---

### 👨‍✈️ Objeto `driverStamp`

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `name` | string | Nome completo |
| `phone` | string | Telefone |
| `profilePicture.url` | string | URL da foto de perfil, quando houver |

**Exemplo:**
```json
{
  "name": "Roberto Souza",
  "phone": "11999999999",
  "profilePicture": {
    "url": "https://example.com/driver.png"
  }
}
```

---

### 🚏 Objeto `stops[]` (rotas fixas)

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `sequence` | number | Ordem da parada |
| `name` | string | Nome da parada |
| `estimatedToArriveAt` | string (ISO 8601) | Chegada estimada |
| `arrivedAt` | string (ISO 8601) \| null | Chegada real |
| `isPassengerBoardingStop` | boolean | Se o usuário autenticado embarca nesta parada |
| `isPassengerAlightingStop` | boolean | Se o usuário autenticado desembarca nesta parada |
| `address` | object | Endereço da parada |

---

### 🗺️ Objeto `route`

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `polyline` | string | Polyline codificada (Google Encoded Polyline) |

Também podem existir na raiz do `job`:
- `routePlannedPolyline`
- `routeTraveledPolyline`

#### 📍 O que é Polyline?

Polyline é um formato compacto de sequência de coordenadas. Para usar em mapas, decodifique-o:

```javascript
// Exemplo com Google Maps JavaScript API
const path = google.maps.geometry.encoding.decodePath(polyline);

// Exemplo com biblioteca polyline
import polyline from '@mapbox/polyline';
const coordinates = polyline.decode('`{viCvou~Gg@AQ...');
// Retorna: [[lat1, lng1], [lat2, lng2], ...]
```

**Bibliotecas úteis:**
- JavaScript: `@mapbox/polyline`
- Python: `polyline`
- Java: `com.google.maps:google-maps-services`
- PHP: `googlemaps/google-maps-services-php`

---

## 🎯 Status do Atendimento

O campo `job.status` indica o estado atual da execução do atendimento.

### Possíveis Status

| Status | Descrição |
|--------|-----------|
| `Pendente` | Atendimento criado, aguardando início da execução |
| `Aceito` | Motorista aceitou o atendimento |
| `Deslocamento` | Motorista está se deslocando para buscar o primeiro passageiro da rota |
| `Atendimento` | Motorista está com o primeiro passageiro no veículo e irá começar a rota planejada |
| `Finalizado` | Atendimento foi finalizado com sucesso |
| `Cancelado` | Atendimento foi cancelado |

### Status dos passageiros

O status do passageiro `tripulation[].status` também fica equivalente ao status do atendimento. Porém, existem alguns casos onde o status do passageiro pode ser diferente do atendimento:

| Status | Descrição |
|--------|-----------|
| `No show` | Passageiro não apareceu no ponto de embarque |
| `Cancelado` | Passageiro cancelou o atendimento porém existem outros passageiros na viagem |

**💡 Dica:** Use esse status para exibir informações em tempo real sobre o andamento da corrida. Detalhamento completo em [Status do Atendimento](job-status.md).

---

## 🔄 Múltiplos Passageiros e Atendimentos

### Cenário Comum: Um Atendimento para Todos

Na maioria dos casos, todos os passageiros de uma solicitação compartilham o mesmo atendimento. No Tripee, cada usuário autenticado vê **apenas o próprio** registro em `data.tripulation` e em `job.tripulation`, mais os agregados de ocupação:

```json
{
  "tripulation": [
    {
      "name": "João Silva",
      "job": {
        "jobId": 2539,
        "_id": "68e67340...",
        "numberOfPassengersConfirmed": 8,
        "vehicleStamp": {
          "plate": "ABC1234",
          "numberOfPassengers": 15
        },
        "tripulation": [
          { "name": "João Silva", "registrationNumber": 123 }
        ]
      }
    }
  ]
}
```

### Cenário Raro: Atendimentos Diferentes

Em situações específicas, passageiros podem ter atendimentos separados:

```json
{
  "tripulation": [
    {
      "name": "João Silva",
      "job": {
        "jobId": 2539,
        "vehicleStamp": { "plate": "ABC1234", "numberOfPassengers": 4 },
        "numberOfPassengersConfirmed": 2
      }
    },
    {
      "name": "Maria Santos",
      "job": {
        "jobId": 2540,
        "vehicleStamp": { "plate": "XYZ5678", "numberOfPassengers": 4 },
        "numberOfPassengersConfirmed": 1
      }
    }
  ]
}
```

**Quando isso acontece?**
- Passageiros em locais de origem muito distantes
- Restrições de capacidade do veículo
- Requisitos especiais (VIP, PCD, etc.)

---

**Próximo:** [Status da Solicitação →](trip-status.md) | [Status do Atendimento →](job-status.md)  
**Anterior:** [← Edição de Solicitações](trip-edit.md)  
**Voltar para:** [Autenticação](authentication.md)
