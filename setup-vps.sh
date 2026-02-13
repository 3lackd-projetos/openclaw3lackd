#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting OpenClaw VPS Setup...${NC}"

# 1. Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Please run as root (sudo ./setup-vps.sh)${NC}"
  exit 1
fi

# 2. Create openclaw user if it doesn't exist
USERNAME="openclaw"
if id "$USERNAME" &>/dev/null; then
    echo "User $USERNAME already exists."
else
    echo "Creating user $USERNAME..."
    useradd -m -s /bin/bash "$USERNAME"
    # Set a default password or leave it locked (using sudo without password below)
    # echo "$USERNAME:password" | chpasswd
fi

# 3. Configure passwordless sudo for openclaw
echo "Configuring passwordless sudo for $USERNAME..."
echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME
chmod 0440 /etc/sudoers.d/$USERNAME

# 4. Install system dependencies
echo "Installing system dependencies..."
apt-get update
apt-get install -y curl git build-essential

# 5. Fix permissions for project directory
PROJECT_DIR="/opt/openclaw3lackd"
if [ -d "$PROJECT_DIR" ]; then
    echo "Fixing permissions for $PROJECT_DIR..."
    chown -R $USERNAME:$USERNAME "$PROJECT_DIR"
else
    echo -e "${RED}Project directory $PROJECT_DIR not found! Please clone the repo first.${NC}"
    exit 1
fi

# 6. Install Homebrew (as openclaw user)
echo "Checking/Installing Homebrew..."
# Create directory for brew if it doesn't exist to avoid permission issues during install script
mkdir -p /home/linuxbrew/.linuxbrew
chown -R $USERNAME:$USERNAME /home/linuxbrew/.linuxbrew

su - "$USERNAME" -c '
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add to .bashrc
        echo "Adding brew to .bashrc..."
        (echo; echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"") >> ~/.bashrc
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    else
        echo "Homebrew already installed."
    fi
    
    # Reload shellenv for this session
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    # Install GCC recommended by brew
    echo "Installing GCC via brew..."
    brew install gcc
'

# 7. Install Project Dependencies (pnpm)
echo "Installing project dependencies..."
su - "$USERNAME" -c "
    cd $PROJECT_DIR
    # Ensure pnpm is installed (using npm coming from nodejs or brew)
    if ! command -v pnpm &> /dev/null; then
        echo "Installing pnpm..."
        npm install -g pnpm
    fi
    
    echo "Running pnpm install..."
    pnpm install
    
    echo "Running pnpm build..."
    pnpm build
    
    echo "Linking openclaw CLI..."
    # npm link requires sudo if node is system installed, but strictly we want it for the user
    # If node is from brew, no sudo needed. If from apt, sudo needed.
    # We gave sudo NOPASSWD so this should work either way.
    sudo npm link
"

echo -e "${GREEN}Setup complete!${NC}"
echo "You can now run the service or switch user: su - $USERNAME"
