export SDKMAN_DIR="$HOME/.sdkman"
if [ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]; then
  # shellcheck source=/dev/null
  . "$SDKMAN_DIR/bin/sdkman-init.sh"
fi

# export JAVA_HOME=/usr/lib/jvm/java
add_to_path 1 "$HOME/Applications/jdt_js/bin"

# Kotlin language server
add_to_path 1 "$HOME/Applications/kls/bin"
