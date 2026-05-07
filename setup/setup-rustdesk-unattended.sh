#!/bin/bash
set -e

CONFIG_DIR="$HOME/.config/rustdesk"

check_rustdesk() {
    if command -v rustdesk &>/dev/null; then
        return 0
    fi
    if [ -x /usr/bin/rustdesk ] || [ -x /usr/local/bin/rustdesk ]; then
        return 0
    fi
    if command -v dpkg &>/dev/null && dpkg -l rustdesk &>/dev/null 2>&1; then
        return 0
    fi
    if command -v rpm &>/dev/null && rpm -q rustdesk &>/dev/null 2>&1; then
        return 0
    fi
    if command -v flatpak &>/dev/null && flatpak list --app 2>/dev/null | grep -qi rustdesk; then
        return 0
    fi
    if command -v snap &>/dev/null && snap list rustdesk &>/dev/null 2>&1; then
        return 0
    fi
    return 1
}

read -rsp "Enter permanent password for RustDesk: " PASSWORD
echo

if ! check_rustdesk; then
    echo "RustDesk not found. Installing..."
    if command -v apt &>/dev/null; then
        curl -fsSL https://get.rustdesk.com | bash
    elif command -v dnf &>/dev/null; then
        curl -fsSL https://get.rustdesk.com | bash
    elif command -v zypper &>/dev/null; then
        curl -fsSL https://get.rustdesk.com | bash
    elif command -v pacman &>/dev/null; then
        if command -v yay &>/dev/null; then
            yay -S --noconfirm rustdesk
        elif command -v paru &>/dev/null; then
            paru -S --noconfirm rustdesk
        else
            curl -fsSL https://get.rustdesk.com | bash
        fi
    else
        curl -fsSL https://get.rustdesk.com | bash
    fi
    if ! check_rustdesk; then
        echo "Installation may have failed - rustdesk binary not found after install." >&2
        exit 1
    fi
fi

echo "Setting permanent password..."
sudo rustdesk --password "$PASSWORD"

mkdir -p "$CONFIG_DIR"

RUSTDESK2="$CONFIG_DIR/RustDesk2.toml"
if grep -q '^\[options\]' "$RUSTDESK2" 2>/dev/null; then
    if grep -q 'verification-method' "$RUSTDESK2"; then
        sed -i 's/verification-method = .*/verification-method = '\''use-permanent-password'\''/' "$RUSTDESK2"
    else
        sed -i '/^\[options\]/a verification-method = '\''use-permanent-password'\''' "$RUSTDESK2"
    fi
else
    cat >> "$RUSTDESK2" << 'EOF'

[options]
verification-method = 'use-permanent-password'
EOF
fi

echo "RustDesk unattended access configured."
echo "ID:       $(rustdesk --get-id 2>/dev/null || echo 'check RustDesk window')"
echo "Password: $PASSWORD"
