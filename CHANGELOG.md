# Changelog

All notable changes to Git Monitor will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2024-01-XX

### Added
- Initial release of Git Monitor
- Real-time repository monitoring with auto-refresh
- Color-coded file status indicators
- Interactive keyboard controls (q, r, d, +/-)
- Branch information display
- File change statistics
- Recent commits activity log
- Diff preview for modified files
- Flicker-free terminal updates
- Support for remote repository monitoring
- Bash and Zsh completions
- Automated installer script
- Makefile for easy installation
- GitHub Actions CI/CD pipeline
- Man page documentation

### Features
- **Branch Info**: Current branch, remote URL, last commit
- **File Stats**: Staged, modified, untracked, deleted counts
- **Changed Files**: List with visual indicators [S], [M], [U], [D]
- **Diff Preview**: Toggle-able preview of recent changes
- **Activity Log**: Last 5 commits with graph visualization
- **Sync Status**: Commits ahead/behind remote
- **Stash Count**: Number of stashed changes

### Technical
- Pure bash implementation (no dependencies)
- Works on Linux, macOS, and WSL
- Configurable refresh intervals
- Handles terminal resize gracefully
- Preserves terminal state on exit

### Author
- Gabriel Augusto Gonçalves ([@gaugustog](https://github.com/gaugustog))

[Unreleased]: https://github.com/gaugustog/git-monitor/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/gaugustog/git-monitor/releases/tag/v1.0.0
