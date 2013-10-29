export PATH="$PATH:~/bin"

source ~/.bash/aliases
source ~/.bash/completions
source ~/.bash/config

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

if [ -f ~/.localrc ]; then
  . ~/.localrc
fi

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
