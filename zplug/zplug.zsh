source ~/.zplug/init.zsh

# Setup powerlevel9k
POWERLEVEL9K_MODE='awesome-patched'
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="%{%F{249}%}\u250f"
POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX="%{%F{249}%}\u2517%{%F{default}%} "
POWERLEVEL9K_SHORTEN_DIR_LENGTH=4
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"
POWERLEVEL9K_OS_ICON_BACKGROUND="black"
POWERLEVEL9K_OS_ICON_FOREGROUND="249"
POWERLEVEL9K_TODO_BACKGROUND="black"
POWERLEVEL9K_TODO_FOREGROUND="249"
POWERLEVEL9K_DIR_HOME_BACKGROUND="black"
POWERLEVEL9K_DIR_HOME_FOREGROUND="249"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="black"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="249"
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="black"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="249"
POWERLEVEL9K_STATUS_OK_BACKGROUND="black"
POWERLEVEL9K_STATUS_OK_FOREGROUND="green"
POWERLEVEL9K_STATUS_ERROR_BACKGROUND="black"
POWERLEVEL9K_STATUS_ERROR_FOREGROUND="red"
POWERLEVEL9K_NVM_BACKGROUND="black"
POWERLEVEL9K_NVM_FOREGROUND="249"
POWERLEVEL9K_NVM_VISUAL_IDENTIFIER_COLOR="green"
POWERLEVEL9K_RVM_BACKGROUND="black"
POWERLEVEL9K_RVM_FOREGROUND="249"
POWERLEVEL9K_RVM_VISUAL_IDENTIFIER_COLOR="red"
POWERLEVEL9K_LOAD_CRITICAL_BACKGROUND="black"
POWERLEVEL9K_LOAD_WARNING_BACKGROUND="black"
POWERLEVEL9K_LOAD_NORMAL_BACKGROUND="black"
POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND="249"
POWERLEVEL9K_LOAD_WARNING_FOREGROUND="249"
POWERLEVEL9K_LOAD_NORMAL_FOREGROUND="249"
POWERLEVEL9K_LOAD_CRITICAL_VISUAL_IDENTIFIER_COLOR="red"
POWERLEVEL9K_LOAD_WARNING_VISUAL_IDENTIFIER_COLOR="yellow"
POWERLEVEL9K_LOAD_NORMAL_VISUAL_IDENTIFIER_COLOR="green"
POWERLEVEL9K_RAM_BACKGROUND="black"
POWERLEVEL9K_RAM_FOREGROUND="249"
POWERLEVEL9K_RAM_ELEMENTS=(ram_free)
POWERLEVEL9K_BATTERY_LOW_BACKGROUND="black"
POWERLEVEL9K_BATTERY_CHARGING_BACKGROUND="black"
POWERLEVEL9K_BATTERY_CHARGED_BACKGROUND="black"
POWERLEVEL9K_BATTERY_DISCONNECTED_BACKGROUND="black"
POWERLEVEL9K_BATTERY_LOW_FOREGROUND="249"
POWERLEVEL9K_BATTERY_CHARGING_FOREGROUND="249"
POWERLEVEL9K_BATTERY_CHARGED_FOREGROUND="249"
POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND="249"
POWERLEVEL9K_BATTERY_LOW_VISUAL_IDENTIFIER_COLOR="red"
POWERLEVEL9K_BATTERY_CHARGING_VISUAL_IDENTIFIER_COLOR="yellow"
POWERLEVEL9K_BATTERY_CHARGED_VISUAL_IDENTIFIER_COLOR="green"
POWERLEVEL9K_BATTERY_DISCONNECTED_VISUAL_IDENTIFIER_COLOR="249"
POWERLEVEL9K_TIME_BACKGROUND="black"
POWERLEVEL9K_TIME_FOREGROUND="249"
POWERLEVEL9K_TIME_FORMAT="%D{%H:%M:%S} \UE12E"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=('status' 'os_icon' 'todo' 'dir' 'vcs')
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=('nvm' 'rvm' 'load' 'ram_joined' 'battery' 'time')
NVM_LAZY_LOAD=true


zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "zsh-users/zsh-history-substring-search"

# Plugins from oh-my-zsh

zplug "plugins/command-not-found", from:oh-my-zsh
zplug "plugins/common-aliases", from:oh-my-zsh
zplug "plugins/compleat", from:oh-my-zsh
zplug "plugins/composer", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/git-extras", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/github", from:oh-my-zsh
zplug "plugins/gitignore", from:oh-my-zsh
zplug "plugins/gulp", from:oh-my-zsh
zplug "plugins/node", from:oh-my-zsh
zplug "plugins/osx", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh
zplug "plugins/vagrant", from:oh-my-zsh
zplug "plugins/rbenv", from:oh-my-zsh

# Load if "if" tag returns true
zplug "lib/clipboard", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"

zplug "b4b4r07/httpstat", \
    as:command, \
    use:'*.sh', \
    rename-to:'httpstat'

# Set the priority when loading
# e.g., zsh-syntax-highlighting must be loaded
# after executing compinit command and sourcing other plugins
# (If the defer tag is given 2 or above, run after compinit command)
zplug "zsh-users/zsh-syntax-highlighting", defer:2

zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme

# Install plugins if there are plugins that have not been installed
if ! zplug check; then
  echo; zplug install
fi

zplug load
