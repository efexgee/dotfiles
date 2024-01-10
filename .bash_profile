# .bash_profile

echo "Sourcing $BASH_SOURCE"

# Get the aliases and functions
if [ -f $HOME/.bashrc ]; then
	. $HOME/.bashrc
fi

# User specific environment and startup programs

PATH=$HOME/bin:$HOME/miniconda2/bin:/usr/local/anaconda-current/bin:$PATH
PATH="/ihme/geospatial/tools/bin:$PATH"

export PATH

export CDPATH=".:$HOME/repos/:$HOME/"

# Reading .bash_login and .profile is unexpected behavior
# for bash when .bash_profile exists.
# TODO This should be fixed
if [ -f $HOME/.bash_login ]; then
    . $HOME/.bash_login
fi

if [ -f $HOME/.profile ]; then
    . $HOME/.profile
fi
