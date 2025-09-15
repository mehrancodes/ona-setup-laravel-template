# Ona Laravel + Frontend Setup Template

A comprehensive template for setting up Laravel + Vue.js/React projects with Ona AI agent integration in Gitpod environments.

## 🚀 Quick Start

```bash
# Clone this template to your new project
curl -fsSL https://raw.githubusercontent.com/your-username/your-repo/main/ona-setup-template/install.sh | bash

# Or manually copy the template
cp -r ona-setup-template/* your-new-project/
cd your-new-project
./setup.sh
```

## 📁 What's Included

### Development Container
- **Dockerfile** - Optimized for Laravel + Node.js development
- **devcontainer.json** - Complete VS Code dev container configuration
- **setup.sh** - Automated environment setup script

### Helper Scripts
- **setup.sh** - Main project setup script
- **dev** - Start development servers (Laravel + Vite)
- **server** - Production server management
- **secrets** - Secret management utilities
- **scripts/** - Comprehensive development utilities

### Ona Integration
- **ona-notes/** - Ona agent guidelines and project context
- **dotfiles/** - Development environment dotfiles (optional)
- **SETUP.md** - Detailed setup instructions

### Configuration Files
- **.env.example** - Environment template with all necessary variables
- **.gitignore** - Comprehensive ignore patterns
- **package.json** - Frontend dependencies template
- **composer.json** - Backend dependencies template

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

### 1. Create New Project

```bash
# Using the installer
curl -fsSL https://raw.githubusercontent.com/your-username/your-repo/main/ona-setup-template/install.sh | bash -s -- my-new-project

# Or manually
mkdir my-new-project
cd my-new-project
curl -fsSL https://raw.githubusercontent.com/your-username/your-repo/main/ona-setup-template/template.tar.gz | tar -xz
```

### 2. Initialize Project

```bash
./setup.sh
```

This will:
- Install Laravel with optimized configuration
- Set up frontend tooling (Vue.js/React)
- Configure database and environment
- Install development dependencies
- Set up Git hooks and formatting

### 3. Start Development

```bash
./dev          # Start all development servers
./server       # Production server management
./secrets      # Manage environment secrets
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
ona-setup-template/
├── .devcontainer/          # Development container config
├── .ona-notes/             # Ona agent guidelines
├── scripts/                # Development utilities
├── templates/              # File templates
├── install.sh              # Template installer
├── setup.sh                # Project setup script
├── dev                     # Development server script
├── server                  # Production server script
├── secrets                 # Secret management script
└── README.md               # This file
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with a new project
5. Submit a pull request

## 📄 License

This template is open source and available under the [MIT License](LICENSE).

---

**Happy coding with Ona! 🤖✨**