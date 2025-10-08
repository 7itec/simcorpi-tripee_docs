---
layout: default
title: Status do Atendimento
permalink: /docs/job-status.html
---

# Status do Atendimento

Esta seção detalha todos os possíveis status que um atendimento (job) pode assumir durante seu ciclo de vida, desde a criação até a finalização da viagem.

## 📋 Visão Geral

O status do atendimento representa o estado atual da **execução** da viagem. Ele é diferente do status da solicitação e evolui conforme o motorista interage com o sistema e realiza a viagem.

### 🔗 Relação com Status do Passageiro

**Importante:** O status do passageiro (`tripulation[].status`) geralmente reflete o status do atendimento vinculado a ele, **exceto** em casos específicos:

- **No show**: Passageiro não compareceu ao local de embarque
- **Cancelado**: Passageiro cancelou a viagem individualmente

---

## 🎯 Status do Atendimento

### Tabela de Status Possíveis

| Status | Quando Ocorre | Pode Cancelar? | Próximo Status |
|--------|---------------|----------------|----------------|
| `Pendente` | Atendimento criado, aguardando aceitação do motorista | ✅ Sim | `Aceito`, `Recusado`, `Cancelado` |
| `Aceito` | Motorista aceitou o atendimento | ✅ Sim | `Deslocamento`, `Cancelado` |
| `Recusado` | Motorista recusou o atendimento | ❌ Não | `Pendente` (com novo veículo) |
| `Deslocamento` | Motorista está indo para o ponto de embarque | ❌ Não | `Chegada` |
| `Chegada` | Motorista chegou ao ponto de embarque | ❌ Não | `Atendimento`, `No show` |
| `Atendimento` | Passageiro embarcou, viagem em execução | ❌ Não | `Finalizado` |
| `Finalizado` | Atendimento concluído com sucesso | ❌ Não | Status final |
| `Cancelado` | Atendimento cancelado antes do início | ❌ Não | Status final |

---

## 📝 Detalhamento dos Status

### 1. Pendente

**Descrição:** O atendimento foi criado e está aguardando que um motorista aceite a corrida.

**Características:**
- ⏳ **Aguardando**: Ação do motorista
- ✅ **Cancelável**: Pode ser cancelado nesta fase
- 🚗 **Veículo alocado**: Já tem veículo designado
- 🔄 **Transições possíveis**: `Aceito`, `Recusado`, `Cancelado`

**Quando ocorre:**
- Logo após a criação do vínculo entre solicitação e atendimento
- Quando um novo veículo é alocado após recusa

**Exemplo de resposta:**
```json
{
  "_id": "68e64e2d725f5da3cbc613ed",
  "status": "Programada",
  "tripulation": [
    {
      "name": "João Silva",
      "status": "Pendente",
      "job": {
        "jobId": 2539,
        "status": "Pendente",
        "_id": "68e67340a9168dc169f4db46",
        "startDate": "2025-11-24T14:30:00.000Z",
        "endDate": "2025-11-24T15:12:29.000Z",
        "vehicleStamp": {
          "plate": "ABC1234",
          "model": "GOL 1.0"
        },
        "driverStamp": {
          "name": "Roberto Souza",
          "phone": "11999999999"
        }
      }
    }
  ]
}
```

**💡 Observação:** Neste status, o passageiro ainda pode cancelar a viagem.

---

### 2. Aceito

**Descrição:** O motorista aceitou o atendimento e está ciente da viagem que deve realizar.

**Características:**
- ✅ **Confirmado**: Motorista comprometido com a viagem
- ✅ **Cancelável**: Ainda pode ser cancelado
- 🚗 **Preparação**: Motorista se preparando para iniciar
- 🔄 **Transições possíveis**: `Deslocamento`, `Cancelado`

**Quando ocorre:**
- Motorista aceita o atendimento via aplicativo/sistema
- Após status `Pendente`

**Exemplo de resposta:**
```json
{
  "_id": "68e64e2d725f5da3cbc613ed",
  "status": "Programada",
  "tripulation": [
    {
      "name": "João Silva",
      "status": "Aceito",
      "job": {
        "jobId": 2539,
        "status": "Aceito",
        "_id": "68e67340a9168dc169f4db46",
        "vehicleStamp": {
          "plate": "ABC1234",
          "model": "GOL 1.0"
        },
        "driverStamp": {
          "name": "Roberto Souza",
          "phone": "11999999999"
        }
      }
    }
  ]
}
```

**💡 Observação:** Este é o último momento em que o atendimento pode ser cancelado antes do início da execução.

---

### 3. Recusado

**Descrição:** O motorista recusou o atendimento.

**Características:**
- ❌ **Não aceito**: Motorista não pode/quer realizar
- 🔄 **Aguardando reatribuição**: Novo veículo será alocado
- ⚠️ **Temporário**: Status transitório
- 🔄 **Transições possíveis**: `Pendente` (com novo veículo)

**Quando ocorre:**
- Motorista recusa o atendimento via aplicativo
- Sistema detecta indisponibilidade do motorista
- Após status `Pendente`

**Exemplo de resposta:**
```json
{
  "_id": "68e64e2d725f5da3cbc613ed",
  "status": "Programada",
  "tripulation": [
    {
      "name": "João Silva",
      "status": "Recusado",
      "job": {
        "jobId": 2539,
        "status": "Recusado",
        "_id": "68e67340a9168dc169f4db46",
        "vehicleStamp": {
          "plate": "ABC1234",
          "model": "GOL 1.0"
        },
        "driverStamp": {
          "name": "Roberto Souza",
          "phone": "11999999999"
        }
      }
    }
  ]
}
```

**⚠️ O que fazer:**
- Aguardar que a equipe de programação aloque um novo veículo
- O status retornará para `Pendente` com novo motorista/veículo
- O passageiro será notificado sobre a mudança

**Motivos comuns para recusa:**
- Motorista indisponível no horário
- Veículo com problema mecânico
- Conflito com outro atendimento
- Distância muito grande

---

### 4. Deslocamento

**Descrição:** O motorista está se deslocando para o primeiro ponto da rota (local de embarque).

**Características:**
- 🚗 **Em movimento**: Motorista a caminho
- ❌ **Não cancelável**: Viagem em execução
- 📍 **Rastreável**: Posição do veículo pode ser monitorada
- 🔄 **Transições possíveis**: `Chegada`

**Quando ocorre:**
- Motorista inicia o deslocamento para buscar o passageiro
- Após status `Aceito`

**Exemplo de resposta:**
```json
{
  "_id": "68e64e2d725f5da3cbc613ed",
  "status": "Programada",
  "tripulation": [
    {
      "name": "João Silva",
      "status": "Deslocamento",
      "job": {
        "jobId": 2539,
        "status": "Deslocamento",
        "_id": "68e67340a9168dc169f4db46",
        "vehicleStamp": {
          "plate": "ABC1234",
          "model": "GOL 1.0"
        },
        "driverStamp": {
          "name": "Roberto Souza",
          "phone": "11999999999"
        }
      }
    }
  ]
}
```

**💡 Funcionalidades úteis:**
- Exibir tempo estimado de chegada (ETA)
- Mostrar localização em tempo real do veículo
- Notificar passageiro sobre aproximação do motorista

---

### 5. Chegada

**Descrição:** O motorista chegou ao ponto de embarque e aguarda o passageiro.

**Características:**
- 📍 **No local**: Motorista aguardando no ponto
- ⏳ **Aguardando embarque**: Passageiro deve se apresentar
- ❌ **Não cancelável**: Motorista já está no local
- 🔄 **Transições possíveis**: `Atendimento`, `No show`

**Quando ocorre:**
- Motorista confirma chegada ao ponto de embarque
- Após status `Deslocamento`

**Exemplo de resposta:**
```json
{
  "_id": "68e64e2d725f5da3cbc613ed",
  "status": "Programada",
  "tripulation": [
    {
      "name": "João Silva",
      "status": "Chegada",
      "job": {
        "jobId": 2539,
        "status": "Chegada",
        "_id": "68e67340a9168dc169f4db46",
        "vehicleStamp": {
          "plate": "ABC1234",
          "model": "GOL 1.0"
        },
        "driverStamp": {
          "name": "Roberto Souza",
          "phone": "11999999999"
        }
      }
    }
  ]
}
```

**⚠️ Atenção:**
- Passageiro tem tempo limitado para embarcar
- Se não comparecer, motorista pode registrar `No show`
- Notifique o passageiro que o motorista chegou

---

### 6. Atendimento

**Descrição:** O passageiro embarcou no veículo e a viagem está sendo executada conforme a rota planejada.

**Características:**
- 🚗 **Viagem em execução**: Rota sendo percorrida
- ✅ **Passageiro a bordo**: Confirmado embarque
- ❌ **Não cancelável**: Viagem em andamento
- 🔄 **Transições possíveis**: `Finalizado`

**Quando ocorre:**
- Motorista confirma embarque do primeiro passageiro
- Após status `Chegada`

**Exemplo de resposta:**
```json
{
  "_id": "68e64e2d725f5da3cbc613ed",
  "status": "Programada",
  "tripulation": [
    {
      "name": "João Silva",
      "status": "Atendimento",
      "job": {
        "jobId": 2539,
        "status": "Atendimento",
        "_id": "68e67340a9168dc169f4db46",
        "vehicleStamp": {
          "plate": "ABC1234",
          "model": "GOL 1.0"
        },
        "driverStamp": {
          "name": "Roberto Souza",
          "phone": "11999999999"
        }
      }
    }
  ]
}
```

**💡 Funcionalidades úteis:**
- Rastreamento em tempo real da viagem
- Tempo estimado de chegada ao destino
- Visualização da rota no mapa

---

### 7. Finalizado

**Descrição:** O atendimento foi concluído com sucesso. O passageiro chegou ao destino.

**Características:**
- ✅ **Concluído**: Viagem realizada com sucesso
- 🏁 **Status final**: Não há mais transições
- 📊 **Registrado**: Dados da viagem armazenados
- ❌ **Não cancelável**: Já foi executado

**Quando ocorre:**
- Motorista confirma chegada ao destino e desembarque do passageiro
- Após status `Atendimento`

**Exemplo de resposta:**
```json
{
  "_id": "68e64e2d725f5da3cbc613ed",
  "status": "Atendida",
  "tripulation": [
    {
      "name": "João Silva",
      "status": "Finalizado",
      "job": {
        "jobId": 2539,
        "status": "Finalizado",
        "_id": "68e67340a9168dc169f4db46",
        "vehicleStamp": {
          "plate": "ABC1234",
          "model": "GOL 1.0"
        },
        "driverStamp": {
          "name": "Roberto Souza",
          "phone": "11999999999"
        }
      }
    }
  ]
}
```

**💡 Observação:** Quando todos os atendimentos de uma solicitação são finalizados, o status da solicitação muda para `Atendida`.

---

### 8. Cancelado

**Descrição:** O atendimento foi cancelado antes do início da execução da viagem.

**Características:**
- 🚫 **Cancelado**: Viagem não será realizada
- 🏁 **Status final**: Não há mais transições
- ⏰ **Antes do início**: Só pode ocorrer em `Pendente` ou `Aceito`
- ❌ **Não reversível**: Cancelamento definitivo

**Quando ocorre:**
- Passageiro cancela a viagem
- Solicitação é cancelada pelo solicitante
- Sistema cancela automaticamente
- Apenas quando status é `Pendente` ou `Aceito`

**Exemplo de resposta:**
```json
{
  "_id": "68e64e2d725f5da3cbc613ed",
  "status": "Cancelada",
  "tripulation": [
    {
      "name": "João Silva",
      "status": "Cancelado",
      "job": {
        "jobId": 2539,
        "status": "Cancelado",
        "_id": "68e67340a9168dc169f4db46",
        "vehicleStamp": {
          "plate": "ABC1234",
          "model": "GOL 1.0"
        },
        "driverStamp": {
          "name": "Roberto Souza",
          "phone": "11999999999"
        }
      }
    }
  ]
}
```

**⚠️ Importante:** Cancelamento só é permitido até o status `Aceito`. Após `Deslocamento`, não é mais possível cancelar.

---

## 👤 Status Especiais do Passageiro

Existem dois status que o passageiro pode ter que **não correspondem** ao status do atendimento:

### No show

**Descrição:** O passageiro não compareceu ao local de embarque.

**Características:**
- ❌ **Ausente**: Passageiro não se apresentou
- 🚫 **Viagem não realizada**: Motorista não pôde executar
- 📝 **Registrado**: Falta registrada no sistema
- 🏁 **Status final** para o passageiro

**Quando ocorre:**
- Motorista está no status `Chegada` aguardando o passageiro
- Tempo de espera esgotou e passageiro não embarcou
- Motorista registra o não comparecimento

**Exemplo de resposta:**
```json
{
  "_id": "68e64e2d725f5da3cbc613ed",
  "status": "Programada",
  "tripulation": [
    {
      "name": "João Silva",
      "status": "No show",
      "job": {
        "jobId": 2539,
        "status": "Chegada",
        "_id": "68e67340a9168dc169f4db46"
      }
    }
  ]
}
```

**💡 Observação:** O atendimento pode continuar para outros passageiros, mas este passageiro específico não será mais atendido.

---

### Cancelado (pelo passageiro)

**Descrição:** O passageiro individual cancelou sua viagem.

**Características:**
- 🚫 **Cancelamento individual**: Só afeta este passageiro
- ⏰ **Antes do início**: Deve ocorrer cedo no processo
- 🏁 **Status final** para o passageiro
- 👥 **Outros passageiros não afetados**: Podem continuar normalmente

**Quando ocorre:**
- Passageiro cancela individualmente via sistema
- Apenas em solicitações com múltiplos passageiros
- Enquanto atendimento está em `Pendente` ou `Aceito`

**Exemplo de resposta:**
```json
{
  "_id": "68e64e2d725f5da3cbc613ed",
  "status": "Programada",
  "tripulation": [
    {
      "name": "João Silva",
      "status": "Atendimento",
      "job": {
        "jobId": 2539,
        "status": "Atendimento"
      }
    },
    {
      "name": "Maria Santos",
      "status": "Cancelado",
      "job": {
        "jobId": 2539,
        "status": "Atendimento"
      }
    }
  ]
}
```

**💡 Observação:** Note que o atendimento continua normalmente para João Silva, mas Maria Santos não será mais atendida.

---

**💡 Saiba mais:** 
- [Status da Solicitação →](trip-status.md)
- [Vínculo com Atendimento →](trip-job-link.md)

---

**Próximo:** [Listagem de Solicitações →](trip-list.md)  
**Anterior:** [← Status da Solicitação](trip-status.md)  
**Voltar para:** [Vínculo com Atendimento](trip-job-link.md)
