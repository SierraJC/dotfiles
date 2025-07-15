Follow the Conventional Commits format strictly for commit messages. Use the structure below:

```
<type>[optional scope]: <description>

[optional body]
```

Guidelines:

1. **Type and Scope**: Choose an appropriate type (e.g., `feat`, `fix`, `chore`, `refactor`, `deps`) and optional scope to describe the affected module or feature. When referring a function, variable, or component name, always wrap it in a code quote, such as `MyComponent`.
   Not everything is a `feat`! Use `feat` for new features that affect the user experience, `fix` for bug fixes, and `chore` for most tasks and maintenance tasks. Use `refactor` for code changes that neither fix a bug nor add a feature. Use `deps` when editing a dependency file like `package.json`, `go.mod`, etc.

2. **Description**: Write a concise, informative description in the header; use backticks if referencing code, function/component names, or specific terms.

3. **Body**: For additional details, use a well-structured body section:
   - Use bullet points (`*`) for clarity.
   - Clearly describe the motivation, context, or technical details behind the change, if applicable.

4. **Footer**: Optionally, include a footer for breaking changes or issues related to the commit:
   - Use `BREAKING CHANGE:` to indicate any breaking changes.

Commit messages should be clear, informative, and professional, aiding readability and project tracking.