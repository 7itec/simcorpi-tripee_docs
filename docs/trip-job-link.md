---
layout: default
title: Vínculo com Atendimento
permalink: /docs/trip-job-link.html
---

# Vínculo da Solicitação com Atendimento

Esta seção explica como funciona o vínculo entre solicitações de transporte e atendimentos, e quais informações são retornadas quando esse vínculo é estabelecido.

## 📋 Visão Geral

### O que é uma Solicitação?
A **solicitação** é o pedido de corrida criado pelo usuário, contendo informações sobre passageiros, origem, destino e data/hora desejada.

### O que é um Atendimento?
O **atendimento** (job) é a **execução concreta** dessa corrida, contendo informações operacionais como:
- 🚗 Veículo alocado
- 👨‍✈️ Motorista designado
- 📅 Datas de início e fim planejadas
- 🗺️ Rota calculada

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

```json
{
  "statusCode": 200,
  "data": {
    "_id": "68e64e2d725f5da3cbc613ed",
    "createdAt": "2025-10-08T11:42:39.474Z",
    "mode": "Requisição de Transporte",
    "observations": "Teste de integração",
    "planningCenter": "REPLAN",
    "requestUserTimezone": "-03:00",
    "requestedFor": "2025-11-24T14:30:00.000Z",
    "status": "Programada",
    "tripId": 4582,
    "updatedAt": "2025-10-08T14:20:50.433Z",
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
        "registrationNumber": 46145810,
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
          "status": "Pendente",
          "startDate": "2025-11-24T14:30:00.000Z",
          "endDate": "2025-11-24T15:12:29.000Z",
          "jobId": 2539,
          "_id": "68e67340a9168dc169f4db46",
          "vehicleStamp": {
            "plate": "DLQ6I12",
            "model": "GOL 1.0  MPI"
          },
          "driverStamp": {
            "name": "Roberto Souza",
            "phone": "11999999999"
          },
          "route": {
            "polyline": "`{viCvou~Gg@AQHo@BWDQT[lDJfBt@zCCxCwAlR]hB}AtCeGpIEf@Rt@^b@BP@`@Wx@e@J_AMoCiCaIoH{ByAs@WsAi@{OaDqG_BwN_DqC]gE?gJ^gDNuAWaED_GK_@@ONC|@Dt@@ZLDNFf@AzGmAvB[zNk@bGSbBDpFdA|b@nJxBr@bBz@nBxAtT|ShTxShj@lh@tDzChCbAlBd@lBNrA@zD[nAYbBq@zA_A|@s@jS_ShBiB~E{FnCeEhAeCpJyVjDsGxC}DdCgCrFmEvNeIvKuFrK}FzKcGb`@wR`P_InEoBvC}@fCg@dIq@xBAbBH~XdC|TrBb[pCxBJfEKzCWhE{@`DgApBaArDaClGyFfMkLlC{C~A{BhCwE|JiRbDwGnAkDhEuPtDsMrIgTnH}Pj[eo@|BoDbDkDlH{Fp]oXnF_EzDaDpWiSdCiBrHoGxDeEzCgErNcXrAoCRINMtBoDnAqAfAc@pCG`BKvB_A~@q@lAm@rA_@pG]hBHtBj@|A~@bD|Bz@hAd@bBb@nDPnAXfCd@pDb@vG`AnNZbG^vDfDxVpA|K|B`SvA|MhBtLbGze@^bDv@|F~@tFZnFJVh@~DFf@z@nHhBvOpD`Y~F|d@nA~K`BhLVnANJzBrQlCdTXrDDtBQpCa@xCAjDXtAd@dAX\\bAl@XH|AB|@QrA}@f@gAPiA@eFf@sDl@kBNa@CS`C_F`C}ElP_]~CoFrCaDxAoAxCqB`EkB~C_AnF{@vDUv\\iBtX}ArDGlG@zDPpGl@zATjEx@rGbB~HnC`i@~QbJjCjATnFp@|Hd@h\\DhNDrC?fFMrGi@tGeAvIgBlQsDrGuA|HuBtGgCrH_EdC_BvE{Cd@MhCwA|HuCxIuBhLuBpZmFvNgCtFu@tFi@pJg@xLMjf@Qhd@YrDYpBWhDw@hBg@nD{AnDuBfCmBhL_JtScPpIcGlK{Fl\\mPrIcEnC}@~Bk@~De@lBKhDGhCEjJMrQ]jJWZJp@FlDIhGa@lGcAtN{ChDy@t@MjASlBD\\D\\FlGvA`R|ErMdEnK|D`LvEj_@rPbLdF`HbEzIvGvNdLpDtCBVf@d@`ChC`@dAXnCTzD@vAWdBgBjDo@hAEX{IhNgK|OmBxCyEtHiFlIMD{@rA{CrEUNm@JuAQ_AMs@Hg@Z_@~@An@`@~EE`AYp@w@jAi@|@y@|@qAb@q@@u@IWMs@c@k@_Ac@sAGo@CwBQQeBj@aDjA"
          }
        }
      }
    ]
  }
}
```

---

## 📚 Detalhamento dos Campos do Atendimento

### Objeto `tripulation[].job`

Quando um atendimento é vinculado, cada passageiro recebe um objeto `job` com as seguintes propriedades:

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `_id` | string | ID único do atendimento no banco de dados |
| `jobId` | number | Número identificador do atendimento para exibição |
| `status` | string | Status atual do atendimento (ver seção de status abaixo) |
| `startDate` | string (ISO 8601) | Data/hora planejada para início do atendimento (UTC) |
| `endDate` | string (ISO 8601) | Data/hora planejada para término do atendimento (UTC) |
| `vehicleStamp` | object | Informações do veículo alocado (snapshot) |
| `driverStamp` | object | Informações do motorista designado (snapshot) |
| `route` | object | Informações da rota calculada |

---

### 🚗 Objeto `vehicleStamp`

Contém um "snapshot" das informações do veículo no momento da criação do atendimento.

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `plate` | string | Placa do veículo |
| `model` | string | Modelo do veículo |

**Exemplo:**
```json
{
  "plate": "DLQ6I12",
  "model": "GOL 1.0  MPI"
}
```

**💡 Por que "stamp"?**

O sufixo "stamp" indica que esses dados são um registro estático do momento da criação do atendimento. Mesmo que os dados do veículo sejam alterados posteriormente no cadastro, essas informações permanecerão inalteradas no atendimento.

---

### 👨‍✈️ Objeto `driverStamp`

Contém um "snapshot" das informações do motorista no momento da criação do atendimento.

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `name` | string | Nome completo do motorista |
| `phone` | string | Telefone de contato do motorista |

**Exemplo:**
```json
{
  "name": "Roberto Souza",
  "phone": "11999999999"
}
```

---

### 🗺️ Objeto `route`

Contém informações sobre a rota calculada para o atendimento.

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `polyline` | string | Polyline codificada da rota no formato Google Encoded Polyline |

**Exemplo:**
```json
{
  "polyline": "`{viCvou~Gg@AQHo@BWDQT[lDJfBt@zCCxCwAlR..."
}
```

#### 📍 O que é Polyline?

Polyline é um formato compacto de representação de uma sequência de coordenadas geográficas (latitude/longitude) que formam um caminho. É amplamente utilizado por APIs de mapas como Google Maps.

**Decodificação:**

Para usar o polyline, você precisa decodificá-lo. A maioria das bibliotecas de mapas oferece funções para isso:

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

**💡 Dica:** Use esse status para exibir informações em tempo real sobre o andamento da corrida.

---

## 🔄 Múltiplos Passageiros e Atendimentos

### Cenário Comum: Um Atendimento para Todos

Na maioria dos casos, todos os passageiros de uma solicitação compartilham o mesmo atendimento:

```json
{
  "tripulation": [
    {
      "name": "João Silva",
      "job": { "jobId": 2539, "_id": "68e67340..." }
    },
    {
      "name": "Maria Santos",
      "job": { "jobId": 2539, "_id": "68e67340..." }
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
      "job": { "jobId": 2539, "vehicleStamp": { "plate": "ABC1234" } }
    },
    {
      "name": "Maria Santos",
      "job": { "jobId": 2540, "vehicleStamp": { "plate": "XYZ5678" } }
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
