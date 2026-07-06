# Vi keybindings
bindkey -v

# Make cursor fat and skinny

function zle-keymap-select {
  case $KEYMAP in
    vicmd)      echo -ne '\e[1 q' ;;  # Block (fat) cursor for normal mode
    viins|main) echo -ne '\e[5 q' ;;  # Beam (thin) cursor for insert mode
  esac
}
zle -N zle-keymap-select

# Also trigger cursor change on zsh line start
function zle-line-init {
  zle-keymap-select
}
zle -N zle-line-init

# Enable color formatting for prompt
autoload -U colors && colors

# make ls colorful
# export LSCOLORS=ExGxcxdxCxegedabagacad
# alias ls='ls -G' 

# aliases
alias v="nvim"

# Change prompt style 
NEWLINE=$'\n'
PROMPT="%{$fg[cyan]%}%n@%m %{$fg[green]%}%~ %# %{$reset_color%}"

# Wait less after Esc (units: hundredths of a second) 
export KEYTIMEOUT=1 # 50ms is a good starting point; try 1–10

# Let my shell know where the new Ruby binaries are (installed with rbenv)
eval "$(rbenv init -)"

# Fzf stuff
# fd is a fast, friendly replacement for `find`. fzf shells out to it to build
# its candidate lists very quickly. --strip-cwd-prefix => clean relative paths.
# NOTE: every continuation line needs a trailing backslash (the old config was
# missing one before .DS_Store, which silently broke that exclude).
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --strip-cwd-prefix \
  --exclude .git \
  --exclude Library \
  --exclude node_modules \
  --exclude __pycache__ \
  --exclude .DS_Store'

# Ctrl-T (paste a file path into the command line) reuses the file list above.
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# The cd widget needs DIRECTORIES, not files -> note `--type d`.
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --strip-cwd-prefix \
  --exclude .git \
  --exclude Library \
  --exclude node_modules \
  --exclude __pycache__ \
  --exclude .DS_Store'

# Appearance + previews. cat/ls previews need no extra tools (no bat required).
export FZF_DEFAULT_OPTS="
  --height 60%
  --layout=reverse
  --border
  --inline-info
"
export FZF_CTRL_T_OPTS="--preview '(cat {} 2>/dev/null || ls -la {}) | head -200'"
export FZF_ALT_C_OPTS="--preview 'ls -la {} | head -200'"

# Use nvim to read man pages
export MANPAGER='nvim +Man!'

# SCRIPTS

# script for daily notes

function daily() {
		(
	cd ~/Documents/DailyNotes || exit
	nvim "$(date +%Y-%m-%d).md"
)
}

# script to cd to developing projects
function dev() {
		cd ~/Documents/Developing/
}

function doc() {
		cd ~/Documents/
}

# script for todos
function todo() {
  local file=~/Documents/DailyNotes/todos.md
  if [[ $# -eq 0 ]]; then
    nvim "$file"
    return
  fi
  mkdir -p "${file:h}"
  touch "$file"
  local today="# $(date +%Y-%m-%d)"
  if ! grep -Fxq "$today" "$file"; then
    [[ -s "$file" ]] && echo "" >> "$file"
    echo "$today" >> "$file"
  fi
  echo "$*" >> "$file"
}

# if something is below this I didn't write it

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="$HOME/.local/bin:$PATH"

# ---------------------------------------------------------------------------
# fzf keybindings (defined AFTER sourcing fzf so the widgets exist)
#   ^F  pick a file, paste its path at the cursor      e.g.  v ^F
#   ^G  cd into a directory under the current folder
#   ^R  search command history                         (fzf default)
#   **  fuzzy-complete a TYPED path, then press TAB:
#         mv ~/Downloads/**<TAB> .          (grab a file from Downloads)
#         mv report.pdf ~/Documents/**<TAB> (fuzzy-pick a destination)
#         cd ~/Documents/**<TAB>            (fuzzy-pick a dir to enter)
# (Alt/Option is unreliable on macOS, so the cd widget is on ^G, not Alt-C.)
# ---------------------------------------------------------------------------
bindkey '^F' fzf-file-widget
bindkey '^G' fzf-cd-widget

# dotcheck: verify every tracked dotfile is still symlinked into the repo.
# Catches the rare case where an editor replaced a symlink with a real copy
# (a "detached" config). Run it after big editor/app config changes.
# Locates the repo by following ~/.zshrc's own symlink, so it works no matter
# where the repo was cloned. Override with: export DOTFILES_DIR=/path/to/repo
dotcheck() {
  local link="$HOME/.zshrc" repo
  repo="${DOTFILES_DIR:-${link:A:h}}"   # :A resolve symlink, :h strip filename
  [[ -x "$repo/hooks/pre-push" ]] || { echo "no dotfiles repo found (looked in $repo)"; return 1; }
  "$repo/hooks/pre-push" && echo "all tracked dotfiles linked ✔"
}

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/jplk/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/jplk/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/jplk/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/jplk/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

