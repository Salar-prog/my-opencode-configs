# Contributing

Thanks for stopping by! This repo is a personal multi-machine OpenCode dotfiles collection. Contributions are welcome if they improve portability, add new skills, or fix bugs.

## How to Contribute

1. **Fork** this repo.
2. **Create a topic branch** (`git checkout -b feat/add-your-skill` / `fix/bootstrap-error`).
3. **Make your change**:
   - Skills go in `opencode/skills/<name>/` (each dir has a `SKILL.md` with `name` + `description` frontmatter).
   - Server config edits go in `opencode/opencode.jsonc` (use `{env:VAR}` for any secrets — never hard-code tokens).
   - Bootstrap changes go in `scripts/bootstrap.sh` and `agents/bootstrap-new-machine.md`.
4. **Test** on a fresh machine (or at least verify the script runs end-to-end).
5. **Commit** with a clear message (`feat:`, `fix:`, `docs:`, `chore:`).
6. **Push** and open a PR.

## Pull Request Guidelines

- Keep changes scoped — one skill, one config change, or one script fix per PR.
- Ensure `git commit` passes and files are formatted as JSON/JSONC where applicable.
- If adding a new skill, include its full directory (SKILL.md + references/scripts/assets).
- Update `README.md` if your change affects setup steps or the skills count.

## Code Style

- **Configs**: JSON/JSONC, 2-space indent, `$schema` header in `opencode.jsonc`.
- **Scripts**: Bash with `set -uo pipefail`, quoted variables, helpful echo output.
- **Environment variables**: always `{env:VAR}` interpolation — never bake secrets into files.

## Maintaining Upstream Skills

The 78 gamedev skills are vendored from [gamedev-skills/awesome-gamedev-agent-skills](https://github.com/gamedev-skills/awesome-gamedev-agent-skills). To refresh them, follow the instructions in the README under "Updating Upstream Skills".

## Reporting Issues

Use the [issue templates](.github/ISSUE_TEMPLATE/). For security issues, see [SECURITY.md](SECURITY.md).
