# <Title>

Project: <project> · Branch: <branch> · Commit: <short hash> · Date: <YYYY-MM-DD>
Ticket: <ticket key or link, or "none">

## Goal

1 to 3 sentences: what is different when the work is done.

## Behavior

| Requirement | Now | After | Phase |
|---|---|---|---|
| <words of the task> | <behavior now> | <behavior after> | 1 |

## Approach

The chosen approach and the reason in 1 to 3 sentences.
Rejected options: one line for each option, with the reason.

## Decisions

- <Decision about behavior that the task does not state>. Reason: <reason>.
- <Exception to a requirement>. Source: <quote from the task or statement of the user>.

If there are no decisions and no exceptions, write "None".

## Out of scope

- <What this plan does not change>

## Phase 1: <Name>

Level: <0 to 3> · Reason: <one line>

### Changes

- Add test `<test name>` to `path/to/test`: <behavior that the test checks>.
- Add `<signature>` to `path/to/file`.
- Change `path/to/file`: <what changes>.

### Review focus

- <What only a human can judge in this phase, for example a name, a boundary or a risk>

### Success criteria

Automated:

- [ ] `<exact command>`

Manual:

- [ ] <what the user checks in the result>

## Phase 2: <Name>

...

## Current state

Only the facts that the implementation needs. One line for each fact, with a `path:line` reference.

## Progress

Not started. The skill `implement` updates this section after each phase.
