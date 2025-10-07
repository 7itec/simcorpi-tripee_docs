# 🔧 Correções para GitHub Pages

## Problemas Identificados e Soluções

### ❌ Problema 1: CSS Não Carrega (Estilização Genérica)
**Causa**: O `baseurl` no `_config.yml` precisa corresponder ao nome do repositório.

**Solução**:
1. Abra `_config.yml`
2. Ajuste o `baseurl` para o nome do SEU repositório:

```yaml
# Se o repositório é: https://github.com/wilsonjnr665/tripee-api-docs
baseurl: "/tripee-api-docs"

# Se o repositório é: https://github.com/wilsonjnr665/tripee-docs
baseurl: "/tripee-docs"

# Se for o repositório do usuário (username.github.io)
baseurl: ""
```

### ❌ Problema 2: Links 404
**Causa**: Links precisam da extensão `.html` no GitHub Pages.

**✅ Já Corrigido!** Atualizei todos os links para:
- `authentication.html`
- `trip-creation.html`
- `examples.html`

### ❌ Problema 3: Jekyll Não Processa
**Causa**: Falta de Gemfile e configurações.

**✅ Já Corrigido!** Criei o `Gemfile` com:
```ruby
source "https://rubygems.org"
gem "github-pages", group: :jekyll_plugins
gem "webrick", "~> 1.8"
```

## 🚀 Passos para Deploy Correto

### 1. Ajustar o baseurl no _config.yml

```bash
# Edite _config.yml e ajuste conforme o nome do seu repositório
nano _config.yml  # ou use seu editor
```

**IMPORTANTE**: O `baseurl` deve ser `/nome-do-repositorio` (com barra no início, sem barra no final).

### 2. Verificar Nome do Repositório

No GitHub, verifique a URL:
- URL: `https://github.com/wilsonjnr665/NOME-DO-REPO`
- Então: `baseurl: "/NOME-DO-REPO"`

### 3. Commit e Push

```bash
cd tripee-docs

# Adicionar todos os arquivos
git add .

# Commit
git commit -m "Fix GitHub Pages configuration and links"

# Push
git push origin main  # ou master, dependendo da sua branch
```

### 4. Configurar GitHub Pages

1. Vá no repositório no GitHub
2. Settings → Pages
3. Source: **Branch: main** (ou master)
4. Folder: **/ (root)**
5. Clique em **Save**
6. Aguarde 2-3 minutos

### 5. Testar Localmente Antes (Opcional)

```bash
cd tripee-docs

# Instalar dependências
bundle install

# Servir localmente
bundle exec jekyll serve

# Acesse: http://localhost:4000
```

## 📋 Checklist de Verificação

- [ ] `baseurl` no `_config.yml` corresponde ao nome do repositório
- [ ] `url` no `_config.yml` está como `https://wilsonjnr665.github.io`
- [ ] Todos os links usam `.html` (já corrigido)
- [ ] `Gemfile` existe (já criado)
- [ ] Commit e push foram feitos
- [ ] GitHub Pages está ativado em Settings
- [ ] Aguardou 2-3 minutos após o deploy

## 🔍 Como Descobrir o baseurl Correto

### Opção 1: Ver a URL do GitHub Pages
Depois de ativar o GitHub Pages, ele mostra a URL:
```
Your site is published at https://wilsonjnr665.github.io/NOME-DO-REPO/
```

O `baseurl` é: `/NOME-DO-REPO`

### Opção 2: Verificar pela URL do repositório
Se a URL é: `https://github.com/wilsonjnr665/tripee-docs`

Então:
```yaml
baseurl: "/tripee-docs"
url: "https://wilsonjnr665.github.io"
```

## ⚠️ Casos Especiais

### Se for repositório username.github.io
```yaml
baseurl: ""
url: "https://wilsonjnr665.github.io"
```

### Se for organização
```yaml
baseurl: "/nome-do-repo"
url: "https://nome-org.github.io"
```

## 🐛 Troubleshooting

### CSS ainda não carrega?
1. Inspecione a página (F12)
2. Veja o erro no Console
3. Verifique se o caminho do CSS está correto
4. Ajuste o `baseurl` conforme necessário

### Links ainda dão 404?
1. Verifique se os arquivos têm `permalink` no front matter
2. Verifique se Jekyll está processando (aguarde alguns minutos)
3. Force rebuild: faça um commit vazio e push

```bash
git commit --allow-empty -m "Trigger rebuild"
git push
```

### Página mostra Markdown puro?
Isso significa que Jekyll não está processando. Verifique:
1. Se o repositório tem o `_config.yml`
2. Se GitHub Pages está ativado
3. Se a branch está correta

## ✅ Exemplo de _config.yml Correto

```yaml
title: Tripee API Documentation
description: Documentação oficial da API de integração Tripee

# AJUSTE AQUI - substitua pelo nome real do seu repositório
baseurl: "/SEU-REPO-AQUI"
url: "https://wilsonjnr665.github.io"

markdown: kramdown
kramdown:
  input: GFM
  syntax_highlighter: rouge
  auto_ids: true

plugins:
  - jekyll-seo-tag
  - jekyll-sitemap

exclude:
  - README.md
  - SETUP_GUIDE.md
  - VISUAL_UPDATE.md
  - STYLE_GUIDE.md
  - CHANGELOG.md
  - GITHUB_PAGES_FIX.md
  - Gemfile
  - Gemfile.lock
  - node_modules/
  - vendor/

defaults:
  - scope:
      path: ""
    values:
      layout: default
```

## 📞 Ainda com Problemas?

1. **Verifique os logs do GitHub Actions** (se houver)
2. **Espere 5 minutos** após fazer push (o GitHub Pages pode demorar)
3. **Limpe o cache do navegador** (Ctrl+Shift+R)
4. **Teste em aba anônima** para garantir que não é cache

---

**Lembre-se**: O passo mais importante é **ajustar o `baseurl` no `_config.yml`**! 🎯
