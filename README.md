# 🚗 Simcorpi Tripee Integration API Documentation

Documentação oficial da api do Simcorpi para integração com a Tripee, focada no gerenciamento de solicitações de transporte.

## 📖 Sobre

Este repositório contém a documentação completa para gerenciamento de solicitações de transporte, construída com Jekyll e hospedada no GitHub Pages. A documentação fornece informações detalhadas sobre autenticação, criação, edição e gerenciamento completo de solicitações de transporte.

## 🚀 Desenvolvimento Local

### Pré-requisitos

- Ruby (versão 2.7 ou superior)
- Bundler
- Jekyll

### Instalação

```bash
# Instalar dependências
bundle install

# Executar servidor local
bundle exec jekyll serve

# Acessar em: http://localhost:4000
```

## 📁 Estrutura do Projeto

```
simcorpi-tripee_docss/
├── _layouts/           # Templates do site
│   └── default.html    # Layout principal
├── assets/            # Recursos estáticos
│   └── css/          # Folhas de estilo
├── docs/             # Documentação da API
│   ├── authentication.md
│   ├── trip-creation.md
│   ├── trip-edit.md
│   ├── trip-job-link.md
│   ├── trip-list.md
│   ├── trip-status.md
│   └── job-status.md
├── index.md          # Página inicial
├── _config.yml       # Configuração do Jekyll
└── Gemfile          # Dependências Ruby
```

## 🎨 Características

- ✅ Design moderno e responsivo
- ✅ Navegação intuitiva em grid
- ✅ Breadcrumbs para navegação contextual
- ✅ Botão de scroll to top
- ✅ Animações suaves e transições
- ✅ Destaque da página ativa
- ✅ Suporte a dark mode (automático)
- ✅ Otimizado para impressão
- ✅ Acessibilidade aprimorada (WCAG)
- ✅ Footer informativo e organizado
- ✅ Emojis específicos para cada seção

## 🌐 Visualizar Documentação

### Produção (GitHub Pages)
Acesse: `https://7itec.github.io/simcorpi-tripee_docs/`

### Desenvolvimento Local
```bash
# 1. Clone o repositório
git clone https://github.com/7itec/simcorpi-tripee_docs.git
cd simcorpi-tripee_docs

# 2. Instale as dependências
bundle install

# 3. Execute o servidor local
bundle exec jekyll serve

# 4. Acesse em seu navegador
# http://localhost:4000
```

## 📚 Conteúdo da Documentação

### 🔐 Autenticação
Guia completo sobre autenticação via Azure AD, gerenciamento de tokens JWT, refresh e logout.

### ➕ Criar Solicitação
Processo completo para criar solicitações de transporte, incluindo centros de planejamento e tipos de viagem.

### ✏️ Editar Solicitação
Como editar solicitações existentes, restrições e regras de negócio.

### 🔗 Vínculo com Atendimento
Compreenda a relação entre solicitações e atendimentos (jobs).

### 📋 Listar Solicitações
Listagem, filtros, paginação e ordenação de solicitações.

### 🔄 Status da Solicitação
Todos os possíveis status e transições de uma solicitação.

### 🚦 Status do Atendimento
Estados e ciclo de vida de um atendimento.

## 📝 Como Contribuir

1. Faça fork do repositório
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## 🛠️ Tecnologias

- Jekyll (Gerador de sites estáticos)
- Markdown (Formatação de conteúdo)
- HTML5 & CSS3 (Interface)
- JavaScript (Interatividade)
- GitHub Pages (Hospedagem)

## 🔗 Links Úteis

- [GitHub Pages](https://pages.github.com/)
- [Jekyll Documentation](https://jekyllrb.com/docs/)
- [Markdown Guide](https://www.markdownguide.org/)

## 📋 Arquivos de Referência

- **_config.yml**: Configurações do Jekyll

## 📞 Suporte

Para dúvidas, problemas ou sugestões:
- 📧 Entre em contato com a equipe de desenvolvimento
- 🐛 Abra uma issue neste repositório
- 💬 Consulte a documentação inline

## 📄 Licença

Este projeto é mantido pela equipe Simcorpi.

---

**Versão:** 1.0.0  
**Última atualização:** Outubro 2025  
**Repositório:** [github.com/7itec/simcorpi-tripee_docs](https://github.com/7itec/simcorpi-tripee_docs)
