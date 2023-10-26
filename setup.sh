#!/bin/bash
set -e

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

    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>/Users/$user/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew is already installed."
fi

# Update homebrew recipes
echo "Updating homebrew..."
brew update

# CLI Apps
cli_apps=(
    git
    autojump
    exa
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

echo "# History
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Highlight the current autocomplete option
zstyle ':completion:*' list-colors \"\${(s.:.)LS_COLORS}\"

# Better SSH/Rsync/SCP Autocomplete
zstyle ':completion:*:(scp|rsync):*' tag-order ' hosts:-ipaddr:ip\ address hosts:-host:host files'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

# Allow for autocomplete to be case insensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Initialize the autocompletion
autoload -U compinit && compinit

# Prompt
autoload -Uz add-zsh-hook vcs_info
setopt prompt_subst
add-zsh-hook precmd vcs_info
PROMPT='%F{cyan}%1~%f %F{red}\${vcs_info_msg_0_}%f %# '
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'
zstyle ':vcs_info:git:*' formats       '(%b%u%c)'
zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c)'

# Aliases
alias vim='nvim'
alias vcfg='vim ~/.config/nvim/init.vim'
alias zcfg='vim ~/.zshrc'
alias zsrc='source ~/.zshrc'
alias rmhist='rm \$HISTFILE && history -p'
alias clhist='history -p'
alias l='exa'
alias la='exa -a'
alias ll='exa -lah'
alias ls='exa --color=auto'
alias s='ssh'
alias gl='(){ git log --oneline -n \$1 | pbcopy }'

# Autojump setup
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

# Plugins
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" > ~/.zshrc

source ~/.zshrc

echo "Done! ✅"
