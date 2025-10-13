#!/bin/bash
# Cleanup unused Vite/CRA boilerplate files
# Based on code review analysis: 3 stories had unused boilerplate files

echo "🧹 Cleaning up unused boilerplate files..."
echo ""

REMOVED_COUNT=0

# Function to check if file is imported
is_imported() {
  local file=$1
  local basename=$(basename "$file")
  
  # Check if file is imported anywhere in src/
  if grep -r "import.*$basename\|from.*$basename\|require.*$basename" src/ --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" > /dev/null 2>&1; then
    return 0  # File is imported
  else
    return 1  # File is not imported
  fi
}

# Check and remove unused CSS files
echo "Checking for unused CSS files..."
for file in src/App.css src/index.css; do
  if [ -f "$file" ]; then
    if ! is_imported "$file"; then
      echo "  🗑️  Removing unused: $file"
      rm "$file"
      REMOVED_COUNT=$((REMOVED_COUNT + 1))
    else
      echo "  ✅ Keeping (imported): $file"
    fi
  fi
done
echo ""

# Check for unused logo files
echo "Checking for unused logo files..."
for file in src/assets/react.svg src/logo.svg public/vite.svg; do
  if [ -f "$file" ]; then
    local basename=$(basename "$file")
    if ! grep -r "$basename" src/ public/ index.html --include="*.ts" --include="*.tsx" --include="*.js" --include="*.jsx" --include="*.html" > /dev/null 2>&1; then
      echo "  🗑️  Removing unused: $file"
      rm "$file"
      REMOVED_COUNT=$((REMOVED_COUNT + 1))
    else
      echo "  ✅ Keeping (referenced): $file"
    fi
  fi
done
echo ""

# Check for empty directories
echo "Checking for empty directories..."
if [ -d "src/assets" ] && [ -z "$(ls -A src/assets 2>/dev/null)" ]; then
  echo "  🗑️  Removing empty directory: src/assets"
  rmdir src/assets
  REMOVED_COUNT=$((REMOVED_COUNT + 1))
fi
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $REMOVED_COUNT -eq 0 ]; then
  echo "✅ No unused boilerplate files found"
  echo "   Your codebase is clean!"
else
  echo "✅ Cleanup complete: Removed $REMOVED_COUNT file(s)/directory(ies)"
  echo ""
  echo "   Next steps:"
  echo "   1. Review changes: git status"
  echo "   2. Stage deletions: git add -u"
  echo "   3. Commit: git commit -m \"chore: remove unused boilerplate files\""
fi
echo ""

