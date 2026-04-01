#!/usr/bin/env bash
set -euo pipefail

echo "=== Nano-Claw EC2 Bootstrap ==="

# Install Docker
sudo dnf install -y docker
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user
echo "Docker installed. You MUST log out and back in for group membership to take effect."

# Install Node.js 22 via nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install 22
nvm use 22
nvm alias default 22
echo "Node.js $(node -v) installed"

# Verify build tools for better-sqlite3
gcc --version > /dev/null 2>&1 || sudo dnf install -y gcc-c++ make python3
echo "Build tools verified"

# Setup swap
bash setup/swap.sh

echo ""
echo "=== Bootstrap complete ==="
echo "IMPORTANT: Log out and log back in, then run:"
echo "  1. cp .env.example .env  (edit with your ANTHROPIC_API_KEY)"
echo "  2. mkdir -p data/env && cp .env data/env/env"
echo "  3. npm install && npm run build"
echo "  4. bash container/build.sh  (or: docker build -t nanoclaw-agent:latest container/)"
echo "  5. npx tsx setup/index.ts  (runs NanoClaw setup including systemd + OneCLI)"
