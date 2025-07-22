#!/bin/zsh

set -e
# Zsh-specific options for script compatibility
setopt SH_WORD_SPLIT  # Make word splitting behave like bash
setopt POSIX_ALIASES  # Make aliases behave like bash

# Function to set up SSH keys
setup_ssh() {
    echo "--- Setting up SSH ---"
    if [ ! -d "$HOME/.ssh" ]; then
        mkdir -p "$HOME/.ssh"
        chmod 700 "$HOME/.ssh"
    fi

    read -p "Enter a comment for your SSH key (e.g., your email): " ssh_comment
    read -p "Enter a name for your SSH key (default: id_ed25519): " ssh_key_name
    ssh_key_name=${ssh_key_name:-id_ed25519}
    local ssh_key_path="$HOME/.ssh/$ssh_key_name"

    if [ -f "$ssh_key_path" ]; then
        echo "SSH key $ssh_key_path already exists."
    else
        echo "Creating an SSH key for you..."
        ssh-keygen -t ed25519 -C "$ssh_comment" -f "$ssh_key_path"
        echo "Your SSH key ($ssh_key_name) was created in ~/.ssh"
    fi

    local ssh_config_path="$HOME/.ssh/config"
    if [ ! -f "$ssh_config_path" ]; then
        touch "$ssh_config_path"
    fi

    # Add common Git hosts
    local hosts=("github.com" "bitbucket.org")
    for host in "${hosts[@]}"; do
        if ! grep -q "Host $host" "$ssh_config_path"; then
            echo "Adding $host to SSH config..."
            {
                echo "Host $host"
                echo "    Hostname $host"
                echo "    IdentityFile $ssh_key_path"
                echo "    UseKeychain yes"
                echo "    AddKeysToAgent yes"
                echo ""
            } >> "$ssh_config_path"
        else
            echo "$host already configured in SSH config."
        fi
    done

    echo "Please add this public key to your preferred version control platform:"
    cat "$ssh_key_path.pub"
    echo "https://github.com/settings/keys"
    echo "https://bitbucket.org/account/settings/ssh-keys/"
    echo "https://gitlab.com/-/profile/keys"
    echo "--------------------"
}

# Function to install Homebrew and its dependencies
install_homebrew() {
    echo "--- Installing Homebrew ---"
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew... 🍺"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH
        (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> "$HOME/.zprofile"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo "Homebrew is already installed."
    fi
    
    # Update Homebrew
    echo "Updating Homebrew..."
    brew update
    echo "--------------------"
}

# Function to install packages from Brewfile
install_packages() {
    echo "--- Installing Packages from Brewfile ---"
    if [ -f "Brewfile" ]; then
        brew bundle --file="./Brewfile"
    else
        echo "Brewfile not found. Skipping package installation."
    fi
    echo "--------------------"
}

# Function to configure Git global settings
configure_git() {
    echo "--- Configuring Git ---"
    read -p "Enter your name for Git: " name
    git config --global user.name "$name"

    read -p "Enter your email for Git: " email
    git config --global user.email "$email"
    echo "--------------------"
}

# Function to set macOS defaults
configure_macos() {
    echo "--- Configuring macOS Settings ---"
    
    # Dock - Clear all icons and configure settings
    echo "Clearing all dock icons..."
    defaults write com.apple.dock persistent-apps -array
    defaults write com.apple.dock persistent-others -array
    defaults write com.apple.dock "autohide" -bool "true"
    defaults write com.apple.dock "show-recents" -bool "false"
    defaults write com.apple.dock minimize-to-application -bool "true"
    killall Dock || true
    
    # Finder
    defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
    defaults write com.apple.finder "ShowPathbar" -bool "true"
    killall Finder || true

    # Xcode
    defaults write com.apple.dt.Xcode "ShowBuildOperationDuration" -bool "true"
    killall Xcode || true
    
    echo "--------------------"
}

# Function to set up Zsh configuration
setup_zsh() {
    echo "--- Setting up Zsh ---"
    local zshrc_source="config/.zshrc"
    local zshrc_dest="$HOME/.zshrc"

    if [ -f "$zshrc_dest" ]; then
        echo "Backing up existing .zshrc to .zshrc.bak"
        mv "$zshrc_dest" "$zshrc_dest.bak"
    fi

    if [ -f "$zshrc_source" ]; then
        cp "$zshrc_source" "$zshrc_dest"
        echo ".zshrc copied to home directory."
        source "$zshrc_dest"
    else
        echo "Source .zshrc not found in 'config' directory."
    fi
    echo "--------------------"
}

# Function to install Xcode Command Line Tools
install_xcode_tools() {
    echo "--- Installing Xcode Command Line Tools ---"
    if ! xcode-select -p &> /dev/null; then
        echo "Installing Xcode Command Line Tools..."
        # This will open a prompt, user interaction is required
        xcode-select --install
    else
        echo "Xcode Command Line Tools are already installed."
    fi
    echo "--------------------"
}

# Main function to run all setup steps
main() {
    echo "Starting Mac Setup..."
    
    setup_ssh
    install_xcode_tools
    install_homebrew
    install_packages
    configure_git
    configure_macos
    setup_zsh

    echo "Cleaning up brew..."
    brew cleanup
    
    echo "Done! ✅"
}

main
