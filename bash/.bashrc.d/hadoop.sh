HADOOP_HOME="$HOME/Applications/hadoop"

if [ -d "$HADOOP_HOME/bin" ]; then
    HADOOP_CONF_DIR="$HADOOP_HOME/etc/hadoop"

    # Prepend native libs, preservando eventuali valori già presenti
    LD_LIBRARY_PATH="$HADOOP_HOME/lib/native${LD_LIBRARY_PATH+:$LD_LIBRARY_PATH}"

    # Prepend bin and sbin to PATH (higher priority)
    add_to_path 0 "$HADOOP_HOME/bin" "$HADOOP_HOME/sbin"

    export HADOOP_HOME HADOOP_CONF_DIR LD_LIBRARY_PATH
else
    unset HADOOP_HOME
fi
