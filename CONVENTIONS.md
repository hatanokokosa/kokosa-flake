Explicit user instructions override all rules and conventions defined in this file.

### Code Standards

Implement only what was requested. A constraint narrows permitted effects; it does not authorize adding unsolicited features, extra dependencies, or speculative abstractions.

Prefer one established path. Add configuration, fallbacks, compatibility, caches, or abstractions only for an observed contract. Simple, readable code over minimizing.

Clean orphans created by the change. Report adjacent drift unless it blocks the fix. Choose the more current or better-tested pattern when local conventions conflict.

Write code that even a beginner can easily understand. Avoid overly clever or obscure syntactic sugar.

Reduce unnecessary lines of code. Minimize redundant classes, abstractions, or boilerplate. No unnecessary comments; write self-explanatory code instead.

Keeping the code simple, stupid. Extract reusable logic into modular components (DRY principle). Do not over-engineer.

Do not use emojis anywhere in the source code, logs, or error messages.

### Comments

A comment states the non-obvious reason at the owning boundary. Do not restate the operation, preserve intermediate attempts, or list speculative future work.

Never write comments explaining what was deleted, why an alternative was rejected, or that a change was made per user request. Deliver the code as if the rejected feature never existed.

### PR & Commit

State the final behavior and only the material rationale or trade-offs that a reviewer cannot recover from the diff. A mechanical change may need only one sentence.

Describe what the change actually delivers. Never reference rejected attempts, deleted features, or conversational debates in commit messages or PR titles.

Do not use emojis in commit messages, PR titles, or PR descriptions. Use clear, imperative, and concise language.

Keep commits atomic and focused. Use structured PR sections only when multiple distinct architectural decisions require navigation; do not force rigid boilerplate on simple changes.

### Build & Test

If the project already has a designated test directory, all new test files must be placed inside it. Only if no such directory exists may tests be placed adjacent to the target source file.

Ensure all newly created test files are automatically discoverable and executable by the project's standard test command without modifying test configuration files.

Ensure new tests manage their own setup and teardown. Tests must clean up generated artifacts, database rows, and mock states upon completion.

Commit only formal unit, integration, or end-to-end tests intended to prevent regressions. Delete any temporary diagnostic scripts prior to completing the task.

### File & Directory

Keep the repository root clean. New files, tests, or modules must adhere strictly to the established directory structure and must never be placed directly in the root folder.

Do not create unprompted documentation, summary files, migration notes, or changelogs. Deliver explanations directly in the conversation, not as repository files.

Never create backup files or version-suffixed duplicates. Rely entirely on Git for history and rollbacks.

Confine all disposable scripts, exploratory runs, raw logs, and intermediate debugging outputs exclusively to the .scratch/ directory.

The .scratch/ directory is not assumed to exist by default. If you need to create temporary files, first create .scratch/ if missing and ensure it is listed in .gitignore so it is never committed.

Never leave temporary files in standard workspace directories, and never import or reference scratch files from production code or formal test suites.
