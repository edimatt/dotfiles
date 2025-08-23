ORACLE_BASE=/u01/app/oracle
if [ -d "$ORACLE_BASE" ]; then
    ORACLE_HOME="$ORACLE_BASE/product/19.0.0/dbhome_1"
    # export TWO_TASK=pdb1
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME/lib
    CLASSPATH=$ORACLE_HOME/jdbc/lib:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib
    TNS_ADMIN=$HOME/.local/share/oracle
    export ORACLE_BASE ORACLE_HOME CLASSPATH TNS_ADMIN LD_LIBRARY_PATH PATH
    add_to_path 1 $ORACLE_HOME/bin
else
    unset ORACLE_BASE
fi

# Alias sqlplus con rlwrap, solo se disponibili
if command -v sqlplus >/dev/null 2>&1 && command -v rlwrap >/dev/null 2>&1; then
  alias sqlplus="rlwrap sqlplus"
fi
