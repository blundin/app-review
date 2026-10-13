# Tracker Adapter: Markdown File

Performs the operations in `tracker.md` on one markdown file, `docs/reviews/findings.md` unless the config names another target. Use it when a project has no other tracker.

## Write path

- **Claude can edit the repo:** read the file, edit it in place, and confirm each change in one line. Create the file, with the heading below, when it does not exist.
- **Claude cannot edit the repo** (plain chat, or a read-only attachment): use the copy the user attached or keeps in Project knowledge, or start a new file when there is none. Apply every operation to that copy in the conversation, then deliver the whole updated file at the end of the run for the user to save.

Never renumber, reorder, or delete entries. A closed entry stays in the file.

## File format

```
# Review Findings

## T-001 · open · [product-review] New users cannot invite a second household member
Labels: product-review, severity:major

**Finding:** New users cannot invite a second household member.
**Evidence:** /settings/members returns 404 (observed).
**Impact:** Households that need a second member cannot use the app together, a meaningful segment.
**Recommendation:** Ship the invite flow in PRD section 4.1.
**Confidence:** High

_From product-review on 2026-10-13 as P-03._
app-review-fp: product-review.trace.settings-members.invite-flow-missing

### Comments
- 2026-11-02: Seen again by product-review as P-01. **Evidence:** /settings/members still returns 404 (observed).
```

## Operations

- **find:** scan every entry for an `app-review-fp:` line equal to the fingerprint. Report the entry ID, its status (`open` or `closed`, from the heading), and its comments.
- **list open:** return entries whose heading says `open` and whose `Labels:` line includes the label, with their comments.
- **create:** append a new entry numbered one past the highest `T-` number, zero-padded to three digits, with status `open`.
- **comment:** add a dated line under the entry's `### Comments`, creating that heading when the entry has none. A pickup comment starts with its marker: `- 2026-11-02: app-review-pickup: design-review. Picked up as D-03 (T-014).`
- **close** and **reopen:** change the status in the heading to `closed` or `open`, then add the reason as a comment.
