---
layout: default
title: Responder CSAT
permalink: /docs/csat.html
---

# Responder Pesquisa de Satisfação (CSAT)

Esta seção detalha o endpoint para responder a pesquisa de satisfação de um atendimento, no contexto da integração Tripee.

Os atendimentos com CSAT pendente podem ser obtidos em [CSAT e Atestes Pendentes](csats-and-attests.md).

---

## 📋 Visão Geral

Após a finalização de um atendimento, o passageiro (ou solicitante relacionado) pode avaliar a experiência por meio da pesquisa de satisfação (CSAT).

Isso é avaliado da seguinte forma:

- **Nota geral (`score`)** — pontuação de 0 a 5
- **Observação sobre a corrida (`observation`)** - comentário opcional sobre a experiência do passageiro

Também é possível anexar um **áudio** opcional com comentário falado, para substituir o texto escrito.

### ⚠️ Restrições Importantes

- O usuário autenticado precisa ser **passageiro** ou **solicitante** do atendimento
- A pesquisa precisa estar relacionada ao atendimento e ainda não respondida
- O conteúdo JSON vai no campo `data` do `multipart/form-data`

---

## 📝 Endpoint

<div class="endpoint">
  <span class="method post">POST</span>
  <span>/tripee/csats</span>
</div>

**Headers:**
```http
Authorization: Bearer {ACCESS_TOKEN}
Content-Type: multipart/form-data
```

---

## 📦 Corpo da Requisição (multipart/form-data)

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| `data` | string (JSON) | Sim | Payload da avaliação em formato JSON stringificado |
| `audio` | file | Não | Áudio opcional com comentário (filtro de arquivo de áudio) |

### Campos do JSON em `data`

| Campo | Tipo | Obrigatório | Descrição |
|-------|------|-------------|-----------|
| `job` | string (MongoId) | Sim | ID do atendimento (`_id` retornado na listagem de pendências) |
| `score` | number (0–5) | Sim | Nota geral da corrida |
| `observation` | string | Não | Comentário textual do passageiro |
| `passenger` | object | Sim | Dados do passageiro que está respondendo* |
| `driver` | object | Não | Dados do motorista |
| `vehicle` | object | Não | Dados do veículo |

\* Utilizar os dados do passageiro que é retornado em `tripulation`.

### Estrutura mínima de `passenger`

```json
{
  "_id": "6447e3292be7586024ed1ed8",
  "name": "Maria da Silva"
}
```

---

## 💻 Exemplos

### Exemplo 1: Resposta com nota geral

```bash
curl -X POST "https://api.example.com/tripee/csats" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -F 'data={"job":"68e51d0d1702b4e46af96509","score":5,"observation":"Excelente atendimento","passenger":{"_id":"6447e3292be7586024ed1ed8","name":"Maria da Silva"}}'
```

### Exemplo 2: Com áudio anexado

```bash
curl -X POST "https://api.example.com/tripee/csats" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -F 'data={"job":"68e51d0d1702b4e46af96509","score":4,"observation":"Bom atendimento","passenger":{"_id":"6447e3292be7586024ed1ed8","name":"Maria da Silva"}}' \
  -F "audio=@/caminho/para/comentario.mp3"
```

---

## ✅ Resposta de Sucesso

```json
{
  "message": "Pesquisa de satisfação respondida com sucesso"
}
```

---

## ⚙️ Como Funciona

1. A Tripee lista as pendências em `GET /tripee/trips/csats-and-attests` (com `searchType=csat` ou `all`)
2. Para cada item com `hasPendingCsat = true`, utiliza o `_id` do atendimento como `job`
3. Monta o JSON em `data` (nota geral, observações) e envia `POST /tripee/csats`
4. Em sucesso, recebe a mensagem de confirmação

```
GET /tripee/trips/csats-and-attests
        │
        └─ hasPendingCsat = true
                │
                └─ POST /tripee/csats
                       multipart: data (JSON) + audio (opcional)
```

---

## ❌ Erros Possíveis

| Situação | Mensagem / comportamento |
|----------|--------------------------|
| Atendimento não encontrado | Atendimento não encontrado |
| Sem alerta de pesquisa para o usuário | Alerta referente a pesquisa não foi encontrado |
| Pesquisa já respondida | Pesquisa de satisfação já respondida |
| Usuário sem vínculo com o atendimento | Usuário não está relacionado ao atendimento como passageiro ou solicitante |
| Token inválido/ausente | `401 Unauthorized` |

---

**Anterior:** [← CSAT e Atestes Pendentes](csats-and-attests.md) | [← Ateste e Contestação](attest.md)  
**Voltar para:** [Home](../index.md)
