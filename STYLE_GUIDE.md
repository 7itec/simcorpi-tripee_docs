# Guia de Estilos - Tripee API Docs

## 🎨 Componentes Disponíveis

Este guia mostra todos os componentes estilizados disponíveis para usar na documentação.

## 📝 Markdown Básico

### Títulos
```markdown
# Título H1 (Azul, borda inferior grossa)
## Título H2 (Azul, borda inferior fina)
### Título H3 (Azul secundário)
#### Título H4 (Cinza escuro)
```

### Texto
```markdown
**Negrito** e *itálico*

`código inline` com cor rosa

> Blockquote (borda azul lateral)
```

### Listas
```markdown
- Item 1
- Item 2
  - Sub-item
  
1. Primeiro
2. Segundo
```

### Links
```markdown
[Texto do link](url) - Azul com hover
```

## 🎯 Componentes HTML Customizados

### Cards
```html
<div class="card">
  <h4>Título do Card</h4>
  <ul>
    <li>Item 1</li>
    <li>Item 2</li>
  </ul>
</div>
```

### Grid de Features
```html
<div class="features">
  <div class="feature-card">
    <div class="emoji">🚀</div>
    <h3>Título</h3>
    <p>Descrição breve</p>
  </div>
  <!-- Mais cards... -->
</div>
```

### Seções
```html
<div class="section">
  <h2>Título da Seção</h2>
  <p>Conteúdo...</p>
</div>
```

### Endpoints
```html
<div class="endpoint">
  <span class="method get">GET</span>
  <span>/caminho/do/endpoint</span>
</div>
```

### Métodos HTTP
```html
<span class="method get">GET</span>
<span class="method post">POST</span>
<span class="method patch">PATCH</span>
<span class="method delete">DELETE</span>
```

### Badges
```html
<span class="badge required">Obrigatório</span>
<span class="badge optional">Opcional</span>
```

### Navegação entre Páginas
```html
<div class="page-nav">
  <a href="/docs/anterior">← Anterior</a>
  <a href="/docs/proximo">Próximo →</a>
</div>
```

## 💻 Blocos de Código

### Código com Linguagem
```markdown
```javascript
const example = "código";
console.log(example);
```
```

Linguagens suportadas com highlighting:
- `javascript` / `js`
- `typescript` / `ts`
- `python`
- `bash` / `shell`
- `json`
- `html`
- `css`

### Código HTTP
```markdown
```http
GET /api/endpoint HTTP/1.1
Authorization: Bearer token
Content-Type: application/json
```
```

## 📊 Tabelas

```markdown
| Coluna 1 | Coluna 2 | Coluna 3 |
|----------|----------|----------|
| Dado 1   | Dado 2   | Dado 3   |
| Dado 4   | Dado 5   | Dado 6   |
```

Renderiza com:
- Header azul claro
- Hover cinza nas linhas
- Bordas sutis

## ✅ Listas de Tarefas

```markdown
- [ ] Tarefa não concluída
- [x] Tarefa concluída
```

## 🎨 Variáveis CSS

### Cores
```css
--primary-color: #2563eb;     /* Azul principal */
--secondary-color: #1e40af;   /* Azul escuro */
--text-color: #1f2937;        /* Cinza escuro */
--bg-color: #f9fafb;          /* Cinza muito claro */
--border-color: #e5e7eb;      /* Cinza claro */
```

### Uso
```css
.meu-elemento {
  color: var(--primary-color);
  background: var(--bg-color);
}
```

## 📐 Layout

### Container
```html
<div class="container">
  <!-- Conteúdo centralizado, max-width 1200px -->
</div>
```

### Content
```html
<div class="content">
  <!-- Área de conteúdo principal com fundo branco -->
</div>
```

## 🔍 Exemplos Práticos

### Exemplo: Documentar Endpoint

```markdown
## Criar Solicitação

**Endpoint:** `POST /tripee/trips/personnel`

<div class="endpoint">
  <span class="method post">POST</span>
  <span>/tripee/trips/personnel</span>
</div>

**Headers:**
- <span class="badge required">Obrigatório</span> `Authorization: Bearer {token}`
- <span class="badge required">Obrigatório</span> `Content-Type: multipart/form-data`
- <span class="badge optional">Opcional</span> `timezone-offset: -03:00`

**Exemplo:**
```javascript
const response = await fetch('/tripee/trips/personnel', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${token}`
  },
  body: formData
});
```
```

### Exemplo: Seção com Cards

```markdown
## Recursos da API

<div class="features">
  <div class="feature-card">
    <div class="emoji">🔐</div>
    <h3>Segurança</h3>
    <p>Autenticação via Azure AD</p>
  </div>
  
  <div class="feature-card">
    <div class="emoji">⚡</div>
    <h3>Performance</h3>
    <p>Respostas rápidas e eficientes</p>
  </div>
</div>
```

## 📱 Responsividade

Todos os componentes são responsivos e se adaptam automaticamente a:
- Desktop (> 768px)
- Tablet (768px)
- Mobile (< 768px)

## 🎯 Dicas de Uso

### ✅ Faça
- Use heading hierarchy (H1 → H2 → H3)
- Use badges para destacar campos obrigatórios
- Use blocos de código com linguagem específica
- Agrupe conteúdos relacionados em cards
- Use emojis para tornar visual mais amigável

### ❌ Evite
- Pular níveis de heading (H1 → H3)
- Usar inline CSS (já tem classes prontas)
- Código sem especificar linguagem
- Parágrafos muito longos
- Cores hardcoded (use variáveis CSS)

## 🔧 Customizações Rápidas

### Mudar Cor Primária
```css
/* Em assets/css/style.css */
:root {
  --primary-color: #8b5cf6; /* Roxo */
}
```

### Adicionar Nova Classe
```css
/* Em assets/css/style.css */
.minha-classe {
  background: var(--primary-color);
  padding: 1rem;
  border-radius: 8px;
}
```

### Usar na Documentação
```html
<div class="minha-classe">
  Conteúdo customizado
</div>
```

## 📚 Referências

- [Markdown Guide](https://www.markdownguide.org/)
- [Liquid Template Language](https://shopify.github.io/liquid/)
- [CSS Variables MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties)

---

**Dica**: Consulte os arquivos em `docs/` para ver exemplos reais de uso!
