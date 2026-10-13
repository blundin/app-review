# Tracking Findings

A shared procedure that gives every review finding a recorded state and sends the ones the user approves to the project's tracker. The calling skill supplies its review label (for example, `design-review`), its finding ID prefix (for example, `D`), and its finding fields.

Each review run stands alone. It needs only its own inputs and the tracker; it never relies on an earlier conversation. The tracker is how one run's findings reach a later run, of the same lens or another.

## Finding states

Every finding ends the run in one state:

- **written:** recorded in the review's own artifact (the PRD, `docs/design.md`, or an ADR).
- **exported:** a tracker entry holds it, newly created or an existing one it matched.
- **dropped:** the user dropped it, with a reason.
- **pending:** not yet ruled on.

A run is not done while any finding is pending. The user may defer the queue; the run summary then names every pending finding.

## Step 1: Resolve the tracker

Every path in this file and its adapters, including "the repo," is in the project under review. Never write to the plugin's own directory.

Do this once, at the start of the run:

1. **Repo config:** `.app-review.json` at the repo root, such as `{"tracker": "github", "target": "owner/repo"}` or `{"tracker": "markdown", "target": "docs/reviews/findings.md"}`. A markdown tracker with no target uses `docs/reviews/findings.md`.
2. **Project knowledge:** a file or note stating the same two keys.
3. **Ask once:** which tracker (`github` or `markdown`) and which target. When Claude can write to the repo, offer to save the answer as `.app-review.json`, and write it only on the user's OK. Do not ask again during the run.

Then read the adapter for that tracker: `references/tracker-github.md` or `references/tracker-markdown.md`. For any other tracker value, say it is not supported and use the markdown adapter.

## Operations

Each adapter performs these six operations. The skills use no others.

| Operation | Does |
|---|---|
| create | Creates an entry from a title, body, and labels; returns its ID. |
| find | Returns entries, open or closed, whose body holds a given fingerprint, with their comments. |
| comment | Adds a comment to an entry. |
| close | Closes an entry with a comment. |
| reopen | Reopens an entry with a comment. |
| list open | Returns open entries carrying a given label, with their bodies and comments. |

## Fingerprint

Every entry's body ends with one line that identifies the finding across runs:

```
app-review-fp: <review label>.<lens>.<location key>.<slug>
```

- **Location key:** the finding's most stable locator, lowercased, with every run of other characters turned into one hyphen. Use a route (`/settings/members` becomes `settings-members`), a screen name, a file path without line numbers (`app/models/user.rb` becomes `app-models-user-rb`), a PRD section heading, or a system component. Never include line numbers, dates, or counts, which change between runs.
- **Slug:** two to five words in kebab case naming the defect, not the sentence that describes it (`invite-flow-missing`). The same defect found again must produce the same slug.

Example: `app-review-fp: product-review.trace.settings-members.invite-flow-missing`

Matching compares the whole line exactly. A **near match** shares the review, lens, and location key but not the slug. Never merge or skip a near match silently; put it in the queue as a question.

## Entry format

**Title:** `[<review label>] <finding sentence, trimmed to 70 characters>`. Finding IDs restart every run, so they stay out of the title.

**Labels:** the review label; one of `severity:blocker`, `severity:major`, `severity:minor`, or `severity:nit`; and `handoff:<lens>` when the finding carries a handoff, including `handoff:code`. A product-review finding with a PRD change also gets `handoff:prd`, unless prd-review settled it in the same session.

**Body:** the finding's fields in the order the calling skill writes them, then these two lines, the fingerprint last:

```
_From <review label> on YYYY-MM-DD as <ID>._
app-review-fp: <fingerprint>
```

**Pickup comment:** a review that takes up another review's handoff marks the entry so it stops waiting. The first line is the marker:

```
app-review-pickup: <review label>
Picked up by <review label> on YYYY-MM-DD as <ID> (<new entry ID>), or: no <lens> cause found, because <reason>.
```

**Comment on a match:** `Seen again by <review label> on YYYY-MM-DD as <ID>.` followed by the new evidence line, and the new severity when it differs.

## Step 2: Reconcile open entries

Right after Step 1, run **list open** twice and keep both lists for the run:

- **Own entries:** this review's label.
- **Handoffs waiting:** `handoff:<this lens>` (prd-review uses `handoff:prd`), minus entries whose comments already hold `app-review-pickup: <this review label>`.

While writing findings:

- A finding whose fingerprint matches an own entry is **still present**; the queue proposes a comment on it.
- An own entry that no finding matched gets a recheck at its location. If the evidence shows it fixed, propose **close** with that evidence. If this run's evidence cannot reach the location, mark it **unverifiable**, leave it open, and name it in the run summary. If it is still present after all, write it as a finding.
- For each handoff waiting, check its cause in this lens. A confirmed cause becomes this review's own finding, with its own fingerprint, and the queue proposes a **pickup** comment linking it. When no cause exists in this lens, propose a pickup comment that says so and why. When the evidence cannot reach it, leave it waiting and name it in the run summary.

Never close another review's entry. The review that owns the label closes it once its own recheck shows it fixed. The one exception: prd-review may propose closing a `handoff:prd` entry when the PRD decision it wrote needs no change to the app.

## Done

- **A run is done** when no finding is pending.
- **A lens is done** when no open Blocker or Major entry carries its review label and no handoff to it is waiting for pickup.

## Step 3: Build the export queue

After the report, and after the grill when one runs, run **find** for every finding not written. Then present the queue:

```
**Export queue** (tracker: github, owner/repo)

| ID | Severity | Proposed action | Why |
|---|---|---|---|
| P-01 | Major | create | no match |
| P-02 | Minor | comment on #41 | open entry, same fingerprint |
| P-05 | Major | reopen #12 | closed entry, same fingerprint: possible regression |
| P-06 | Minor | same as #18? | near match: same location, different slug |
| #9 | Major | close #9 | rechecked: /settings/members now sends invites (observed) |
| #33 | Minor | pickup #33 | handoff:product from design-review; cause confirmed as P-07 |

Approve all, or name exceptions: drop an ID with a reason, or change its action.
```

Propose **create** when nothing matches, **comment** on an open exact match, **reopen** on a closed exact match, a question on a near match, **close** for an own entry the recheck shows fixed, and **pickup** for each handoff checked. Rows for existing entries use the entry ID in place of a finding ID. Never propose a drop; only the user drops a finding.

## Step 4: Apply the ruling

- Act only on findings the user ruled on, and only as ruled. One reply can cover the whole queue.
- Ask once more about any finding the reply did not cover. If the user defers, those findings stay pending.
- A drop with no reason given records "no reason given."
- When the adapter can only hand the user commands to run, mark those findings `exported (commands given)`. A later run's find catches any command never run and proposes it again.

## Step 5: Log the run

When Claude can write to the repo, write the full report and the run summary to `docs/reviews/YYYY-MM-DD-<review label>.md` without asking, adding `-2`, `-3`, and so on when the file exists. Otherwise the report in chat is the log.

## Step 6: Run summary

End the run with:

1. Counts: written, exported, dropped, pending.
2. One line per finding: ID, state, and where it went (artifact and section, entry ID, or drop reason).
3. Entries commented on, reopened, closed, or picked up this run, and entries left unverifiable or waiting.
4. Every pending finding, named plainly, and why it is pending.
5. Lens status: done or not, by the rule in Done, with the open Blocker and Major count and the handoffs still waiting.
6. With a markdown tracker in chat, a reminder to save the delivered `findings.md` to Project knowledge so a later session can match against it.
