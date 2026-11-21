---
name: implement
description: Implements a plan from create-plan phase by phase. Writes tests first, runs the checks and a review, commits and reports each phase. Use only when the user runs /implement.
disable-model-invocation: true
argument-hint: "[path of the plan]"
allowed-tools:
  - Bash(git branch --show-current)
  - Bash(git symbolic-ref *)
  - Bash(git rev-parse *)
  - Bash(git status *)
  - Bash(git diff *)
  - Bash(git log *)
  - Read(~/.claude/skills/implement/**)
---

# Implement a plan

Plan: $ARGUMENTS

If the line before is empty or shows a placeholder, the plan is in the message that started this skill.
If no message names a plan, use the newest `*.plan.md` in `.agent-work/plans/<branch>/`. Replace each `/` in the branch with `-`.
If there is no plan, stop. Tell the user to run `/create-plan` first.

## Step 1: Prepare

1. Get the branch with `git branch --show-current`.
2. If the branch is `main`, `master` or the branch of `origin/HEAD`, stop. Reason: this skill commits, and commits belong on a feature branch.
3. Read the plan fully.
   If the skill `coding-principles` is available, load it. Follow its rules in each phase.
4. Read the section "Progress". Start with the first phase that has open items. Reason: a new session continues where the last session stopped.
5. Run `git status --short`. If there are changes that are not from this plan, stop and ask the user.
6. If the user sets a level in the message, use it for the phases that the user names. Example: "all phases level 0".
7. Tell the user the start phase and the level of each open phase in one short message. Do not wait.

## Step 2: Implement the phase

1. If the phase has a test change, write the test first. Run it.
   If a test for new behavior passes before the change, stop and report it. Reason: the plan assumes behavior that already exists.
   A test that protects existing behavior can pass. Name it in the report.
2. Make the changes of the phase. Do only what the phase says.
3. If the code does not match the plan, stop and report the difference. Do not change the plan silently.
4. Run each automated success criterion of the phase. This skill calls them "checks".
5. If a check fails, fix the cause. If it still fails after two attempts, stop and report it.
6. Check off each done item in the plan.

## Step 3: Review the phase

If the level is 0, skip this step.

1. Start a review subagent with the prompt in `references/review.md`. Give it the path of the plan and the phase.
2. If no subagent tool is available, do the review yourself with the same prompt.
3. If a finding is clearly inside the plan, fix it. Then run the checks again.
4. Report each other finding to the user. Do not fix it.

## Step 4: Lower the level if necessary

Use level 0 for the current phase in these cases:

- A check still fails.
- The code does not match the plan.
- The review found a problem that you did not fix.
- The phase changed a file that the plan does not name.

Never raise a level. Only the user can raise it.

## Step 5: Commit and report

1. Update the section "Progress" in the plan. Use the format of `assets/progress.md`.
2. Write the phase report with `assets/phase-report.md`.
3. If the level is 0 or 1, show the report and stop. Wait for the approval of the user.
   After the approval, commit the phase. Then continue with the next phase.
4. If the level is 2 or 3, commit the phase. Show the report and continue with the next phase.
5. If the level of the next phase is 0 or 1 and the current level is 2, stop after the commit. Reason: the user must see the work before a risky phase.

Rules for commits:

- Stage only the files of the phase. Do not stage `.agent-work/`.
- Use the commit format of the project instructions.
- Do not push, amend, rebase or reset. Reason: the user can then review and revert each phase locally.

## Step 6: Finish

After the last phase:

1. Set the section "Progress" to done.
2. Give a summary: one line for each phase with the commit hash, then all deviations and open points.
3. Tell the user to review the commits and to push when the review is done.

## Guidelines

- Talk to the user in the language of the user. Write the plan updates in simple technical English.
- Keep the phase report short. The user reads it to decide where to look in the diff.
- If the user gives feedback on a phase, fix it in a new commit. Do not amend.
