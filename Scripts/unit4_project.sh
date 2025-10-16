#!/bin/bash
set -e  # Exit on any error

red='\033[0;31m'
green='\033[0;32m'
none='\033[0m'

echo "[UNIT 4 PROJECT] Starting script..."

# If slowloris is already usable from PATH, exit early (keeps behavior familiar/simple)
if command -v slowloris &> /dev/null || command -v slowloris-run &> /dev/null; then
    echo -e "${green}[UNIT 4 PROJECT]${none} Slowloris is already installed and available."
    exit 0
fi

# Remove CD-ROM source if it exists (common issue in VMs) — backup first
cdrom_pattern='^\s*deb\s+cdrom:'
sources_file="/etc/apt/sources.list"
if sudo grep -qE "$cdrom_pattern" "$sources_file" 2>/dev/null; then
    echo "[UNIT 4 PROJECT] Backing up apt sources and commenting cdrom entries..."
    sudo cp "$sources_file" "${sources_file}.bak" || true
    sudo sed -ri 's@^\s*(deb\s+cdrom:)@# \1@' "$sources_file"
fi

# Skipping apt update for stability on lab machines
echo "[UNIT 4 PROJECT] Skipping apt update (lab machines pre-provisioned)."
sudo apt install -y python3 python3-venv python3-pip nginx curl ca-certificates lsb-release --fix-missing || true

# Install required dependencies (use distro packages only)
echo "[UNIT 4 PROJECT] Installing required dependencies..."
sudo apt install -y python3 python3-venv python3-pip nginx curl ca-certificates lsb-release

# Ensure NGINX is installed and running
echo "[UNIT 4 PROJECT] Installing NGINX..."
sudo apt install -y nginx
# Try to enable and start nginx (non-fatal if systemctl not available)
if command -v systemctl &> /dev/null; then
  sudo systemctl enable --now nginx || true
fi

# Configure NGINX stub_status for Netdata monitoring
echo "[UNIT 4 PROJECT] Configuring NGINX stub_status endpoint for monitoring..."
NGINX_CONF="/etc/nginx/conf.d/stub_status.conf"
sudo tee "$NGINX_CONF" > /dev/null <<'EOF'
server {
    listen 127.0.0.1:8090;
    server_name 127.0.0.1;

    location /nginx_status {
        stub_status;
        allow 127.0.0.1;
        deny all;
    }
}
EOF

# Test NGINX config and reload
if sudo nginx -t &>/dev/null; then
    sudo systemctl reload nginx || sudo nginx -s reload
    echo -e "${green}[UNIT 4 PROJECT]${none} NGINX stub_status enabled on http://127.0.0.1:8090/nginx_status"
else
    echo -e "${red}[UNIT 4 PROJECT]${none} Warning: failed to validate NGINX config; stub_status not applied."
fi

# Set up a per-user virtual environment for Slowloris (safe, non-system-modifying)
VENV_DIR="$HOME/.local/venvs/unit4_slowloris"
echo "[UNIT 4 PROJECT] Setting up Python virtual environment at $VENV_DIR ..."
mkdir -p "$(dirname "$VENV_DIR")"
if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
fi

# Attempt to detect slowloris inside the venv first, else install into venv
echo "[UNIT 4 PROJECT] Attempting Slowloris install in a user virtualenv..."
# shellcheck disable=SC1090
source "$VENV_DIR/bin/activate"
python -m pip install --upgrade pip setuptools wheel >/dev/null
if python -m pip show slowloris &> /dev/null; then
    echo -e "${green}[UNIT 4 PROJECT]${none} Slowloris already present in the virtualenv."
else
    python -m pip install slowloris
fi
deactivate

# Create a simple wrapper so students can call slowloris easily
LOCAL_BIN="$HOME/.local/bin"
WRAPPER="$LOCAL_BIN/slowloris-run"
mkdir -p "$LOCAL_BIN"
cat > "$WRAPPER" <<'EOF'
#!/usr/bin/env bash
VENV="$HOME/.local/venvs/unit4_slowloris"
if [ ! -d "$VENV" ]; then
  echo "[UNIT 4 PROJECT] Error: virtualenv not found at $VENV"
  exit 1
fi
# shellcheck disable=SC1090
source "$VENV/bin/activate"
exec slowloris "$@"
EOF
chmod +x "$WRAPPER"

# Put ~/.local/bin on PATH for future shells if not present (append to ~/.profile)
PROFILE="$HOME/.profile"
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$PROFILE" 2>/dev/null; then
    echo "[UNIT 4 PROJECT] Adding ~/.local/bin to PATH in ~/.profile..."
    {
        echo ""
        echo "# Added by UNIT 4 setup script: make user-local bin available"
        echo 'export PATH="$HOME/.local/bin:$PATH"'
    } >> "$PROFILE"
else
    echo "[UNIT 4 PROJECT] ~/.local/bin already on PATH in $PROFILE."
fi

# Verify installation: check wrapper exists and slowloris is present in venv
if [ -x "$WRAPPER" ] && "$WRAPPER" --help >/dev/null 2>&1; then
    echo -e "${green}[UNIT 4 PROJECT]${none} Slowloris successfully installed (use 'slowloris-run')."
    exit 0
else
    echo -e "${red}[UNIT 4 PROJECT]${none} ERROR: Slowloris did not install correctly!"
    exit 1
fi
