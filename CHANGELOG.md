# Changelog

## Unreleased

## 0.1.3 (2026-10-13)

- `prd-review` closing step: after the audit or the grill, unsettled findings are offered as open questions in the PRD, tagged with the review and date, with one owner or decision date asked for the batch. The section is created when the PRD has none, and questions it already asks are skipped. Blockers, findings already tracked, and findings about the open questions section stay in the export queue. Approved questions count as written; the rest go to the export queue.

## 0.1.2 (2026-10-13)

- Reviews close loops: each run lists its open entries and waiting handoffs first, comments on still-present findings, proposes closing fixed ones with evidence, and names unreachable ones as unverifiable. Handoffs are marked picked up with an `app-review-pickup:` comment; only the owning review closes an entry, except prd-review for a PRD-only decision.
- Product findings that need a PRD change carry `handoff:prd` when not settled in the same session; prd-review offers waiting ones as incoming findings.
- Definition of done: a run is done with nothing pending; a lens is done with no open Blocker or Major entry and no handoff waiting. Run summaries report lens status, and `app-review` reports it per lens without writing to the tracker.
- `scripts/check` fails when the GitHub adapter's label loop misses a label the skills use.
- `app-review` triggers on status questions, such as where reviews stand on a project or whether a lens is done.
- The markdown adapter's find returns each entry's comments, matching the shared contract.

## 0.1.1 (2026-10-13)

- Plugin and marketplace descriptions now describe findings tracking (GitHub issues or a markdown file) instead of GitHub export, and name the `app-review` entry skill.
- README no longer offers a release zip; install through the marketplace.
- Findings tracking replaces on-request GitHub export. Every finding ends a run written, exported, or dropped; each report ends with an export queue the user rules on, then a run summary. Entries carry an `app-review-fp:` fingerprint so reruns comment on or reopen a match instead of duplicating it. `handoff: code` findings join the queue like any other.
- Each project picks its tracker in `.app-review.json` (GitHub issues or a markdown file); without it, a review asks once. Shared `tracker.md` defines the contract, with `tracker-github.md` and `tracker-markdown.md` adapters; `github-issues.md` is removed.
- `prd-review` now tracks findings it leaves unsettled.
- Runs write their report and summary to `docs/reviews/` when the repo is writable.
- `scripts/check` reports a missing canonical shared file instead of crashing, and fails when a skill names a `references/` file that does not exist.
- `app-review`: new entry skill that takes stock of what exists, recommends a review order, and starts the first review on a yes.
- Every review report now names the reviews its handoffs point to as suggested next runs; `prd-review` suggests `product-review` when the PRD is ready. The README gains a Workflow section.
- Handoff targets are the same in every finding template (`code`, `product`, `design`, `architecture`, `accessibility`, minus the skill's own), enforced by `scripts/check`. The skills say accessibility-review is not yet available.
- `product-review` rates `prd`-lens findings with prd-review's severities instead of always Minor.
- `architecture-review`: documents why an ADR contradiction is Major here and a Blocker in 007's reviewer; restores 007 architect heuristics (mixed commits, test-induced design damage, last responsible moment, pattern worship, speculative generality, out-of-context decisions); grilled ADRs are written as accepted and deferred decisions produce no ADR; secrets are cited by location, never by value; ops commands log in as a deploy user with `sudo`, not root.
- `prd-review`: derives dependencies for findings passed in from another review.
- `design-review`: iOS permission guidance matches the HIG (purpose string required, custom pre-prompt optional); adds iOS 26 Liquid Glass conventions; the heuristics lens covers flexibility and help at lower weight.

## 0.1.0

- `prd-review`: audit against an eight-element rubric and six cross-cutting checks, then an optional grill that writes decisions into the PRD. Accepts findings passed in from `product-review`.
- `product-review`: readiness gate, requirements ledger, forward and reverse trace, product fundamentals, and handoff of PRD changes to `prd-review`.
- `design-review`: web and iOS, an assembled baseline with stated and inferred sources, six lenses, a state matrix, and an optional grill into `docs/design.md`.
- `architecture-review`: forces checklist, system map, seven lenses, operations evidence commands, and an optional grill into ADRs that respects 007's ADR ownership.
- One severity scale (Blocker, Major, Minor, Nit) and a shared GitHub issue export.
- Evals are written but not yet run.
