# claude-ego shell wrapper (zsh/bash).
# Launches `claude` under the account chosen with /switch, and relaunches it with
# --continue when /switch was used in the session that just exited.

claude() {
  local home="${CLAUDE_EGO_HOME:-$HOME/.claude-ego}"
  local session="$$-$RANDOM$RANDOM"
  local alias dir rc
  while true; do
    dir=""
    alias="$(cat "$home/current" 2>/dev/null)"
    if [ -n "$alias" ]; then
      dir="$(awk -F'\t' -v a="$alias" '$1 == a { print $2; exit }' "$home/accounts.tsv" 2>/dev/null)"
    fi
    rm -f "$home/restart.$session"
    if [ -z "$dir" ] || [ "$dir" = "@default" ]; then
      env -u CLAUDE_CONFIG_DIR CLAUDE_EGO_SESSION="$session" claude "$@"
    else
      env CLAUDE_CONFIG_DIR="$dir" CLAUDE_EGO_SESSION="$session" claude "$@"
    fi
    rc=$?
    [ -f "$home/restart.$session" ] || return $rc
    rm -f "$home/restart.$session"
    echo "↻ relaunching Claude Code as '$(cat "$home/current" 2>/dev/null)'..."
    set -- --continue
  done
}
