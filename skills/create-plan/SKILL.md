---
name: create-plan
description: Writes a phased implementation plan with success criteria to .agent-work/plans/<branch>/ in the project. Writes no code. Use only when the user runs /create-plan.
disable-model-invocation: true
argument-hint: "[task, ticket or file]"
allowed-tools:
  - Bash(git branch --show-current)
  - Bash(git rev-parse *)
  - Bash(git symbolic-ref *)
  - Read(~/.claude/skills/create-plan/**)
---

# Create a plan

Task: $ARGUMENTS

If the line before is empty or shows a placeholder, the task is in the message that started this skill.
The task can also come from the conversation before this command. Use all sources.
If there is no task in any source, ask for it and stop.
Do not change project code. Do not commit.

## Step 1: Find the plan folder

1. Get the branch with `git branch --show-current`.
2. If the output is empty (detached HEAD), stop. Tell the user to check out a branch.
3. If the branch is `main`, `master` or the branch of `origin/HEAD`, stop. Tell the user to create a branch first. Reason: plans are stored for each branch.
4. Get the project root with `git rev-parse --show-toplevel`.
5. Replace each `/` in the branch name with `-`.
6. The plan folder is `<project root>/.agent-work/plans/<branch>/`.
7. If `<project root>/.agent-work/.gitignore` does not exist, create it with the single line `*`.
   Reason: then git ignores the folder and never commits a work file. Nothing changes in the repository.
8. Run each git command of this step on its own. Reason: the allowed tools match only single commands.

## Step 2: Collect context

1. If the user gives a ticket key, get the ticket with a ticket tool, for example a Jira MCP server. Get the summary, the description, the acceptance criteria and the relevant comments. If no ticket tool is available, ask the user to paste the ticket text. Stop until the user does.
2. If the plan folder contains `*.research.md` files, read them fully. Use them as the main source for the current state. Check only the facts that the plan depends on.
3. If the plan folder already contains a plan for this task, ask the user: update it or write a new one.
4. Read all files and links that the user gave. Read them fully.
5. List the requirements of the task before you explore the code. Keep the words that set the scope, for example "always" or "for all users". Reason: the existing code must not change what the task requires.
6. Find the commands for tests, lint and build. Look in `CLAUDE.md`, `AGENTS.md`, `README`, `Makefile`, `package.json` and `composer.json`. If you cannot find them, ask. Do not guess.
7. Explore the code that the task touches. Find existing patterns that the change can follow. A pattern shows how to build the change. The task decides what the change does.

## Step 3: Check the task

The task is input, not truth. It can contain wrong assumptions, gaps and contradictions.
Check the task against the code. Follow `references/ticket-check.md`.
Ask the questions together with the questions of step 4, before the outline.

## Step 4: Clarify

1. Ask only what the code cannot tell you: decisions, constraints and scope.
2. Do not ask about facts that you found. State them instead.
3. If a pattern contains an exception that the task does not state, ask if the exception applies to this task.
   An exception is a condition that makes a requirement not apply, for example a flag, a parameter, a role or a fallback.
   Reason: the existing code can have a different scope than this task.
4. Ask all questions in one message. If the task is clear, do not ask.
5. If the task contains independent parts, propose one plan for each part.

## Step 5: Choose the approach

If there is more than one sensible approach, show 2 or 3 options:

- For each option: the approach, the advantages and the risks.
- If two options meet all requirements, prefer the option that follows the existing patterns.
- Recommend one option and give the reason.

Then stop and wait for the decision.
If there is only one sensible approach, state it in one or two sentences. Do not stop.
You can show the options in the same message as the questions from steps 3 and 4.

## Step 6: Propose an outline

Show the user:

- The goal in one sentence.
- The phases, with one line for each phase. Give each phase a level and the reason for the level.
- What is out of scope.
- Each exception to a requirement, with its source.

Then stop and wait for approval.

Rules for phases:

- Each phase leaves the project in a working state.
- Each phase can be verified and committed on its own.
- Put foundations first, then logic, then wiring.
- Use as few phases as possible. One phase is correct for a small task.
- If a phase changes behavior, it starts with a test for the new behavior. Reason: the test shows that the phase works.

Choose the level of each phase with `references/autonomy-levels.md`.
The level tells `implement` if it stops after the phase.

## Step 7: Write the plan

1. If a question is still open, ask it now. Do not write open questions into the plan. Reason: the plan must be complete enough to implement.
2. Name the file `YYYY-MM-DD-<slug>.plan.md`. The slug has 2 to 5 words in kebab-case.
3. Write the plan into the plan folder. Use the structure of `assets/plan-template.md`.
4. If you cannot write the file, stop and tell the user. Do not write the plan to a different place. Reason: the next session looks for the plan in the plan folder.

## Step 8: Check the plan

Read the plan again and check these points. Fix each problem in the plan.

1. Coverage: each requirement of the task and each acceptance criterion of the ticket has a row in the table "Behavior" and a phase.
   The phase covers the full scope of the requirement. Compare the scope with the words of the task.
2. Exceptions: each exception in the plan is in the section "Decisions" with a source in the task or in a statement of the user.
   "The existing code does it" is not a source.
   If an exception has no source, ask the user. If the user does not confirm it, remove it.
3. Bypasses: if the plan adds a restriction, the restriction applies on each path to the same data.
   Examples of paths: request parameters, other endpoints, jobs, caches and aggregates.
4. Precision: each line decides something. Replace vague lines such as "handle edge cases" or "add validation" with the exact behavior.
5. Names: each file, function and signature has the same name in all phases.
6. Checks: each phase has automated success criteria with exact commands.
   If a phase changes behavior, its first change adds a test for this behavior.
7. Levels: each phase has a level and a reason. Each level follows `references/autonomy-levels.md`.
8. Review focus: each phase names what only a human can judge. Do not list what tests or lint check.
9. Size: the plan is shorter than the code that it describes. Replace function bodies with signatures and test names.
   The part before the first phase has 40 lines or fewer. Reason: the user reads this part to approve the plan.
   Each phase has 7 changes or fewer. If a phase has more, merge related changes or split the phase.

## Step 9: Hand over

1. Tell the user the path of the plan.
2. Give a short summary: phases, important decisions and risks.
3. Tell the user the next step: start a new session and run `/implement <path of the plan>`.
4. Stop and wait for the review. Do not start the implementation. Reason: the user must approve the plan first.

When the user gives feedback, change the plan file. Then show only what changed.

## Guidelines

- If the user corrects a fact, check the correction in the code before you use it.
- Write the plan in simple technical English. Do this also when a terse output style is active. Reason: the user and a new session must understand the plan without this chat.
  - Write sentences of 20 words or fewer, in the active voice.
  - Use one word for one thing in the full plan.
  - Start each change with a verb: "Add", "Change", "Remove" or "Move".
  - Write one line for each change. Give a reason only if it is not obvious.
- Talk to the user in the language of the user.
- Keep the plan short. Do not describe what the reader can see in the code.
- Show code only where the exact form is important: signatures, config keys, SQL.
- Show a signature as code. Do not describe it in words.
- If a flow changes across more than two components, add a Mermaid diagram of the new flow to "Approach".
- Do not define a commit format. The project instructions define it.
