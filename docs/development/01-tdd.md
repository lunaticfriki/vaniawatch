# Test-Driven Development

All production code is written test-first, in every package. No production code exists without a test that failed first and demanded it.

## The cycle

1. **Red.** Write the smallest test that describes the next behavior. Run it and watch it fail for the *expected* reason: a missing class or wrong behavior, not a typo.
2. **Green.** Write the minimum production code that makes it pass. Do not write code no test asks for.
3. **Refactor.** With the suite green, clean up names, duplication and structure in both the production code and the test code. Run the tests again.

Repeat. Each cycle is minutes, not hours.

## Order of work for a new feature

Build from the inside out. Each step starts with its tests:

0. **Design in the vault.** Read the relevant notes in [[codebase]], then create the new concept notes with `status: planned` and link their relations. See [[05-docs-vault#During a task: design in the vault]].
1. **Value objects** (`core`): `create` accepts valid input and rejects invalid input with the right `DomainError`; `empty` behaves as expected; equality is structural.
2. **Entities and aggregates** (`core`): behavior and invariants, with fixtures built by Object Mothers.
3. **Domain services and errors** (`core`).
4. **Repository port** (`core`): the `abstract class` only. Its signatures are driven by what the handler tests need.
5. **Command and query handlers** (`frontend` / `backend`), with mocked ports.
6. **Read and write services**, checked to delegate to the right handler.
7. **Infrastructure adapters and ACL mappers**: mapping in both directions, and the adapter honoring the port contract.
8. **Presentation**:
   - frontend: Cubit tests with `bloc_test` (the exact state sequence), then page tests with a mocked Cubit, then view tests with plain parameters.
   - backend: route tests with a mocked `RequestContext`, plus error middleware tests.

## Rules

- A bug fix starts with a failing test that reproduces the bug.
- Test names describe behavior in business language: `'cannot add a line once confirmed'`, not `'test addLine'`.
- Keep one behavior per test. Arrange with Object Mothers, act once, assert.
- Never weaken or delete a failing test to get to green. Fix the code, or change the test only when the requirement itself changed.
- The suite stays green on every commit, and the pre-push hook enforces it. See [[04-git-workflow]].
- AI assistants follow the same cycle. Propose or write the test first, show it failing, then implement.
- When the cycle is done, update the vault notes. A task is not done until [[05-docs-vault#After a task: update the vault (definition of done)|the vault reflects it]].
