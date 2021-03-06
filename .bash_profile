# .bash_profile

# Get the aliases and functions
if [ -f $HOME/.bashrc ]; then
	. $HOME/.bashrc
fi

# User specific environment and startup programs

PATH=$HOME/bin:$HOME/miniconda2/bin:/usr/local/anaconda-current/bin:$PATH
PATH="/ihme/geospatial/tools/bin:$PATH"

export PATH

export CDPATH=".:$HOME/repos/:$HOME/"

if [ -f $HOME/.bash_login ]; then
    . $HOME/.bash_login
fi
