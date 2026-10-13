# Grill Protocol

A shared protocol for resolving a ranked list of findings with the user, one decision at a time, and writing each decision into a target artifact. Each skill that uses this file supplies three inputs:

- **Finding list:** ranked findings, each with an ID and its dependencies.
- **Target artifact:** the document that receives the decisions (a PRD, an ADR, design notes).
- **Standard for a good answer:** the skill's rubric, which every recommended answer must meet.

This file defines the conversation. The calling skill defines what good looks like.

## Rules

1. **One question per turn.** Ask about one finding, then stop and wait. Several questions at once force the user to hold too much in mind and invite shallow answers.
2. **Dependencies first.** Take findings in the ranked order. Before asking about a finding, confirm that every finding it depends on is resolved or deferred. If an answer changes an earlier decision, say so, and revisit that decision before moving on.
3. **Recommend an answer.** Every question carries Claude's recommended answer, written to meet the skill's standard, with one or two sentences of reasoning. The user decides faster when reacting to a concrete proposal.
4. **Look up facts; ask for decisions.** If the repo, the artifact, Project knowledge, or a tool can answer a factual question, look it up and state what you found. Put only judgment calls to the user: priorities, tradeoffs, scope, intent.
5. **Never invent a decision.** A recommendation is a proposal until the user accepts it. Silence, "sure," or a move to another topic counts as acceptance of nothing beyond what the user plainly agreed to.
6. **Hold the standard.** If the user's answer falls short of the skill's standard (a metric with no target, a requirement no one can test), say what is missing and propose the smallest addition that meets it. If the user declines, accept the answer as written and note the remaining shortfall in the closing summary.

## Turn format

```
**PRD-04 · Blocker · metrics** (3 of 9)
**Finding:** The PRD lists no metric for the core job.
**Why it matters:** Product-review cannot tell whether the app works.
**Question:** What number would tell you the core job is succeeding?
**Recommended:** "60% of new teams complete a second weekly check-in within 14 days of signup, measured from the check-ins table." Reasoning: a repeat check-in is the earliest proof that the core job delivers value.

Accept, edit, defer, or drop?
```

The user's four responses:

- **Accept:** write the recommended text into the artifact.
- **Edit:** write the user's version, after checking it against the standard (rule 6).
- **Defer:** add the question to the artifact's open questions, with an owner or date if the user gives one.
- **Drop:** the finding does not matter to the user. Record it in the closing summary and make no change to the artifact.

## Writing back

Write each decision as soon as the user settles it, so stopping midway keeps the progress made. Before writing, show the exact text going in and where it lands. Choose the write path by where the artifact lives:

1. **Editable in place** (a local file in Cowork, a repo file, or a doc Claude can edit through a connected tool): apply the change, then confirm it in one line.
2. **Read-only** (an attachment, Project knowledge, a repo snapshot): keep a running list of section replacements in the conversation. At the end, deliver the full revised artifact in its original format so the user can replace the old one in one step.

Preserve the artifact's existing structure, headings, and voice. Add a section only when a decision has no home, such as a missing Non-goals section.

## Ending

The grill ends when every finding in the list is resolved, deferred, or dropped, or when the user stops. Close with a summary:

1. Counts: resolved, deferred, dropped, and remaining.
2. Each decision in one line, with its finding ID.
3. Any answers the user accepted below the standard, with the remaining shortfall.
4. The calling skill's closing step, such as a rescore.
