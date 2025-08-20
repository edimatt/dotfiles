EDO_HOME=/opt/edo

# NOTE 1
# To fix a problem with vconsole
# journalctl -xeu systemd-vconsole-setup.service --> sg file not found, install:
# dnf install kbd-legacy
# and restart the service: systemctl restart systemd-vconsole-setup.service

# NOTE 2
# Compile the following dir then export it
# glib-compile-schemas /opt/edo/share/glib-2.0/schemas
# Need to build glib 2.0
export XDG_DATA_DIRS=$XDG_DATA_DIRS:$EDO_HOME/share


export O='$$O'
export ORIGIN='$ORIGIN'
if [ "$PATH" != *"$EDO_HOME"* ]; then
    export PATH=$EDO_HOME/bin:$EDO_HOME/sbin:$PATH
fi

export MANPATH=$MANPATH:$EDO_HOME/share/man

# Source the bash completion
. /etc${EDO_HOME}/profile.d/bash_completion.sh
