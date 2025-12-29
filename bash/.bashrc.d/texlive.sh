# Tex live
if [ -d "$HOME"/Applications/texlive ]; then
    export MANPATH="$MANPATH":"$HOME"/Applications/texlive/2024/texmf-dist/doc/man
    export INFOPATH="$INFOPATH":"$HOME"/Applications/texlive/2024/texmf-dist/doc/info
    add_to_path 1 "$HOME/Applications/texlive/2024/bin/x86_64-linux"
fi
