---
name: coding-principles
description: Coding principles as if-then rules for scope, commits, abstraction, errors, tests and comments. Load this skill before you plan, write, change or review code in any project, also for small changes.
---

# Coding principles

These rules describe how the user wants to plan, write and review code.
They apply in each project, private and at work.
Project conventions are not in this file. They are in the `CLAUDE.md` or `AGENTS.md` of the project.

## How to use

1. If a project instruction conflicts with a rule, follow the project instruction. Reason: the team agreed on it.
2. If the task conflicts with a rule, follow the task. Name the conflict to the user.
3. If you review a change, report each violation with the name of the rule.
4. Do not report a violation that lint, the formatter or the type check finds.

## Scope

- **Task sets the scope.** If the task does not ask for a change, do not make it.
  Example: in a bugfix, do not refactor the function next to it.
- **Ask about different scope.** If the existing code has a different scope than the task, ask which one applies.
  Example: the task says "all users", the existing code checks an admin flag.
- **No guessed defaults.** If a requirement is unclear, ask. Do not choose a default silently.

## Changes

- **Small commits.** Keep each commit small enough to review in one pass.
  If a commit changes more than about 400 lines, split it.
- **Refactor apart from behavior.** If a change refactors code and changes behavior, put each part into its own commit.
  Reason: the reviewer then sees the behavior change alone.
- **Move without change.** If you move code, do not change it in the same commit.

## Design

- **Extract at the second use.** If logic has one caller, keep it at the caller.
  Extract it when a second caller needs it.

## Errors

- **No silent catch.** Never catch an error and ignore it. Do not hide an error behind a fallback value.
  Reason: the error then appears later at a different place.

## Tests

- **Test behavior.** Check what the code does, not how it does it.
  Example: check the response of an endpoint, not that a private method was called.
- **Mock only external systems.** Mock network services, the clock and other systems that you do not control.

## Comments

- **Comments give the reason.** Write a comment only to explain why. The code shows what it does.
