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
