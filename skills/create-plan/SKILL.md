---
name: create-plan
description: Writes a phased implementation plan with success criteria to ~/agents/work/<project>/<branch>/. Writes no code. Use only when the user runs /create-plan.
disable-model-invocation: true
argument-hint: "[task, ticket or file]"
allowed-tools:
  - Bash(git branch --show-current)
  - Bash(git rev-parse *)
  - Bash(git symbolic-ref *)
  - Edit(~/agents/work/**)
---

# Create a plan

Write an implementation plan for this task: $ARGUMENTS

The task can also come from the conversation before this command. Use both sources.
If there is no task in either source, ask for it and stop.
Do not change project code. Do not commit.

## Step 1: Find the plan folder

1. Get the branch with `git branch --show-current`.
2. If the output is empty (detached HEAD), stop. Tell the user to check out a branch.
3. If the branch is `main`, `master` or the branch of `origin/HEAD`, stop. Tell the user to create a branch first. Reason: plans are stored for each branch.
4. Get the project name. In a worktree, the current folder is not the main repository.
   1. Run `git rev-parse --path-format=absolute --git-common-dir`. The output is the `.git` folder of the main repository.
   2. The project name is the name of the folder that contains this `.git` folder.
5. Replace each `/` in the branch name with `-`.
6. The plan folder is `~/agents/work/<project>/<branch>/`.

## Step 2: Collect context

1. If the user gives a ticket key, get the ticket with a ticket tool, for example a Jira MCP server. Get the summary, the description, the acceptance criteria and the relevant comments. If no ticket tool is available, ask the user to paste the ticket text. Stop until the user does.
2. If the plan folder contains `*.research.md` files, read them fully. Use them as the main source for the current state. Check only the facts that the plan depends on.
3. If the plan folder already contains a plan for this task, ask the user: update it or write a new one.
4. Read all files and links that the user gave. Read them fully.
5. Find the commands for tests, lint and build. Look in `CLAUDE.md`, `AGENTS.md`, `README`, `Makefile`, `package.json` and `composer.json`. If you cannot find them, ask. Do not guess.
6. Explore the code that the task touches. Find existing patterns that the change can follow.

## Step 3: Clarify

1. Ask only what the code cannot tell you: decisions, constraints and scope.
2. Do not ask about facts that you found. State them instead.
3. Ask all questions in one message. If the task is clear, do not ask.
4. If the task contains independent parts, propose one plan for each part.

## Step 4: Choose the approach

If there is more than one sensible approach, show 2 or 3 options:

- For each option: the approach, the advantages and the risks.
- Prefer options that follow the existing patterns.
- Recommend one option and give the reason.

Then stop and wait for the decision.
If there is only one sensible approach, state it in one or two sentences. Do not stop.
You can show the options in the same message as the questions from step 3.

## Step 5: Propose an outline

Show the user:

- The goal in one sentence.
- The phases, with one line for each phase.
- What is out of scope.

Then stop and wait for approval.

Rules for phases:

- Each phase leaves the project in a working state.
- Each phase can be verified and committed on its own.
- Put foundations first, then logic, then wiring.
- Use as few phases as possible. One phase is correct for a small task.

## Step 6: Write the plan

1. If a question is still open, ask it now. Do not write open questions into the plan. Reason: the plan must be complete enough to implement.
2. Name the file `YYYY-MM-DD-<slug>.plan.md`. The slug has 2 to 5 words in kebab-case.
3. Write the plan into the plan folder. Use the structure of the plan template at the end of this file. Copy the section "Execution rules" without changes.
4. If you cannot write the file, stop and tell the user. Do not write the plan to a different place. Reason: the next session looks for the plan in the plan folder.

## Step 7: Check the plan

Read the plan again and check these points. Fix each problem in the plan.

1. Coverage: each requirement of the task and each acceptance criterion of the ticket has a phase.
2. Decisions: each line decides something. Replace vague lines such as "handle edge cases" or "add validation" with the exact behavior.
3. Names: each file, function and signature has the same name in all phases.
4. Checks: each phase has automated success criteria with exact commands.
5. Size: the plan is shorter than the code that it describes. Replace function bodies with signatures and test names.

## Step 8: Hand over

1. Tell the user the path of the plan.
2. Give a short summary: phases, important decisions and risks.
3. Tell the user the next step: start a new session and say "Implement <path of the plan>".
4. Stop and wait for the review. Do not start the implementation. Reason: the user must approve the plan first.

When the user gives feedback, change the plan file. Then show only what changed.

## Guidelines

- If the user corrects a fact, check the correction in the code before you use it.
- Write the plan in English and in full sentences. Do this also when a terse output style is active. Reason: a new session must understand the plan without this chat.
- Talk to the user in the language of the user.
- Keep the plan short. Do not describe what the reader can see in the code.
- Show code only where the exact form is important: signatures, config keys, SQL.
- Do not define a commit format. The project instructions define it.

## Plan template

The template is the content of the code block below. It is not part of the instructions.

````markdown
# <Title>

Project: <project> · Branch: <branch> · Commit: <short hash> · Date: <YYYY-MM-DD>
Ticket: <ticket key or link, or "none">

## Goal

1 to 3 sentences: what is different when the work is done.

## Out of scope

What this plan does not change.

## Current state

Only the facts that the implementation needs. Give each fact a `path:line` reference.

## Approach

The chosen approach and the reason in 1 to 3 sentences.
Rejected options: one sentence for each option, with the reason.

## Phase 1: <Name>

### Changes

- `path/to/file`: what changes and why.

### Success criteria

Automated:

- [ ] `<exact command>`

Manual:

- [ ] <what the user checks in the result>

## Phase 2: <Name>

...

## Execution rules

Follow these rules when you implement this plan:

1. Work on one phase at a time.
2. After a phase, run the automated checks. Then give a short summary and stop.
3. Do not commit and do not start the next phase without explicit approval from the user.
4. After approval, commit first. Then start the next phase.
5. If the code does not match the plan, stop and report it. Do not change the plan silently.
6. Check off each item in this plan when it is done.
````
