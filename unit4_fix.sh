#!/bin/bash
# uninstall_unit4.sh — clean uninstall/reset for Unit 4 project setup
set -e

red='\033[0;31m'
green='\033[0;32m'
none='\033[0m'

echo "[F25 UNIT 4 FIX] Starting uninstall..."

# Stop and remove nginx (ignore errors if not installed)
echo "[F25 UNIT 4 FIX] Removing NGINX..."
if command -v systemctl &>/dev/null; then
  sudo systemctl stop nginx 2>/dev/null || true
  sudo systemctl disable nginx 2>/dev/null || true
fi
sudo apt purge -y nginx nginx-common 2>/dev/null || true
sudo apt autoremove -y 2>/dev/null || true

# Remove the Slowloris virtual environment
VENV_DIR="$HOME/.local/venvs/unit4_slowloris"
if [ -d "$VENV_DIR" ]; then
  echo "[F25 UNIT 4 FIX] Removing Slowloris virtual environment..."
  rm -rf "$VENV_DIR"
fi

# Remove the wrapper script
WRAPPER="$HOME/.local/bin/slowloris-run"
if [ -f "$WRAPPER" ]; then
  echo "[F25 UNIT 4 FIX] Removing slowloris-run wrapper..."
  rm -f "$WRAPPER"
fi

# Remove PATH entry from ~/.profile if it was added by the installer
PROFILE="$HOME/.profile"
if grep -q '# Added by UNIT 4 setup script:' "$PROFILE" 2>/dev/null; then
  echo "[F25 UNIT 4 FIX] Cleaning PATH lines from ~/.profile..."
  sed -i '/# Added by UNIT 4 setup script:/,+2d' "$PROFILE"
fi

echo -e "${green}[F25 UNIT 4 FIX]${none} Uninstall complete. Now reinstalling Unit 4."

# Download and run project install  script
wget "https://raw.githubusercontent.com/codepath/cyb102-vm-setup/main/Scripts/unit4_project.sh"
chmod +x unit4_project.sh
./unit4_project.sh