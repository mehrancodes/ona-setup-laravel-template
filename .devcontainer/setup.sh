#!/bin/bash

# Ona Laravel Development Container Setup Script
# Runs after the container is created to set up the development environment

set -e

echo "🚀 Setting up Ona Laravel development environment..."

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

# Update package lists
print_header "Updating System Packages"
sudo apt-get update -qq

# Set up proper permissions
print_header "Setting Up Permissions"
sudo chown -R vscode:vscode /workspaces
sudo chown -R vscode:vscode /home/vscode

# Configure Git for the container
print_header "Configuring Git"
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global core.autocrlf input
git config --global core.editor "code --wait"
git config --global merge.tool "vscode"
git config --global mergetool.vscode.cmd "code --wait \$MERGED"
git config --global diff.tool "vscode"
git config --global difftool.vscode.cmd "code --wait --diff \$LOCAL \$REMOTE"

# Set up user info (will be overridden by actual user)
git config --global user.name "Ona Developer"
git config --global user.email "developer@ona.dev"

print_status "Git configured successfully"

# Update Composer
print_header "Updating Composer"
composer self-update --quiet
print_status "Composer updated"

# Update npm packages
print_header "Updating Node.js Packages"
npm update -g --silent
print_status "Node.js packages updated"

# Set up Laravel installer
print_header "Setting Up Laravel Tools"
if ! command -v laravel &> /dev/null; then
    composer global require laravel/installer --quiet
fi
print_status "Laravel installer ready"

# Set up PHP CS Fixer
if ! command -v php-cs-fixer &> /dev/null; then
    composer global require friendsofphp/php-cs-fixer --quiet
fi
print_status "PHP CS Fixer ready"

# Set up PHPStan
if ! command -v phpstan &> /dev/null; then
    composer global require phpstan/phpstan --quiet
fi
print_status "PHPStan ready"

# Create common directories
print_header "Creating Development Directories"
mkdir -p /home/vscode/.config
mkdir -p /home/vscode/.local/bin
mkdir -p /home/vscode/.cache
mkdir -p /home/vscode/.composer
mkdir -p /workspaces/.tmp
mkdir -p /workspaces/.logs

print_status "Development directories created"

# Set up shell aliases and functions
print_header "Setting Up Shell Environment"
cat >> /home/vscode/.bashrc << 'EOF'

# Ona Laravel Development Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Laravel aliases
alias art='php artisan'
alias tinker='php artisan tinker'
alias serve='php artisan serve --host=0.0.0.0'
alias migrate='php artisan migrate'
alias fresh='php artisan migrate:fresh --seed'
alias rollback='php artisan migrate:rollback'
alias seed='php artisan db:seed'

# Composer aliases
alias ci='composer install'
alias cu='composer update'
alias cr='composer require'
alias cda='composer dump-autoload'

# Node.js aliases
alias ni='npm install'
alias nr='npm run'
alias nrd='npm run dev'
alias nrb='npm run build'
alias nrt='npm run test'

# Testing aliases
alias test='php artisan test'
alias pest='./vendor/bin/pest'
alias phpunit='./vendor/bin/phpunit'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias gm='git merge'

# Development functions
ona-init() {
    echo "🚀 Initializing new Laravel project with Ona setup..."
    if [ -z "$1" ]; then
        echo "Usage: ona-init <project-name>"
        return 1
    fi
    
    laravel new "$1" --git --pest
    cd "$1"
    
    # Copy Ona setup files if they exist
    if [ -d "../ona-setup-template" ]; then
        cp -r ../ona-setup-template/.ona-notes .
        cp -r ../ona-setup-template/scripts .
        cp ../ona-setup-template/dev .
        cp ../ona-setup-template/server .
        cp ../ona-setup-template/secrets .
        chmod +x dev server secrets scripts/*.sh
        echo "✅ Ona setup files copied"
    fi
    
    echo "✅ Laravel project '$1' created with Ona integration"
}

ona-serve() {
    echo "🚀 Starting Laravel development server..."
    php artisan serve --host=0.0.0.0 --port=8000 &
    
    if [ -f "package.json" ] && grep -q "vite" package.json; then
        echo "🚀 Starting Vite development server..."
        npm run dev &
    fi
    
    echo "✅ Development servers started"
    echo "📱 Laravel: http://localhost:8000"
    echo "⚡ Vite: http://localhost:3000"
}

ona-stop() {
    echo "🛑 Stopping development servers..."
    pkill -f "php artisan serve" || true
    pkill -f "vite" || true
    pkill -f "npm run dev" || true
    echo "✅ Development servers stopped"
}

ona-fresh() {
    echo "🔄 Refreshing Laravel application..."
    php artisan migrate:fresh --seed
    php artisan cache:clear
    php artisan config:clear
    php artisan route:clear
    php artisan view:clear
    echo "✅ Application refreshed"
}

ona-test() {
    echo "🧪 Running test suite..."
    if [ -f "./vendor/bin/pest" ]; then
        ./vendor/bin/pest
    else
        php artisan test
    fi
}

ona-build() {
    echo "🏗️ Building for production..."
    composer install --optimize-autoloader --no-dev
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache
    
    if [ -f "package.json" ]; then
        npm ci --only=production
        npm run build
    fi
    
    echo "✅ Production build complete"
}

# Show Ona welcome message
ona-welcome() {
    echo -e "${PURPLE}"
    echo "  ___             "
    echo " / _ \ _ __   __ _ "
    echo "| | | | '_ \ / _\` |"
    echo "| |_| | | | | (_| |"
    echo " \___/|_| |_|\__,_|"
    echo -e "${NC}"
    echo "🤖 Ona Laravel Development Environment"
    echo "======================================"
    echo ""
    echo "Available commands:"
    echo "  ona-init <name>  - Create new Laravel project"
    echo "  ona-serve        - Start development servers"
    echo "  ona-stop         - Stop development servers"
    echo "  ona-fresh        - Refresh application state"
    echo "  ona-test         - Run test suite"
    echo "  ona-build        - Build for production"
    echo ""
    echo "Laravel aliases: art, tinker, serve, migrate, fresh, test"
    echo "Composer aliases: ci, cu, cr, cda"
    echo "Node.js aliases: ni, nr, nrd, nrb, nrt"
    echo ""
    echo "Happy coding! 🚀"
}

EOF

print_status "Shell environment configured"

# Set up VS Code settings directory
print_header "Setting Up VS Code"
mkdir -p /home/vscode/.vscode
mkdir -p /home/vscode/.config/Code/User

# Create a basic settings file
cat > /home/vscode/.config/Code/User/settings.json << 'EOF'
{
  "editor.fontSize": 14,
  "editor.fontFamily": "'Fira Code', 'Cascadia Code', 'JetBrains Mono', Consolas, monospace",
  "editor.fontLigatures": true,
  "editor.formatOnSave": true,
  "php.validate.enable": true,
  "php.suggest.basic": false,
  "files.associations": {
    "*.blade.php": "blade"
  },
  "emmet.includeLanguages": {
    "blade": "html"
  }
}
EOF

print_status "VS Code configured"

# Set up log rotation
print_header "Setting Up Logging"
sudo mkdir -p /var/log/laravel
sudo chown -R vscode:vscode /var/log/laravel

# Create logrotate configuration
sudo tee /etc/logrotate.d/laravel > /dev/null << 'EOF'
/var/log/laravel/*.log {
    daily
    missingok
    rotate 14
    compress
    notifempty
    create 0644 vscode vscode
    postrotate
        /bin/kill -USR1 $(cat /var/run/supervisord.pid 2>/dev/null) 2>/dev/null || true
    endscript
}
EOF

print_status "Logging configured"

# Set up cron for Laravel scheduler (if needed)
print_header "Setting Up Cron"
(crontab -l 2>/dev/null; echo "# Laravel Scheduler (uncomment when needed)") | crontab -
(crontab -l 2>/dev/null; echo "# * * * * * cd /workspaces/your-project && php artisan schedule:run >> /dev/null 2>&1") | crontab -

print_status "Cron configured"

# Create health check endpoint script
print_header "Setting Up Health Check"
mkdir -p /home/vscode/.local/bin
cat > /home/vscode/.local/bin/health-check << 'EOF'
#!/bin/bash
# Simple health check for the development environment

echo "🏥 Ona Development Environment Health Check"
echo "=========================================="

# Check PHP
if command -v php &> /dev/null; then
    echo "✅ PHP $(php -r 'echo PHP_VERSION;')"
else
    echo "❌ PHP not found"
fi

# Check Composer
if command -v composer &> /dev/null; then
    echo "✅ Composer $(composer --version --no-ansi | cut -d' ' -f3)"
else
    echo "❌ Composer not found"
fi

# Check Node.js
if command -v node &> /dev/null; then
    echo "✅ Node.js $(node --version)"
else
    echo "❌ Node.js not found"
fi

# Check npm
if command -v npm &> /dev/null; then
    echo "✅ npm $(npm --version)"
else
    echo "❌ npm not found"
fi

# Check Laravel installer
if command -v laravel &> /dev/null; then
    echo "✅ Laravel installer available"
else
    echo "⚠️  Laravel installer not found"
fi

# Check database connectivity (if configured)
if [ -f ".env" ] && grep -q "DB_CONNECTION" .env; then
    DB_CONNECTION=$(grep "DB_CONNECTION" .env | cut -d'=' -f2)
    echo "📊 Database: $DB_CONNECTION configured"
fi

echo ""
echo "🎯 Environment ready for Ona development!"
EOF

chmod +x /home/vscode/.local/bin/health-check
print_status "Health check script created"

# Set proper ownership
sudo chown -R vscode:vscode /home/vscode

# Final setup
print_header "Final Setup"
print_info "Installing final dependencies..."

# Ensure all global packages are available
export PATH="/home/vscode/.composer/vendor/bin:$PATH"

print_status "Container setup completed successfully!"

# Show welcome message
print_header "Welcome to Ona Laravel Development!"
echo ""
echo "🎉 Your development environment is ready!"
echo ""
echo "Next steps:"
echo "1. Run 'ona-welcome' to see available commands"
echo "2. Use 'ona-init <project-name>' to create a new Laravel project"
echo "3. Or navigate to your existing project and run './setup.sh'"
echo ""
echo "Happy coding with Ona! 🤖✨"