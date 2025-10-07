# Tripee API Documentation - Setup Guide

## 🚀 Como Publicar no GitHub Pages

### Passo 1: Criar um Novo Repositório no GitHub

1. Acesse o GitHub e crie um novo repositório
2. Nome sugerido: `tripee-api-docs`
3. Defina como público ou privado conforme necessário
4. Não inicialize com README (já temos um)

### Passo 2: Preparar os Arquivos

Esta pasta (`tripee-docs/`) contém toda a estrutura necessária:

```
tripee-docs/
├── _config.yml            # Configuração do Jekyll/GitHub Pages
├── index.md               # Página inicial (Markdown)
├── index.html.backup      # Backup do HTML original
├── README.md              # Documentação do repositório
├── _layouts/
│   └── default.html       # Layout customizado
├── assets/
│   └── css/
│       └── style.css      # Estilos customizados
└── docs/
    ├── authentication.md  # Guia de autenticação
    ├── trip-creation.md   # Guia de criação de trips
    └── examples.md        # Exemplos de código
```

### Passo 3: Subir para o GitHub

```bash
# Navegue até a pasta tripee-docs
cd tripee-docs

# Inicialize o repositório git
git init

# Adicione todos os arquivos
git add .

# Faça o commit inicial
git commit -m "Initial commit: Tripee API documentation"

# Adicione o remote (substitua com a URL do seu repositório)
git remote add origin https://github.com/SEU_USUARIO/tripee-api-docs.git

# Faça o push
git branch -M main
git push -u origin main
```

### Passo 4: Ativar GitHub Pages

1. No repositório do GitHub, vá em **Settings**
2. No menu lateral, clique em **Pages**
3. Em **Source**, selecione:
   - Branch: `main`
   - Folder: `/ (root)`
4. Clique em **Save**
5. Aguarde alguns minutos para o deploy

### Passo 5: Acessar a Documentação

Após o deploy, sua documentação estará disponível em:

```
https://SEU_USUARIO.github.io/tripee-api-docs/
```

## 🎨 Personalizações

### Estilos Customizados

A documentação usa um layout customizado com estilos consistentes:

- **Layout**: `_layouts/default.html` - Define a estrutura HTML de todas as páginas
- **Estilos**: `assets/css/style.css` - CSS customizado que mantém o visual consistente

Para alterar cores, fontes ou layout:
1. Edite `assets/css/style.css` para mudanças de estilo
2. Edite `_layouts/default.html` para mudanças estruturais

### Variáveis CSS

As cores principais estão definidas como variáveis CSS no início do `style.css`:

```css
:root {
    --primary-color: #2563eb;     /* Azul principal */
    --secondary-color: #1e40af;   /* Azul secundário */
    --text-color: #1f2937;        /* Cor do texto */
    --bg-color: #f9fafb;          /* Cor de fundo */
    --border-color: #e5e7eb;      /* Cor das bordas */
}
```

Basta alterar essas variáveis para mudar o esquema de cores de toda a documentação.

## 📝 Atualizando a Documentação

Para adicionar ou atualizar conteúdo:

```bash
# Faça as alterações nos arquivos
# Depois:

git add .
git commit -m "Descrição das alterações"
git push origin main
```

O GitHub Pages irá redeployar automaticamente em alguns minutos.

## 🔧 Desenvolvimento Local

Para visualizar localmente antes de fazer o deploy:

### Usando Python (simples)

```bash
cd tripee-docs
python3 -m http.server 8000
```

Acesse: http://localhost:8000

### Usando Jekyll (como no GitHub Pages)

```bash
# Instalar Jekyll (se não tiver)
gem install jekyll bundler

# Na pasta tripee-docs
bundle init
bundle add jekyll

# Servir localmente
bundle exec jekyll serve
```

Acesse: http://localhost:4000

## 📋 Checklist de Deploy

- [ ] Repositório criado no GitHub
- [ ] Arquivos commitados e pushed
- [ ] GitHub Pages ativado nas configurações
- [ ] URL da documentação funcionando
- [ ] Links internos funcionando corretamente
- [ ] Atualizar o README.md com a URL real do GitHub Pages

## 🔗 Recursos Úteis

- [Documentação GitHub Pages](https://docs.github.com/en/pages)
- [Jekyll Documentation](https://jekyllrb.com/docs/)
- [GitHub Pages Themes](https://pages.github.com/themes/)
- [Markdown Guide](https://www.markdownguide.org/)

## ⚠️ Notas Importantes

1. **URLs**: Após o deploy, atualize o README.md com a URL real do GitHub Pages
2. **Base URL da API**: Altere `https://api.example.com/tripee` para a URL real da sua API
3. **Privacidade**: Se o repositório for privado, apenas membros da organização poderão acessar
4. **Custom Domain**: Você pode configurar um domínio customizado nas configurações do GitHub Pages

## 🎯 Próximos Passos

Após publicar a documentação:

1. Compartilhe a URL com a equipe Tripee
2. Adicione mais exemplos conforme necessário
3. Documente endpoints adicionais
4. Adicione seções sobre atualização, listagem e cancelamento de trips
5. Considere adicionar um sistema de versionamento da API

---

**Dúvidas?** Consulte a [documentação oficial do GitHub Pages](https://docs.github.com/en/pages)
