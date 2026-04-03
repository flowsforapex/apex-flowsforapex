This is the Flows for APEX Community Edition (CE).

- This is the base implementation.
- All database table ddl should be placed in the CE install script.
- Package Specs (.pks) for both CE and EE packages should be placed in this repo.
- Do not include package bodies for enterprise-only features here.
- Changes should remain compatible with open-source distribution.

## Error Handling Conventions

- Prefer `flow_errors.handle_instance_error` for errors tied to a running process instance or subflow.
- This includes background, scheduled, recursive, or autonomous engine execution, even when the root cause is model or configuration related.
- Use `flow_errors.handle_general_error` only for true non-instance errors, typically UI-driven or design-time operations such as loading, validating, or creating process definitions.
- If an error occurs during step execution and the instance should move into error state so it can be restarted, use `handle_instance_error`.
- Do not leave execution-path errors as debug-only logging when the process should stop and surface the problem.

## Error Message Conventions

- If you introduce a new error message key, add an inline comment immediately after the error call showing the key and English text.
- Use this comment format: `-- $F4AMESSAGE 'message-key' || 'English message text'`
- Add new English messages to `src/data/install_engine_messages_en.sql` near the bottom of the file.
- Keep message keys to 30 characters or fewer.
- Reuse existing message keys where the semantics already match.

## Runtime Guidance

- For adhoc subprocess and similar engine-runtime code, model or configuration defects encountered during runtime should normally be treated as instance errors, not general errors.
- Transient external or AI provider failures may remain soft only if there is a safe fallback or deferred retry that preserves correct process behavior.
- Malformed control payloads or invalid runtime responses that prevent safe execution should be treated as instance errors.