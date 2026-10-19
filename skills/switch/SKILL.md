---
name: switch
description: Switch the Claude Code account (e.g. /switch personal, /switch work).
argument-hint: <alias>
disable-model-invocation: true
allowed-tools: Bash(${CLAUDE_SKILL_DIR}/../../bin/claude-ego *)
---

!`"${CLAUDE_SKILL_DIR}/../../bin/claude-ego" use $ARGUMENTS 2>&1`

Relay the output above to the user verbatim. Do not run any other commands.
