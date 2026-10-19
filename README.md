# claude-ego

Switch between authenticated Claude Code accounts by alias:

```
/switch peter      # personal
/switch converge   # work
```

Claude Code has no built-in account switcher. Its documented way to run several
accounts is one config directory per account (`CLAUDE_CONFIG_DIR`), each with its
own login and Keychain entry. This plugin manages those directories for you:

- Each alias maps to a config dir under `~/.claude-ego/profiles/<alias>`
  (or `@default` = your normal `~/.claude` login).
- New profiles symlink your settings, CLAUDE.md, plugins, skills, hooks, agents and
  `projects/` (conversation history) from `~/.claude`, so only the login differs.
- A running process can't change its own config dir, so switching needs a restart.
  The optional shell wrapper does that for you: `/switch peter`, `/exit`, and
  Claude Code relaunches as `peter` with `--continue` (same conversation).

## Install

```sh
claude plugin marketplace add ~/Development/claude-ego
claude plugin install ego@claude-ego
```

Then in Claude Code:

```
/accounts add converge --existing   # register the login you're using now
/accounts add peter                 # new, not-yet-logged-in account
/accounts setup                     # install the auto-relaunch shell wrapper
```

Add the `source` line that `setup` prints to `~/.zshrc` and open a new terminal.
Then run `/switch peter` and `/exit`. Claude Code relaunches, and you log in to the
personal account once. After that, `/switch` moves between the two.

## Commands

| Command | Does |
|---|---|
| `/switch <alias>` | Pick an account; `/exit` to relaunch into it |
| `/accounts` | List accounts (`*` = this session) |
| `/accounts add <alias> [--existing]` | Register an account |
| `/accounts rm <alias>` | Unregister (leaves dir and Keychain login) |
| `/accounts setup` | Install the shell wrapper |

`bin/claude-ego` is the same CLI and works from a terminal.

## Caveats

- If Claude Code rewrites a shared file with an atomic rename (for example
  `settings.json`), that profile gets its own copy instead of the symlink.
- `--continue` resumes the latest conversation in the current directory.
- Console (API-key) logins are stored outside the config dir, so they are not
  isolated per profile. This only matters for subscription/OAuth logins.
- `/switch` and the wrapper are global: the alias you pick is the default for
  every new `claude` launch until you switch again.
