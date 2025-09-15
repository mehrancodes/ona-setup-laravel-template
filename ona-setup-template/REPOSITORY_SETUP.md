# Ona Laravel Setup Template - Repository Creation Guide

This guide explains how to create and set up your own repository using the Ona Laravel Setup Template.

## 🚀 Quick Repository Setup

### Option 1: Create New Repository from Template

1. **Create GitHub Repository**
   ```bash
   # Create new repository on GitHub
   gh repo create your-username/ona-laravel-template --public --clone
   cd ona-laravel-template
   ```

2. **Copy Template Files**
   ```bash
   # Copy all template files from timefolio project
   cp -r /path/to/timefolio/ona-setup-template/* .
   cp -r /path/to/timefolio/ona-setup-template/.* . 2>/dev/null || true
   ```

3. **Initialize Repository**
   ```bash
   git add .
   git commit -m "feat: initial Ona Laravel setup template

   - Add comprehensive development environment setup
   - Include Laravel 10.x with PHP 8.3 support
   - Configure Vue.js 3 with Vite build system
   - Set up Filament admin panel and Livewire
   - Add Pest testing framework
   - Include development container configuration
   - Add Ona AI agent integration files
   - Provide automated setup and deployment scripts

   Co-authored-by: Ona <no-reply@ona.com>"
   
   git push origin main
   ```

### Option 2: Fork and Customize

1. **Fork the Original Repository**
   ```bash
   gh repo fork original-repo/ona-laravel-template
   cd ona-laravel-template
   ```

2. **Customize for Your Needs**
   - Update README.md with your information
   - Modify package.json and composer.json
   - Customize .devcontainer configuration
   - Update documentation

3. **Commit Changes**
   ```bash
   git add .
   git commit -m "feat: customize template for specific use case"
   git push origin main
   ```

## 📁 Repository Structure

Your repository should have this structure:

```
ona-laravel-template/
├── .devcontainer/              # Development container configuration
│   ├── devcontainer.json       # VS Code dev container settings
│   ├── Dockerfile              # Container definition
│   ├── php.ini                # PHP configuration
│   ├── supervisord.conf       # Background services
│   └── setup.sh               # Container setup script
├── .ona-notes/                # Ona AI agent integration
│   ├── PROJECT_CONTEXT.md     # Project overview for Ona
│   ├── COMMIT_GUIDELINES.md   # Commit conventions
│   └── README.md              # Ona integration guide
├── scripts/                   # Development utilities
│   ├── install.sh             # Template installer
│   ├── test.sh               # Test suite runner
│   ├── build.sh              # Production build
│   └── deploy.sh             # Deployment script
├── .env.example              # Environment template
├── .gitignore                # Git ignore patterns
├── CHANGELOG.md              # Version history
├── LICENSE                   # MIT license
├── README.md                 # Main documentation
├── SETUP.md                  # Detailed setup guide
├── REPOSITORY_SETUP.md       # This file
├── composer.json             # PHP dependencies template
├── package.json              # Node.js dependencies template
├── setup.sh                  # Main setup script
├── dev                       # Development server script
├── server                    # Production server script
└── secrets                   # Environment management script
```

## 🔧 Customization Options

### 1. Update Repository Information

Edit these files with your information:

**README.md**
```markdown
# Your Laravel Template Name

Your description here...

## Installation
```bash
curl -fsSL https://raw.githubusercontent.com/your-username/your-repo/main/scripts/install.sh | bash
```

**package.json**
```json
{
  "name": "your-template-name",
  "repository": {
    "type": "git",
    "url": "https://github.com/your-username/your-repo.git"
  }
}
```

**composer.json**
```json
{
  "name": "your-username/your-template",
  "description": "Your template description"
}
```

### 2. Customize Installation Script

Update `scripts/install.sh`:
```bash
# Configuration
REPO_URL="https://github.com/your-username/your-repo"
TEMPLATE_URL="$REPO_URL/archive/main.tar.gz"
```

### 3. Modify Development Container

Customize `.devcontainer/Dockerfile`:
```dockerfile
# Add your specific requirements
RUN apt-get update && apt-get install -y \
    your-additional-packages
```

### 4. Update Documentation

Modify documentation files:
- Update URLs in README.md
- Customize SETUP.md for your specific needs
- Update .ona-notes/ with your project context

## 🌐 Making Template Publicly Available

### 1. GitHub Repository Settings

1. **Make Repository Public**
   ```bash
   gh repo edit --visibility public
   ```

2. **Enable GitHub Pages** (optional)
   - Go to repository Settings > Pages
   - Select source branch (main)
   - Enable GitHub Pages for documentation

3. **Add Repository Topics**
   ```bash
   gh repo edit --add-topic laravel,vue,template,ona,ai-development
   ```

### 2. Create Release

```bash
# Tag the release
git tag -a v1.0.0 -m "Initial release of Ona Laravel template"
git push origin v1.0.0

# Create GitHub release
gh release create v1.0.0 \
  --title "Ona Laravel Template v1.0.0" \
  --notes "Initial stable release with complete Laravel + Vue.js setup"
```

### 3. Update Installation URLs

Update all references to use your repository:

**In scripts/install.sh:**
```bash
REPO_URL="https://github.com/your-username/your-repo"
```

**In README.md:**
```bash
curl -fsSL https://raw.githubusercontent.com/your-username/your-repo/main/scripts/install.sh | bash
```

## 📦 Distribution Options

### Option 1: Direct GitHub Installation
Users can install directly from GitHub:
```bash
curl -fsSL https://raw.githubusercontent.com/your-username/your-repo/main/scripts/install.sh | bash -s -- project-name
```

### Option 2: NPM Package (Optional)
Create an npm package for easier distribution:

1. **Create npm package structure:**
   ```bash
   mkdir npm-package
   cp -r ona-setup-template/* npm-package/
   cd npm-package
   ```

2. **Update package.json for npm:**
   ```json
   {
     "name": "@your-username/ona-laravel-template",
     "version": "1.0.0",
     "bin": {
       "create-ona-laravel": "./scripts/install.sh"
     }
   }
   ```

3. **Publish to npm:**
   ```bash
   npm publish --access public
   ```

### Option 3: Composer Package (Optional)
Create a Composer package:

1. **Register on Packagist**
2. **Update composer.json:**
   ```json
   {
     "name": "your-username/ona-laravel-template",
     "type": "project-template"
   }
   ```

## 🧪 Testing Your Template

### 1. Test Installation Process
```bash
# Test in clean environment
mkdir test-install
cd test-install
curl -fsSL https://raw.githubusercontent.com/your-username/your-repo/main/scripts/install.sh | bash -s -- test-project
```

### 2. Verify All Components
```bash
cd test-project
./setup.sh
./dev  # Test development servers
./scripts/test.sh  # Run test suite
./scripts/build.sh  # Test production build
```

### 3. Test in Different Environments
- Local development
- Gitpod workspace
- GitHub Codespaces
- Docker container

## 📚 Documentation Maintenance

### Keep Documentation Updated
1. **Version Information**: Update version numbers in all files
2. **Installation URLs**: Ensure all URLs point to your repository
3. **Examples**: Keep code examples current with latest versions
4. **Changelog**: Document all changes and improvements

### Regular Updates
1. **Dependencies**: Keep Laravel, Vue.js, and other dependencies updated
2. **Security**: Apply security patches promptly
3. **Features**: Add new features based on user feedback
4. **Documentation**: Keep setup guides and examples current

## 🤝 Community and Contributions

### Enable Contributions
1. **Contributing Guidelines**: Create CONTRIBUTING.md
2. **Issue Templates**: Set up GitHub issue templates
3. **Pull Request Template**: Create PR template
4. **Code of Conduct**: Add CODE_OF_CONDUCT.md

### Community Features
```bash
# Enable discussions
gh repo edit --enable-discussions

# Add issue templates
mkdir .github/ISSUE_TEMPLATE
# Create bug report and feature request templates
```

## 🔄 Maintenance and Updates

### Regular Maintenance Tasks
1. **Dependency Updates**: Monthly dependency updates
2. **Security Patches**: Apply security updates immediately
3. **Documentation Review**: Quarterly documentation review
4. **Template Testing**: Test template with each major update

### Version Management
```bash
# Create new version
git tag -a v1.1.0 -m "Version 1.1.0 - Add new features"
git push origin v1.1.0
gh release create v1.1.0
```

## 🚀 Success Metrics

Track template success with:
- GitHub stars and forks
- Download/installation statistics
- User feedback and issues
- Community contributions
- Documentation usage

## 📞 Support and Help

Provide support through:
- GitHub Issues for bug reports
- GitHub Discussions for questions
- Documentation and guides
- Example projects and demos

---

**Your Ona Laravel Setup Template is now ready for the community! 🎉**

Users can create new Laravel projects with:
```bash
curl -fsSL https://raw.githubusercontent.com/your-username/your-repo/main/scripts/install.sh | bash -s -- my-awesome-project
```