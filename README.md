# 📊 Git Monitor

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/gaugustog/git-monitor/releases)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

A real-time Git repository monitor for your terminal - like `htop` for Git! Perfect for monitoring changes made by automated tools like Claude Code or tracking team activity.

![Git Monitor Demo](https://via.placeholder.com/800x400/0d1117/58a6ff?text=Git+Monitor+Demo)

## ✨ Features

- **Real-time monitoring** - Auto-refresh with configurable intervals
- **Comprehensive status** - Branch info, file changes, commits ahead/behind
- **Visual indicators** - Color-coded file status (staged, modified, untracked, deleted)
- **Diff preview** - See recent changes inline
- **Activity log** - Last 5 commits with graph
- **Interactive controls** - Keyboard shortcuts for navigation
- **Zero dependencies** - Pure bash, works everywhere
- **Flicker-free** - Smooth terminal updates

## 🚀 Quick Start

### One-line Install

```bash
curl -sSL https://raw.githubusercontent.com/gaugustog/git-monitor/main/install.sh | bash
```

Or with wget:

```bash
wget -qO- https://raw.githubusercontent.com/gaugustog/git-monitor/main/install.sh | bash
```

### Manual Install

```bash
# Clone the repository
git clone https://github.com/gaugustog/git-monitor.git
cd git-monitor

# Install
sudo cp git-monitor /usr/local/bin/
sudo chmod +x /usr/local/bin/git-monitor
```

## 📖 Usage

### Basic Usage

```bash
# Monitor current directory
git-monitor

# Monitor specific repository
git-monitor /path/to/repo

# Custom refresh interval (5 seconds)
git-monitor /path/to/repo 5
```

### Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `q` | Quit |
| `r` | Refresh immediately |
| `d` | Toggle diff preview |
| `+` | Increase refresh interval |
| `-` | Decrease refresh interval |

## 🎨 Display

### Information Shown

- **Branch Information**
  - Current branch name
  - Remote URL
  - Last commit message and time
  - Commits ahead/behind remote
  - Stash count

- **File Statistics**
  - Number of staged files
  - Number of modified files
  - Number of untracked files
  - Number of deleted files

- **Changed Files List**
  - `[S]` Staged files (green)
  - `[M]` Modified files (yellow)
  - `[U]` Untracked files (cyan)
  - `[D]` Deleted files (red)

- **Recent Activity**
  - Graph view of last 5 commits

## ⚙️ Configuration

Configuration file is located at `~/.config/git-monitor/config`:

```bash
# Default refresh interval in seconds
REFRESH_INTERVAL=2

# Show diff preview by default
SHOW_DIFF_PREVIEW=true

# Maximum number of diff lines to show
MAX_DIFF_LINES=5

# Maximum number of files to display
MAX_FILES=10
```

## 🛠️ Installation Options

### System-wide Install

```bash
sudo ./install.sh
```

### User Install

```bash
./install.sh --dir ~/bin
```

### Specific Version

```bash
./install.sh --version v1.0.0
```

## 📦 What's Included

```
git-monitor/
├── git-monitor           # Main script
├── install.sh           # Installer script
├── README.md           # This file
├── LICENSE            # MIT License
├── completions/       # Shell completions
│   ├── git-monitor.bash
│   └── git-monitor.zsh
└── man/              # Manual page
    └── git-monitor.1
```

## 🔧 Requirements

- Git
- Bash 4.0+
- Unix-like OS (Linux, macOS, WSL)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 🐛 Troubleshooting

### Terminal Shows Strange Characters

Your terminal might not support UTF-8. The script automatically falls back to ASCII characters.

### Keyboard Stops Working After Exit

Run `stty sane` or `reset` to restore terminal settings.

### Permission Denied

Make sure you have execute permissions:
```bash
chmod +x /usr/local/bin/git-monitor
```

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by `htop`, `tig`, and `watch`
- Built for developers using AI coding assistants
- Special thanks to the Git community

## 📊 Stats

![GitHub stars](https://img.shields.io/github/stars/gaugustog/git-monitor?style=social)
![GitHub forks](https://img.shields.io/github/forks/gaugustog/git-monitor?style=social)
![GitHub watchers](https://img.shields.io/github/watchers/gaugustog/git-monitor?style=social)

## 📮 Contact

- **Author**: Gabriel Augusto Gonçalves
- **Email**: gabri.augustog@gmail.com
- **GitHub**: [@gaugustog](https://github.com/gaugustog)

---

**Made with ❤️ for the developer community**
