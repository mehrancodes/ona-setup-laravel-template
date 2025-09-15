# Ona Laravel Setup Guide

Complete setup guide for Laravel + Frontend development with Ona AI agent integration.

## 🚀 Quick Start

### Option 1: One-Line Installation
```bash
curl -fsSL https://raw.githubusercontent.com/your-username/your-repo/main/ona-setup-template/scripts/install.sh | bash -s -- my-project
```

### Option 2: Manual Setup
```bash
# Clone the template
git clone https://github.com/your-username/your-repo.git
cd your-repo/ona-setup-template

# Copy to your project
cp -r . /path/to/your/new/project
cd /path/to/your/new/project

# Run setup
./setup.sh
```

## 📋 Prerequisites

### System Requirements
- **PHP 8.3+** with extensions: gd, zip, intl, mbstring, xml, curl, pdo, bcmath, opcache
- **Node.js 20+** with npm/yarn
- **Composer 2.x**
- **Git**
- **SQLite** (for development) or **MySQL/PostgreSQL** (for production)

### Development Environment
- **Gitpod** (recommended) - Fully configured with devcontainer
- **VS Code** with Dev Containers extension
- **Docker Desktop** (for local development)

## 🛠 Installation Process

### Step 1: Environment Setup

The setup script will:
1. Create a new Laravel project (if not existing)
2. Install and configure essential packages:
   - **Filament** - Admin panel framework
   - **Livewire** - Dynamic interfaces
   - **Pest** - Testing framework
   - **Laravel Horizon** - Queue management
   - **Laravel Telescope** - Debugging
   - **Spatie packages** - Permissions, activity log

### Step 2: Frontend Configuration

Automatically configures:
- **Vite** for modern build tooling
- **Vue.js 3** with Composition API
- **Tailwind CSS** for styling
- **TypeScript** support (optional)
- Hot module replacement for development

### Step 3: Development Tools

Sets up:
- **VS Code** settings and extensions
- **Git hooks** for code quality
- **PHP CS Fixer** for code formatting
- **ESLint/Prettier** for JavaScript
- **PHPStan** for static analysis

## 🎯 Project Structure

```
your-project/
├── .devcontainer/          # Development container config
│   ├── devcontainer.json   # VS Code dev container settings
│   ├── Dockerfile          # Container definition
│   ├── php.ini            # PHP configuration
│   └── setup.sh           # Container setup script
├── .ona-notes/            # Ona AI agent integration
│   ├── PROJECT_CONTEXT.md # Project overview for Ona
│   ├── COMMIT_GUIDELINES.md # Commit conventions
│   └── README.md          # Ona integration guide
├── scripts/               # Development utilities
│   ├── install.sh         # Template installer
│   ├── test.sh           # Test suite runner
│   ├── build.sh          # Production build
│   └── deploy.sh         # Deployment script
├── app/                   # Laravel application
├── resources/             # Frontend assets
├── dev                    # Development server script
├── server                 # Production server script
├── secrets               # Environment management
└── setup.sh              # Main setup script
```

## 🔧 Configuration

### Environment Variables

The setup creates a comprehensive `.env` file with:

```env
# Application
APP_NAME="Your Project"
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost:8000

# Database (SQLite for development)
DB_CONNECTION=sqlite
DB_DATABASE=database/database.sqlite

# Frontend
VITE_APP_NAME="${APP_NAME}"
VITE_APP_URL="${APP_URL}"

# Mail (Mailhog for development)
MAIL_MAILER=smtp
MAIL_HOST=localhost
MAIL_PORT=8025

# Queue
QUEUE_CONNECTION=database

# Cache
CACHE_DRIVER=file
SESSION_DRIVER=file
```

### Package Configuration

#### Composer Dependencies
```json
{
  "require": {
    "laravel/framework": "^10.0",
    "filament/filament": "^3.0",
    "livewire/livewire": "^3.0",
    "laravel/horizon": "^5.0",
    "spatie/laravel-permission": "^5.0",
    "spatie/laravel-activitylog": "^4.0"
  },
  "require-dev": {
    "pestphp/pest": "^2.0",
    "pestphp/pest-plugin-laravel": "^2.0",
    "laravel/telescope": "^4.0",
    "barryvdh/laravel-debugbar": "^3.0"
  }
}
```

#### NPM Dependencies
```json
{
  "devDependencies": {
    "vite": "^4.0",
    "laravel-vite-plugin": "^0.8",
    "@vitejs/plugin-vue": "^4.0",
    "vue": "^3.0",
    "tailwindcss": "^3.0",
    "@tailwindcss/forms": "^0.5",
    "@tailwindcss/typography": "^0.5",
    "autoprefixer": "^10.0",
    "postcss": "^8.0",
    "axios": "^1.0"
  }
}
```

## 🚀 Development Workflow

### Starting Development
```bash
# Start all development servers
./dev

# Or individually
php artisan serve --host=0.0.0.0 --port=8000  # Laravel
npm run dev                                     # Vite
```

### Running Tests
```bash
# Run all tests
./scripts/test.sh

# Or specific test suites
./vendor/bin/pest           # PHP tests
npm test                    # JavaScript tests
```

### Code Quality
```bash
# Format PHP code
php-cs-fixer fix

# Analyze PHP code
phpstan analyse

# Format JavaScript
npx prettier --write resources/js
npx eslint resources/js --fix
```

### Database Management
```bash
# Run migrations
php artisan migrate

# Fresh migration with seeding
php artisan migrate:fresh --seed

# Create new migration
php artisan make:migration create_example_table
```

## 🎨 Frontend Development

### Vue.js Integration
```javascript
// resources/js/app.js
import { createApp } from 'vue';
import ExampleComponent from './components/ExampleComponent.vue';

const app = createApp({});
app.component('example-component', ExampleComponent);
app.mount('#app');
```

### Tailwind CSS Usage
```html
<!-- resources/views/welcome.blade.php -->
<div class="ona-container">
    <div class="ona-card p-6">
        <h1 class="text-2xl font-bold text-gray-900">
            Welcome to Ona Laravel
        </h1>
        <button class="ona-button mt-4">
            Get Started
        </button>
    </div>
</div>
```

### Vite Configuration
```javascript
// vite.config.js
import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import vue from '@vitejs/plugin-vue';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
            refresh: true,
        }),
        vue(),
    ],
    server: {
        host: '0.0.0.0',
        port: 3000,
    },
});
```

## 🧪 Testing

### PHP Testing with Pest
```php
<?php
// tests/Feature/ExampleTest.php

test('homepage loads successfully', function () {
    $response = $this->get('/');
    $response->assertStatus(200);
});

test('user can register', function () {
    $response = $this->post('/register', [
        'name' => 'Test User',
        'email' => 'test@example.com',
        'password' => 'password',
        'password_confirmation' => 'password',
    ]);
    
    $response->assertRedirect('/dashboard');
    $this->assertDatabaseHas('users', [
        'email' => 'test@example.com',
    ]);
});
```

### JavaScript Testing
```javascript
// resources/js/tests/example.test.js
import { mount } from '@vue/test-utils';
import ExampleComponent from '../components/ExampleComponent.vue';

test('component renders correctly', () => {
    const wrapper = mount(ExampleComponent);
    expect(wrapper.text()).toContain('Hello World');
});
```

## 🚀 Production Deployment

### Build for Production
```bash
# Run production build
./scripts/build.sh
```

This will:
- Install optimized dependencies
- Build and minify frontend assets
- Cache Laravel configuration
- Optimize Composer autoloader
- Set proper permissions

### Deploy to Server
```bash
# Deploy to staging
./scripts/deploy.sh staging

# Deploy to production
./scripts/deploy.sh production
```

### Environment Variables for Production
```env
APP_ENV=production
APP_DEBUG=false
APP_URL=https://your-domain.com

DB_CONNECTION=mysql
DB_HOST=your-db-host
DB_DATABASE=your-database
DB_USERNAME=your-username
DB_PASSWORD=your-password

CACHE_DRIVER=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=redis

REDIS_HOST=your-redis-host
REDIS_PASSWORD=your-redis-password
```

## 🤖 Ona Integration

### Project Context
The `.ona-notes/PROJECT_CONTEXT.md` file provides Ona with:
- Project overview and technology stack
- Development workflow and conventions
- Key features and architecture decisions
- Testing and deployment procedures

### Commit Guidelines
Follow conventional commit format:
```
feat: add user authentication system
fix(auth): resolve login redirect issue
docs: update API documentation
style: format code with prettier
refactor(user): simplify user model
test: add unit tests for user service
chore: update dependencies

Co-authored-by: Ona <no-reply@ona.com>
```

### Development Notes
Keep `.ona-notes/` updated with:
- Important architectural decisions
- Development patterns and conventions
- Known issues and workarounds
- Future enhancement plans

## 🔧 Customization

### Adding New Packages
```bash
# PHP packages
composer require vendor/package

# JavaScript packages
npm install package-name

# Update setup script to include new packages
```

### Modifying Build Process
Edit `scripts/build.sh` to:
- Add custom build steps
- Include additional optimizations
- Configure deployment artifacts

### Custom VS Code Settings
Modify `.devcontainer/devcontainer.json`:
- Add new extensions
- Update editor settings
- Configure debugging options

## 🆘 Troubleshooting

### Common Issues

#### Permission Errors
```bash
# Fix storage permissions
chmod -R 775 storage bootstrap/cache
```

#### Database Connection Issues
```bash
# Check database configuration
php artisan config:clear
php artisan migrate:status
```

#### Frontend Build Errors
```bash
# Clear npm cache
npm cache clean --force
rm -rf node_modules package-lock.json
npm install
```

#### Container Issues
```bash
# Rebuild dev container
# In VS Code: Ctrl+Shift+P -> "Dev Containers: Rebuild Container"
```

### Getting Help

1. Check the troubleshooting section
2. Review error logs in `storage/logs/`
3. Use Laravel's built-in debugging tools
4. Consult the Ona integration notes

## 📚 Additional Resources

- [Laravel Documentation](https://laravel.com/docs)
- [Filament Documentation](https://filamentphp.com/docs)
- [Vue.js Documentation](https://vuejs.org/guide/)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [Pest Testing Documentation](https://pestphp.com/docs)

---

**Happy coding with Ona! 🤖✨**