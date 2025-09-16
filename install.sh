#!/bin/bash

# Ona Laravel Template Installer
# Downloads template files and sets up gitignore exclusions for existing Laravel projects
# Usage: curl -fsSL https://raw.githubusercontent.com/mehrancodes/ona-setup-laravel-template/main/install.sh | bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
TEMPLATE_REPO="https://github.com/mehrancodes/ona-setup-laravel-template"
TEMPLATE_BRANCH="main"
TEMP_DIR="/tmp/ona-template-$$"

# Template-managed directories (will be gitignored and pulled fresh)
TEMPLATE_DIRS=(".devcontainer" ".ona-notes" "scripts" ".gitpod")

# Files to copy to project root
ROOT_FILES=(".env.example")

echo -e "${BLUE}🚀 Ona Laravel Template Installer${NC}"
echo -e "${BLUE}====================================${NC}"

# Check if we're in a directory (not piped from curl)
if [ ! -t 0 ]; then
    echo -e "${YELLOW}⚠️  Running from curl pipe. Installing in current directory.${NC}"
fi

# Verify we're in a Laravel project or empty directory
if [ -f "composer.json" ]; then
    if grep -q "laravel/framework" composer.json; then
        echo -e "${GREEN}✅ Laravel project detected${NC}"
    else
        echo -e "${YELLOW}⚠️  composer.json found but doesn't appear to be Laravel${NC}"
        echo -e "${YELLOW}   Continuing anyway...${NC}"
    fi
elif [ "$(ls -A . 2>/dev/null | wc -l)" -eq 0 ]; then
    echo -e "${GREEN}✅ Empty directory - ready for new Laravel project${NC}"
else
    echo -e "${YELLOW}⚠️  Not a Laravel project and directory not empty${NC}"
    echo -e "${YELLOW}   Template files will be added to current directory${NC}"
fi

echo ""
echo -e "${BLUE}📥 Downloading template files...${NC}"

# Store original directory
ORIGINAL_DIR=$(pwd)

# Create temporary directory
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Download template repository
echo "Cloning template repository..."
git clone --depth 1 --branch "$TEMPLATE_BRANCH" "$TEMPLATE_REPO" template

# Go back to original directory
cd "$ORIGINAL_DIR"

echo -e "${GREEN}✅ Template downloaded${NC}"
echo ""

echo -e "${BLUE}📁 Installing template files...${NC}"

# Copy template-managed directories
for dir in "${TEMPLATE_DIRS[@]}"; do
    if [ -d "$TEMP_DIR/template/$dir" ]; then
        echo "Installing $dir/"
        rm -rf "$dir"
        cp -r "$TEMP_DIR/template/$dir" .
    fi
done

# Copy root files if they don't exist
for file in "${ROOT_FILES[@]}"; do
    if [ -f "$TEMP_DIR/template/$file" ] && [ ! -f "$file" ]; then
        echo "Installing $file"
        cp "$TEMP_DIR/template/$file" .
    fi
done

# Copy sync script to project root
if [ -f "$TEMP_DIR/template/scripts/sync-ona-template.sh" ]; then
    echo "Installing sync-ona-template.sh"
    cp "$TEMP_DIR/template/scripts/sync-ona-template.sh" .
    chmod +x sync-ona-template.sh
else
    echo "Warning: sync-ona-template.sh not found in template"
fi

echo -e "${GREEN}✅ Template files installed${NC}"
echo ""

echo -e "${BLUE}📝 Updating .gitignore...${NC}"

# Create or update .gitignore
if [ ! -f ".gitignore" ]; then
    echo "Creating .gitignore"
    touch .gitignore
fi

# Add template-managed directories to .gitignore
{
    echo ""
    echo "# Ona Template - Managed files (pulled fresh from template)"
    echo "# These directories are managed by the Ona template and should not be committed"
    for dir in "${TEMPLATE_DIRS[@]}"; do
        # Check if already in gitignore
        if ! grep -q "^$dir/$" .gitignore 2>/dev/null; then
            echo "$dir/"
        fi
    done
    echo ""
    echo "# Ona Template - Local sync script (keep in repository)"
    echo "# This script should be committed to allow easy template updates"
    if ! grep -q "^!sync-ona-template.sh$" .gitignore 2>/dev/null; then
        echo "!sync-ona-template.sh"
    fi
} >> .gitignore

echo -e "${GREEN}✅ .gitignore updated${NC}"
echo ""

# Clean up
rm -rf "$TEMP_DIR"

echo -e "${GREEN}🎉 Installation complete!${NC}"
echo ""
echo -e "${BLUE}📋 What was installed:${NC}"
for dir in "${TEMPLATE_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "  ✅ $dir/ (template-managed, gitignored)"
    fi
done
if [ -f "sync-ona-template.sh" ]; then
    echo "  ✅ sync-ona-template.sh (for future updates)"
fi
echo ""

echo -e "${BLUE}🔄 To update template files in the future:${NC}"
echo "  ./sync-ona-template.sh"
echo ""

echo -e "${BLUE}📚 Next steps:${NC}"
if [ ! -f "composer.json" ]; then
    echo "  1. Create a new Laravel project:"
    echo "     composer create-project laravel/laravel ."
    echo "  2. Run the setup script:"
    echo "     ./scripts/setup.sh"
else
    echo "  1. Run the setup script to configure your environment:"
    echo "     ./scripts/setup.sh"
    echo "  2. Start development:"
    echo "     ./scripts/dev"
fi
echo ""

echo -e "${GREEN}Happy coding with Ona! 🤖✨${NC}"