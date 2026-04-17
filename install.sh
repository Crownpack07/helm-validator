#!/usr/bin/env bash

set -e

INSTALL_DIR="$HOME/global-scripts"
SCRIPT_NAME="validate-helm.sh"
ALIAS_NAME="validate-helm"

echo "📦 Installing Helm Validator..."

mkdir -p "$INSTALL_DIR"

# Copy script as a .sh file and make it executable
cp validate-helm.sh "$INSTALL_DIR/$SCRIPT_NAME"
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

# Detect shell config
if [ -n "$ZSH_VERSION" ]; then
  SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
  SHELL_RC="$HOME/.bashrc"
elif [ -f "$HOME/.bash_profile" ]; then
  SHELL_RC="$HOME/.bash_profile"
else
  SHELL_RC="$HOME/.profile"
fi

# Add alias if not already present
if ! grep -qE "^alias $ALIAS_NAME=" "$SHELL_RC"; then
  echo "" >> "$SHELL_RC"
  echo "# Added by Helm Validator installer" >> "$SHELL_RC"
  echo "alias $ALIAS_NAME=\"$INSTALL_DIR/$SCRIPT_NAME\"" >> "$SHELL_RC"
  echo "✅ Added alias $ALIAS_NAME to $SHELL_RC"
fi

echo ""
echo "✅ Installation complete!"
echo "👉 Installed: $INSTALL_DIR/$SCRIPT_NAME"
echo "👉 Restart your terminal or run: source $SHELL_RC"
echo "👉 Then run: $ALIAS_NAME"