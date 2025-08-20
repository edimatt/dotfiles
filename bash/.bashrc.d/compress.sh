xcompress() {
	set -x
	tar cf - $1 | xz -9zev > $1.tar.xz
	set +x
}

xdecompress() {
	set -x
	xz -dvc $1 | tar -xf -
	set +x
}

extract () {
  if [ $# -lt 1 ]; then
    echo "Usage: extract <archive> [...more archives]"
    return 2
  fi

  for f in "$@"; do
    [ -f "$f" ] || { echo "extract: '$f' not found"; continue; }
    case "${f,,}" in
      *.tar.bz2|*.tbz2)   tar xjf "$f"   ;;
      *.tar.gz|*.tgz)     tar xzf "$f"   ;;
      *.tar.xz|*.txz)     tar xJf "$f"   ;;   # ← xz-compressed tar
      *.tar)              tar xf "$f"    ;;
      *.bz2)              bunzip2 "$f"   ;;
      *.gz)               gunzip "$f"    ;;
      *.xz)               xz -d "$f"     ;;   # ← raw .xz
      *.zip)              unzip "$f"     ;;
      *.7z)               7z x "$f"      ;;
      *.rar)              unrar x "$f"   ;;
      *.Z)                uncompress "$f";;
      *)                  echo "extract: '$f' cannot be extracted" ;;
    esac
  done
}
