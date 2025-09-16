#!/bin/bash

# Ona Template Sync Script
# Syncs latest template configurations without overwriting customizations
# Creates backups and detailed reports of changes

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
TEMPLATE_REPO="https://github.com/mehrancodes/ona-setup-laravel-template"
TEMPLATE_BRANCH="main"
TEMP_DIR="/tmp/ona-template-sync-$$"
BACKUP_DIR=".ona-backups/$(date +%Y%m%d-%H%M%S)"

# Template-managed directories (will be replaced completely)
TEMPLATE_DIRS=(".devcontainer" ".ona-notes" "scripts" ".gitpod")

# Files that may need merging (not replaced completely)
MERGE_FILES=(".env.example" ".gitignore")

# Flags
FORCE_UPDATE=false
SKIP_BACKUP=false
VERBOSE=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--force)
            FORCE_UPDATE=true
            shift
            ;;
        --skip-backup)
            SKIP_BACKUP=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            echo "Ona Template Sync Script"
            echo ""
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -f, --force        Force update even if no changes detected"
            echo "  --skip-backup      Skip creating backups (not recommended)"
            echo "  -v, --verbose      Show detailed output"
            echo "  -h, --help         Show this help message"
            echo ""
            echo "This script syncs the latest Ona template files while preserving"
            echo "your customizations. It creates backups and provides detailed reports."
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Unknown option: $1${NC}"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

log_verbose() {
    if [ "$VERBOSE" = true ]; then
        echo -e "${CYAN}[VERBOSE]${NC} $1"
    fi
}

echo -e "${BLUE}🔄 Ona Template Sync${NC}"
echo -e "${BLUE}===================${NC}"
echo ""

# Check if we're in a project with Ona template
if [ ! -d ".devcontainer" ] && [ ! -d ".ona-notes" ] && [ ! -d "scripts" ]; then
    echo -e "${RED}❌ No Ona template detected in current directory${NC}"
    echo -e "${YELLOW}   Run the installer first:${NC}"
    echo "   curl -fsSL https://raw.githubusercontent.com/mehrancodes/ona-setup-laravel-template/main/install.sh | bash"
    exit 1
fi

echo -e "${BLUE}📥 Downloading latest template...${NC}"

# Create temporary directory
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Download template repository
log_verbose "Cloning template repository from $TEMPLATE_REPO"
git clone --depth 1 --branch "$TEMPLATE_BRANCH" "$TEMPLATE_REPO" template
cd template

# Get template version info
TEMPLATE_COMMIT=$(git rev-parse HEAD)
TEMPLATE_DATE=$(git log -1 --format=%cd --date=short)

cd - > /dev/null
cd - > /dev/null

echo -e "${GREEN}✅ Template downloaded${NC}"
echo -e "${CYAN}   Version: ${TEMPLATE_COMMIT:0:8} (${TEMPLATE_DATE})${NC}"
echo ""

# Create backup directory if not skipping
if [ "$SKIP_BACKUP" = false ]; then
    echo -e "${BLUE}💾 Creating backup...${NC}"
    mkdir -p "$BACKUP_DIR"
    
    for dir in "${TEMPLATE_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            log_verbose "Backing up $dir"
            cp -r "$dir" "$BACKUP_DIR/"
        fi
    done
    
    for file in "${MERGE_FILES[@]}"; do
        if [ -f "$file" ]; then
            log_verbose "Backing up $file"
            cp "$file" "$BACKUP_DIR/"
        fi
    done
    
    echo -e "${GREEN}✅ Backup created at $BACKUP_DIR${NC}"
    echo ""
fi

# Track changes
CHANGES_MADE=false
CHANGE_LOG="$BACKUP_DIR/changes.log"
mkdir -p "$(dirname "$CHANGE_LOG")"

echo "Ona Template Sync - Change Log" > "$CHANGE_LOG"
echo "Date: $(date)" >> "$CHANGE_LOG"
echo "Template Version: $TEMPLATE_COMMIT" >> "$CHANGE_LOG"
echo "Template Date: $TEMPLATE_DATE" >> "$CHANGE_LOG"
echo "" >> "$CHANGE_LOG"

echo -e "${BLUE}🔄 Syncing template directories...${NC}"

# Update template-managed directories
for dir in "${TEMPLATE_DIRS[@]}"; do
    if [ -d "$TEMP_DIR/template/$dir" ]; then
        echo "Updating $dir/"
        
        # Check if there are changes
        if [ -d "$dir" ]; then
            if ! diff -r "$dir" "$TEMP_DIR/template/$dir" > /dev/null 2>&1; then
                echo "  📝 Changes detected in $dir/" >> "$CHANGE_LOG"
                CHANGES_MADE=true
                log_verbose "Changes detected in $dir"
            else
                log_verbose "No changes in $dir"
            fi
        else
            echo "  ➕ New directory: $dir/" >> "$CHANGE_LOG"
            CHANGES_MADE=true
            log_verbose "New directory: $dir"
        fi
        
        # Replace directory
        rm -rf "$dir"
        cp -r "$TEMP_DIR/template/$dir" .
        
        echo -e "  ${GREEN}✅ Updated${NC}"
    else
        log_verbose "Template directory $dir not found in template"
    fi
done

echo ""
echo -e "${BLUE}📝 Checking merge files...${NC}"

# Handle files that may need merging
for file in "${MERGE_FILES[@]}"; do
    if [ -f "$TEMP_DIR/template/$file" ]; then
        if [ -f "$file" ]; then
            # Compare files
            if ! diff "$file" "$TEMP_DIR/template/$file" > /dev/null 2>&1; then
                echo "Changes detected in $file"
                echo "  📝 Changes detected in $file" >> "$CHANGE_LOG"
                CHANGES_MADE=true
                
                # Show diff and ask for action
                echo -e "${YELLOW}  Differences found:${NC}"
                diff -u "$file" "$TEMP_DIR/template/$file" | head -20 || true
                
                if [ "$FORCE_UPDATE" = true ]; then
                    echo -e "${YELLOW}  Force mode: Replacing with template version${NC}"
                    cp "$TEMP_DIR/template/$file" "$file"
                    echo "    🔄 Replaced with template version" >> "$CHANGE_LOG"
                else
                    echo -e "${CYAN}  Template version saved as ${file}.template${NC}"
                    cp "$TEMP_DIR/template/$file" "${file}.template"
                    echo "    💾 Template version saved as ${file}.template" >> "$CHANGE_LOG"
                    echo -e "${YELLOW}  Please review and merge manually${NC}"
                fi
            else
                log_verbose "No changes in $file"
            fi
        else
            echo "Installing new file: $file"
            cp "$TEMP_DIR/template/$file" .
            echo "  ➕ New file: $file" >> "$CHANGE_LOG"
            CHANGES_MADE=true
        fi
    fi
done

echo ""
echo -e "${BLUE}📝 Updating .gitignore...${NC}"

# Ensure .gitignore has template exclusions
if [ -f ".gitignore" ]; then
    # Check if template exclusions exist
    if ! grep -q "# Ona Template - Managed files" .gitignore; then
        echo "Adding template exclusions to .gitignore"
        {
            echo ""
            echo "# Ona Template - Managed files (pulled fresh from template)"
            echo "# These directories are managed by the Ona template and should not be committed"
            for dir in "${TEMPLATE_DIRS[@]}"; do
                echo "$dir/"
            done
            echo ""
            echo "# Ona Template - Local sync script (keep in repository)"
            echo "!sync-ona-template.sh"
        } >> .gitignore
        echo "  ➕ Added template exclusions to .gitignore" >> "$CHANGE_LOG"
        CHANGES_MADE=true
    else
        log_verbose ".gitignore already has template exclusions"
    fi
fi

# Clean up
rm -rf "$TEMP_DIR"

echo -e "${GREEN}✅ .gitignore updated${NC}"
echo ""

# Summary
if [ "$CHANGES_MADE" = true ] || [ "$FORCE_UPDATE" = true ]; then
    echo -e "${GREEN}🎉 Sync complete! Changes were made.${NC}"
    echo ""
    echo -e "${BLUE}📋 Summary:${NC}"
    for dir in "${TEMPLATE_DIRS[@]}"; do
        if [ -d "$dir" ]; then
            echo "  ✅ $dir/ (updated from template)"
        fi
    done
    
    if [ -f "sync-ona-template.sh" ]; then
        echo "  ✅ sync-ona-template.sh (available for future updates)"
    fi
    
    echo ""
    echo -e "${BLUE}📄 Change log: ${CHANGE_LOG}${NC}"
    
    if [ "$SKIP_BACKUP" = false ]; then
        echo -e "${BLUE}💾 Backup location: ${BACKUP_DIR}${NC}"
    fi
    
    # Check for .template files
    TEMPLATE_FILES=$(find . -maxdepth 1 -name "*.template" 2>/dev/null || true)
    if [ -n "$TEMPLATE_FILES" ]; then
        echo ""
        echo -e "${YELLOW}⚠️  Manual merge required:${NC}"
        for file in $TEMPLATE_FILES; do
            echo "  📝 Review and merge: $file"
        done
        echo ""
        echo -e "${CYAN}💡 Tip: Use 'diff' or your favorite merge tool to compare files${NC}"
    fi
else
    echo -e "${GREEN}✅ Sync complete! No changes needed.${NC}"
    echo -e "${CYAN}   Your template is already up to date.${NC}"
fi

echo ""
echo -e "${BLUE}🔄 To sync again in the future:${NC}"
echo "  ./sync-ona-template.sh"
echo ""
echo -e "${GREEN}Happy coding with Ona! 🤖✨${NC}"