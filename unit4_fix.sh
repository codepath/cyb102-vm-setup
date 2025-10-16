#!/bin/bash
# uninstall_unit4.sh — clean uninstall/reset for Unit 4 project setup
set -euo pipefail

red='\033[0;31m'
green='\033[0;32m'
none='\033[0m'

echo "[F25 UNIT 4 FIX] Starting uninstall..."

# --- Stop/disable nginx if present ---
echo "[F25 UNIT 4 FIX] Stopping NGINX if running..."
if command -v systemctl &>/dev/null; then
  sudo systemctl stop nginx 2>/dev/null || true
  sudo systemctl disable nginx 2>/dev/null || true
fi

# --- Remove any Unit-4 nginx config we may have added (stub_status, etc.) ---
echo "[F25 UNIT 4 FIX] Removing NGINX Unit 4 configs..."
sudo rm -f /etc/nginx/conf.d/stub_status.conf 2>/dev/null || true

# --- Purge nginx packages (distro nginx) ---
echo "[F25 UNIT 4 FIX] Purging NGINX packages..."
sudo apt purge -y nginx nginx-common 2>/dev/null || true
sudo apt autoremove -y 2>/dev/null || true

# --- Remove nginx.org upstream repository and pin/key if added by original script ---
echo "[F25 UNIT 4 FIX] Cleaning nginx.org repository and key (if present)..."
sudo rm -f /etc/apt/sources.list.d/nginx.list 2>/dev/null || true
sudo rm -f /etc/apt/preferences.d/99nginx 2>/dev/null || true
sudo rm -f /usr/share/keyrings/nginx-archive-keyring.gpg 2>/dev/null || true

# NOTE: We intentionally do NOT run a global `apt update` here to avoid
# triggering unrelated broken repos/keys on older lab machines.

# --- Remove Slowloris from a venv (newer installer path) ---
VENV_DIR="$HOME/.local/venvs/unit4_slowloris"
if [ -d "$VENV_DIR" ]; then
  echo "[F25 UNIT 4 FIX] Removing Slowloris virtual environment..."
  rm -rf "$VENV_DIR"
fi

# --- Remove wrapper script added by newer installer ---
WRAPPER="$HOME/.local/bin/slowloris-run"
if [ -f "$WRAPPER" ]; then
  echo "[F25 UNIT 4 FIX] Removing slowloris-run wrapper..."
  rm -f "$WRAPPER"
fi

# --- Remove PATH line added by newer installer ---
PROFILE="$HOME/.profile"
if grep -q '# Added by UNIT 4 setup script:' "$PROFILE" 2>/dev/null; then
  echo "[F25 UNIT 4 FIX] Cleaning PATH lines from ~/.profile..."
  sed -i '/# Added by UNIT 4 setup script:/,+2d' "$PROFILE"
fi

# --- Uninstall Slowloris that may have been installed system-wide via sudo pip3 (original script path) ---
echo "[F25 UNIT 4 FIX] Attempting to uninstall system-wide Slowloris (pip as root)..."
# Try multiple common invocations; ignore failures to keep idempotent
sudo python3 -m pip uninstall -y slowloris 2>/dev/null || true
sudo pip3 uninstall -y slowloris 2>/dev/null || true

# --- Uninstall user-level Slowloris (in case original script fell back to --user) ---
echo "[F25 UNIT 4 FIX] Attempting to uninstall user-site Slowloris..."
python3 -m pip uninstall -y slowloris 2>/dev/null || true
pip3 uninstall -y slowloris 2>/dev/null || true

# --- Remove any leftover slowloris executables from common locations ---
echo "[F25 UNIT 4 FIX] Removing stray slowloris executables (if any)..."
for CAND in \
  "$HOME/.local/bin/slowloris" \
  /usr/local/bin/slowloris \
  /usr/bin/slowloris
do
  if [ -f "$CAND" ] || [ -L "$CAND" ]; then
    sudo rm -f "$CAND" 2>/dev/null || rm -f "$CAND" 2>/dev/null || true
  fi
done

echo -e "${green}[F25 UNIT 4 FIX]${none} Uninstall/reset complete."

# --- Optional: automatically re-run the Unit 4 installer (kept from your original flow) ---
echo "[F25 UNIT 4 FIX] Reinstalling Unit 4 setup..."
# You can swap this URL to whichever script you want students to run.
# (If you prefer the safer venv-based script, point to that instead.)
wget -q "https://raw.githubusercontent.com/codepath/cyb102-vm-setup/main/Scripts/unit4_project.sh" -O unit4_project.sh
chmod +x unit4_project.sh
./unit4_project.sh