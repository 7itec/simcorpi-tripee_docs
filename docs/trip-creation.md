# Criação de Solicitações de Transporte

Este guia detalha o processo completo para criar uma solicitação de transporte (trip) na API Tripee.

## 📋 Visão Geral do Processo

A criação de uma solicitação envolve 4 etapas principais:

1. **Buscar Centros de Planejamento** disponíveis
2. **Consultar Tipos de Viagem** (modes) do centro escolhido
3. **Preencher dados dos Passageiros** (tripulation)
4. **Criar a Solicitação** com todos os dados

---

## 1️⃣ Buscar Centros de Planejamento

Primeiro, obtenha a lista de centros de planejamento disponíveis.

**Endpoint:** `GET /tripee/planning-centers/all`

**Headers:**
```http
Authorization: Bearer {ACCESS_TOKEN}
```

**Resposta de Sucesso (200):**
```json
[
  {
    "_id": "507f1f77bcf86cd799439011",
    "name": "REPLAN"
  },
  {
    "_id": "507f1f77bcf86cd799439012",
    "name": "REDUC"
  },
  {
    "_id": "507f1f77bcf86cd799439013",
    "name": "RPBC"
  }
]
```

**💡 O usuário deve escolher um centro de planejamento desta lista.**

---

## 2️⃣ Consultar Tipos de Viagem (Modes)

Após escolher um centro de planejamento, consulte os tipos de viagem disponíveis para aquele centro.

**Endpoint:** `GET /tripee/planning-centers/:id/modes`

**Parâmetros:**
- `id` (path): ID do centro de planejamento escolhido

**Headers:**
```http
Authorization: Bearer {ACCESS_TOKEN}
```

**Exemplo de Requisição:**
```bash
GET /tripee/planning-centers/507f1f77bcf86cd799439011/modes
```

**Resposta de Sucesso (200):**
```json
[
  {
    "_id": "607f1f77bcf86cd799439021",
    "name": "Requisição de Transporte"
  },
  {
    "_id": "607f1f77bcf86cd799439022",
    "name": "Transporte Emergencial"
  },
  {
    "_id": "607f1f77bcf86cd799439023",
    "name": "Transporte VIP"
  }
]
```

**💡 O usuário deve escolher um tipo de viagem desta lista.**

---

## 3️⃣ Buscar Centros de Custo

Para cada passageiro, é necessário fornecer um centro de custo válido.

**Endpoint:** `GET /tripee/cost-centers/names/:name`

**Parâmetros:**
- `name` (path): Nome do centro de custo (deve ter **match EXATO**)

**Headers:**
```http
Authorization: Bearer {ACCESS_TOKEN}
```

**Exemplo de Requisição:**
```bash
GET /tripee/cost-centers/names/A003ADMR01
```

**Resposta de Sucesso (200):**
```json
[
  {
    "_id": "707f1f77bcf86cd799439031",
    "name": "A003ADMR01",
    "description": "Centro de Custo - Administrativo"
  }
]
```

**⚠️ Importante:** 
- A busca deve ser **exata** (case-sensitive)
- Se não houver correspondência exata, o centro de custo não será encontrado
- Cada passageiro pode ter múltiplos centros de custo

---

## 4️⃣ Criar a Solicitação

Agora que você tem todos os dados necessários, pode criar a solicitação.

**Endpoint:** `POST /tripee/trips/personnel`

**Content-Type:** `multipart/form-data`

**Headers:**
```http
Authorization: Bearer {ACCESS_TOKEN}
Content-Type: multipart/form-data
timezone-offset: -03:00
```

**Campos do Formulário:**

### 📄 Campo `data` (JSON string)

```json
{
  "mode": "Requisição de Transporte",
  "planningCenter": "REPLAN",
  "requestedFor": "2024-04-25T14:30:00.000Z",
  "observations": "Reunião importante com diretoria",
  "tripulation": [
    {
      "_id": "64480d0f9d0e52c173e1e362",
      "name": "PEDRO JORGE DE OLIVEIRA FREIRE",
      "registrationNumber": 46145810,
      "email": "pedro.freire@empresa.com",
      "phone": "11999873247",
      "department": "COMPARTILHADO/SC/SMOB/GT",
      "isVip": true,
      "pcd": false,
      "costCenter": [
        "A003ADMR01",
        "AB17RPLL15"
      ],
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
      }
    }
  ]
}
```

### 📎 Campo `files` (arquivos)

- Até **3 arquivos**
- Tamanho máximo: **5MB por arquivo**
- Formatos aceitos: imagens (JPG, PNG, etc.) e PDF

---

## 📝 Detalhamento dos Campos

### Campos Obrigatórios da Solicitação

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `mode` | string | Nome do tipo de viagem escolhido |
| `planningCenter` | string | Nome do centro de planejamento escolhido |
| `requestedFor` | string (ISO 8601) | Data/hora da viagem em **UTC** |
| `tripulation` | array | Lista de passageiros (mínimo 1) |

### Campos Opcionais da Solicitação

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `observations` | string | Observações sobre a viagem |
| `files` | files | Anexos (até 3, máx 5MB cada) |

### Campos do Passageiro (tripulation)

#### Obrigatórios:

| Campo | Tipo | Descrição |
|-------|------|-----------|
| `name` | string | Nome completo do passageiro |
| `registrationNumber` | number | Número de matrícula |
| `email` | string | E-mail do passageiro |
| `phone` | string | Telefone para contato |
| `department` | string | Departamento do passageiro |
| `costCenter` | string[] | Lista de centros de custo |
| `originAddress` | object | Endereço de origem |
| `destinyAddress` | object | Endereço de destino |

#### Opcionais:

| Campo | Tipo | Descrição | Padrão |
|-------|------|-----------|--------|
| `_id` | string | ID do passageiro (se cadastrado) | - |
| `isVip` | boolean | Se é passageiro VIP | false |
| `pcd` | boolean | Se é pessoa com deficiência | false |

### Estrutura de Endereço

```json
{
  "street": "Nome da rua",
  "streetNumber": "Número",
  "neighborhood": "Bairro",
  "city": "Cidade",
  "state": "Estado completo",
  "uf": "SP",
  "zipcode": "00000-000",
  "latitude": -23.550520,
  "longitude": -46.633308
}
```

**Campos Obrigatórios do Endereço:**
- `street`
- `streetNumber`
- `neighborhood`
- `city`
- `state`
- `uf`
- `zipcode`
- `latitude`
- `longitude`

---

## ⏰ Gerenciamento de Timezone

A API trabalha com três conceitos de timezone:

### 1. Data da Viagem (UTC)

O campo `requestedFor` deve ser enviado em **UTC (ISO 8601)**:

```json
{
  "requestedFor": "2024-04-25T14:30:00.000Z"
}
```

**Como calcular:**
- Data local desejada: 25/04/2024 11:30 (horário de Brasília, UTC-3)
- Converter para UTC: 25/04/2024 14:30
- Formato ISO: `2024-04-25T14:30:00.000Z`

### 2. Timezone Local da Viagem

Enviar no corpo da requisição (campo `requestUserTimezone`):

```json
{
  "requestUserTimezone": "-03:00"
}
```

Este é o offset do timezone da **localidade onde a viagem será executada**.

**Exemplos:**
- Brasília: `-03:00`
- Manaus: `-04:00`
- Fernando de Noronha: `-02:00`

### 3. Timezone do Usuário

Enviar no **header** `timezone-offset`:

```http
timezone-offset: -03:00
```

Este é o offset do timezone da **localidade onde o usuário está fazendo a requisição**.

### Exemplo Completo com Timezones

```javascript
// Usuário em São Paulo quer criar viagem para Campinas
// Data desejada: 25/04/2024 às 11:30 (horário local)

// 1. Converter para UTC
const localDate = new Date('2024-04-25T11:30:00-03:00');
const utcDate = localDate.toISOString(); // "2024-04-25T14:30:00.000Z"

// 2. Montar requisição
const formData = new FormData();
formData.append('data', JSON.stringify({
  mode: "Requisição de Transporte",
  planningCenter: "REPLAN",
  requestedFor: utcDate, // UTC
  requestUserTimezone: "-03:00", // Timezone local da viagem
  tripulation: [...]
}));

// 3. Enviar com header
fetch('/tripee/trips/personnel', {
  method: 'POST',
  headers: {
    'Authorization': 'Bearer YOUR_TOKEN',
    'timezone-offset': '-03:00' // Timezone do usuário
  },
  body: formData
});
```

---

## 📤 Exemplo Completo de Requisição

### Usando JavaScript (Fetch API)

```javascript
async function createTrip() {
  // 1. Preparar os dados da viagem
  const tripData = {
    mode: "Requisição de Transporte",
    planningCenter: "REPLAN",
    requestedFor: "2024-04-25T14:30:00.000Z",
    requestUserTimezone: "-03:00",
    observations: "Reunião importante com diretoria",
    tripulation: [
      {
        _id: "64480d0f9d0e52c173e1e362",
        name: "PEDRO JORGE DE OLIVEIRA FREIRE",
        registrationNumber: 46145810,
        email: "pedro.freire@empresa.com",
        phone: "11999873247",
        department: "COMPARTILHADO/SC/SMOB/GT",
        isVip: true,
        pcd: false,
        costCenter: ["A003ADMR01", "AB17RPLL15"],
        originAddress: {
          street: "RUA SEIS",
          streetNumber: "2250",
          neighborhood: "BONFIM",
          city: "PAULÍNIA",
          state: "SÃO PAULO",
          uf: "SP",
          zipcode: "13147-030",
          latitude: -22.73217,
          longitude: -47.13737
        },
        destinyAddress: {
          street: "RODOVIA SANTOS DUMONT",
          streetNumber: "KM 66",
          neighborhood: "PARQUE VIRACOPOS",
          city: "CAMPINAS",
          state: "SÃO PAULO",
          uf: "SP",
          zipcode: "13055-900",
          latitude: -23.0080502,
          longitude: -47.1396595
        }
      }
    ]
  };

  // 2. Criar FormData
  const formData = new FormData();
  formData.append('data', JSON.stringify(tripData));
  
  // 3. Adicionar arquivos (se houver)
  const fileInput = document.getElementById('fileInput');
  if (fileInput.files.length > 0) {
    Array.from(fileInput.files).forEach(file => {
      formData.append('files', file);
    });
  }

  // 4. Enviar requisição
  const response = await fetch('https://api.example.com/tripee/trips/personnel', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${accessToken}`,
      'timezone-offset': '-03:00'
    },
    body: formData
  });

  const result = await response.json();
  
  if (response.ok) {
    console.log('Solicitação criada com sucesso:', result);
    return result;
  } else {
    console.error('Erro ao criar solicitação:', result);
    throw new Error(result.message);
  }
}
```

### Usando cURL

```bash
curl -X POST https://api.example.com/tripee/trips/personnel \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "timezone-offset: -03:00" \
  -F 'data={
    "mode": "Requisição de Transporte",
    "planningCenter": "REPLAN",
    "requestedFor": "2024-04-25T14:30:00.000Z",
    "requestUserTimezone": "-03:00",
    "observations": "Reunião importante",
    "tripulation": [{
      "_id": "64480d0f9d0e52c173e1e362",
      "name": "PEDRO JORGE DE OLIVEIRA FREIRE",
      "registrationNumber": 46145810,
      "email": "pedro.freire@empresa.com",
      "phone": "11999873247",
      "department": "COMPARTILHADO/SC/SMOB/GT",
      "isVip": true,
      "pcd": false,
      "costCenter": ["A003ADMR01"],
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
      }
    }]
  }' \
  -F 'files=@/path/to/document1.pdf' \
  -F 'files=@/path/to/image1.jpg'
```

---

## ✅ Resposta de Sucesso

**Status:** `201 Created`

```json
{
  "data": {
    "_id": "661f1a2b3c4d5e6f7a8b9c0d",
    "tripId": "TRIP-2024-001234",
    "status": "pending_approval",
    "mode": "Requisição de Transporte",
    "planningCenter": "REPLAN",
    "requestedFor": "2024-04-25T14:30:00.000Z",
    "requestUserTimezone": "-03:00",
    "observations": "Reunião importante com diretoria",
    "tripulation": [
      {
        "name": "PEDRO JORGE DE OLIVEIRA FREIRE",
        "registrationNumber": 46145810,
        "email": "pedro.freire@empresa.com",
        "phone": "11999873247",
        "department": "COMPARTILHADO/SC/SMOB/GT",
        "isVip": true,
        "pcd": false,
        "costCenter": ["A003ADMR01", "AB17RPLL15"],
        "originAddress": { ... },
        "destinyAddress": { ... }
      }
    ],
    "files": [
      {
        "url": "https://storage.example.com/trips/661f1a2b3c4d5e6f7a8b9c0d/document1.pdf"
      }
    ],
    "requestedBy": {
      "_id": "507f1f77bcf86cd799439011",
      "name": "João Silva"
    },
    "createdBy": {
      "_id": "507f1f77bcf86cd799439011",
      "name": "João Silva"
    },
    "createdAt": "2024-04-20T10:00:00.000Z",
    "updatedAt": "2024-04-20T10:00:00.000Z"
  },
  "statusCode": 201
}
```

**Campos Principais da Resposta:**
- `_id`: ID único da solicitação
- `tripId`: Identificador legível da viagem
- `status`: Status atual da solicitação
- `files[].url`: URLs dos arquivos anexados

**Possíveis Status:**
- `pending_approval`: Aguardando aprovação
- `approved`: Aprovada
- `in_progress`: Em andamento
- `completed`: Concluída
- `cancelled`: Cancelada

---

## ❌ Erros Comuns

### 400 - Bad Request

**Cenário 1: Nenhum passageiro fornecido**
```json
{
  "statusCode": 400,
  "message": "Ao menos um passageiro é necessário para que a solicitação seja criada"
}
```

**Cenário 2: Data no passado**
```json
{
  "statusCode": 400,
  "message": "A data de solicitação não pode ser menor que a data atual"
}
```

**Cenário 3: Arquivo muito grande**
```json
{
  "statusCode": 400,
  "message": "File too large. Maximum size is 5MB per file"
}
```

**Cenário 4: Muitos arquivos**
```json
{
  "statusCode": 400,
  "message": "Too many files. Maximum is 3 files"
}
```

### 401 - Unauthorized

```json
{
  "statusCode": 401,
  "message": "Unauthorized"
}
```

**Solução:** Verifique se o `access_token` está válido e corretamente formatado no header.

### 403 - Forbidden

```json
{
  "statusCode": 403,
  "message": "Insufficient permissions"
}
```

**Solução:** O usuário não tem permissão para criar solicitações.

---

## 📊 Diagrama de Fluxo

```
┌──────────────┐
│   Cliente    │
└──────┬───────┘
       │
       │ 1. GET /planning-centers/all
       ▼
┌──────────────┐
│ API: Retorna │
│   centros    │
└──────┬───────┘
       │
       │ 2. Usuário escolhe centro
       │ 3. GET /planning-centers/:id/modes
       ▼
┌──────────────┐
│ API: Retorna │
│    modes     │
└──────┬───────┘
       │
       │ 4. Usuário escolhe mode
       │ 5. Para cada passageiro:
       │    GET /cost-centers/names/:name
       ▼
┌──────────────┐
│ API: Retorna │
│centro de custo│
└──────┬───────┘
       │
       │ 6. Usuário preenche dados
       │ 7. POST /trips/personnel
       │    (multipart/form-data)
       ▼
┌──────────────┐
│ API: Cria e  │
│retorna viagem│
└──────┬───────┘
       │
       │ 8. Notificações enviadas
       │    (aprovadores, gestores)
       ▼
┌──────────────┐
│  Finalizado  │
└──────────────┘
```

---

## 💡 Dicas e Boas Práticas

### ✅ Recomendações

1. **Validação no Cliente:**
   - Valide todos os campos obrigatórios antes de enviar
   - Verifique tamanho e tipo dos arquivos
   - Confirme que a data não é no passado

2. **Experiência do Usuário:**
   - Mostre preview dos arquivos antes do upload
   - Implemente loading states durante o upload
   - Mostre progresso para arquivos grandes
   - Permita remover arquivos antes do envio

3. **Tratamento de Erros:**
   - Mostre mensagens de erro claras ao usuário
   - Destaque campos com problemas
   - Permita retry em caso de falha de rede

4. **Performance:**
   - Comprima imagens antes do upload quando possível
   - Use loading lazy para listas grandes de centros/modes
   - Cache a lista de centros de planejamento

5. **Dados de Endereço:**
   - Integre com APIs de geocoding (Google Maps, etc.)
   - Valide CEP antes de permitir o envio
   - Preencha automaticamente cidade/estado a partir do CEP

### ❌ Evite

- ❌ Enviar data no passado (mais de 10 minutos atrás)
- ❌ Arquivos maiores que 5MB
- ❌ Mais de 3 arquivos por solicitação
- ❌ Lista vazia de passageiros
- ❌ Centros de custo inválidos
- ❌ Coordenadas inválidas (lat/lng)

---

## 🔍 Validações da API

A API valida automaticamente:

- ✓ Data da viagem não está no passado (tolerância de 10 minutos)
- ✓ Pelo menos 1 passageiro na tripulação
- ✓ Tamanho dos arquivos (máx 5MB cada)
- ✓ Quantidade de arquivos (máx 3)
- ✓ Centro de planejamento existe e está ativo
- ✓ Modo de viagem existe e está disponível no centro
- ✓ Centros de custo existem
- ✓ Formato das coordenadas geográficas
- ✓ Permissões do usuário

---

## 🧪 Checklist de Teste

Antes de integrar em produção, teste os seguintes cenários:

- [ ] Criar solicitação com 1 passageiro
- [ ] Criar solicitação com múltiplos passageiros
- [ ] Criar solicitação com arquivos anexados
- [ ] Criar solicitação sem arquivos
- [ ] Criar solicitação com observações
- [ ] Criar solicitação sem observações
- [ ] Tentar criar com data no passado (deve falhar)
- [ ] Tentar criar sem passageiros (deve falhar)
- [ ] Tentar criar com arquivo > 5MB (deve falhar)
- [ ] Tentar criar com > 3 arquivos (deve falhar)
- [ ] Verificar diferentes timezones
- [ ] Testar com passageiro VIP
- [ ] Testar com passageiro PCD
- [ ] Verificar notificações enviadas após criação

---

**Próximo:** [Exemplos de Código →](examples.md)  
**Anterior:** [← Autenticação](authentication.md)
