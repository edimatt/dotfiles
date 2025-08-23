SPARK_HOME="$HOME/Applications/spark"

if [ -d "$SPARK_HOME/bin" ]; then
    export SPARK_HOME
    add_to_path 0 "$SPARK_HOME/bin"
else
    unset SPARK_HOME
fi
