# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi
# User specific environment and startup programs

# Oracle
export PATH=$PATH:$HOME/Applications/sqlcl/bin

# Emacs
export WORKON_HOME=$HOME/Applications/miniforge3/envs

# Kotlin language server
export PATH=$PATH:$HOME/Applications/kls/bin

fortune
