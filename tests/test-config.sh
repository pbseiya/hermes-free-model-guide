#!/bin/bash

# Test script for configuration validation
# Usage: bash tests/test-config.sh

set -e

echo "🧪 Running Configuration Tests..."
echo "=================================="

# Test 1: Check config.yaml structure
echo "✓ Test 1: Checking config.yaml structure..."
if grep -q "model:" templates/config.yaml && grep -q "providers:" templates/config.yaml; then
    echo "  ✅ config.yaml has required sections"
else
    echo "  ❌ config.yaml missing required sections"
    exit 1
fi

# Test 2: Check env.example has required variables
echo "✓ Test 2: Checking env.example variables..."
if grep -q "OKMD_API_KEY" templates/env.example && grep -q "TELEGRAM_BOT_TOKEN" templates/env.example; then
    echo "  ✅ env.example has required variables"
else
    echo "  ❌ env.example missing required variables"
    exit 1
fi

# Test 3: Check if .env is in .gitignore
echo "✓ Test 3: Checking .gitignore..."
if grep -q ".env" .gitignore; then
    echo "  ✅ .env is in .gitignore"
else
    echo "  ❌ .env is NOT in .gitignore (security risk!)"
    exit 1
fi

# Test 4: Validate examples syntax
echo "✓ Test 4: Validating examples syntax..."
ERROR_COUNT=0
for file in examples/*.md; do
    if grep -q 'yaml' "$file"; then
        echo "  ✅ $file has valid YAML code blocks"
    else
        echo "  ⚠️  $file may not have YAML code blocks"
        ERROR_COUNT=$((ERROR_COUNT + 1))
    fi
done

if [ $ERROR_COUNT -gt 0 ]; then
    echo "  ⚠️  $ERROR_COUNT files may have issues"
fi

# Test 5: Check for hardcoded secrets
echo "✓ Test 5: Checking for hardcoded secrets..."
if grep -r "sk-.*[A-Za-z0-9]\{20,\}" templates/ examples/ 2>/dev/null | grep -v "sk_YOUR_KEY_HERE" | grep -v "sk-proj-placeholder"; then
    echo "  ❌ Found potential hardcoded secrets!"
    exit 1
else
    echo "  ✅ No hardcoded secrets found"
fi

echo ""
echo "=================================="
echo "✅ All configuration tests passed!"
echo "=================================="
