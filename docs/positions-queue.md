---
layout: default
title: Fila de Posições
permalink: /docs/positions-queue.html
---

# Fila de Posições

As posições dos veículos enviadas pelo aplicativo do motorista Simcorpi são publicadas em uma fila do **RabbitMQ**. Essa fila é o canal oficial para a Tripee obter as posições em tempo real: cada mensagem corresponde a uma posição registrada pelo aplicativo e deve ser consumida diretamente da fila.

---

## 🔌 Conexão

| Item | Valor |
|------|-------|
| Protocolo | AMQP 0-9-1 |
| Fila | `positions` |
| Credenciais | Fornecidas pela equipe Simcorpi (host, porta, usuário e senha) |

**⚠️ Importante:** As credenciais de acesso são enviadas separadamente pela equipe de desenvolvimento e não devem ser expostas publicamente.

---

## ⚙️ Configuração da Fila

| Propriedade | Valor | Descrição |
|-------------|-------|-----------|
| `durable` | `true` | A fila sobrevive a reinicializações do RabbitMQ |
| `x-max-length` | `100000` | Quantidade máxima de posições armazenadas |
| `x-overflow` | `drop-head` | Ao atingir o limite, as posições **mais antigas** são descartadas para dar lugar às novas |

As mensagens são publicadas como **persistentes** e em formato **JSON** (`content-type: application/json`).

**💡 Observação:** Como a fila tem tamanho máximo, posições não consumidas por muito tempo são descartadas. Mantenha o consumidor ativo de forma contínua para não perder posições.

---

## 📦 Formato da Mensagem

```json
{
  "vehicleId": "627312d6bc0cbce93d8be891",
  "jobId": "68e67340a9168dc169f4db46",
  "latitude": -23.578412,
  "longitude": -51.996178,
  "registrationDate": "2026-10-07T11:00:00.000Z",
  "heading": 90,
  "speed": 60
}
```

### Campos

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `vehicleId` | `string` | ID do veículo |
| `jobId` | `string` | ID (mongo) do atendimento que o veículo está executando no momento da posição |
| `latitude` | `number` | Latitude da posição |
| `longitude` | `number` | Longitude da posição |
| `registrationDate` | `string` (ISO 8601, UTC) | Data e hora em que a posição foi registrada no aplicativo |
| `heading` | `number` | Direção do veículo em graus (0 a 360) |
| `speed` | `number` | Velocidade do veículo |

---

## 📥 Consumindo a Fila

### Recomendações

- **Confirme o recebimento (`ack`)** após processar cada mensagem. Mensagens sem confirmação voltam para a fila caso a conexão caia.
- **Ordene pelo `registrationDate`:** o aplicativo pode enviar posições acumuladas (por exemplo, após um período sem internet), portanto a ordem de chegada na fila nem sempre é a ordem cronológica.

---

**💡 Saiba mais:**
- [Status do Atendimento →](job-status.md)
- [Vínculo com Atendimento →](trip-job-link.md)
