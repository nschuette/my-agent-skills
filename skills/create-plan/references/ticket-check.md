# Check the task

A ticket shows what the ticket author knew when they wrote it.
Before you plan, check the task against the code. Then the plan does not build on a wrong assumption.

## What to check

1. Assumptions: the task states or implies a fact about the current system. Check each fact in the code.
   Example: "The export already shows all orders." The code shows only orders of the last 90 days.
2. Gaps: the change needs a behavior that the task does not state.
   Examples: empty state, errors, permissions, existing data, limits, notifications.
3. Contradictions: two statements cannot both be true.
   This includes a statement against the code and two acceptance criteria against each other.
4. Edge cases: inputs and states at the boundary.
   Examples: empty, very large, null, duplicates, concurrent changes, deleted or archived records, other roles, time zones.
5. Scope: a path to the same data that the task does not name.
   Examples: API endpoints, jobs, imports, exports, caches.

Report only findings that change the plan. Do not list generic risks. Reason: a long list hides the important questions.

## Sort the findings

- Fact: the code answers it. State it with a `path:line` reference. Do not ask.
- Technical decision: the user can decide it. Ask it in step 4.
- Product question: only the ticket author can decide it, for example the product manager.

## Ask the product questions

1. Show the product questions in a separate list "Questions for the ticket author".
2. Give each question a number, the reason in one sentence and a proposed answer.
3. Tell the user the options: answer the questions, accept the proposed answers, or wait for the ticket author.
4. If the user wants to wait for the ticket author, stop. When the user gives the answers, continue.
5. If the task has no ticket, ask the product questions to the user. Do not offer a ticket comment.
6. Write each answer into the section "Decisions" of the plan. The source is the answer of the ticket author or the user.

## Ticket comment

If the user asks for a ticket comment, write it with `assets/ticket-comment.md`.

- Write the comment in the language of the ticket.
- Write for a reader who does not know the code. Do not use paths, class names or code.
- If the user does not tell you to post the comment, do not post it.
  Reason: a ticket comment is a message on behalf of the user.
