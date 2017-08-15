# .bash_profile

# Get the aliases and functions
if [ -f $HOME/.bashrc ]; then
	. $HOME/.bashrc
fi

# User specific environment and startup programs

PATH=$HOME/bin:$HOME/miniconda2/bin:$PATH

export PATH

if [ -f $HOME/.bash_login ]; then
    . $HOME/.bash_login
fi
