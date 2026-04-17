#!/usr/bin/env bash

set -e

INSTALL_DIR="$HOME/.local/bin"
SCRIPT_NAME="validate-helm"

echo "📦 Installing Helm Validator..."

mkdir -p "$INSTALL_DIR"

# Copy script
cp validate-helm.sh "$INSTALL_DIR/$SCRIPT_NAME"
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

# Detect shell config
if [ -n "$ZSH_VERSION" ]; then
  SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
  SHELL_RC="$HOME/.bashrc"
else
  SHELL_RC="$HOME/.profile"
fi

# Add to PATH if not already there
if ! grep -q "$INSTALL_DIR" "$SHELL_RC"; then
  echo "" >> "$SHELL_RC"
  echo "# Added by Helm Validator installer" >> "$SHELL_RC"
  echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$SHELL_RC"
  echo "✅ Added $INSTALL_DIR to PATH in $SHELL_RC"
fi

echo ""
echo "✅ Installation complete!"
echo "👉 Restart your terminal or run: source $SHELL_RC"
echo "👉 Then run: validate-helm"