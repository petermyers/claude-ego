---
name: accounts
description: List or manage Claude Code accounts (list | add <alias> [--existing] | rm <alias> | setup).
argument-hint: "[list | add <alias> [--existing] | rm <alias> | setup]"
disable-model-invocation: true
allowed-tools: Bash(${CLAUDE_SKILL_DIR}/../../bin/claude-ego *)
---

```!
"${CLAUDE_SKILL_DIR}/../../bin/claude-ego" $ARGUMENTS 2>&1
```

Relay the output above to the user verbatim. Do not run any other commands.
