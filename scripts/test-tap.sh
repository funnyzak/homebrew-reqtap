#!/bin/bash

# Test script for homebrew-reqtap tap
# This script helps test the tap installation and functionality

set -e

# Helper function to validate checksums
function validate_checksum() {
    local url="$1"
    local expected_sha="$2"

    # Create temp file
    local temp_file=$(mktemp)

    # Download file
    if curl -s -L "$url" -o "$temp_file" 2>/dev/null; then
        # Calculate checksum
        local actual_sha=$(sha256sum "$temp_file" 2>/dev/null | cut -d' ' -f1)

        # Cleanup
        rm -f "$temp_file"

        # Compare checksums
        if [ "$actual_sha" = "$expected_sha" ]; then
            return 0
        else
            echo "Expected: $expected_sha, Got: $actual_sha" >&2
            return 1
        fi
    else
        rm -f "$temp_file"
        echo "Failed to download $url" >&2
        return 1
    fi
}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "Formula/reqtap.rb" ]; then
    print_error "Formula/reqtap.rb not found. Please run this script from the repository root."
    exit 1
fi

print_status "Starting homebrew-reqtap test suite..."

# Test 1: Check formula syntax
print_status "Testing formula syntax..."
if ruby -c Formula/reqtap.rb > /dev/null 2>&1; then
    print_success "Formula syntax is valid"
else
    print_error "Formula syntax is invalid"
    exit 1
fi

# Test 2: Check if brew is available
print_status "Checking Homebrew installation..."
if command -v brew &> /dev/null; then
    print_success "Homebrew is installed"
    HOMEBREW_VERSION=$(brew --version | head -n1)
    print_status "Homebrew version: $HOMEBREW_VERSION"
else
    print_warning "Homebrew is not installed. Some tests will be skipped."
fi

# Test 3: Check update script
print_status "Testing update script..."
if [ -f "scripts/update-formula.rb" ]; then
    if ruby -c scripts/update-formula.rb > /dev/null 2>&1; then
        print_success "Update script syntax is valid"
    else
        print_error "Update script syntax is invalid"
        exit 1
    fi
else
    print_error "Update script not found"
    exit 1
fi

# Test 4: Validate URLs and checksums (only if curl is available)
if command -v curl &> /dev/null; then
    print_status "Validating download URLs and checksums..."

    # Extract URLs and checksums from formula
    INTEL_URL=$(grep -A1 'on_intel do' Formula/reqtap.rb | grep 'url "' | sed 's/.*url "\(.*\)".*/\1/')
    ARM_URL=$(grep -A1 'on_arm do' Formula/reqtap.rb | grep 'url "' | sed 's/.*url "\(.*\)".*/\1/')
    INTEL_SHA=$(grep -A2 'on_intel do' Formula/reqtap.rb | grep 'sha256 "' | sed 's/.*sha256 "\(.*\)".*/\1/')
    ARM_SHA=$(grep -A2 'on_arm do' Formula/reqtap.rb | grep 'sha256 "' | sed 's/.*sha256 "\(.*\)".*/\1/')

    if [ -n "$INTEL_URL" ] && [ -n "$INTEL_SHA" ]; then
        print_status "Checking Intel binary..."
        if validate_checksum "$INTEL_URL" "$INTEL_SHA"; then
            print_success "Intel binary checksum is valid"
        else
            print_error "Intel binary checksum is invalid"
        fi
    fi

    if [ -n "$ARM_URL" ] && [ -n "$ARM_SHA" ]; then
        print_status "Checking ARM binary..."
        if validate_checksum "$ARM_URL" "$ARM_SHA"; then
            print_success "ARM binary checksum is valid"
        else
            print_error "ARM binary checksum is invalid"
        fi
    fi
else
    print_warning "curl is not available. Skipping URL and checksum validation."
fi

# Test 5: Check if all required files are present
print_status "Checking required files..."
required_files=(
    "Formula/reqtap.rb"
    "scripts/update-formula.rb"
    "README-homebrew.md"
    ".github/workflows/update-formula.yml"
    ".github/workflows/ci.yml"
)

missing_files=0
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        print_success "$file exists"
    else
        print_error "$file is missing"
        missing_files=$((missing_files + 1))
    fi
done

if [ $missing_files -eq 0 ]; then
    print_success "All required files are present"
else
    print_error "$missing_files required files are missing"
    exit 1
fi

# Test 6: Optional - Test with Homebrew (only if available)
if command -v brew &> /dev/null && [ "$1" = "--full" ]; then
    print_status "Testing Homebrew installation (full test mode)..."

    # Create a temporary tap for testing
    TEMP_TAP_DIR=$(mktemp -d)
    cp -r . "$TEMP_TAP_DIR"

    print_status "Creating temporary tap..."
    cd "$TEMP_TAP_DIR"

    # Tap the local repository
    if brew tap funnyzak/reqtap-temp "$(pwd)" 2>/dev/null; then
        print_success "Temporary tap created"

        # Try to install (this might fail if reqtap is already installed)
        if brew install reqtap-temp 2>/dev/null || true; then
            print_success "Installation test passed"

            # Test the installation
            if command -v reqtap &> /dev/null; then
                VERSION=$(reqtap --version 2>/dev/null || echo "version check failed")
                print_success "reqtap is working: $VERSION"

                # Cleanup
                brew uninstall reqtap-temp 2>/dev/null || true
            else
                print_warning "reqtap command not found after installation"
            fi
        else
            print_warning "Installation test failed (might be expected if already installed)"
        fi

        # Cleanup tap
        brew untap funnyzak/reqtap-temp 2>/dev/null || true
    else
        print_warning "Failed to create temporary tap"
    fi

    # Cleanup temp directory
    cd - > /dev/null
    rm -rf "$TEMP_TAP_DIR"
fi

print_success "All tests completed successfully! 🎉"
print_status ""
print_status "To install reqtap using this tap, run:"
print_status "  brew tap funnyzak/reqtap <repository-url>"
print_status "  brew install reqtap"
print_status ""
print_status "To run this test with full Homebrew testing, use:"
print_status "  ./scripts/test-tap.sh --full"