# Product Review Rubric

## A. Product fundamentals

Walk each check against the live app when possible.

1. **Core job.** Can a new user complete the core job end to end? Count steps and note every point where they must leave the app, wait on someone, or guess.
2. **Time to first value.** How long and how many steps from first visit to the first moment the app pays off? Name that moment. Signup, email verification, and configuration all count against it.
3. **Core loop.** What brings a user back, and what do they do each time? If no loop exists, the app is a one-time utility; check whether the PRD intends that.
4. **Retention hooks.** Notifications, email, shared state with other people, or accumulated data that grows more valuable. For each hook, confirm it works (email actually sends, links actually resolve).
5. **Multi-user dynamics.** If the app involves more than one person (a household, a team), check invitation, the second user's first experience, permissions, and what happens when one person leaves.
6. **Trust.** What data does the user hand over, and does the app earn it? Check for a clear privacy statement, data export, and account deletion when the app holds personal data.
7. **Edge populations.** The empty account, the heavy user with years of data, the user on a phone, the user who returns after six months.
8. **Measurement.** Can the app's owner answer "is this working?" from the data the app records today?

## B. Severity

Each level names the action it requires. The product column defines the impact that earns it.

| Severity | Action | Product impact |
|---|---|---|
| Blocker | Resolve before the next release. | Blocks the core job for the primary user, loses or exposes user data, or makes a success metric impossible to achieve. |
| Major | Fix before the next release unless the owner records a reason. | Blocks the core job for a meaningful segment, breaks a retention hook, or diverges from the PRD in a way users will notice. |
| Minor | Fix when convenient. | Adds friction to the core job, leaves a requirement partial, or adds unaccounted scope that costs maintenance. |
| Nit | Record only when a stated standard covers it. | Wording or polish with no user-visible effect. |

Findings with the `prd` lens judge the document, not the app, so they take prd-review's severities to keep one scale across both skills: an untestable requirement or a core-job metric with no target is Major; an orphan requirement, an open question with no owner, or a constraint with no reason is Minor.

When unsure between two levels, pick the lower and state why in Confidence.

### Calibration example

An inflated finding:

```
### P-07 · Blocker · fundamentals
**Finding:** The signup page asks for a phone number the app never uses.
**Evidence:** /signup form field "Phone (optional)" (observed); no code path reads it (code).
**Impact:** Users may distrust the app.
```

The field is optional, so it blocks no one, and nothing shows users abandoning signup over it. It adds friction and a trust cost without stopping the core job. Corrected:

```
### P-07 · Minor · fundamentals
**Finding:** Signup asks for a phone number the app never uses.
**Evidence:** /signup form field "Phone (optional)" (observed); no code path reads it (code).
**Impact:** Adds a field to the first-run path and asks for personal data with no stated purpose, which costs some trust.
**Recommendation:** Remove the field until a requirement needs it.
**Confidence:** High.
**Handoff:** none.
```
