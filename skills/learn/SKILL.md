---
name: learn
description: Turns review feedback into a rule and writes it to the right place. The place is coding-principles, the project instructions, or a proposal for lint or a hook. Use only when the user runs /learn.
disable-model-invocation: true
argument-hint: "[feedback]"
allowed-tools:
  - Bash(git rev-parse *)
  - Bash(git diff *)
  - Read(~/.claude/skills/learn/**)
  - Read(~/.claude/skills/coding-principles/**)
---

# Learn from feedback

Feedback: $ARGUMENTS

If the line before is empty or shows a placeholder, the feedback is in the message that started this skill.
The feedback can also come from the conversation before this command. Use all sources.
If there is no feedback in any source, ask for it and stop.

## Step 1: Understand the feedback

1. If the user gives a link to a pull request, get its review comments with a tool, for example `gh`.
2. Find the problem behind the feedback. Ignore the single case. Example: "passive voice in line 12" means "new text does not follow the writing rules".
3. Find the cause. Ask: what did the agent not know, or what did it skip?
4. If the feedback is unclear, ask. Do not guess the rule.

## Step 2: Choose the place

Choose one place with `references/places.md`.
Reason: a rule in the wrong place either applies in projects where it is wrong, or it is missing where it is needed.

## Step 3: Check the place

1. Read the target file fully.
2. If the target file has a rule for the same problem, sharpen that rule. Do not add a second rule.
3. If the target file has a rule that conflicts with the new rule, show both to the user and ask.
4. If the agent already follows the rule without help, tell the user. Reason: such a rule costs context and adds nothing.

## Step 4: Write the rule

1. Write the rule in the format of the target file. If the file has no format, use these parts:
   - A condition and an instruction: "If ..., do ...".
   - One example, if the rule is not obvious.
   - The reason, if it is not obvious.
2. If the target file has writing rules, follow them.
3. Keep the rule short. Name the problem, not the single case.

## Step 5: Ask for approval

1. Show the path of the target file and the diff.
2. Give the place and the reason for the place in one sentence.
3. Stop and wait for the approval. Reason: a rule changes each later session.

## Step 6: Write and hand over

1. If the place is a tool, do not change the tool configuration. Tell the user the file and the setting. Stop.
   Reason: a new lint rule or hook can fail on existing code. The user decides when to add it.
2. Write the rule into the target file.
3. Do not commit. Reason: the user reviews and commits the change.
4. If the target is `coding-principles`, tell the user to commit the change in the skills repository and to run its `install.sh`.

## Guidelines

- Talk to the user in the language of the user. Write the rule in the language of the target file.
- One run of this skill writes one rule. If the feedback has more problems, ask which problem comes first.
