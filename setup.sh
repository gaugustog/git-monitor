#!/bin/bash

# Setup script para criar a estrutura do projeto git-monitor
# Autor: Gabriel Augusto Gonçalves

set -e

echo "🚀 Configurando projeto git-monitor..."

# Criar estrutura de diretórios
echo "📁 Criando estrutura de diretórios..."
mkdir -p completions
mkdir -p man
mkdir -p .github/workflows

# Criar arquivo de versão
echo "1.0.0" > VERSION

# Criar man page básica
echo "📝 Criando man page..."
cat > man/git-monitor.1 << 'EOF'
.TH GIT-MONITOR 1 "2024" "Version 1.0.0" "User Commands"
.SH NAME
git-monitor \- Real-time Git repository monitor
.SH SYNOPSIS
.B git-monitor
[\fIDIRECTORY\fR] [\fIINTERVAL\fR]
.SH DESCRIPTION
.B git-monitor
is a real-time Git repository monitor for your terminal, similar to htop for Git.
It displays branch information, file changes, and recent commits with auto-refresh.
.SH OPTIONS
.TP
\fIDIRECTORY\fR
Path to Git repository (default: current directory)
.TP
\fIINTERVAL\fR
Refresh interval in seconds (default: 2)
.SH KEYBOARD SHORTCUTS
.TP
.B q
Quit
.TP
.B r
Refresh immediately
.TP
.B d
Toggle diff preview
.TP
.B +
Increase refresh interval
.TP
.B -
Decrease refresh interval
.SH AUTHOR
Written by Gabriel Augusto Gonçalves.
.SH REPORTING BUGS
Report bugs to: https://github.com/gaugustog/git-monitor/issues
.SH COPYRIGHT
Copyright (C) 2024 Gabriel Augusto Gonçalves.
License MIT: https://opensource.org/licenses/MIT
EOF

# Criar completion para zsh
echo "🔧 Criando zsh completion..."
cat > completions/git-monitor.zsh << 'EOF'
#compdef git-monitor

_git_monitor() {
    local -a opts
    opts=(
        '--help:Show help message'
        '--version:Show version information'
        '--interval:Set refresh interval'
        '--no-diff:Disable diff preview'
        '--no-color:Disable colors'
    )
    
    _arguments \
        '1:directory:_directories' \
        '2:interval:(1 2 3 5 10 15 30 60)' \
        '*: :->opts'
    
    case $state in
        opts)
            _describe 'options' opts
            ;;
    esac
}

_git_monitor "$@"
EOF

# Tornar scripts executáveis
chmod +x git-monitor 2>/dev/null || echo "⚠️  Arquivo git-monitor não encontrado ainda"
chmod +x install.sh 2>/dev/null || echo "⚠️  Arquivo install.sh não encontrado ainda"

# Inicializar repositório git se não existir
if [ ! -d .git ]; then
    echo "📚 Inicializando repositório Git..."
    git init
    git config user.name "Gabriel Augusto Gonçalves"
    git config user.email "gabri.augustog@gmail.com"
fi

# Criar primeiro commit
echo "💾 Preparando primeiro commit..."
git add -A
git commit -m "Initial commit: Git Monitor v1.0.0

- Real-time Git repository monitoring
- Color-coded file status
- Interactive keyboard controls
- Diff preview
- Activity log
- Zero dependencies (pure bash)
- Flicker-free display

Author: Gabriel Augusto Gonçalves <gabri.augustog@gmail.com>" || echo "⚠️  Nada para commitar"

# Instruções finais
echo ""
echo "✅ Setup completo!"
echo ""
echo "📋 Próximos passos:"
echo ""
echo "1. Certifique-se de que o arquivo 'git-monitor' (script principal) está na raiz"
echo ""
echo "2. Crie o repositório no GitHub:"
echo "   gh repo create git-monitor --public --description 'Real-time Git repository monitor for terminal'"
echo "   # ou manualmente em https://github.com/new"
echo ""
echo "3. Adicione o remote e faça push:"
echo "   git remote add origin https://github.com/gaugustog/git-monitor.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "4. (Opcional) Crie a primeira release:"
echo "   git tag -a v1.0.0 -m 'First release'"
echo "   git push origin v1.0.0"
echo ""
echo "5. Teste a instalação remota:"
echo "   curl -sSL https://raw.githubusercontent.com/gaugustog/git-monitor/main/install.sh | bash"
echo ""
echo "📚 Documentação completa no README.md"
echo "📧 Suporte: gabri.augustog@gmail.com"
echo ""
