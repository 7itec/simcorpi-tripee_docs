---
layout: default
title: Ateste e Contestação
permalink: /docs/attest.html
---

# Ateste e Contestação de Atendimentos

Esta seção detalha os endpoints para confirmar ou contestar o ateste de um atendimento finalizado, no contexto da integração Tripee.

Os dados dos atendimentos com ateste pendente podem ser obtidos em [CSAT e Atestes Pendentes](csats-and-attests.md).

---

## 📋 Visão Geral

Após a finalização de um atendimento, o passageiro ou o solicitante pode:

- **Confirmar o ateste** — indica que o atendimento ocorreu conforme o esperado
- **Contestar o ateste** — indica divergência (valor ou presença), com justificativa

O identificador usado nos endpoints é o **ID do alerta de ateste** (`attestationAlertId`), retornado na listagem de pendências — **não** é o ID do atendimento.

### ⚠️ Restrições Importantes

- Apenas o **passageiro** ou o **solicitante** do atendimento podem atestar/contestar
- O atendimento precisa estar com ateste ainda pendente
- O `:id` da URL é o `attestationAlertId`, não o `_id` do job
- Em caso de sucesso, a resposta contém apenas uma mensagem (sem o objeto completo do alerta)

---

## ✅ Confirmar Ateste

<div class="endpoint">
  <span class="method patch">PATCH</span>
  <span>/tripee/alerts/:id/attest/confirm</span>
</div>

**Parâmetros:**
- `id` (path): ID do alerta de ateste (`attestationAlertId`)

**Content-Type:** não é necessário enviar body

**Headers:**
```http
Authorization: Bearer {ACCESS_TOKEN}
```

### Corpo da Requisição

Este endpoint **não possui body**.

### Exemplo

```bash
curl -X PATCH "https://api.example.com/tripee/alerts/68e51d0d1702b4e46af96500/attest/confirm" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### Resposta de Sucesso (200)

```json
{
  "message": "Atendimento atestado com sucesso"
}
```

---

## ⚠️ Contestar Ateste

<div class="endpoint">
  <span class="method patch">PATCH</span>
  <span>/tripee/alerts/:id/attest/contest</span>
</div>

**Parâmetros:**
- `id` (path): ID do alerta de ateste (`attestationAlertId`)

**Headers:**
```http
Authorization: Bearer {ACCESS_TOKEN}
Content-Type: application/json
```

### Corpo da Requisição

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| `contestation` | string | Sim | Texto justificando a contestação |
| `type` | string | Sim | Tipo da contestação: `VALUE` ou `PRESENCE` |

#### Tipos de contestação

| Valor | Significado |
|-------|-------------|
| `VALUE` | Contestação relacionada ao valor do atendimento |
| `PRESENCE` | Contestação relacionada à presença/realização do atendimento |

### Exemplo

```bash
curl -X PATCH "https://api.example.com/tripee/alerts/68e51d0d1702b4e46af96500/attest/contest" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "contestation": "O valor cobrado está divergente do combinado.",
    "type": "VALUE"
  }'
```

### Resposta de Sucesso (200)

```json
{
  "message": "Atendimento contestado com sucesso"
}
```

---

## ⚙️ Como Funciona

1. A Tripee lista as pendências em `GET /tripee/trips/csats-and-attests` (com `searchType=attest` ou `all`)
2. Para cada item com `hasPendingAttest = true`, utiliza o `attestationAlertId`
3. Chama `confirm` ou `contest` conforme a ação do usuário
4. Em sucesso, recebe a mensagem de confirmação

```
GET /tripee/trips/csats-and-attests
        │
        └─ hasPendingAttest = true
                │
                ├─ Confirmar → PATCH /tripee/alerts/:attestationAlertId/attest/confirm
                │
                └─ Contestar → PATCH /tripee/alerts/:attestationAlertId/attest/contest
                                   body: { contestation, type }
```

---

## ❌ Erros Possíveis

| Situação | Comportamento |
|----------|---------------|
| Token inválido/ausente | `401 Unauthorized` |
| Alerta inexistente | Erro de negócio da API |
| Usuário sem permissão (não é passageiro nem solicitante) | Erro informando falta de autorização |
| Atendimento já atestado | Erro informando que o atendimento já foi atestado |
| Body inválido na contestação (`type` fora de `VALUE`/`PRESENCE`, campos vazios) | Erro de validação |

A API Tripee não adiciona tratamento especial de erro nesses endpoints: o fluxo padrão da plataforma trata as falhas.

---

**Anterior:** [← CSAT e Atestes Pendentes](csats-and-attests.md)  
**Próximo:** [Responder CSAT →](csat.md)
