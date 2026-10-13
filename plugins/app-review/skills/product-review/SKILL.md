---
name: product-review
description: Validates a running app or codebase from a product point of view. Traces the app's PRD against what the app actually does, in both directions, then judges product fundamentals such as core job, time to first value, scope creep, retention, and measurement. Produces a severity-ranked findings report in chat and logs findings to the project's tracker (GitHub issues or a markdown file) after the user rules on an export queue. Use whenever the user asks for a product review or product validation of an app, asks whether an app does what its spec says, wants a scope or feature-creep check, or wants a product lens on something already built, even without the words "product review." Requires an existing app, screenshots, or code. For a review of the PRD document alone, use prd-review instead. Leaves interface design to design-review, code structure to architecture-review, and accessibility to accessibility-review.
---

# Product Review

Judge whether an app delivers the product its PRD promises, and whether that promise is the right one. The PRD sets the baseline. The running app, screenshots, and code supply the evidence. Every finding cites evidence; opinions without evidence do not ship.

## Boundaries

This skill covers product intent, scope, user value, and measurement. Visual design and interaction quality belong to design-review, and accessibility belongs to accessibility-review. Code structure, data model, security, and operations belong to architecture-review. A full audit of the PRD document belongs to prd-review. When a product finding has a design, architecture, or accessibility cause, record the product impact here and tag the handoff instead of diagnosing it. Accessibility-review is not yet available; tag accessibility issues `handoff: accessibility` and do not diagnose them.

## Progress checklist

Copy this checklist into the response and check items off as the review proceeds:

```
Product review progress:
- [ ] Step 1: Inputs gathered, coverage declared
- [ ] Step 2: PRD readiness gate passed
- [ ] Step 3: Requirements ledger built
- [ ] Step 4: Forward trace complete
- [ ] Step 5: Reverse trace complete
- [ ] Step 6: Fundamentals walked
- [ ] Step 7: Findings written
- [ ] Step 8: Report verified
- [ ] Step 9: Report delivered
- [ ] PRD changes passed to prd-review (if chosen)
- [ ] Export queue ruled, run summary delivered
```

## Step 1: Gather inputs and declare coverage

Find the PRD. Check, in order: files attached to the conversation, Project knowledge, a path or URL the user gives, then the repo (`docs/`, `PRD.md`, `SPEC.md`, `README.md`). If no PRD exists, stop and ask for one. A product review without stated intent turns into taste.

Find the app evidence, strongest first:

1. **Live app:** a URL Claude can drive through a browser tool, such as Claude in Chrome in Cowork. Observed behavior is the strongest evidence.
2. **Screenshots or recordings** the user supplies.
3. **Repo:** routes, controllers, views, feature flags, and seed data show what exists even when Claude cannot run it.
4. **PRD claims alone:** these never count as evidence that a feature works.

Before reviewing, tell the user in two or three sentences which evidence sources you have and which you lack. Every requirement later traced through a weaker source carries that limit in its confidence rating.

Then resolve the project's tracker and list its open entries as in `references/tracker.md` Steps 1 and 2, and reconcile against them while writing findings.

## Step 2: Check PRD readiness

This step gates the review; prd-review audits the document in full. Check that the PRD states three things:

- **Primary user:** one user, described by situation and need.
- **Core job:** one sentence stating what that user hires the app to do.
- **Testable requirements:** statements a reviewer can confirm or refute by watching the app.

If any of the three is missing or too vague to trace against, stop. Tell the user which one fails, quote the passage when one exists, and recommend running prd-review before product-review.

If all three pass, continue. Record any other PRD gaps the trace exposes along the way (an untestable requirement, a metric with no target) as findings with the `prd` lens, rated by the `prd` lens rule in `references/rubric.md` section B, and point to prd-review for the full audit.

## Step 3: Build the requirements ledger

Extract every testable statement from the PRD into a ledger with these columns:

| ID | Type | Statement (paraphrased) | PRD location |

Types: `user`, `job`, `requirement`, `metric`, `non-goal`, `constraint`. Number them R1, R2, and so on. Paraphrase faithfully; never add requirements the PRD omits. When the PRD states something vaguely, record it as written and log a `prd` finding.

## Step 4: Forward trace (PRD to app)

For each ledger row, assign a status and cite evidence:

- **Delivered:** the app does it, as specified.
- **Partial:** the app does part of it, or does it with a gap that blocks some users.
- **Diverged:** the app does something different from what the PRD says.
- **Missing:** no evidence of it anywhere.
- **Unverifiable:** the available evidence cannot settle it. Say what evidence would.

For metrics, check whether the app captures the data the metric needs (events, timestamps, counts). A success metric with no instrumentation counts as Missing.

For non-goals, check whether the app quietly does them anyway. That counts as Diverged.

## Step 5: Reverse trace (app to PRD)

List features, screens, settings, and flows in the app that no ledger row accounts for. For each, decide whether it serves a stated job (fine, though the PRD should catch up), serves no stated job (scope creep), or contradicts a non-goal (Diverged). Unaccounted features carry real cost in maintenance and user attention, so name them.

## Step 6: Product fundamentals

Read `references/rubric.md` section A and walk the app through each fundamental. These checks catch problems a faithful trace misses, because a PRD can describe the wrong product perfectly.

## Step 7: Write findings

Each finding uses this shape:

```
### P-03 · Major · trace
**Finding:** One sentence stating what is wrong.
**Evidence:** What Claude observed, and where (URL path, screenshot, file:line, PRD section). Mark the source: observed, screenshot, code, or PRD-only.
**Impact:** Who it hurts and how, in terms of the core job.
**Recommendation:** The smallest change that fixes it. If the PRD is what should change, say so.
**PRD change:** no, or the PRD decision to make (for example, "keep the export feature and add it to the PRD, or remove it").
**Confidence:** High, Medium, or Low, with the reason when below High.
**Handoff:** code, design, architecture, accessibility, or none.
```

Lenses: `prd`, `trace`, `scope`, `fundamentals`. Severities are Blocker, Major, Minor, and Nit, defined in `references/rubric.md` section B with a calibration example. Apply them strictly; inflated severity makes the report useless for triage.

## Step 8: Verify the report

Before delivering, check the draft against each item below. Fix every failure, then check again. Deliver only when every item passes.

- Every ledger row has a status, and every status other than Delivered has evidence or a stated reason.
- Every finding cites an evidence source, and its confidence reflects that source's strength.
- Every severity matches its definition in rubric section B. Re-read each Blocker and Major against the definition.
- The reverse trace lists at least the app's top-level navigation, or states that the evidence could not reveal it.
- No finding diagnoses a design or architecture cause that belongs in a handoff.
- Every finding whose fix changes the PRD, including every scope finding from the reverse trace, fills in `PRD change`.
- Every finding has a location stable enough to fingerprint: a route, screen, file path, PRD section, or component.

## Step 9: Report in chat

Use this order:

1. **Verdict:** two or three sentences. Does the app deliver its core job for its primary user today? State the single biggest gap.
2. **Coverage:** evidence sources used and their limits.
3. **PRD readiness:** one line confirming the Step 2 gate passed.
4. **Trace summary:** counts by status (for example, 14 Delivered, 3 Partial, 1 Diverged, 2 Missing, 1 Unverifiable), then the full ledger with statuses.
5. **Findings:** grouped by severity, Blockers first. Number them P-01, P-02, and so on across the whole report.
6. **PRD changes:** the IDs with a PRD change, one line each.
7. **Handoffs:** the IDs tagged for another review, one line each.
8. **Next step:** name the reviews this report's handoffs point to, with counts, as suggested next runs (for example, "3 findings are tagged design; run design-review next"). For `code`, suggest a code reviewer; for `accessibility`, say that review is not yet available. Then ask whether to pass the PRD changes to prd-review's grill now. After that, or on a no, present the export queue and the run summary as in `references/tracker.md`.

Write plainly. No praise sections and no "strengths" padding. A Delivered row is the only acknowledgment a working feature needs.

## Passing PRD changes to prd-review

Run this only on an explicit yes. Product-review does not grill; prd-review owns decisions about the PRD. Hand prd-review the findings with a PRD change as its finding list, keeping their P-numbers, and tell it to start at Phase 2. Fixes to the app stay in this report and go to the export queue. Findings prd-review settles in its grill count as written in this run's summary; the rest go to this run's export queue. On a no, the findings with a PRD change go to the export queue as well, labeled `handoff:prd`, so a later prd-review run picks them up.

## Tracking findings

Read `references/tracker.md` and follow it with the label `product-review`, the ID prefix `P`, and the finding fields from Step 7. Every finding ends the run written, exported, or dropped; export only what the user rules on in the queue.
