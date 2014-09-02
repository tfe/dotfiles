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

##
# Your previous /Users/red/.bash_profile file was backed up as /Users/red/.bash_profile.macports-saved_2014-08-14_at_14:23:56
##

# MacPorts Installer addition on 2014-08-14_at_14:23:56: adding an appropriate PATH variable for use with MacPorts.
# export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.


# Setting PATH for Python 3.4
# The orginal version is saved in .bash_profile.pysave
# PATH="/Library/Frameworks/Python.framework/Versions/3.4/bin:${PATH}"
# export PATH
