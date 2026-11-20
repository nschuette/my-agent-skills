# Autonomy levels

Each phase of a plan has a level. The level tells `implement` how far it can go without the user.

| Level | Name | What `implement` does | Condition |
|---|---|---|---|
| 0 | Pair | Stops after the phase. The user reviews the diff. Commits after the approval of the user. | None |
| 1 | Checked | Like level 0. Before the stop, it runs the automated success criteria and a review against the plan. It reports the reading order and the risks. | The test commands are known. |
| 2 | Batch | Commits the phase itself and continues. Stops only at a phase with level 0 or 1, or at the end. | Tests cover the changed behavior. Lint or type checks run with one command or a hook. |
| 3 | Full plan | Implements all phases and commits each phase. The user reviews at the end. | Good test coverage, hooks and clear rules in `CLAUDE.md` or `AGENTS.md`. |

## Choose the level

1. Start with level 1. Reason: it makes the review faster and keeps the user in control.
2. If the phase touches one of these areas, use level 0:
   - database migrations and changes to stored data
   - authentication and permissions
   - public APIs and other contracts with other systems
   - payments and other money flows
3. If the approach of the phase is uncertain, use level 0. Reason: an error in the approach is cheaper to find before the next phase.
4. If the condition of a level is not true for the project, use a lower level.
5. If `CLAUDE.md` or `AGENTS.md` of the project sets a maximum level, do not go above it.
6. Use level 2 or 3 only for phases without risk, for example a rename or a new isolated function with tests.

Write the reason in one line, for example "Level 0: changes the permission check".
The user can change each level when they approve the outline.
