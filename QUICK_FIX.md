# 🚨 SOLUÇÃO RÁPIDA - GitHub Pages

## O Que Está Acontecendo?

Você está vendo **Markdown puro** e **links quebrados** porque o GitHub Pages precisa saber o nome correto do repositório para carregar os arquivos CSS e gerar as URLs corretas.

## ✅ SOLUÇÃO EM 3 PASSOS

### PASSO 1: Descobrir o Nome do Repositório

Olhe a URL do seu repositório no GitHub:
```
https://github.com/wilsonjnr665/NOME-DO-REPO
                                 ^^^^^^^^^^^^
                                 Este é o que você precisa!
```

**Exemplo**:
- Se a URL é: `https://github.com/wilsonjnr665/tripee-docs`
- O nome é: `tripee-docs`

### PASSO 2: Atualizar _config.yml

Abra o arquivo `_config.yml` e edite estas linhas:

```yaml
# ANTES (precisa ser ajustado)
baseurl: "/tripee-docs"
url: "https://wilsonjnr665.github.io"

# DEPOIS (com o nome REAL do seu repositório)
baseurl: "/SEU-REPO-AQUI"    # ← Coloque o nome que você descobriu
url: "https://wilsonjnr665.github.io"
```

**Exemplos**:
```yaml
# Se o repo é tripee-api-docs
baseurl: "/tripee-api-docs"

# Se o repo é tripee-documentation  
baseurl: "/tripee-documentation"

# Se o repo é wilsonjnr665.github.io (repo de usuário)
baseurl: ""
```

### PASSO 3: Fazer Commit e Push

```bash
cd tripee-docs

# Adicionar mudanças
git add _config.yml

# Commit
git commit -m "Fix baseurl for GitHub Pages"

# Push
git push origin main
```

Aguarde **2-3 minutos** e recarregue a página!

---

## 🎯 MÉTODO AUTOMÁTICO (Recomendado)

Se o repositório já tem remote configurado, execute:

```bash
cd tripee-docs
./configure-github-pages.sh
```

Este script detecta automaticamente e configura tudo para você!

---

## 🔍 Como Verificar se Funcionou

Depois de fazer push, aguarde alguns minutos e verifique:

1. **Vá em Settings → Pages no GitHub**
2. Você verá: "Your site is published at https://..."
3. **Copie essa URL** e cole no `_config.yml` como referência

### ✅ Página Correta:
- Header azul com gradiente
- Navegação funcionando
- CSS carregado
- Cards e componentes estilizados

### ❌ Página Errada (atual):
- HTML/Markdown puro
- Sem cores
- Links dando 404

---

## ⚡ CHEAT SHEET

| Seu Repositório | baseurl correto |
|----------------|-----------------|
| `tripee-docs` | `"/tripee-docs"` |
| `tripee-api-docs` | `"/tripee-api-docs"` |
| `api-documentation` | `"/api-documentation"` |
| `username.github.io` | `""` (vazio) |

---

## 🐛 Ainda Não Funcionou?

### Problema: CSS ainda não carrega
**Solução**: Limpe o cache do navegador (Ctrl+Shift+R) ou abra em aba anônima

### Problema: Markdown ainda aparece puro
**Solução**: 
1. Verifique se tem o arquivo `_config.yml` no repositório
2. Force rebuild: `git commit --allow-empty -m "rebuild" && git push`
3. Aguarde 5 minutos

### Problema: 404 em todas as páginas
**Solução**: O `baseurl` está errado. Verifique novamente o nome do repo.

---

## 📞 Teste Local Antes

Para testar se está tudo OK antes de fazer deploy:

```bash
cd tripee-docs

# Se não tiver bundle instalado
gem install bundler

# Instalar dependências
bundle install

# Servir localmente
bundle exec jekyll serve

# Acesse: http://localhost:4000
```

Se funcionar localmente, funcionará no GitHub Pages!

---

## 🎉 URL Final da Documentação

Depois de configurado corretamente, sua documentação estará em:

```
https://wilsonjnr665.github.io/NOME-DO-REPO/
```

**Exemplo**:
- Repo: `tripee-docs`
- URL: `https://wilsonjnr665.github.io/tripee-docs/`

---

**IMPORTANTE**: O único arquivo que você **PRECISA** editar é o `_config.yml`! 

Todos os outros arquivos já foram corrigidos. ✅
