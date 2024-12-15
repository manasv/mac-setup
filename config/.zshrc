# History
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
alias l='eza'
alias la='eza -a'
alias ll='eza -lah'
alias ls='eza --color=auto'
alias s='ssh'
alias gl='(){ git log --oneline -n \$1 | pbcopy }'

# Autojump setup
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

# Plugins
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh