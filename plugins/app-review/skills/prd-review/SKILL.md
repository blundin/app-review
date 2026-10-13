---
name: prd-review
description: Audits a PRD, product spec, or requirements document against a product rubric, then optionally grills the user through its findings one decision at a time and writes each agreed answer back into the document. Findings left unsettled go into the PRD as open questions or to the project's tracker (GitHub issues or a markdown file), as the user rules. Use whenever the user asks to review, critique, audit, tighten, improve, stress-test, or grill a PRD, spec, product brief, or requirements doc, or asks whether a PRD is ready to build or ready for product-review, even without the words "PRD review." Judges the document alone and needs no running app. To check whether a built app matches its PRD, use product-review instead.
---

# PRD Review

Judge whether a PRD states the right product clearly enough to build and to verify, then help the user fix it. The skill runs in two phases with a stop between them, then a closing step. The audit scores the document. The grill resolves its findings one decision at a time and writes each decision back into the PRD. The closing step offers whatever is still unsettled as open questions in the PRD, so the document carries its own unknowns.

## Boundaries

This skill reviews the document only. It never judges whether an app matches the PRD; product-review does that. It also stays out of implementation design: module boundaries, data models, and technology choices belong to architecture-review. When a PRD prescribes implementation, flag that as a finding (rubric section B, check 4) without debating the implementation itself.

## Progress checklist

Copy this checklist into the response and check items off as the review proceeds:

```
PRD review progress:
- [ ] Step 1: PRD located, edit path noted
- [ ] Step 2: Elements scored
- [ ] Step 3: Cross-cutting checks run
- [ ] Step 4: Findings written and ranked
- [ ] Step 5: Audit verified
- [ ] Step 6: Audit reported
- [ ] Step 7: Grill decision asked
- [ ] Phase 2 (if chosen): grill complete, elements rescored
- [ ] Closing: unsettled findings offered as open questions
- [ ] Export queue ruled, run summary delivered
```

## Phase 1: Audit

### Step 1: Locate the PRD

Check, in order: files attached to the conversation, Project knowledge, a path or URL the user gives, then the repo (`docs/`, `PRD.md`, `SPEC.md`, `README.md`). If several candidates exist, ask which one governs. Note where the PRD lives and whether Claude can edit it in place, because Phase 2 depends on that. Then resolve the project's tracker and list its open entries as in `references/tracker.md` Steps 1 and 2, and reconcile against them while writing findings. When `handoff:prd` entries are waiting, tell the user how many and offer to grill them as incoming findings (Phase 2), before or after the audit.

### Step 2: Score the elements

Read `references/rubric.md` section A. Score each element Present, Thin, or Missing, and quote or cite the PRD passage behind each score. A Thin score names the specific shortfall.

### Step 3: Run the cross-cutting checks

Read `references/rubric.md` section B and run each check across the whole document. These catch problems that element scoring misses: contradictions between sections, missing scenarios, unstated assumptions, and requirements that prescribe a solution.

### Step 4: Write and rank findings

Each finding uses this shape:

```
### PRD-04 · Blocker · metrics
**Finding:** One sentence naming what the PRD lacks or gets wrong.
**Location:** Section or heading, with a short quote when it helps.
**Why it matters:** What goes wrong downstream: what the builder will guess, or what product-review cannot verify.
**Depends on:** Other finding IDs that must be settled first, or none.
```

Severities are Blocker, Major, Minor, and Nit, defined in `references/rubric.md` section C. Rank findings by dependency first, then by severity. Upstream decisions come first: problem, then primary user, then core job, then requirements, then metrics and non-goals. A metric cannot be settled while the core job is still open, so dependency order beats severity order.

### Step 5: Verify the audit

Before reporting, check the draft against each item below. Fix every failure, then check again. Report only when every item passes.

- Every element score cites or quotes the PRD, and every Thin score names its shortfall.
- Every Missing or Thin element has a matching finding.
- Every finding's severity matches its definition in rubric section C.
- No finding appears before a finding it depends on.
- Every contradiction finding cites both locations.

### Step 6: Report the audit in chat

Use this order:

1. **Verdict:** two or three sentences. Is the PRD ready to build against, and ready for product-review to trace? Name the single finding that matters most.
2. **Element scores:** the Step 2 table with Present, Thin, or Missing, and one line of reason per row.
3. **Findings:** in ranked order, numbered PRD-01, PRD-02, and so on.
4. **Readiness:** one line for each downstream use. "Ready to build: yes or no." "Ready for product-review: yes or no." Product-review needs, at minimum, a primary user, a core job, and testable requirements.

Write plainly and skip praise. A Present score is acknowledgment enough.

### Step 7: Stop

End the audit by asking one question: grill through the findings now, or stop here? Do not start Phase 2 without an explicit yes. A request to grill in the user's original prompt counts as that yes; deliver the audit first, then begin. If the user wants to grill only some findings, take the IDs they name and keep their ranked order. When the user stops, run the closing step, then present the export queue and the run summary as in `references/tracker.md`. When the PRD is ready for product-review and an app already exists, say so in one line and suggest product-review as the next run.

## Phase 2: Grill

Read `references/grill-protocol.md` and follow it. For this skill, the protocol's three inputs are:

- **Finding list:** the ranked findings from Phase 1, or the subset the user chose.
- **Target artifact:** the PRD located in Step 1.
- **Standard for a good answer:** `references/rubric.md`. Every recommended answer must meet the rubric's "Present means" bar for its element. A recommended metric, for example, carries a number, a target, and a time window.

Phase 2 can also start from findings another review passes in, such as product-review's findings with a PRD change. In that case, skip Phase 1, keep the incoming IDs, and rank the findings in the upstream order from Step 4 (problem, primary user, core job, requirements, then metrics and non-goals). Incoming findings carry no `Depends on` field, so derive each one's dependencies from that order before the first question. Score the elements once before the first question so the closing rescore has a baseline.

When the grill ends, rescore the elements and give the user a short before-and-after: which scores changed, which findings were resolved, and which were deferred to the PRD's open questions. Then run the closing step, then present the export queue and the run summary as in `references/tracker.md`. When another review passed the findings in during this session, that review's queue tracks them; skip the closing step, this skill's queue, and its summary. When they came from `handoff:prd` entries, this skill's queue proposes a pickup comment on each naming the decision written, and proposes closing the entry only when the decision needs no change to the app; otherwise product-review closes it after its recheck.

## Closing: write open questions

Run this after the audit when the user stops, or after the grill. It covers this run's own findings that are neither written nor dropped: findings the user chose not to grill, and findings the grill never reached. Deferred findings are already in the PRD's open questions. Handoff entries not grilled stay waiting in the tracker.

Three kinds of finding never go here; they stay in the export queue:

- **Blockers.** Rubric section C says resolve them before building, and a parked Blocker would leave this lens looking done.
- **Findings that matched an open tracker entry.** They stay with that entry, so the queue can comment on it and close it later.
- **Findings about the open questions section itself,** such as a question with no owner. Writing another question would not fix them.

1. **Find the section.** Use the PRD's open questions section under whatever heading it has (Open questions, Unknowns, TBD), and match its format. When there is none, the section will be created as `## Open questions` at the end of the PRD, before any appendix.
2. **Skip what it already asks.** Leave out a finding the section already covers, say which ones you skipped, and count them as written, since the PRD already carries them.
3. **Draft each finding as a question** the PRD's owner can answer, ending with the review and date, since finding IDs restart every run: `- What number would tell us the core job is succeeding? (prd-review, 2026-10-13)`.
4. **Ask once for an owner or decision date** covering the batch. Without one, write `Owner: unassigned`; the next audit will flag that, as rubric section A expects.
5. **Show the exact text and where it lands,** then ask: write them all, or name the ones to leave out.
6. **Write only what the user approves,** by the write path in `references/grill-protocol.md` ("Writing back"). When the PRD is read-only, fold these into the one revised PRD delivered at the end, together with any grill changes.

Questions written here count as written. Ones the user leaves out go to the export queue, so nothing is lost.

## Tracking findings

Read `references/tracker.md` and follow it with the label `prd-review`, the ID prefix `PRD`, and the finding fields from Step 4. A decision written into the PRD, a deferral written to its open questions, or a question written in the closing step counts as written. Every other finding ends the run exported or dropped; export only what the user rules on in the queue.
