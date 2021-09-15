
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_ignore_dups
setopt share_history

setopt auto_cd
function chpwd() { ls --color=tty }


source ~/.powerlevel10k/powerlevel10k.zsh-theme
source ~/dotfiles/.p10k.zsh

setopt alwaystoend
setopt autopushd
setopt completeinword
setopt extendedhistory
setopt histexpiredupsfirst
setopt histignorespace
setopt histverify
setopt incappendhistory
setopt interactivecomments
setopt longlistjobs
setopt noflowcontrol
setopt pushdignoredups
setopt pushdminus
setopt zle

bindkey -e

stty -ixon -ixoff

autoload -U compinit
compinit

typeset -U path PATH

mkdir -p ~/.cache/shell
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':completion:*' menu select
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file "${XDG_CACHE_HOME:-$HOME/.cache}/shell/chpwd-recent-dirs"
zstyle ':chpwd:*' recent-dirs-pushd true

function precmd() {
  if [ ! -z $TMUX ]; then
    tmux refresh-client -S
  fi
}

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

# true colorを有効化
# ここでTERMを設定するべきではないので以下は削除
# .tmux.confで設定する
# eval `tset -s xterm-24bits`
# evalを実行するととても遅いので、結果を直接設定する
# TERM=xterm-24bits;

# LS_COLORSの設定
autoload -U colors
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
zsh_auto_log() {
    local LOGDIR=${HOME}/tmuxlogs
    local LOGFILE=$(hostname)_$(date +%Y-%m-%d_%H%M%S_%N.log)
    local FILECOUNT=0
    local MAXFILECOUNT=500
    mkdir -p ${LOGDIR}
    # zsh起動時に自動で${MAXFILECOUNT}のファイル数以上ログファイルあれば消す
    for file in `\find "${LOGDIR}" -maxdepth 1 -type f -name "*.log" | sort --reverse`; do
        FILECOUNT=`expr ${FILECOUNT} + 1`
        if [ ${FILECOUNT} -ge ${MAXFILECOUNT} ]; then
            rm -f ${file}
        fi
    done
    [ ! -d ${LOGDIR} ] && mkdir -p ${LOGDIR}
    tmux pipe-pane "cat >> ${LOGDIR}/${LOGFILE}" \; \
    display-message "💾Started logging to ${LOGDIR}/${LOGFILE}"
}
if [[ -n ${TMUX} ]]; then
    ( zsh_auto_log & ) > /dev/null 2>&1
fi

# ZFDirDiffでフォルダ間比較
alias vimdirdiff="vim -f '+execute \"ZFDirDiff\" argv(0) argv(1)' $LOCAL $REMOTE"

# manコマンドをvimで開く
export MANPAGER="vim -M +MANPAGER -"

alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.clangd,.ccls-cache}'
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls --color=tty'
alias lsa='ls -lah'

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# fzf

ff() {
    # Interactive search.
    # Usage: `ff` or `ff <folder>`.
    #
    [[ -n $1 ]] && cd $1 # go to provided folder or noop
    RG_DEFAULT_COMMAND="rg -i -l --hidden -g '!.git/' -g '!.svn/'"

    selected=$(
    FZF_DEFAULT_COMMAND="rg --files" fzf \
      -m \
      -e \
      --ansi \
      --phony \
      --reverse \
      --bind "ctrl-a:select-all" \
      --bind "f12:execute-silent:(subl -b {})" \
      --bind "change:reload:$RG_DEFAULT_COMMAND {q} || true" \
      --preview "rg -i --pretty --context 2 {q} {}" | cut -d":" -f1,2
    )

    [[ -n $selected ]] && $EDITOR $selected # open multiple files in editor
}

# fzf-cdr
alias cdd='fzf-cdr'
fzf-cdr() {
    target_dir=`cdr -l | sed 's/^[^ ][^ ]*  *//' | fzf`
    target_dir=`echo ${target_dir/\~/$HOME}`
    if [ -n "$target_dir" ]; then
        cd $target_dir
    fi
}
source /tmp/forgit/forgit.plugin.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

