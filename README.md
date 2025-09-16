# Ona Laravel + Frontend Setup Template

A comprehensive template for setting up Laravel + Vue.js/React projects with Ona AI agent integration in Gitpod environments.

## 🚀 Quick Start

### For Existing Laravel Projects

```bash
# One-command installation - downloads template files and sets up gitignore exclusions
curl -fsSL https://raw.githubusercontent.com/mehrancodes/ona-setup-laravel-template/main/install.sh | bash

# Then run setup to configure your environment
./scripts/setup.sh
```

### For New Projects

```bash
# Create new directory and install template
mkdir my-new-project && cd my-new-project
curl -fsSL https://raw.githubusercontent.com/mehrancodes/ona-setup-laravel-template/main/install.sh | bash

# Create Laravel project
composer create-project laravel/laravel .

# Run setup
./scripts/setup.sh
```

### Keep Template Updated

```bash
# Sync latest template improvements (run anytime)
./sync-ona-template.sh
```

## 📁 What's Included

### Template-Managed Files (Auto-Updated)
These files are managed by the template and pulled fresh on each sync:

- **.devcontainer/** - VS Code dev container configuration
  - Optimized Dockerfile for Laravel + Node.js development
  - Complete devcontainer.json with extensions and settings
- **.ona-notes/** - Ona AI agent guidelines and project context
- **scripts/** - Comprehensive development utilities
  - `setup.sh` - Main project setup script
  - `dev` - Start development servers (Laravel + Vite)
  - `build.sh` - Production build script
  - `test.sh` - Testing utilities
  - `deploy.sh` - Deployment helpers
- **.gitpod/** - Gitpod automation configuration (if present)

### Project Files (Preserved)
These files stay in your project repository:

- **sync-ona-template.sh** - Script to update template files
- **.env.example** - Environment template (merged on updates)
- **.gitignore** - Updated to exclude template-managed files
- **composer.json** - Your Laravel dependencies
- **package.json** - Your frontend dependencies
- All your actual project code

## 🛠 Features

### Development Environment
- **PHP 8.3** with all necessary extensions
- **Node.js 20** with npm/yarn support
- **MySQL/PostgreSQL** database support
- **Redis** for caching and sessions
- **Vite** for modern frontend tooling

### Laravel Optimizations
- **Filament** admin panel ready
- **Livewire** for dynamic interfaces
- **Pest** testing framework
- **Laravel Horizon** for queue management
- **Laravel Telescope** for debugging

### Frontend Support
- **Vue.js 3** with Composition API
- **React 18** with hooks support
- **Tailwind CSS** for styling
- **TypeScript** support
- **Hot module replacement**

### Development Tools
- **VS Code** optimized settings
- **PHP CS Fixer** for code formatting
- **ESLint/Prettier** for JavaScript
- **PHPStan** for static analysis
- **Git hooks** for code quality

## 📋 Usage

### 1. Install Template

**For existing Laravel projects:**
```bash
# Install template files
curl -fsSL https://raw.githubusercontent.com/mehrancodes/ona-setup-laravel-template/main/install.sh | bash
```

**For new projects:**
```bash
# Create project directory
mkdir my-new-project && cd my-new-project

# Install template
curl -fsSL https://raw.githubusercontent.com/mehrancodes/ona-setup-laravel-template/main/install.sh | bash

# Create Laravel project
composer create-project laravel/laravel .
```

### 2. Initialize Environment

```bash
./scripts/setup.sh
```

This will:
- Install Laravel with optimized configuration
- Set up frontend tooling (Vue.js/React)
- Configure database and environment
- Install development dependencies
- Set up Git hooks and formatting

### 3. Start Development

```bash
./scripts/dev          # Start all development servers
./scripts/build.sh     # Production build
./scripts/test.sh      # Run tests
```

### 4. Keep Template Updated

```bash
# Sync latest template improvements
./sync-ona-template.sh

# With options
./sync-ona-template.sh --verbose    # Show detailed output
./sync-ona-template.sh --force      # Force update even if no changes
```

## 🔧 Customization

### Environment Variables
Edit `.env.example` to include your project-specific variables:

```env
APP_NAME="Your Project Name"
APP_URL=https://your-project.gitpod.io

# Database
DB_CONNECTION=mysql
DB_DATABASE=your_project

# Frontend
VITE_APP_NAME="${APP_NAME}"
```

### Package Dependencies
Modify the template files:
- `composer-template.json` - PHP dependencies
- `package-template.json` - Node.js dependencies

### Development Container
Customize `.devcontainer/`:
- `Dockerfile` - Add system dependencies
- `devcontainer.json` - VS Code extensions and settings
- `setup.sh` - Additional setup steps

## 📚 Documentation

- **[SETUP.md](SETUP.md)** - Detailed setup instructions
- **[SCRIPT_ORGANIZATION.md](SCRIPT_ORGANIZATION.md)** - Script documentation
- **[SECRET_MANAGEMENT.md](SECRET_MANAGEMENT.md)** - Security guidelines
- **[ona-notes/](ona-notes/)** - Ona agent integration guide

## 🤖 Ona Integration

This template is optimized for Ona AI agent development:

### Project Context
- Automatic project context generation
- Code organization guidelines
- Development workflow documentation

### Agent Guidelines
- Commit message conventions
- Code review standards
- Testing requirements

### Environment Setup
- Consistent development environment
- Automated dependency management
- Pre-configured tooling

## 🧪 Testing

The template includes comprehensive testing setup:

```bash
# PHP tests with Pest
./vendor/bin/pest

# JavaScript tests
npm test

# Full test suite
./scripts/test.sh
```

## 🚀 Deployment

Production deployment helpers:

```bash
# Build for production
./scripts/build.sh

# Deploy to staging
./scripts/deploy.sh staging

# Deploy to production
./scripts/deploy.sh production
```

## 📦 Template Structure

```
ona-setup-laravel-template/
├── .devcontainer/              # Development container config (template-managed)
├── .ona-notes/                 # Ona agent guidelines (template-managed)
├── scripts/                    # Development utilities (template-managed)
│   ├── setup.sh               # Project setup script
│   ├── dev                    # Development server script
│   ├── build.sh               # Production build script
│   ├── test.sh                # Testing utilities
│   ├── deploy.sh              # Deployment helpers
│   └── sync-ona-template.sh   # Template sync script
├── .gitpod/                   # Gitpod automation (template-managed)
├── install.sh                 # One-command installer
├── .env.example               # Environment template
├── .gitignore                 # Git ignore patterns
└── README.md                  # This file
```

### Template-Managed vs Project Files

**Template-Managed (Gitignored & Auto-Updated):**
- `.devcontainer/` - Development environment
- `.ona-notes/` - AI agent guidelines  
- `scripts/` - Development automation
- `.gitpod/` - Gitpod configuration

**Project Files (Committed to Your Repo):**
- `sync-ona-template.sh` - Update script
- `.env.example` - Environment template
- `.gitignore` - Updated with exclusions
- All your Laravel application code

## 🔄 Template Update System

This template uses an innovative approach to keep your development environment up-to-date:

### How It Works

1. **Template-managed files** are gitignored and pulled fresh from the template
2. **Project files** remain in your repository and are preserved
3. **Automatic merging** handles configuration files intelligently
4. **Backup system** ensures you never lose customizations

### Benefits

- ✅ Always get latest template improvements
- ✅ No merge conflicts with template files
- ✅ Cleaner project repositories
- ✅ Consistent development environments across projects
- ✅ Easy template updates with one command

### Update Process

```bash
# Simple one-command update
./sync-ona-template.sh

# What happens:
# 1. Downloads latest template
# 2. Creates backup of current files
# 3. Updates template-managed directories
# 4. Merges configuration files intelligently
# 5. Provides detailed change report
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with both new and existing Laravel projects
5. Submit a pull request

## 📄 License

This template is open source and available under the [MIT License](LICENSE).

---

**Happy coding with Ona! 🤖✨**