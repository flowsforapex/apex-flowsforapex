This is the Flows for APEX Community Edition (CE).

- This is the base implementation.
- All database table ddl should be placed in the CE install script.
- Package Specs (.pks) for both CE and EE packages should be placed in this repo.
- Do not include package bodies for enterprise-only features here.
- Changes should remain compatible with open-source distribution.
- Any new database objects should be added to the manifest in /src/apex/buildConfig.json. Omitting an object from buildConfig.json will cause it to be excluded from packaged builds. If you are unsure of the correct manifest entry format, refer to an existing entry of the same object type as a template.

## Error Handling Conventions

- Use this decision procedure for error handling:
	1. Is a process instance or subflow currently executing? If no, use `flow_errors.handle_general_error` only for true non-instance, design-time or pre-execution operations (for example loading, validating, or creating process definitions before execution starts).
	2. If yes, use `flow_errors.handle_instance_error` for execution-path errors, including background, scheduled, recursive, or autonomous engine execution, even when the root cause is model or configuration related.
	3. For transient external or AI provider failures during execution, log without moving to error state only when both conditions are true: the process has a configured automatic retry or fallback path, and the instance can continue to a valid next state without the failed result. Otherwise use `flow_errors.handle_instance_error`.
	4. In autonomous transaction contexts, call `handle_instance_error` before the autonomous transaction commits so the error state is persisted independently of the outer transaction. Do not defer error recording to the outer transaction, as an outer rollback would lose the error record.
	5. Do not leave execution-path errors as debug-only logging when the process should stop and surface the problem.

## Error Message Conventions

- If you introduce a new error message key, add an inline comment immediately after the error call showing the key and English text.
- Use this comment format: `-- $F4AMESSAGE 'message-key' || 'English message text'`
- Append new English messages as the last INSERT statements in `src/data/install_engine_messages_en.sql`, after all existing entries and before any trailing COMMIT or end-of-file comment.
- Keep message keys to 30 characters or fewer.
- Reuse existing message keys when they represent the same error condition, even if wording differs slightly. If the condition is meaningfully different (different cause, different remediation, or different audience), create a new key. When in doubt, prefer a new key over overloading an unrelated existing key.

## Runtime Guidance

- Apply the Error Handling Conventions decision procedure above for adhoc subprocess and similar engine-runtime code.
- During runtime, model or configuration defects should be treated as instance errors, not general errors.
- Malformed control payloads or invalid runtime responses that prevent safe execution should be treated as instance errors.
