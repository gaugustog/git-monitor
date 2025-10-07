#!/usr/bin/env bash
# Bash completion for git-monitor
# Author: Gabriel Augusto Gonçalves
# 
# Installation:
# - Linux: Copy to /etc/bash_completion.d/
# - macOS: Copy to /usr/local/etc/bash_completion.d/
# - User: Add to ~/.bash_completion or source from ~/.bashrc

_git_monitor() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    # Opções principais
    local opts_main="--help --version --interval --no-diff --no-color --config"
    
    # Opções curtas
    local opts_short="-h -v -i -d -c"
    
    # Intervalos comuns
    local intervals="1 2 3 5 10 15 30 60"
    
    # Se for o primeiro argumento após git-monitor
    if [[ ${COMP_CWORD} -eq 1 ]]; then
        # Listar opções e diretórios git
        if [[ "$cur" == -* ]]; then
            # Se começar com -, mostrar opções
            COMPREPLY=( $(compgen -W "${opts_main} ${opts_short}" -- ${cur}) )
        else
            # Procurar por repositórios git nas proximidades
            local git_dirs=""
            
            # Buscar diretórios .git em até 3 níveis de profundidade
            if command -v find >/dev/null 2>&1; then
                git_dirs=$(find . -maxdepth 3 -type d -name ".git" 2>/dev/null | while read gitdir; do
                    dirname "$gitdir"
                done | sed 's|^\./||' | sort -u)
            fi
            
            # Combinar com diretórios normais
            COMPREPLY=( $(compgen -W "${opts_main} ${opts_short} ${git_dirs}" -- ${cur}) )
            
            # Adicionar diretórios do sistema de arquivos
            COMPREPLY+=( $(compgen -d -- ${cur}) )
        fi
        
    # Se for o segundo argumento
    elif [[ ${COMP_CWORD} -eq 2 ]]; then
        case "${prev}" in
            --interval|-i)
                # Sugerir intervalos comuns
                COMPREPLY=( $(compgen -W "${intervals}" -- ${cur}) )
                ;;
            --config|-c)
                # Sugerir arquivos de configuração
                COMPREPLY=( $(compgen -f -X '!*.conf' -- ${cur}) )
                COMPREPLY+=( $(compgen -f -X '!*.config' -- ${cur}) )
                ;;
            --help|-h|--version|-v)
                # Nada a completar após estas opções
                return 0
                ;;
            *)
                # Se o primeiro argumento foi um diretório, sugerir intervalos
                if [[ -d "${prev}" ]]; then
                    COMPREPLY=( $(compgen -W "${intervals}" -- ${cur}) )
                else
                    COMPREPLY=( $(compgen -W "${opts_main} ${opts_short}" -- ${cur}) )
                fi
                ;;
        esac
        
    # Terceiro argumento em diante
    elif [[ ${COMP_CWORD} -eq 3 ]]; then
        # Se os dois primeiros foram diretório e intervalo, sugerir opções
        if [[ -d "${COMP_WORDS[1]}" ]] && [[ "${COMP_WORDS[2]}" =~ ^[0-9]+$ ]]; then
            COMPREPLY=( $(compgen -W "${opts_main} ${opts_short}" -- ${cur}) )
        fi
    fi
    
    return 0
}

# Função auxiliar para detectar se estamos em um repositório git
_git_monitor_in_git_repo() {
    git rev-parse --git-dir >/dev/null 2>&1
}

# Registrar a completion
complete -F _git_monitor git-monitor

# Também registrar para o caminho completo se estiver instalado
if command -v git-monitor >/dev/null 2>&1; then
    complete -F _git_monitor $(command -v git-monitor)
fi

# Adicionar alias comum
if alias gm >/dev/null 2>&1; then
    complete -F _git_monitor gm
fi
