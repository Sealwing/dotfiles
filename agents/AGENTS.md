# AGENTS.md

## Working agreements

- Ask questions when task is ambiguous
- Code must be typed
- Public functions before private

## Execution policy

- Discovery-first mode by default: do not edit files, run formatters, or run mutating commands unless I explicitly ask to implement.
- For bugfix requests, do only:
  1. reproduce/inspect,
  2. root-cause analysis,
  3. proposed fix options with tradeoffs,
  4. recommended option.
- After analysis, stop and wait for my explicit approval message: "implement option X".
- If my wording is ambiguous (e.g. "let's think", "how to fix"), treat it as analysis-only.
- Before any write action, ask a confirmation question.
- Run exactly the command(s) requested — no extra prep or verification steps
  (clearing __pycache__, ad-hoc syntax/AST checks, compileall, etc.) unless a
  command actually fails and you're diagnosing why it failed.
- Trust the project's own tooling (make pretty/lint, test runner) to handle
  stale caches and catch syntax errors. Don't duplicate what it already checks.
