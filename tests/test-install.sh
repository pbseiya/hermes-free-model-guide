#!/bin/bash

# Test script for installation validation
# Usage: bash tests/test-install.sh

set -e

echo "🧪 Running Installation Tests..."
echo "================================"

# Test 1: Check if installation script exists
echo "✓ Test 1: Checking installation script exists..."
if [ -f "scripts/install-linux.sh" ]; then
    echo "  ✅ install-linux.sh exists"
else
    echo "  ❌ install-linux.sh not found"
    exit 1
fi

# Test 2: Check if config template exists
echo "✓ Test 2: Checking config template exists..."
if [ -f "templates/config.yaml" ]; then
    echo "  ✅ config.yaml exists"
else
    echo "  ❌ config.yaml not found"
    exit 1
fi

# Test 3: Check if env.example exists
echo "✓ Test 3: Checking env.example exists..."
if [ -f "templates/env.example" ]; then
    echo "  ✅ env.example exists"
else
    echo "  ❌ env.example not found"
    exit 1
fi

# Test 4: Validate YAML syntax
echo "✓ Test 4: Validating YAML syntax..."
if command -v python3 &> /dev/null; then
    python3 -c "import yaml; yaml.safe_load(open('templates/config.yaml'))" && echo "  ✅ YAML syntax valid" || echo "  ❌ YAML syntax invalid"
else
    echo "  ⚠️  Python3 not available, skipping YAML validation"
fi

# Test 5: Check if guides are present
echo "✓ Test 5: Checking guides..."
GUIDE_COUNT=$(find guides -name "*.md" | wc -l)
if [ "$GUIDE_COUNT" -ge 5 ]; then
    echo "  ✅ Found $GUIDE_COUNT guides"
else
    echo "  ❌ Expected at least 5 guides, found $GUIDE_COUNT"
    exit 1
fi

# Test 6: Check if examples are present
echo "✓ Test 6: Checking examples..."
EXAMPLE_COUNT=$(find examples -name "*.md" | wc -l)
if [ "$EXAMPLE_COUNT" -ge 6 ]; then
    echo "  ✅ Found $EXAMPLE_COUNT examples"
else
    echo "  ❌ Expected at least 6 examples, found $EXAMPLE_COUNT"
    exit 1
fi

echo ""
echo "================================"
echo "✅ All tests passed!"
echo "================================"
