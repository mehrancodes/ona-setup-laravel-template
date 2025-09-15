#!/bin/bash

# Ona Laravel Project Setup Script
# Initializes a new Laravel project with Ona integration

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

# Show Ona banner
echo -e "${PURPLE}"
echo "  ___             "
echo " / _ \ _ __   __ _ "
echo "| | | | '_ \ / _\` |"
echo "| |_| | | | | (_| |"
echo " \___/|_| |_|\__,_|"
echo -e "${NC}"
echo "🤖 Ona Laravel Project Setup"
echo "============================="
echo ""

# Check if we're in a Laravel project
if [ ! -f "composer.json" ]; then
    print_header "Creating New Laravel Project"
    
    # Get project name
    if [ -z "$1" ]; then
        echo "Enter project name (or press Enter for 'ona-laravel-project'):"
        read -r PROJECT_NAME
        PROJECT_NAME=${PROJECT_NAME:-ona-laravel-project}
    else
        PROJECT_NAME="$1"
    fi
    
    print_info "Creating Laravel project: $PROJECT_NAME"
    
    # Create Laravel project
    composer create-project laravel/laravel "$PROJECT_NAME" --prefer-dist
    cd "$PROJECT_NAME"
    
    print_status "Laravel project created"
else
    print_info "Existing Laravel project detected"
    PROJECT_NAME=$(basename "$(pwd)")
fi

# Install additional Laravel packages
print_header "Installing Laravel Packages"

# Core packages
print_info "Installing Filament..."
composer require filament/filament --quiet

print_info "Installing Livewire..."
composer require livewire/livewire --quiet

print_info "Installing Pest for testing..."
composer require pestphp/pest --dev --with-all-dependencies --quiet
composer require pestphp/pest-plugin-laravel --dev --quiet

print_info "Installing Laravel Horizon..."
composer require laravel/horizon --quiet

print_info "Installing Laravel Telescope..."
composer require laravel/telescope --dev --quiet

print_info "Installing additional utilities..."
composer require spatie/laravel-permission --quiet
composer require spatie/laravel-activitylog --quiet
composer require barryvdh/laravel-debugbar --dev --quiet

print_status "Laravel packages installed"

# Set up frontend
print_header "Setting Up Frontend"

if [ ! -f "package.json" ]; then
    print_info "Initializing package.json..."
    npm init -y
fi

print_info "Installing Vite and frontend dependencies..."
npm install --save-dev vite laravel-vite-plugin
npm install --save-dev @vitejs/plugin-vue vue@next
npm install --save-dev tailwindcss @tailwindcss/forms @tailwindcss/typography
npm install --save-dev autoprefixer postcss
npm install --save-dev axios

# Create Vite config
print_info "Creating Vite configuration..."
cat > vite.config.js << 'EOF'
import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import vue from '@vitejs/plugin-vue';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
            refresh: true,
        }),
        vue({
            template: {
                transformAssetUrls: {
                    base: null,
                    includeAbsolute: false,
                },
            },
        }),
    ],
    server: {
        host: '0.0.0.0',
        port: 3000,
        hmr: {
            host: 'localhost',
        },
    },
});
EOF

# Create Tailwind config
print_info "Creating Tailwind configuration..."
npx tailwindcss init -p

cat > tailwind.config.js << 'EOF'
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./resources/**/*.blade.php",
    "./resources/**/*.js",
    "./resources/**/*.vue",
    "./app/Filament/**/*.php",
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
  ],
}
EOF

# Update CSS
print_info "Setting up CSS..."
cat > resources/css/app.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

/* Custom styles */
.ona-container {
    @apply max-w-7xl mx-auto px-4 sm:px-6 lg:px-8;
}

.ona-card {
    @apply bg-white overflow-hidden shadow rounded-lg;
}

.ona-button {
    @apply inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500;
}
EOF

# Update JS
print_info "Setting up JavaScript..."
cat > resources/js/app.js << 'EOF'
import './bootstrap';
import { createApp } from 'vue';

// Import CSS
import '../css/app.css';

// Create Vue app
const app = createApp({});

// Mount the app
app.mount('#app');

// Ona development helpers
window.Ona = {
    version: '1.0.0',
    debug: true,
    log: (message, data = null) => {
        if (window.Ona.debug) {
            console.log(`[Ona] ${message}`, data);
        }
    }
};

window.Ona.log('Ona Laravel application initialized');
EOF

print_status "Frontend setup completed"

# Set up environment
print_header "Setting Up Environment"

if [ ! -f ".env" ]; then
    print_info "Creating .env file..."
    cp .env.example .env
    php artisan key:generate
fi

# Update .env with development settings
print_info "Configuring environment variables..."
sed -i 's/APP_NAME=Laravel/APP_NAME="'$PROJECT_NAME'"/' .env
sed -i 's/APP_ENV=local/APP_ENV=local/' .env
sed -i 's/APP_DEBUG=true/APP_DEBUG=true/' .env
sed -i 's/LOG_CHANNEL=stack/LOG_CHANNEL=stack/' .env

# Database configuration
if ! grep -q "DB_CONNECTION=sqlite" .env; then
    print_info "Setting up SQLite database..."
    sed -i 's/DB_CONNECTION=mysql/DB_CONNECTION=sqlite/' .env
    sed -i 's/DB_HOST=127.0.0.1/#DB_HOST=127.0.0.1/' .env
    sed -i 's/DB_PORT=3306/#DB_PORT=3306/' .env
    sed -i 's/DB_DATABASE=laravel/#DB_DATABASE=laravel/' .env
    sed -i 's/DB_USERNAME=root/#DB_USERNAME=root/' .env
    sed -i 's/DB_PASSWORD=/#DB_PASSWORD=/' .env
    echo "DB_DATABASE=database/database.sqlite" >> .env
fi

# Create SQLite database
if [ ! -f "database/database.sqlite" ]; then
    print_info "Creating SQLite database..."
    touch database/database.sqlite
fi

print_status "Environment configured"

# Run migrations
print_header "Setting Up Database"
print_info "Running migrations..."
php artisan migrate --force

print_info "Publishing Filament assets..."
php artisan filament:install --panels

print_info "Publishing Horizon assets..."
php artisan horizon:install

print_info "Publishing Telescope assets..."
php artisan telescope:install
php artisan migrate --force

print_status "Database setup completed"

# Set up Ona integration files
print_header "Setting Up Ona Integration"

# Create .ona-notes directory
mkdir -p .ona-notes

# Create project context
cat > .ona-notes/PROJECT_CONTEXT.md << EOF
# $PROJECT_NAME - Project Context

## Project Overview
- **Name**: $PROJECT_NAME
- **Type**: Laravel + Vue.js Application
- **Created**: $(date)
- **Environment**: Development

## Technology Stack
- **Backend**: Laravel 10.x with PHP 8.3
- **Frontend**: Vue.js 3 with Vite
- **Database**: SQLite (development)
- **Styling**: Tailwind CSS
- **Admin Panel**: Filament
- **Testing**: Pest
- **Queue**: Laravel Horizon
- **Debugging**: Laravel Telescope

## Key Features
- Modern Laravel application structure
- Vue.js 3 with Composition API
- Tailwind CSS for styling
- Filament admin panel
- Comprehensive testing setup
- Development tooling integration

## Development Workflow
1. Use \`./dev\` to start development servers
2. Use \`./server\` for production server management
3. Use \`./secrets\` for environment management
4. Follow conventional commit messages
5. Write tests for new features

## Ona Integration
This project is optimized for Ona AI agent development with:
- Consistent code organization
- Automated testing setup
- Development environment standardization
- Clear documentation structure
EOF

# Create commit guidelines
cat > .ona-notes/COMMIT_GUIDELINES.md << 'EOF'
# Commit Guidelines for Ona Development

## Conventional Commits Format

Use the following format for all commits:
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Types
- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that do not affect the meaning of the code
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **perf**: A code change that improves performance
- **test**: Adding missing tests or correcting existing tests
- **chore**: Changes to the build process or auxiliary tools

## Examples
```
feat: add user authentication system
fix(auth): resolve login redirect issue
docs: update API documentation
style: format code with prettier
refactor(user): simplify user model
test: add unit tests for user service
chore: update dependencies
```

## Co-authoring with Ona
Always include Ona as co-author:
```
feat: implement user dashboard

Co-authored-by: Ona <no-reply@ona.com>
```
EOF

# Create README
cat > .ona-notes/README.md << 'EOF'
# Ona Integration Notes

This directory contains Ona AI agent integration files and guidelines.

## Files
- **PROJECT_CONTEXT.md** - Project overview and context for Ona
- **COMMIT_GUIDELINES.md** - Commit message conventions
- **DEVELOPMENT_NOTES.md** - Development workflow notes

## Usage
These files help Ona understand the project structure, conventions, and development workflow. Keep them updated as the project evolves.

## Guidelines
1. Update PROJECT_CONTEXT.md when adding major features
2. Follow COMMIT_GUIDELINES.md for all commits
3. Document important decisions and patterns
4. Keep notes concise but comprehensive
EOF

print_status "Ona integration files created"

# Create helper scripts
print_header "Creating Helper Scripts"

# Create dev script
cat > dev << 'EOF'
#!/bin/bash
# Development server starter script

echo "🚀 Starting development servers..."

# Start Laravel server
echo "📱 Starting Laravel server on http://localhost:8000"
php artisan serve --host=0.0.0.0 --port=8000 &
LARAVEL_PID=$!

# Start Vite dev server
if [ -f "package.json" ] && grep -q "vite" package.json; then
    echo "⚡ Starting Vite dev server on http://localhost:3000"
    npm run dev &
    VITE_PID=$!
fi

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "🛑 Stopping development servers..."
    kill $LARAVEL_PID 2>/dev/null || true
    kill $VITE_PID 2>/dev/null || true
    exit 0
}

# Set trap to cleanup on script exit
trap cleanup SIGINT SIGTERM

echo ""
echo "✅ Development servers started!"
echo "📱 Laravel: http://localhost:8000"
echo "⚡ Vite: http://localhost:3000"
echo ""
echo "Press Ctrl+C to stop all servers"

# Wait for background processes
wait
EOF

# Create server script
cat > server << 'EOF'
#!/bin/bash
# Production server management script

case "$1" in
    start)
        echo "🚀 Starting production server..."
        php artisan config:cache
        php artisan route:cache
        php artisan view:cache
        php artisan serve --host=0.0.0.0 --port=8000 --env=production
        ;;
    stop)
        echo "🛑 Stopping server..."
        pkill -f "php artisan serve"
        ;;
    restart)
        $0 stop
        sleep 2
        $0 start
        ;;
    status)
        if pgrep -f "php artisan serve" > /dev/null; then
            echo "✅ Server is running"
        else
            echo "❌ Server is not running"
        fi
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac
EOF

# Create secrets script
cat > secrets << 'EOF'
#!/bin/bash
# Environment secrets management script

case "$1" in
    show)
        echo "🔐 Environment variables:"
        grep -v '^#' .env | grep -v '^$'
        ;;
    edit)
        echo "📝 Opening .env file..."
        ${EDITOR:-nano} .env
        ;;
    backup)
        echo "💾 Backing up .env file..."
        cp .env ".env.backup.$(date +%Y%m%d_%H%M%S)"
        echo "✅ Backup created"
        ;;
    restore)
        if [ -z "$2" ]; then
            echo "Usage: $0 restore <backup-file>"
            exit 1
        fi
        echo "🔄 Restoring .env from $2..."
        cp "$2" .env
        echo "✅ Environment restored"
        ;;
    generate-key)
        echo "🔑 Generating new application key..."
        php artisan key:generate
        ;;
    *)
        echo "Usage: $0 {show|edit|backup|restore|generate-key}"
        exit 1
        ;;
esac
EOF

# Make scripts executable
chmod +x dev server secrets

print_status "Helper scripts created"

# Set up Git hooks
print_header "Setting Up Git Hooks"

if [ -d ".git" ]; then
    mkdir -p .git/hooks
    
    # Pre-commit hook
    cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Ona Laravel pre-commit hook

echo "🔍 Running pre-commit checks..."

# Check PHP syntax
php_files=$(git diff --cached --name-only --diff-filter=ACM | grep '\.php$')
if [ ! -z "$php_files" ]; then
    for file in $php_files; do
        if [ -f "$file" ]; then
            php -l "$file" > /dev/null 2>&1
            if [ $? -ne 0 ]; then
                echo "❌ PHP syntax error in: $file"
                exit 1
            fi
        fi
    done
fi

# Run tests
if [ -f "./vendor/bin/pest" ]; then
    echo "🧪 Running tests..."
    ./vendor/bin/pest --bail
    if [ $? -ne 0 ]; then
        echo "❌ Tests failed"
        exit 1
    fi
fi

echo "✅ Pre-commit checks passed"
EOF

    chmod +x .git/hooks/pre-commit
    print_status "Git hooks configured"
else
    print_warning "Not a Git repository, skipping Git hooks setup"
fi

# Final setup
print_header "Final Setup"

print_info "Installing npm dependencies..."
npm install

print_info "Building assets..."
npm run build

print_info "Clearing caches..."
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear

print_status "Setup completed successfully!"

# Show completion message
print_header "🎉 Setup Complete!"
echo ""
echo "Your Ona Laravel project is ready for development!"
echo ""
echo "📁 Project: $PROJECT_NAME"
echo "🌐 Laravel: http://localhost:8000"
echo "⚡ Vite: http://localhost:3000"
echo ""
echo "Available commands:"
echo "  ./dev     - Start development servers"
echo "  ./server  - Manage production server"
echo "  ./secrets - Manage environment variables"
echo ""
echo "Next steps:"
echo "1. Run './dev' to start development servers"
echo "2. Visit http://localhost:8000 to see your application"
echo "3. Check .ona-notes/ for project documentation"
echo ""
echo "Happy coding with Ona! 🤖✨"