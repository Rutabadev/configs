# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# NVM config
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  npm
  zsh-vi-mode
  fzf
  fzf-tab
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Save commands history
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory

# Allow regex in backward search
bindkey '^R' history-incremental-pattern-search-backward

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

############
# Commands #
############

# Usage : dock node .
function dock() {
  if [[ "$1" == "npm" || "$1" == "npx" || "$1" == "node" ]]; then
    docker run -it -v $(pwd):/srv -w /srv node:14.21.3 "$@"
    return
  fi
  echo "unknown docker command"
}
alias dock=dock

function dock-clean() {
  docker rm --force $(docker ps --all -q)
}
alias dock-clean=dock-clean

alias gll='i=0; while [ $? -eq 0 ]; do i=$((i+1)); echo -n "@{-$i} "; git rev-parse --symbolic-full-name @{-$i} 2> /dev/null; done | head -n 10'

# Not used anymore since I have "npx get-commits" but keeping this for posterity 
function chang() {
  # Check if there are any tags
  tagsNumber=$(git tag --sort=-v:refname | wc -l)
  if [ ${tagsNumber} -eq 0 ]; then
      echo "No tags found."
      return 1
  fi

  # Use fzf to present the options and get the selected value
  final_tag=$(git tag --sort=-v:refname | head -10 | fzf --prompt="Final tag")

  first_tag=$(git tag --sort=-v:refname | head -11 | grep -vF "$final_tag" | fzf --prompt="First tag")

  echo $(git --no-pager log $first_tag..$final_tag --pretty=format:'%s')
  if [ $(git --no-pager log $first_tag..$final_tag --pretty=format:'%s' | wc -l) -eq 0 ]; then
    echo "No commits between these tags ($first_tag -> $final_tag)";
    return 1;
   fi
  git --no-pager log $first_tag..$final_tag --pretty=format:'%s' | pbcopy

  echo "Changelog between $first_tag and $final_tag copied to clipboard"
}

eval "$(starship init zsh)"
