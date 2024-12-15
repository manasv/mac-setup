#!/bin/bash

echo -n "Enter a comment for your ssh key (e.g. your email): "
read ssh_comment
echo -n "Enter a name for your ssh key: "
read ssh_key_name

echo "Creating an SSH key for you..."
ssh-keygen -t ed25519 -C "$ssh_comment" -f $ssh_key_name
mkdir ~/.ssh
mv "$ssh_key_name" "$ssh_key_name.pub" ~/.ssh
echo "Your SSH key ($ssh_key_name) was moved to ~/.ssh"

echo "Host bitbucket
    Hostname bitbucket.org
    IdentityFile ~/.ssh/$ssh_key_name
    UseKeychain yes
    AddKeysToAgent yes
    
    Host github
    Hostname github.com
    IdentityFile ~/.ssh/$ssh_key_name
    UseKeychain yes
    AddKeysToAgent yes
    " > ~/.ssh/config

echo "Please add this public key to your preferred version control platform"
echo "https://github.com/settings/keys"
echo "https://bitbucket.org/account/settings/ssh-keys/"
echo "https://gitlab.com/-/profile/keys"

echo "Installing Xcode Command Line Tools"
xcode-select --install

# Check for Homebrew,
# Install if we don't have it
if ! [ -x "$(command -v brew)" ]; then
    echo "Installing homebrew... 🍺"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew is already installed."
    local homebrew_init='eval "$(/opt/homebrew/bin/brew shellenv)"'

    if ! grep -qF $homebrew_init ~/.zprofile; then
        echo $homebrew_init >> ~/.zprofile
    fi

    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Update homebrew recipes
echo "Updating homebrew..."
brew update
echo "Enabling alternate versions of casks"
brew tap homebrew/cask-versions

# CLI Apps
cli_apps=(
    git
    autojump
    eza
    mas
    htop
    neovim
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Desktop Apps
desktop_apps=(
    discord
    firefox-developer-edition
    fork
    iterm2
    raycast
    slack
    telegram
    visual-studio-code
    xcodes
)

# Desktop Apps
appstore_apps=(
    441258766  #Magnet
    905953485  #NordVPN
    937984704  #Amphetamine
    1465439395 #Dark Noise
    904280696  #Things
    639968404  #Parcel
)

# Install CLI Apps
echo "Installing CLI apps"
brew install ${cli_apps[@]}

# Install Desktop Apps
echo "Installing desktop apps"
brew install --cask ${desktop_apps[@]}

# Install Appstore only apps
echo "Installing AppStore apps"
mas install ${appstore_apps[@]}

echo "Configuring Git global settings"

echo -n "Enter your name: "
read name
git config --global user.name "$name"

echo -n "Enter your email: "
read email
git config --global user.email "$email"

# Mac Settings
echo "Setting some Mac settings..."

# Dock
defaults write com.apple.dock "autohide" -bool "true"
defaults write com.apple.dock "show-recents" -bool "false"
defaults write com.apple.dock minimize-to-application -bool "true"

killall Dock

# Finder
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
defaults write com.apple.finder "ShowPathbar" -bool "true"
defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"
defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"
defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"

defaults write com.apple.finder "_FXSortFoldersFirstOnDesktop" -bool "true"
defaults write com.apple.menuextra.clock "DateFormat" -string "\"EEE d MMM HH:mm:ss\""

killall Finder

# Xcode
defaults write com.apple.dt.Xcode "ShowBuildOperationDuration" -bool "true"

killall Xcode

# Cleanup
echo "Cleaning up brew..."
brew cleanup

# Copy the existing .zshrc file from the config directory to the home directory
cp config/.zshrc ~/.zshrc

source ~/.zshrc

echo "Done! ✅"
