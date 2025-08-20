SPARK_HOME=$HOME/Applications/spark

if [ -d "$SPARK_HOME" ]; then
    export SPARK_HOME
    export PATH=$PATH:$SPARK_HOME/bin
fi
