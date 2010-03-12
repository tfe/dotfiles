
#!/bin/bash
#
# Set our bash prompt according to the branch/status of the current git 
# repository.
#
# Taken from http://gist.github.com/31934
 
        RED="\[\033[0;31m\]"
     YELLOW="\[\033[0;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[0;34m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_NONE="\[\e[0m\]"
 
function is_git_repository {
  git branch > /dev/null 2>&1
}
 
function parse_git_branch {
  is_git_repository || return 1
  git_status="$(git status 2> /dev/null)"
  branch_pattern="^# On branch ([^${IFS}]*)"
  remote_pattern="# Your branch is (.*) of"
  diverge_pattern="# Your branch and (.*) have diverged"
  if [[ ${git_status} =~ "working directory clean" ]]; then
    state="${GREEN}"
  elif [[ ${git_status} =~ "Untracked files" ]]; then
    state="${RED}"
  else
    state="${YELLOW}"
  fi
  # add an else if or two here if you want to get more specific
  if [[ ${git_status} =~ ${remote_pattern} ]]; then
    if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
      remote="↑"
    else
      remote="↓"
    fi
  fi
  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote="↕"
  fi
  if [[ ${git_status} =~ ${branch_pattern} ]]; then
    branch=${BASH_REMATCH[1]}
    echo "${state}[${branch}]${remote}${COLOR_NONE} "
  fi
}
 
function prompt_symbol () {
  # Set color of dollar prompt based on return value of previous command.
  if test $1 -eq 0
  then
      echo "\$"
  else
      echo "${RED}\$${COLOR_NONE}"
  fi
}
 
function prompt_func () {
  last_return_value=$?
  if is_git_repository; then
    PS1="${HOSTNAME} \w $(parse_git_branch)$(prompt_symbol $last_return_value) "
  else
    PS1="${HOSTNAME} \w $(prompt_symbol $last_return_value) "
  fi
}
 
PROMPT_COMMAND=prompt_func
