source <(kubectl completion bash)
alias k="kubectl"
alias kn='kubectl config set-context --current --namespace'
complete -o default -F __start_kubectl k
export DRY="-o yaml --dry-run=client"
