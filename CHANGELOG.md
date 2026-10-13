# Changelog

## Unreleased

## 0.1.3 (2026-10-13)

Initial public release. Versions 0.1.0 through 0.1.2 were private.

- `app-review`: entry skill that takes stock of what exists, recommends a review order, starts the first review on a yes, and reports where each lens stands.
- `prd-review`: audits a PRD against an eight-element rubric and six cross-cutting checks, then optionally grills the user one decision at a time and writes each answer into the PRD. Unsettled findings become open questions in the PRD or tracker entries, as the user rules.
- `product-review`: readiness gate, requirements ledger, forward and reverse trace against the PRD, and product fundamentals. PRD changes are handed to `prd-review`.
- `design-review`: web and iOS, including iOS 26 Liquid Glass. Assembles a design baseline from stated and inferred sources, reviews six lenses and a state matrix, and can grill decisions into `docs/design.md`.
- `architecture-review`: forces checklist, system map, seven lenses, and operations evidence commands. Can grill decisions into ADRs and respects 007's ADR ownership. Secrets are cited by location, never by value.
- One severity scale (Blocker, Major, Minor, Nit) across every review.
- Findings tracking: each project picks GitHub issues or a markdown file in `.app-review.json`. Every report ends with an export queue the user rules on. Fingerprints keep reruns from duplicating entries, and reruns close loops on fixed, still-present, and handed-off findings.
- `scripts/check` validates manifests, shared files, references, and handoff targets.
- Evals are written but not yet run.
