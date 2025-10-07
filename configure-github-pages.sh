#!/bin/bash

# Script para configurar automaticamente o baseurl do GitHub Pages

echo "🔍 Detectando configuração do repositório..."
echo ""

# Verificar se está em um repositório git
if [ -d .git ]; then
    echo "✅ Repositório Git encontrado"
    
    # Tentar pegar o remote
    REMOTE_URL=$(git remote get-url origin 2>/dev/null)
    
    if [ -n "$REMOTE_URL" ]; then
        echo "📡 Remote URL: $REMOTE_URL"
        
        # Extrair o nome do repositório da URL
        REPO_NAME=$(echo "$REMOTE_URL" | sed -E 's/.*\/([^\/]+)(\.git)?$/\1/' | sed 's/\.git$//')
        USERNAME=$(echo "$REMOTE_URL" | sed -E 's/.*[:/]([^/]+)\/[^/]+(\.git)?$/\1/')
        
        echo "👤 Usuário: $USERNAME"
        echo "📦 Repositório: $REPO_NAME"
        echo ""
        
        # Configurar _config.yml
        echo "⚙️  Configurando _config.yml..."
        
        # Verificar se é repositório de usuário (username.github.io)
        if [ "$REPO_NAME" == "${USERNAME}.github.io" ]; then
            echo "ℹ️  Detectado repositório de usuário"
            BASEURL=""
        else
            BASEURL="/$REPO_NAME"
        fi
        
        # Atualizar _config.yml
        sed -i "s|baseurl:.*|baseurl: \"$BASEURL\"|g" _config.yml
        sed -i "s|url:.*|url: \"https://${USERNAME}.github.io\"|g" _config.yml
        
        echo "✅ Configuração atualizada!"
        echo ""
        echo "📝 Configuração aplicada:"
        echo "   baseurl: \"$BASEURL\""
        echo "   url: \"https://${USERNAME}.github.io\""
        echo ""
        echo "🌐 Sua documentação estará disponível em:"
        if [ -z "$BASEURL" ]; then
            echo "   https://${USERNAME}.github.io/"
        else
            echo "   https://${USERNAME}.github.io${BASEURL}/"
        fi
        echo ""
        echo "✨ Pronto! Agora faça:"
        echo "   git add _config.yml"
        echo "   git commit -m 'Configure baseurl for GitHub Pages'"
        echo "   git push"
        
    else
        echo "⚠️  Nenhum remote configurado ainda"
        echo ""
        echo "📝 Configure manualmente:"
        echo "   1. Edite _config.yml"
        echo "   2. Ajuste baseurl para: \"/nome-do-seu-repositorio\""
        echo "   3. Ajuste url para: \"https://seu-usuario.github.io\""
    fi
else
    echo "❌ Este não é um repositório Git"
    echo ""
    echo "🚀 Inicialize o repositório primeiro:"
    echo "   git init"
    echo "   git remote add origin https://github.com/usuario/repo.git"
    echo ""
    echo "Depois execute este script novamente"
fi

echo ""
echo "📚 Para mais informações, consulte: GITHUB_PAGES_FIX.md"
