---
layout: default
title: Cancelamento de Reserva
permalink: /docs/trip-cancel-reservation.html
---

# Cancelamento de Reserva de Passageiro

Esta seção detalha o processo para cancelar a reserva de um passageiro em uma solicitação de transporte (trip) da API Tripee.

O cancelamento de reserva permite que o passageiro autenticado cancele a própria reserva em um atendimento de rota fixa vinculado à trip.

## 📋 Visão Geral

O endpoint de cancelamento de reserva deve ser utilizado quando a Tripee precisar remover a confirmação de presença/reserva de um passageiro em uma trip já vinculada a um atendimento de rota fixa.

A operação não recebe corpo na requisição. O passageiro que terá a reserva cancelada é identificado pelo token enviado no header `Authorization`.

### ⚠️ Restrições Importantes

- **Cancelamento próprio:** o usuário autenticado só pode cancelar a própria reserva
- **Trip obrigatória:** o `id` informado deve corresponder a uma trip existente
- **Passageiro obrigatório:** o usuário autenticado precisa estar na lista de passageiros da trip
- **Atendimento obrigatório:** a trip precisa estar vinculada a um atendimento
- **Rota fixa:** o atendimento vinculado precisa ser de rota fixa
- **Reserva existente:** o passageiro precisa ter uma reserva confirmada anteriormente
- **Sem body:** não é possível informar outro passageiro na requisição

---

## 🔄 Endpoint de Cancelamento de Reserva

<div class="endpoint">
  <span class="method patch">PATCH</span>
  <span>/tripee/trips/:id/cancel-reservation</span>
</div>

**Parâmetros:**
- `id` (path): ID da solicitação/trip

**Content-Type:** não é necessário enviar body

**Headers:**
```http
Authorization: Bearer {ACCESS_TOKEN}
```

---

## 📝 Corpo da Requisição

Este endpoint **não possui body**.

O passageiro é identificado automaticamente a partir do token de autenticação. Dessa forma, a Tripee não precisa e não deve enviar dados do passageiro no corpo da requisição.

---

## 🔒 Autorização

A requisição deve ser feita com um token válido da Tripee.

O sistema usa o usuário autenticado para validar se ele está presente na trip e se possui um atendimento de rota fixa vinculado.

Caso o usuário do token não seja passageiro da trip ou não esteja vinculado ao atendimento, o cancelamento será bloqueado.

---

## ⚙️ Como Funciona

Ao receber a requisição, o sistema executa o seguinte fluxo:

1. Valida o token de autenticação
2. Busca a trip pelo `id` informado na URL
3. Verifica se o usuário autenticado existe na lista de passageiros da trip
4. Localiza o atendimento vinculado ao passageiro
5. Valida se o atendimento é de rota fixa
6. Valida se o passageiro possui reserva confirmada
7. Cancela a reserva usando a regra interna do Simcorpi
8. Retorna os dados atualizados da trip no padrão Tripee

---

## 🎯 Regras de Negócio

| Regra | Descrição |
|-------|-----------|
| Passageiro autenticado | O usuário do token precisa existir na trip |
| Cancelamento próprio | Não é permitido cancelar reserva de outro passageiro |
| Atendimento vinculado | A trip precisa possuir atendimento associado ao passageiro |
| Rota fixa | O atendimento precisa ser de rota fixa |
| Reserva confirmada | Só é possível cancelar se a reserva já foi feita |
| Sem body | A rota não aceita informar passageiro manualmente |

---

## 🔁 Efeitos do Cancelamento

Quando o cancelamento é concluído com sucesso, o sistema atualiza a reserva do passageiro no atendimento.

| Campo | Resultado |
|-------|-----------|
| `tripulation[].status` | Volta para `À confirmar` |
| `tripulation[].confirmedPresenceAt` | Removido |
| `tripulation[].reservationHistory` | Recebe novo registro de cancelamento |
| `usersSeatings` | Remove o assento reservado do passageiro, quando existir |

Se o atendimento possuir seção de comentários, o sistema também registra um comentário informando que o passageiro cancelou a reserva.

---

## 💻 Exemplo de Requisição

### Usando cURL

```bash
curl -X PATCH https://api.example.com/tripee/trips/68e64e2d725f5da3cbc613ed/cancel-reservation \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
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
    "planningCenter": "REPLAN",
    "requestUserTimezone": "-03:00",
    "requestedFor": "2025-11-24T15:30:00.000Z",
    "status": "Programada",
    "tripId": 4582,
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
        "email": "passageiro@empresa.com",
        "isVip": false,
        "name": "JOÃO DA SILVA",
        "pcd": false,
        "phone": "11999999999",
        "registrationNumber": 46145855,
        "job": {
          "_id": "68e64e2d725f5da3cbc613ef",
          "jobId": 12345,
          "status": "À confirmar",
          "fixedRoute": {
            "title": "Nome da Rota",
            "isReturn": false
          }
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
        "destinyAddress": {
          "city": "CAMPINAS",
          "latitude": -23.0080502,
          "longitude": -47.1396595,
          "neighborhood": "PARQUE VIRACOPOS",
          "state": "SÃO PAULO",
          "street": "RODOVIA SANTOS DUMONT",
          "streetNumber": "KM 66",
          "zipcode": "13055-900"
        }
      }
    ]
  },
  "statusCode": 200
}
```

**Campos importantes na resposta:**
- `data`: Dados atualizados da solicitação
- `data.tripulation[].job`: Atendimento vinculado ao passageiro
- `data.tripulation[].job.status`: Status do passageiro no atendimento após o cancelamento
- `statusCode`: Código HTTP da operação

Após o cancelamento, o status do passageiro no atendimento deve retornar para `À confirmar`.

---

## ❌ Erros Possíveis

### 400 Bad Request - Solicitação não encontrada

```json
{
  "statusCode": 400,
  "message": "Solicitação não encontrada"
}
```

**Causa:** O ID informado não corresponde a uma trip existente ou acessível para o passageiro autenticado.

---

### 400 Bad Request - Passageiro não pertence ao atendimento

```json
{
  "statusCode": 400,
  "message": "Você não é passageiro deste atendimento"
}
```

**Causa:** O usuário autenticado não está vinculado ao atendimento da trip.

---

### 400 Bad Request - Atendimento não é rota fixa

```json
{
  "statusCode": 400,
  "message": "Cancelamento de reserva disponível apenas para atendimentos de rotas fixas"
}
```

**Causa:** O atendimento vinculado à trip não é de rota fixa.

---

### 400 Bad Request - Reserva não encontrada

```json
{
  "statusCode": 400,
  "message": "Não é possível cancelar a reserva. Confirmação de presença não encontrada"
}
```

**Causa:** O passageiro não possui reserva confirmada para cancelar.

---

### 401 Unauthorized - Token inválido

```json
{
  "statusCode": 401,
  "message": "Unauthorized"
}
```

**Solução:** Renove seu token de acesso usando o endpoint de [refresh](authentication.md#-renovação-de-token-refresh).

---

## 🔍 Buscando a Trip Antes do Cancelamento

Caso seja necessário consultar os dados da trip antes de cancelar a reserva, use:

<div class="endpoint">
  <span class="method get">GET</span>
  <span>/tripee/trips/:id</span>
</div>

**Headers:**
```http
Authorization: Bearer {ACCESS_TOKEN}
```

**Exemplo:**
```bash
curl -X GET https://api.example.com/tripee/trips/68e64e2d725f5da3cbc613ed \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

---

## ✅ Critérios de Sucesso

O cancelamento foi executado corretamente quando:

- A resposta retorna `200 OK`
- O passageiro continua vinculado à trip
- O atendimento vinculado retorna com status do passageiro como `À confirmar`
- A reserva anterior deixa de estar ativa
- O assento reservado é liberado, quando aplicável

---

**Próximo:** [Vínculo com Atendimento →](trip-job-link.md)  
**Anterior:** [← Edição de Solicitações](trip-edit.md)  
**Voltar para:** [Autenticação](authentication.md)
