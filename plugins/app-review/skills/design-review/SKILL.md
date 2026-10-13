---
name: design-review
description: Validates the design of a web or native iOS app. Assembles a design baseline from the PRD, the design system implied by the code, and platform conventions, then reviews screens and flows for usability heuristics, consistency, interface states, visual hierarchy, interface copy, and platform fit. Produces a severity-ranked findings report in chat, can grill the user through findings that need a design standard chosen and record those decisions in a design baseline document, and logs findings to the project's tracker (GitHub issues or a markdown file) after the user rules on an export queue. Use whenever the user asks for a design review, UX review, UI critique, usability check, heuristic evaluation, or a design lens on a built app, screens, screenshots, or mockups, even without the words "design review." Leaves product intent to product-review, code structure to architecture-review, and accessibility to accessibility-review.
---

# Design Review

Judge whether an app's interface lets its primary user do the core job clearly, consistently, and in a way the platform's users expect. Most apps lack written design intent, so the review first assembles a baseline, then judges the screens against it. Every finding cites evidence; taste without evidence does not ship.

## Boundaries

This skill covers interaction quality, consistency, states, visual hierarchy, interface copy, and platform conventions. Product-review owns whether a flow exists and whether it delivers value; this skill owns how each step communicates. Code structure belongs to architecture-review. Accessibility belongs to accessibility-review: contrast, screen readers, focus order, Dynamic Type, and target sizes stay out of this report. When a design finding has a product, architecture, or accessibility cause, record the design impact here and tag the handoff. Accessibility-review is not yet available; tag accessibility issues `handoff: accessibility` and do not diagnose them.

## Progress checklist

Copy this checklist into the response and check items off as the review proceeds:

```
Design review progress:
- [ ] Step 1: Inputs gathered, platform identified, coverage declared
- [ ] Step 2: Baseline assembled
- [ ] Step 3: Screen inventory built
- [ ] Step 4: Screens walked through the lenses
- [ ] Step 5: State matrix filled
- [ ] Step 6: Findings written
- [ ] Step 7: Report verified
- [ ] Step 8: Report delivered
- [ ] Phase 2 (if chosen): decisions grilled into the baseline document
- [ ] Export queue ruled, run summary delivered
```

## Step 1: Gather inputs and declare coverage

Identify the platform: web, native iOS, or both. Read `references/web.md` for web and `references/ios.md` for iOS. Read both only when the app ships on both.

Find the evidence, strongest first:

1. **Live app:** a web URL Claude can drive through a browser tool, such as Claude in Chrome in Cowork. Observed behavior is the strongest evidence. Claude cannot drive the iOS Simulator, so iOS review relies on the next sources.
2. **Screenshots and screen recordings** the user supplies. For iOS, ask for both light and dark appearance and at least one small and one large device.
3. **Design files:** Figma or Canva files, read through a connected tool when one is available.
4. **Code:** views, components, stylesheets, design tokens, SwiftUI or UIKit views, and asset catalogs. Code shows what exists and how consistent it is, but not how it looks in use.

Before reviewing, tell the user in two or three sentences which sources you have and which you lack. Findings traced only through code carry lower confidence.

Then resolve the project's tracker and list its open entries as in `references/tracker.md` Steps 1 and 2, and reconcile against them while writing findings.

## Step 2: Assemble the baseline

Build the standard the screens are judged against, in one table with a `source` column (`stated` or `inferred`):

- **From the PRD:** primary user, core job, and the flows that serve it. Without a PRD, ask the user for the core job in one sentence; the review needs it to set priorities.
- **From written design intent:** any style guide, design notes, or design files. These are `stated`.
- **From the code:** the implied design system. Collect colors, type sizes, spacing values, corner radii, and components, and note which values recur and which appear once. Recurring values become the `inferred` standard; one-off values become consistency candidates. Read `references/rubric.md` section C for how to extract them.
- **From the platform:** the conventions in the platform reference read in Step 1.

When a `stated` source and the code disagree, record both and raise a finding; do not pick a winner silently.

## Step 3: Build the screen inventory

List every screen and significant modal or sheet, grouped by flow. Mark each one `core` (on the path of the core job), `first-run` (signup, onboarding, the first empty state), or `other`. Review core screens first and in full; review `other` screens for consistency and states only, unless the user asks for more.

## Step 4: Walk the screens through the lenses

Read `references/rubric.md` section A and walk each screen through each lens: heuristics, consistency, hierarchy, copy, and platform. Note evidence as you go, with the screen name, the element, and the source.

## Step 5: Fill the state matrix

For each core and first-run screen, record which states exist: empty, loading, partial, error, success, and offline where relevant. Read `references/rubric.md` section B for what each state must do. A missing state on a core screen is a finding.

## Step 6: Write findings

Each finding uses this shape:

```
### D-05 · Major · states
**Finding:** One sentence stating what is wrong.
**Evidence:** Screen, element, and source (observed, screenshot, design file, or code), with file:line or URL path where it helps.
**Impact:** What the user will misread, miss, or fail to recover from, in terms of the core job.
**Recommendation:** The smallest change that fixes it, expressed in the baseline's own tokens and components where possible.
**Decision needed:** no, or the standard to choose (for example, "which of the two primary button styles is canonical").
**Confidence:** High, Medium, or Low, with the reason when below High.
**Handoff:** code, product, architecture, accessibility, or none.
```

Lenses: `heuristics`, `consistency`, `states`, `hierarchy`, `copy`, `platform`. Severities are Blocker, Major, Minor, and Nit, defined in `references/rubric.md` section D with a calibration example. Apply them strictly.

## Step 7: Verify the report

Before delivering, check the draft against each item below. Fix every failure, then check again. Deliver only when every item passes.

- Every core and first-run screen appears in the inventory and in the state matrix.
- Every finding cites a screen, an element, and an evidence source.
- Every severity matches its definition in rubric section D. Re-read each Blocker and Major against the definition.
- Every consistency finding names the baseline value it departs from.
- No finding covers accessibility, product intent, or code structure beyond a handoff tag.
- Every finding that needs a standard chosen says so in `Decision needed`.
- Every finding has a location stable enough to fingerprint: a route, screen, file path, PRD section, or component.

## Step 8: Report in chat

Use this order:

1. **Verdict:** two or three sentences. Can the primary user do the core job without confusion today? Name the single biggest design problem.
2. **Coverage:** evidence sources, platforms, devices, and appearances reviewed, and their limits.
3. **Baseline:** the Step 2 table.
4. **Screen inventory and state matrix.**
5. **Findings:** grouped by severity, Blockers first, numbered D-01, D-02, and so on across the whole report.
6. **Decisions needed:** the IDs whose fix requires choosing a standard, one line each.
7. **Handoffs:** the IDs tagged for another review, one line each.
8. **Next step:** name the reviews this report's handoffs point to, with counts, as suggested next runs (for example, "3 findings are tagged design; run design-review next"). For `code`, suggest a code reviewer; for `accessibility`, say that review is not yet available. Then ask whether to grill the decisions now. After the grill, or on a no, present the export queue and the run summary as in `references/tracker.md`.

Write plainly. No praise sections. A screen with no findings needs no comment.

## Phase 2: Grill the decisions

Run this phase only on an explicit yes. A request to grill in the user's original prompt counts as that yes; deliver the report first, then begin. Read `references/grill-protocol.md` and follow it. For this skill, the protocol's three inputs are:

- **Finding list:** the findings with a decision needed, in ranked order, or the subset the user chose.
- **Target artifact:** the project's design baseline document. Use `docs/design.md` in the repo when it exists. When it does not, create it with the Step 2 baseline table as its first section, after the user approves the location.
- **Standard for a good answer:** a decision states the canonical value or component, where it applies, and what replaces each departure. Prefer values that already recur in the code over new ones.

Each settled decision turns its `inferred` baseline row into a `stated` one, so the next design review starts from a firmer standard.

## Tracking findings

Read `references/tracker.md` and follow it with the label `design-review`, the ID prefix `D`, and the finding fields from Step 6. Every finding ends the run written, exported, or dropped; export only what the user rules on in the queue.
