# claude-ego

Switch between authenticated Claude Code accounts by alias:

```
/switch personal
/switch work
```

Claude Code has no built-in account switcher. Its documented way to run several
accounts is one config directory per account (`CLAUDE_CONFIG_DIR`), each with its
own login and Keychain entry. This plugin manages those directories for you:

- Each alias maps to a config dir under `~/.claude-ego/profiles/<alias>`
  (or `@default` = your normal `~/.claude` login).
- New profiles symlink your settings, CLAUDE.md, plugins, skills, hooks, agents and
  `projects/` (conversation history) from `~/.claude`, so only the login differs.
- A running process can't change its own config dir, so switching needs a restart.
  The optional shell wrapper does that for you: `/switch personal`, `/exit`, and
  Claude Code relaunches as `personal` with `--continue` (same conversation).

## Install

```sh
claude plugin marketplace add petermyers/claude-ego
claude plugin install ego@claude-ego
```

Then in Claude Code, install the shell wrapper:

```
/accounts setup
```

Add the `source` line it prints to `~/.zshrc`, open a new terminal, and start
`claude` again. `/switch` can only relaunch sessions started through the wrapper.

Register your accounts:

```
/accounts add work --existing   # the login you're using now
/accounts add personal          # new, not-yet-logged-in account
```

Then run `/switch personal` and `/exit`. Claude Code relaunches, and you log in to the
personal account once. After that, `/switch` moves between the two.

## Commands

| Command | Does |
|---|---|
| `/switch <alias>` | Pick an account; `/exit` to relaunch into it |
| `/accounts list` | List accounts (`*` = this session); plain `/accounts` does the same |
| `/accounts add <alias> [--existing]` | Register an account |
| `/accounts rm <alias>` | Unregister (leaves dir and Keychain login) |
| `/accounts setup` | Install the shell wrapper |

`bin/claude-ego` is the same CLI and works from a terminal.

## Uninstall

1. Optional: log out of the extra accounts so their Keychain logins are removed.
   For each one: `/switch <alias>`, `/exit`, then `/logout` in the relaunched session.
   Finish with `/switch` back to the account registered with `--existing`.
2. Remove the `source ~/.claude-ego/shell.sh` line from `~/.zshrc` (or `~/.bashrc`)
   and open a new terminal.
3. Remove the plugin and marketplace:

   ```sh
   claude plugin uninstall ego@claude-ego
   claude plugin marketplace remove claude-ego
   ```

4. Delete the account data:

   ```sh
   rm -rf ~/.claude-ego
   ```

   Profiles only hold symlinks into `~/.claude`, so your settings and conversation
   history stay intact. Plain `claude` goes back to your normal `~/.claude` login.

## Caveats

- If Claude Code rewrites a shared file with an atomic rename (for example
  `settings.json`), that profile gets its own copy instead of the symlink.
- `--continue` resumes the latest conversation in the current directory.
- Console (API-key) logins are stored outside the config dir, so they are not
  isolated per profile. This only matters for subscription/OAuth logins.
- `/switch` and the wrapper are global: the alias you pick is the default for
  every new `claude` launch until you switch again.
