---
name: app-review
description: Entry point for the app-review plugin. Works out which review an app needs next and in what order, then starts it. Use when the user asks to review, validate, audit, or check an app, project, or idea without naming a lens, asks which review to run, asks what app-review can do, asks what to review next after an earlier review, or asks where reviews stand on a project or whether a lens is done. When the user names a lens (PRD, product, design, UX, architecture, ops), use that skill directly instead.
---

# App Review

Route the user to the right review. This skill judges nothing itself; the four review skills do. Its job is to find out what exists, recommend an order, and start the first review on the user's yes.

## The reviews

| Skill | Judges | Needs |
|---|---|---|
| `prd-review` | The PRD as a document | A PRD |
| `product-review` | Whether the built app delivers its PRD | A PRD that passes prd-review's readiness bar, and the app, screenshots, or code |
| `design-review` | Interface quality and platform fit | The app, screenshots, design files, or code |
| `architecture-review` | Structure, data, security, and operations | The repo, plus ops evidence the user collects |

Accessibility-review is planned but not yet available.

## Step 1: Take stock

Look up what you can before asking: files attached to the conversation, Project knowledge, and, when a repo is open, `PRD.md`, `SPEC.md`, `docs/`, `docs/adr/`, `docs/design.md`, and a `.007-version` file. Resolve the project's tracker as in `references/tracker.md` Step 1 and, when one exists, run its **list open** for each review label and each `handoff:` label. Report each lens in one line: open Blocker and Major counts, handoffs waiting for pickup, and whether the lens is done by the rule in that file's Done section. This skill only reads the tracker; it never creates, comments on, or closes an entry.

Then ask only about what you could not find, in one message:

- Is there a PRD or spec?
- Is the app built? Can Claude reach a live URL, screenshots, or the repo?
- Did an earlier review leave findings tagged `handoff:` in this conversation?
- Is there a specific worry, such as a launch, a slow screen, or a hosting change?

## Step 2: Recommend an order

Apply these rules, then state the order in a short numbered list, one line of reason each:

1. **No app yet:** run prd-review. The other reviews need something built.
2. **App built, no PRD:** product-review cannot run. Recommend prd-review on a PRD the user writes, or start with design-review or architecture-review, which can work from a stated core job.
3. **App built, PRD exists:** prd-review first when the PRD has not been reviewed, then product-review, then design-review and architecture-review in either order.
4. **Earlier handoffs exist:** put the reviews they point to first, since those findings are already waiting.
5. **A specific worry:** put the review that owns it first and say which rule you overrode.

## Step 3: Start

Ask which review to start, recommending the first in the order. On a yes, run that skill and follow it from its first step. Do not run more than one review per turn; each review ends by suggesting the next.
