---
layout: default
title: Status da Solicitação
permalink: /docs/trip-status.html
---

# Status da Solicitação

Esta seção detalha todos os possíveis status que uma solicitação de transporte pode assumir durante seu ciclo de vida, incluindo os status individuais dos passageiros.

## 📋 Visão Geral

O status da solicitação representa o estado atual do pedido de transporte no sistema. Ele evolui de acordo com as aprovações, programações e execuções realizadas.

### 🔄 Hierarquia de Status

- **Status da Solicitação**: Status geral que engloba todos os passageiros
- **Status dos Passageiros**: Cada passageiro pode ter seu próprio status individual

---

## 🎯 Status da Solicitação

### Tabela de Status Possíveis

| Status | Quando Ocorre | Editável? | Pode Vincular Atendimento? |
|--------|---------------|-----------|----------------------------|
| `Em aprovação` | No momento da criação, quando requer aprovação gerencial | ✅ Sim | ❌ Não |
| `Aberta` | Após aprovação, pronta para vínculo com atendimento | ✅ Sim | ✅ Sim |
| `Programada` | Todos os passageiros têm atendimento vinculado | ❌ Não | ✅ Já vinculado |
| `Inviabilidade` | Programadores identificaram inviabilidade na realização | ❌ Não | ❌ Não |
| `Falta de recurso` | Não é possível realizar por falta de recurso | ❌ Não | ❌ Não |
| `Reprovada` | Solicitação foi reprovada pela gerência | ❌ Não | ❌ Não |
| `Cancelada` | Solicitação foi cancelada pelo solicitante ou sistema | ❌ Não | ❌ Não |
| `Atendida` | Todos os atendimentos dos passageiros foram finalizados | ❌ Não | ✅ Já finalizado |

---

## 📝 Detalhamento dos Status

### 1. Em aprovação

**Descrição:** A solicitação aguarda aprovação gerencial antes de ser executada.

**Características:**
- ✅ **Primeira etapa** do fluxo para maioria das solicitações
- ✅ **Editável**: Pode ser modificada enquanto aguarda aprovação
- ⏳ **Aguardando**: Ação de um aprovador
- 🔄 **Transições possíveis**: `Aberta`, `Reprovada`, `Cancelada`

**Quando ocorre:**
- No momento da criação da solicitação
- Quando uma solicitação editada requer nova aprovação

**Exemplo de resposta:**
```json
{
  "_id": "68e64e2d725f5da3cbc613ed",
  "status": "Em aprovação",
  "tripId": 4582,
  "tripulation": [
    {
      "name": "João Silva",
      "status": "Em aprovação"
    }
  ]
}
```

---

### 2. Aberta

**Descrição:** A solicitação foi aprovada e está pronta para ser vinculada a um atendimento.

**Características:**
- ✅ **Aprovada**: Passou pela análise gerencial
- ✅ **Editável**: Ainda pode ser modificada
- ✅ **Pronta para programação**: Pode receber vínculo de atendimento
- 🔄 **Transições possíveis**: `Programada`, `Inviabilidade`, `Falta de recurso`, `Cancelada`, `Em aprovação` (se editada)

**Quando ocorre:**
- Após aprovação gerencial de uma solicitação `Em aprovação`
- Quando criada com aprovação automática
- Quando editada e aprovada automaticamente

**Exemplo de resposta:**
```json
{
  "_id": "68e64e2d725f5da3cbc613ed",
  "status": "Aberta",
  "tripId": 4582,
  "tripulation": [
    {
      "name": "João Silva",
      "status": "Aberta"
    }
  ]
}
```

---

### 3. Programada

**Descrição:** Todos os passageiros da solicitação estão com atendimento vinculado.

**Características:**
- ✅ **Atendimento criado**: Veículo e motorista alocados
- ❌ **Não editável**: Solicitação não pode mais ser modificada
- 🚗 **Em preparação**: Aguardando execução da viagem
- 🔄 **Transições possíveis**: `Atendida`, `Cancelada`

**Quando ocorre:**
- Quando todos os passageiros têm um atendimento (job) vinculado
- Vínculo criado pela equipe de programação

**Exemplo de resposta:**
```json
{
  "_id": "68e64e2d725f5da3cbc613ed",
  "status": "Programada",
  "tripId": 4582,
  "tripulation": [
    {
      "name": "João Silva",
      "status": "Programada",
      "job": {
        "jobId": 2539,
        "status": "Pendente",
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

**💡 Saiba mais:** [Vínculo com Atendimento →](trip-job-link.md)

---

### 4. Inviabilidade

**Descrição:** Os programadores identificaram que a realização da corrida é inviável.

**Características:**
- ⚠️ **Problema identificado**: Impossibilidade técnica ou operacional
- ❌ **Não editável**: Solicitação encerrada
- 🚫 **Sem atendimento**: Não pode ser vinculada a atendimento
- 🔄 **Status final**: Não há transições automáticas

**Quando ocorre:**
- Programadores identificam impossibilidade de realizar a viagem
- Pode ocorrer apenas **antes** de vincular atendimento
- Exemplos: local inacessível, horário incompatível, restrições regulatórias

**Motivos comuns:**
- Local de origem/destino inacessível
- Distância muito grande
- Restrições de segurança
- Conflitos operacionais

**Exemplo de resposta:**
```json
{
  "_id": "68e64e2d725f5da3cbc613ed",
  "status": "Inviabilidade",
  "tripId": 4582,
  "tripulation": [
    {
      "name": "João Silva",
      "status": "Inviabilidade"
    }
  ]
}
```

---

### 5. Falta de recurso

**Descrição:** Não é possível realizar a corrida por falta de recursos disponíveis.

**Características:**
- ⚠️ **Recurso indisponível**: Falta de veículos ou motoristas
- ❌ **Não editável**: Solicitação encerrada
- 🚫 **Sem atendimento**: Não pode ser vinculada a atendimento
- 🔄 **Status final**: Não há transições automáticas

**Quando ocorre:**
- Programadores identificam falta de recursos para atender
- Pode ocorrer apenas **antes** de vincular atendimento
- Sistema não tem disponibilidade para o horário/local solicitado

**Motivos comuns:**
- Todos os veículos já alocados
- Falta de motoristas disponíveis
- Veículo especial (PCD, VIP) indisponível
- Conflito de horários com outras solicitações

**Exemplo de resposta:**
```json
{
  "_id": "68e64e2d725f5da3cbc613ed",
  "status": "Falta de recurso",
  "tripId": 4582,
  "tripulation": [
    {
      "name": "João Silva",
      "status": "Falta de recurso"
    }
  ]
}
```

---

### 6. Reprovada

**Descrição:** A solicitação que estava aguardando aprovação gerencial foi reprovada.

**Características:**
- ❌ **Não aprovada**: Gerência negou a solicitação
- ❌ **Não editável**: Solicitação encerrada
- 🚫 **Sem atendimento**: Não será executada
- 🔄 **Status final**: Não há transições automáticas

**Quando ocorre:**
- Aprovador gerencial reprova a solicitação
- Apenas solicitações com status `Em aprovação` podem ser reprovadas

**Motivos comuns:**
- Falta de justificativa adequada
- Não atende políticas da empresa
- Duplicidade de solicitação
- Informações inconsistentes

**Exemplo de resposta:**
```json
{
  "_id": "68e64e2d725f5da3cbc613ed",
  "status": "Reprovada",
  "tripId": 4582,
  "tripulation": [
    {
      "name": "João Silva",
      "status": "Reprovada"
    }
  ]
}
```

---

### 7. Cancelada

**Descrição:** A solicitação foi cancelada pelo solicitante ou pelo sistema.

**Características:**
- 🚫 **Cancelamento**: Por solicitação do usuário ou automaticamente
- ❌ **Não editável**: Solicitação encerrada
- 🔄 **Status final**: Não há transições automáticas

**Quando ocorre:**
- Usuário cancela a solicitação manualmente
- Sistema cancela automaticamente (ex: prazo expirado)
- Pode ocorrer em qualquer status anterior (exceto finais)

**Como cancelar:**

<div class="endpoint">
  <span class="method patch">PATCH</span>
  <span>/tripee/trips/:id/cancel</span>
</div>

**Exemplo de resposta:**
```json
{
  "_id": "68e64e2d725f5da3cbc613ed",
  "status": "Cancelada",
  "tripId": 4582,
  "tripulation": [
    {
      "name": "João Silva",
      "status": "Cancelada"
    }
  ]
}
```

---

### 8. Atendida

**Descrição:** Todos os atendimentos dos passageiros foram finalizados com sucesso.

**Características:**
- ✅ **Concluída**: Viagem realizada
- ❌ **Não editável**: Solicitação finalizada
- 🏁 **Status final**: Ciclo completo da solicitação

**Quando ocorre:**
- Todos os atendimentos (jobs) vinculados foram finalizados
- Motoristas concluíram as viagens de todos os passageiros

**Exemplo de resposta:**
```json
{
  "_id": "68e64e2d725f5da3cbc613ed",
  "status": "Atendida",
  "tripId": 4582,
  "tripulation": [
    {
      "name": "João Silva",
      "status": "Atendida",
      "job": {
        "jobId": 2539,
        "status": "Finalizado"
      }
    }
  ]
}
```

---

## 👥 Status dos Passageiros

### ⚠️ Importante: Status Individual por Passageiro

Cada passageiro (`tripulation[]`) possui seu **próprio status individual**, que pode ser **diferente** do status geral da solicitação.

**Por que isso acontece?**

Porque o vínculo de atendimento é feito **por passageiro**. Em solicitações com múltiplos passageiros, é possível que:

- ✅ Um passageiro já tenha atendimento vinculado (`Programada`)
- ⏳ Outro passageiro ainda aguarde aprovação (`Em aprovação`)
- ⚠️ Outro passageiro tenha sido identificado como inviável (`Inviabilidade`)

### Exemplo: Status Divergentes

```json
{
  "_id": "68e64e2d725f5da3cbc613ed",
  "status": "Em aprovação",
  "tripId": 4582,
  "tripulation": [
    {
      "name": "João Silva",
      "status": "Programada",
      "job": {
        "jobId": 2539,
        "vehicleStamp": { "plate": "ABC1234" }
      }
    },
    {
      "name": "Maria Santos",
      "status": "Em aprovação"
      // Sem job - ainda aguardando aprovação
    },
    {
      "name": "Carlos Oliveira",
      "status": "Inviabilidade"
      // Sem job - identificado como inviável
    }
  ]
}
```

### Como Interpretar

| Situação | Status da Solicitação | Status dos Passageiros |
|----------|----------------------|------------------------|
| Todos no mesmo status | Reflete o status comum | Todos iguais |
| Status mistos | Status mais restritivo ou prioritário | Cada um com seu status |
| Maioria programada | `Programada` | Alguns podem estar em outros status |

### Regras de Prioridade do Status Geral

Quando há divergência, o status da solicitação segue esta ordem de prioridade:

1. `Cancelada` - Se a solicitação foi cancelada
2. `Reprovada` - Se foi reprovada gerencialmente
3. `Em aprovação` - Se algum passageiro aguarda aprovação
4. `Atendida` - Se todos os atendimentos foram finalizados
5. `Programada` - Se todos os passageiros estão programados
6. `Aberta` - Se aprovada e aguardando programação
7. `Inviabilidade` / `Falta de recurso` - Casos específicos

---

## 📊 Consultando Status

### Buscar Solicitação Específica

<div class="endpoint">
  <span class="method get">GET</span>
  <span>/tripee/trips/:id</span>
</div>

**Resposta:**
```json
{
  "statusCode": 200,
  "data": {
    "_id": "68e64e2d725f5da3cbc613ed",
    "status": "Programada",
    "tripId": 4582,
    "tripulation": [
      {
        "name": "João Silva",
        "status": "Programada",
        "job": { ... }
      }
    ]
  }
}
```

### Listar Solicitações

<div class="endpoint">
  <span class="method get">GET</span>
  <span>/tripee/trips/personnel</span>
</div>

Retorna lista de solicitações com seus respectivos status.

---

**Próximo:** [Status do Atendimento →](job-status.md)  
**Anterior:** [← Vínculo com Atendimento](trip-job-link.md)  
**Voltar para:** [Criação de Solicitações](trip-creation.md) | [Edição de Solicitações](trip-edit.md)
