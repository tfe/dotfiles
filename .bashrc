# Git dirty state in prompt
# The various escape codes that we can use to color our prompt.
        RED="\[\033[0;31m\]"
     YELLOW="\[\033[0;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[0;34m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
 LIGHT_BLUE="\[\033[1;34m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_NONE="\[\e[0m\]"

# Detect whether the current directory is a git repository.
function is_git_repository {
  git branch > /dev/null 2>&1
}

# Determine the branch/state information for this git repository.
function set_git_branch {
  # Capture the output of the "git status" command.
  git_status="$(git status 2> /dev/null)"

  # Set color based on clean/staged/dirty.
  if [[ ${git_status} =~ "working directory clean" ]]; then
    state="${GREEN}"
  elif [[ ${git_status} =~ "Changes to be committed" ]]; then
    state="${YELLOW}"
  else
    state="${RED}"
  fi

  # Set arrow icon based on status against remote.
  remote_pattern="# Your branch is (.*) of"
  if [[ ${git_status} =~ ${remote_pattern} ]]; then
    if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
      remote="↑"
    else
      remote="↓"
    fi
  else
    remote=""
  fi
  diverge_pattern="# Your branch and (.*) have diverged"
  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote="↕"
  fi

  # Get the name of the branch.
  branch_pattern="^# On branch ([^${IFS}]*)"
  if [[ ${git_status} =~ ${branch_pattern} ]]; then
    branch=${BASH_REMATCH[1]}
  fi

  # Set the final branch string.
  BRANCH="${state}(${branch})${remote}${COLOR_NONE} "
}

# Return the prompt symbol to use, colorized based on the return value of the
# previous command.
function set_prompt_symbol () {
  if test $1 -eq 0 ; then
      PROMPT_SYMBOL="\$"
  else
      PROMPT_SYMBOL="${RED}\$${COLOR_NONE}"
  fi
}

# Set the full bash prompt.
function set_bash_prompt () {
  # Set the PROMPT_SYMBOL variable. We do this first so we don't lose the
  # return value of the last command.
  set_prompt_symbol $?

  # Set the BRANCH variable.
  if is_git_repository ; then
    set_git_branch
  elif is_svn_repository ; then
    set_svn_branch
  else
    BRANCH=''
  fi

  # Set the bash prompt variable. Set colour of user/host to green, current dir in blue
  PS1="${LIGHT_GREEN}(\t)${COLOR_NONE}:${LIGHT_BLUE}\w${COLOR_NONE} ${BRANCH}${PROMPT_SYMBOL} "

  # Set the Terminal title to the current location
  echo -ne "\033]0;Terminal - ${PWD}\007"

}

# Tell bash to execute this function just before displaying its prompt.
PROMPT_COMMAND=set_bash_prompt

# ALIASES
alias fs="foreman start"

alias gs="git status"
alias gcm="git checkout master"
alias gpom="git pull origin master && git fetch origin"
alias gmmnff="git merge master --no-ff"
alias gp="git pull"
alias gap="git add --patch"
alias gco="git checkout "
alias gpo="git push origin "

alias wip="git add . && git commit -m 'WIP.'"
alias unwip="git reset head^"

alias diff="git mergetool -t opendiff"

alias tests="rake db:test:prepare && bundle exec rspec -b"
alias rakedb="rake db:migrate"

alias cdlm="cd /Users/leapjared/Documents/leap/projects/"
