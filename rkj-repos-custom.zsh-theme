# user, host, full path, and time/date on two lines for easier vgrepping

function hg_prompt_info {
  if (( $+commands[hg] )) && grep -q "prompt" ~/.hgrc; then
    hg prompt --angle-brackets "\
<hg:%{$fg[magenta]%}<branch>%{$reset_color%}><:%{$fg[magenta]%}<bookmark>%{$reset_color%}>\
</%{$fg[yellow]%}<tags|%{$reset_color%}, %{$fg[yellow]%}>%{$reset_color%}>\
%{$fg[red]%}<status|modified|unknown><update>%{$reset_color%}<
patches: <patches|join( → )|pre_applied(%{$fg[yellow]%})|post_applied(%{$reset_color%})|pre_unapplied(%{$fg_bold[black]%})|post_unapplied(%{$reset_color%})>>" 2>/dev/null
  fi
}

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%}+ added"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}✱ modified"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✗ deleted"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$FX[bold]$FG[038]%}➦ renamed"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%}✂ unmerged"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$FX[bold]$FG[038]%}✈ untracked"
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$FX[bold]$FG[038]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}"

function mygit() {
  if [[ "$(git config --get oh-my-zsh.hide-status)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(git_prompt_short_sha)$(git_prompt_status)%{$FX[bold]$FG[038]%}$ZSH_THEME_GIT_PROMPT_SUFFIX "
  fi
}

function retcode() {}

# alternate prompt with git & hg
PROMPT=$'%{$FX[bold]$FG[038]%}┌─[%{$fg_bold[green]%}%n%b%{$fg[black]%}@%{$fg[cyan]%}%m%{$FX[bold]$FG[038]%}]%{$reset_color%} - %{$FX[bold]$FG[038]%}[%{$fg_bold[white]%}%~%{$FX[bold]$FG[038]%}]%{$reset_color%} - %{$FX[bold]$FG[038]%}[%b%{$fg[yellow]%}'%D{"%Y-%m-%d %I:%M:%S"}%b$'%{$FX[bold]$FG[038]%}]
%{$FX[bold]$FG[038]%}└─[%{$fg_bold[magenta]%}%?$(retcode)%{$FX[bold]$FG[038]%}] <$(mygit)$(hg_prompt_info)>%{$reset_color%} '
PS2=$' \e[0;34m%}%B>%{\e[0m%}%b '
