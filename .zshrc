# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
  export ZSH=~/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="rkj-repos-custom"

# Uncomment the following line to use case-sensitive completion.
#CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_ignore_dups
setopt share_history

setopt auto_cd
function chpwd() { ls }

setopt share_history

stty -ixon -ixoff

export GTAGSCONF=/usr/local/share/gtags/gtags.conf
export GTAGSLABEL=pygments

# added by Anaconda3 4.3.1 installer
export PATH="/opt/anaconda3/bin:$PATH"

if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs
  zstyle ':completion:*:*:cdr:*:*' menu selection
  zstyle ':completion:*' recent-dirs-insert both
  zstyle ':chpwd:*' recent-dirs-max 500
  zstyle ':chpwd:*' recent-dirs-default true
  zstyle ':chpwd:*' recent-dirs-file "${XDG_CACHE_HOME:-$HOME/.cache}/shell/chpwd-recent-dirs"
  zstyle ':chpwd:*' recent-dirs-pushd true
fi
mkdir -p ~/.cache/shell

# hook関数precmd実行
__call_precmds() {
  type precmd > /dev/null 2>&1 && precmd
  for __pre_func in $precmd_functions; do $__pre_func; done
}

#shift+upで親ディレクトリへ
#shift+downで戻る
__cd_up()   { builtin pushd ..; echo; __call_precmds; zle reset-prompt }
__cd_undo() { builtin popd;     echo; __call_precmds; zle reset-prompt }
zle -N __cd_up;   bindkey '^[[1;2A' __cd_up
zle -N __cd_undo; bindkey '^[[1;2B' __cd_undo

# パスの単語区切り文字に含めない文字
export WORDCHARS="*?_-.[]~=&;!#$%^(){}<>/"

# history search
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end


# 実行したプロセスの消費時間が3秒以上かかったら
# 自動的に消費時間の統計情報を表示する
REPORTTIME=3

# 全コマンドで correct 機能を無効化
unsetopt correctall

# 256色化
TERM=xterm-256color

# LS_COLORSの設定
eval `dircolors ~/.dircolors-solarized/dircolors.ansi-universal`
zstyle ':completion:*' list-colors "${LS_COLORS}"

# cdrコマンドを有効 ログアウトしても有効なディレクトリ履歴
# cdr タブでリストを表示
autoload -Uz add-zsh-hook
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs
# cdrコマンドで履歴にないディレクトリにも移動可能に
zstyle ":chpwd:*" recent-dirs-default true

# 大文字小文字に関わらず, 候補が見つからない時のみ文字種を無視した補完をする設定
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

########################################
# tmuxの設定
# 自動ロギング
if [[ !${TMUX} ]]; then
    local LOGDIR=${HOME}/tmuxlogs
    local LOGFILE=$(hostname)_$(date +%Y-%m-%d_%H%M%S_%N.log)
    local FILECOUNT=0
    local MAXFILECOUNT=500 #ここを好きな保存ファイル数に変える。
    mkdir -p ${LOGDIR}
    # zsh起動時に自動で${MAXFILECOUNT}のファイル数以上ログファイルあれば消す
    for file in `\find "${LOGDIR}" -maxdepth 1 -type f -name "*.log" | sort --reverse`; do
        FILECOUNT=`expr ${FILECOUNT} + 1`
        if [ ${FILECOUNT} -ge ${MAXFILECOUNT} ]; then
            rm -f ${file}
        fi
    done
    [ ! -d ${LOGDIR} ] && mkdir -p ${LOGDIR}
    tmux set-option default-terminal "screen" \; \
    pipe-pane "cat >> ${LOGDIR}/${LOGFILE}" \; \
    display-message "💾Started logging to${LOGDIR}/${LOGFILE}"
fi

# vimのclang_completeでpython3を用いる時のため、libpythonのパスを指定する
export LD_PRELOAD=/opt/anaconda3/lib/libpython3.6m.so.1.0
