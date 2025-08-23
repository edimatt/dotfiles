# ~/.bash_logout

# 1) Salva sempre la history della sessione
shopt -s histappend 2>/dev/null || true
history -a  # append delle nuove righe su $HISTFILE

# 2) Chiudi agent avviati nella login (se presenti)
if [ -n "${SSH_AGENT_PID:-}" ] && ps -p "$SSH_AGENT_PID" >/dev/null 2>&1; then
  ssh-agent -k >/dev/null 2>&1
fi
if command -v gpgconf >/dev/null 2>&1; then
  gpgconf --kill gpg-agent >/dev/null 2>&1 || true
fi

# 3) Smonta mount “di casa” (OPZIONALE: personalizza il percorso)
if command -v mountpoint >/dev/null 2>&1; then
  for m in "$HOME"/mnt/*; do
    [ -d "$m" ] || continue
    mountpoint -q "$m" && umount "$m" 2>/dev/null || true
  done
fi

# 4) Pulisci tmp di sessione (se l’hai creato in ~/.bash_profile)
if [ -n "${SESSION_TMP:-}" ] && [ -d "$SESSION_TMP" ] && [[ "$SESSION_TMP" == /tmp/* ]]; then
  rm -rf -- "$SESSION_TMP"
fi

# 5) Cosmetica: pulisci lo schermo all’uscita
[ -t 1 ] && clear
