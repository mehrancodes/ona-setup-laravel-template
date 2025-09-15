#!/bin/bash

# Ona Laravel Setup Template Installer
# Downloads and sets up the Ona Laravel template in a new project

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}✅${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ️${NC} $1"
}

print_header() {
    echo -e "${PURPLE}🎯 $1${NC}"
    echo "$(printf '=%.0s' {1..50})"
}

# Show banner
echo -e "${PURPLE}"
echo "  ___             "
echo " / _ \ _ __   __ _ "
echo "| | | | '_ \ / _\` |"
echo "| |_| | | | | (_| |"
echo " \___/|_| |_|\__,_|"
echo -e "${NC}"
echo "🤖 Ona Laravel Template Installer"
echo "================================="
echo ""

# Configuration
REPO_URL="https://github.com/your-username/your-repo"
TEMPLATE_URL="$REPO_URL/archive/main.tar.gz"
TEMPLATE_DIR="ona-setup-template"

# Get project name
if [ -z "$1" ]; then
    echo "Enter project name:"
    read -r PROJECT_NAME
    if [ -z "$PROJECT_NAME" ]; then
        print_error "Project name is required"
        exit 1
    fi
else
    PROJECT_NAME="$1"
fi

print_header "Installing Ona Laravel Template"
print_info "Project name: $PROJECT_NAME"

# Check if directory already exists
if [ -d "$PROJECT_NAME" ]; then
    print_error "Directory '$PROJECT_NAME' already exists"
    exit 1
fi

# Create project directory
print_info "Creating project directory..."
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Download template
print_info "Downloading template..."
if command -v curl &> /dev/null; then
    curl -fsSL "$TEMPLATE_URL" | tar -xz --strip-components=1
elif command -v wget &> /dev/null; then
    wget -qO- "$TEMPLATE_URL" | tar -xz --strip-components=1
else
    print_error "Neither curl nor wget is available"
    exit 1
fi

# Extract only the template directory
if [ -d "$TEMPLATE_DIR" ]; then
    # Move template files to root
    mv "$TEMPLATE_DIR"/* .
    mv "$TEMPLATE_DIR"/.* . 2>/dev/null || true
    rmdir "$TEMPLATE_DIR"
fi

print_status "Template downloaded"

# Make scripts executable
print_info "Setting up permissions..."
chmod +x setup.sh
chmod +x .devcontainer/setup.sh
find scripts -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

print_status "Permissions set"

# Initialize Git repository
print_info "Initializing Git repository..."
git init
git add .
git commit -m "feat: initial commit with Ona Laravel template

- Add comprehensive development environment setup
- Include Filament, Livewire, and Pest integration
- Configure Vite with Vue.js and Tailwind CSS
- Set up development container with PHP 8.3 and Node.js 20
- Add Ona AI agent integration files and guidelines

Co-authored-by: Ona <no-reply@ona.com>"

print_status "Git repository initialized"

# Run setup
print_header "Running Project Setup"
./setup.sh "$PROJECT_NAME"

print_header "🎉 Installation Complete!"
echo ""
echo "Your Ona Laravel project '$PROJECT_NAME' is ready!"
echo ""
echo "📁 Location: $(pwd)"
echo "🌐 Laravel: http://localhost:8000"
echo "⚡ Vite: http://localhost:3000"
echo ""
echo "To get started:"
echo "  cd $PROJECT_NAME"
echo "  ./dev"
echo ""
echo "Happy coding with Ona! 🤖✨"