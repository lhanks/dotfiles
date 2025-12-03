
# Enable native Windows symlinks in Git Bash/MSYS2
export MSYS=winsymlinks:nativestrict

# Load Angular CLI autocompletion (if available)
command -v ng &>/dev/null && source <(ng completion script)
export PATH=$PATH:"/c/Users/leslie.hanks/AppData/Local/Programs/cursor"
alias cursor=Cursor.exe
alias tree='cmd //c "tree /F"'

export CLAUDE_CODE_MAX_OUTPUT_TOKENS=64000

# source .aliases
. ~/.aliases
