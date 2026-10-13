---
name: architecture-review
description: Validates the architecture of a built web app, service, or native iOS app as a whole. Assembles the forces and quality attributes the system must serve from the PRD, ADRs, and repo, then reviews recorded decisions, structure, data, system-level security, operations, dependency health, and fitness functions. Produces a severity-ranked findings report in chat, can grill the user through findings that need a decision and draft each one as an ADR, and logs findings to the project's tracker (GitHub issues or a markdown file) after the user rules on an export queue. Use whenever the user asks for an architecture review, system review, technical audit, production-readiness or ops check, or asks whether an app's design will hold up, even without the words "architecture review." Reviews the whole system after the fact; line-level code review of a diff or branch belongs to a code reviewer, product intent to product-review, and interface design to design-review.
---

# Architecture Review

Judge whether a system's structure and operations serve the forces it actually faces: its users, its team, its rate of change, and its hosting. Everything in architecture is a trade-off, so every finding names the force it weighs against. Every finding cites evidence; preference without a force behind it does not ship.

## Boundaries

This skill reviews the whole system. Line-level defects in a diff or branch (a specific null check, an N+1 query in one handler) belong to a code reviewer, such as 007's reviewer agent; tag them `handoff: code`. Product intent belongs to product-review, interface design to design-review, and accessibility to accessibility-review. Accessibility-review is not yet available; tag accessibility issues `handoff: accessibility` and do not diagnose them.

The heuristics in `references/rubric.md` follow 007's architect agent, so both judge structure the same way. When the repo has 007 installed (a `.007-version` file exists), the architect agent is the only author of ADRs there; see Phase 2.

## Progress checklist

Copy this checklist into the response and check items off as the review proceeds:

```
Architecture review progress:
- [ ] Step 1: Inputs gathered, coverage declared
- [ ] Step 2: Forces and characteristics assembled
- [ ] Step 3: System map drawn
- [ ] Step 4: Lenses walked
- [ ] Step 5: Operations evidence gathered
- [ ] Step 6: Findings written
- [ ] Step 7: Report verified
- [ ] Step 8: Report delivered
- [ ] Phase 2 (if chosen): decisions grilled into ADR drafts
- [ ] Export queue ruled, run summary delivered
```

## Step 1: Gather inputs and declare coverage

Find the evidence, strongest first:

1. **Repo:** code, schema and migrations, dependency manifests and lockfiles, Dockerfiles, compose files, CI workflows, server configs, and `docs/adr/`.
2. **Server and platform evidence:** output from commands the user runs against the host or platform. `references/ops-evidence.md` lists them; Claude asks for them in Step 5 and never assumes a check passed.
3. **Live endpoints and DNS:** response headers, TLS certificates, and mail records Claude can check from its own tools.
4. **The user's description** of hosting, deploys, and backups. This counts as a claim until other evidence confirms it.

Read `PRD.md` or the governing spec for constraints, and every ADR in `docs/adr/`. Before reviewing, tell the user in two or three sentences which sources you have and which you lack.

Then resolve the project's tracker and list its open entries as in `references/tracker.md` Steps 1 and 2, and reconcile against them while writing findings.

## Step 2: Assemble forces and characteristics

Read `references/rubric.md` section A and fill in the forces checklist, marking each item `stated` (the PRD, an ADR, or the user says so) or `assumed` (inferred, with the evidence). Then name the top three architecture characteristics this system needs and which of them conflict. Every later finding is judged against these forces; a finding that ignores them is taste.

## Step 3: Draw the system map

Describe the system in one short table or list: deployable units, data stores, external services (email, payments, auth), scheduled jobs, and how each is hosted and deployed. Count architectural quanta honestly; units that call each other synchronously form one. Flag anything the evidence cannot place.

## Step 4: Walk the lenses

Read `references/rubric.md` section B and walk the system through each lens: decisions, structure, data, security, operations, dependencies, and fitness. For a native iOS app, apply the native-app notes in that section in place of server operations.

## Step 5: Gather operations evidence

Read `references/ops-evidence.md`. Give the user the commands that match the hosting in the system map, written for their shell, and ask for the output. Review what comes back. Any check the user cannot or will not run becomes a finding marked Unverified, with Low confidence, never a pass.

## Step 6: Write findings

Each finding uses this shape:

```
### A-04 · Major · operations
**Finding:** One sentence stating what is wrong.
**Evidence:** What Claude found and where (file:line, command output, ADR, header), with the source marked: repo, server, live, or claim.
**Force:** The force or characteristic from Step 2 this finding weighs against.
**Impact:** What fails, for whom, and how costly it is to change later.
**Recommendation:** The smallest change that resolves it. Include "change nothing" when the cost outweighs the risk, and say why.
**Decision needed:** no, or the decision to make (for example, "whether to keep Postgres on the app droplet or move to a managed database").
**Confidence:** High, Medium, or Low, with the reason when below High.
**Handoff:** code, product, design, accessibility, or none.
```

Lenses: `decisions`, `structure`, `data`, `security`, `operations`, `dependencies`, `fitness`. Severities are Blocker, Major, Minor, and Nit, defined in `references/rubric.md` section C with a calibration example. Rank findings within each severity by the cost of changing them later, most expensive first.

## Step 7: Verify the report

Before delivering, check the draft against each item below. Fix every failure, then check again. Deliver only when every item passes.

- Every forces item is marked stated or assumed, and every assumed item names its evidence.
- Every finding names a force from Step 2 and cites an evidence source.
- Every operations check the user did not run appears as Unverified; none is reported as passing.
- Every severity matches its definition in rubric section C. Re-read each Blocker and Major against the definition and the forces.
- No finding recommends a structural change without naming what it sacrifices.
- Line-level defects carry `handoff: code` and are not diagnosed here.
- Every finding has a location stable enough to fingerprint: a route, screen, file path, PRD section, or component.

## Step 8: Report in chat

Use this order:

1. **Verdict:** two or three sentences. Will this system serve its forces for the next year without a costly rescue? Name the single biggest risk.
2. **Coverage:** evidence sources used and their limits.
3. **Forces:** the Step 2 checklist and the top three characteristics.
4. **System map:** the Step 3 table, with the quantum count.
5. **Findings:** grouped by severity, Blockers first, numbered A-01, A-02, and so on across the whole report.
6. **Decisions needed:** the IDs that need a decision, one line each.
7. **Handoffs:** the IDs tagged for another review, one line each.
8. **Next step:** name the reviews this report's handoffs point to, with counts, as suggested next runs (for example, "3 findings are tagged design; run design-review next"). For `code`, suggest a code reviewer; for `accessibility`, say that review is not yet available. Then ask whether to grill the decisions now. After the grill, or on a no, present the export queue and the run summary as in `references/tracker.md`.

Write plainly. No praise sections. A lens with no findings gets one line saying so.

## Phase 2: Grill the decisions

Run this phase only on an explicit yes. A request to grill in the user's original prompt counts as that yes; deliver the report first, then begin. Read `references/grill-protocol.md` and follow it. For this skill, the protocol's three inputs are:

- **Finding list:** the findings with a decision needed, in ranked order, or the subset the user chose.
- **Target artifact:** one ADR per decision, in the format in `references/rubric.md` section D, numbered after the highest existing ADR in `docs/adr/`.
- **Standard for a good answer:** an ADR fills the forces checklist, considers at least two options including "change nothing structural," states the decision and its dominant force, lists consequences including what becomes harder later, and names a fitness function or a manual-review trigger.

A decision the user settles becomes an ADR with `Status: accepted`, recording the option the user chose, even when it differs from the recommendation. A deferred decision produces no ADR: list it in the closing summary with an owner or date if the user gives one, and put it in the export queue.

Write each accepted ADR to `docs/adr/` when Claude can edit the repo and the repo lacks 007. When `.007-version` exists, write nothing: deliver each ADR as text and tell the user to have the architect agent record it in `record` mode, because 007 makes the architect the only ADR author.

## Tracking findings

Read `references/tracker.md` and follow it with the label `architecture-review`, the ID prefix `A`, and the finding fields from Step 6. Every finding ends the run written, exported, or dropped; export only what the user rules on in the queue.
