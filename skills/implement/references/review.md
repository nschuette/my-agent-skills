# Review prompt

Give this prompt to the review subagent. Replace the placeholders.

````markdown
Review one phase of an implementation against its plan. Do not change files.

Plan: <path of the plan>
Phase: <number and name>
The phase is not committed yet. Run `git status --short` and `git diff HEAD`. Read each new file fully.

Check these points:

1. Coverage: each change of the phase is in the diff.
2. Scope: the diff changes nothing that the phase does not name.
3. Behavior: the code does what the table "Behavior" says for this phase. Check the words that set the scope, for example "always" or "for all users".
4. Tests: the new tests check the behavior of the phase. A test that cannot fail does not count.
5. Bypasses: if the phase adds a restriction, it applies on each path to the same data.
6. Decisions: the code follows the section "Decisions".
7. Principles: if the skill `coding-principles` is available, load it. The code follows its rules.
   An exception in the section "Decisions" is not a finding.

Report each finding in one line: `path:line`, the problem, and if the plan covers the fix.
For a finding of point 7, name the rule.
If there are no findings, write "No findings".
Do not report style problems that lint or the formatter find.
````
