# app-review

A Claude plugin with four review skills that validate an app before and after it's built, plus an `app-review` entry skill that picks which review to run next. Each skill reports severity-ranked findings in chat, cites evidence for every finding, and logs findings to the project's tracker once you rule on them. The skills work in Claude chat, Cowork, and Claude Code.

| Skill | Judges | Needs | Grills into |
|---|---|---|---|
| `prd-review` | The PRD as a document: elements, contradictions, missing scenarios, testability | A PRD | The PRD |
| `product-review` | Whether the built app delivers its PRD, traced both ways, plus product fundamentals | A PRD and the app, screenshots, or code | Hands PRD changes to `prd-review` |
| `design-review` | Heuristics, consistency, states, hierarchy, copy, and platform fit for web and iOS | The app, screenshots, design files, or code | `docs/design.md` |
| `architecture-review` | Decisions, structure, data, system security, operations, dependencies, fitness | The repo, plus ops evidence you collect | ADRs in `docs/adr/` |
| `app-review` | Nothing; recommends which review to run next and starts it | Whatever exists | Nothing |

An `accessibility-review` skill is planned. Until it ships, accessibility findings appear only as `handoff: accessibility` tags.

## Install

**Cowork or Claude Desktop:** open Customize, then Plugins, choose **+**, then **Add marketplace**, and enter `blundin/app-review`. Install `app-review` from it.

**Claude Code:**

    /plugin marketplace add blundin/app-review
    /plugin install app-review@blundin

## Workflow

You don't need to memorize the order. Ask to "review my app" and `app-review` checks what exists and recommends one. Each review ends by naming the reviews its handoffs point to. The usual order:

1. **Before building:** `prd-review` until the PRD reports "Ready for product-review: yes."
2. **After building:** `product-review`, to check that the app delivers the PRD. PRD changes it finds go back to `prd-review`'s grill.
3. **Then, in either order:** `design-review` and `architecture-review`. Run whichever the earlier reports' handoffs point to first.

Each review stands alone: you can run one lens in a session and nothing else. Handoffs reach later runs through the tracker, where `handoff:*` labels show what each next review should pick up.

## Tracking

Every finding ends a run in one state: written into the review's artifact (PRD, including its open questions, `docs/design.md`, or an ADR), exported to the tracker, or dropped by you with a reason. Nothing is exported until you rule on it, and nothing is skipped silently.

- **Pick a tracker** per project in `.app-review.json` at the repo root: `{"tracker": "github", "target": "owner/repo"}` or `{"tracker": "markdown", "target": "docs/reviews/findings.md"}`. Without the file, a review checks Project knowledge, then asks once and offers to save the answer.
- **Export queue:** each report ends with every finding not written, each with a proposed action (create, comment on an existing entry, reopen a closed one). Approve it all in one reply or name exceptions.
- **No duplicates:** each entry carries an `app-review-fp:` fingerprint line, and a review matches it before proposing a new entry.
- **Closing loops:** each run lists its open entries first. Still-present findings comment on their entry, fixed ones are proposed for closing with evidence, and ones the run can't reach are named as unverifiable. Handoffs to the lens get checked and marked with an `app-review-pickup:` comment; a review never closes another review's entry, except prd-review for a PRD-only decision. Product findings that need a PRD change carry `handoff:prd` until prd-review picks them up.
- **Done:** a run is done when no finding is pending. A lens is done when it has no open Blocker or Major entry and no handoff waiting for it. `app-review` reports this per lens.
- **Run summary and log:** every run ends with each finding's state. When the repo is writable, the report and summary are saved to `docs/reviews/YYYY-MM-DD-<review>.md`.

## How the skills fit together

- **One severity scale.** Blocker, Major, Minor, and Nit, as in 007. Each level names the action it requires; each skill defines the impact that earns it. One deliberate difference: code that contradicts an accepted ADR is Major in `architecture-review`, which finds drift already shipped, and a Blocker in 007's reviewer, which gates a merge.
- **Handoffs, not overlap.** A finding with a cause in another lens gets a `handoff:` tag and stays undiagnosed. Line-level code defects go to a code reviewer as `handoff: code`.
- **Grill only real decisions.** A skill grills when its findings need a choice only you can make and the answer has a durable home the next review reads.
- **007 projects.** `architecture-review` follows 007's architect agent and never writes ADRs into a repo with `.007-version`; it returns them as text for the architect to record.

## Repo layout

| Path | Contents |
|---|---|
| `plugins/app-review/` | The plugin: manifest and skills. Everything here ships |
| `shared/` | Canonical copies of `grill-protocol.md`, `tracker.md`, and the tracker adapters (`tracker-github.md`, `tracker-markdown.md`) |
| `evals/<skill>/` | Three eval cases per skill and their fixtures. Never shipped |
| `scripts/check` | The single gate |
| `.claude-plugin/marketplace.json` | Marketplace catalog for this repo |

## Changing a skill

1. Edit the skill under `plugins/app-review/skills/`. To change a shared file, edit it in `shared/`, then copy it into every skill that carries it (listed in `SHARED_COPIES` in `scripts/check`).
2. Run `./scripts/check`. It fails on a drifted shared copy, bad frontmatter, mismatched versions, an em or en dash in skill text, or an eval that names a missing file.
3. Rerun the affected evals.
4. Add an entry under `Unreleased` in `CHANGELOG.md`.

The structure heuristics, forces checklist, and ADR format in `architecture-review/references/rubric.md` follow 007's `architect.md` at commit 166131f. Change them together.

## Evals

Each `evals/<skill>/evals.json` holds three cases: a prompt, input files, and the behavior a correct run shows. There is no built-in runner. Open a fresh session with the plugin installed, give it the prompt and files, and grade the output against `expected_behavior`. Slots marked `SUPPLY` take real inputs, such as a live app or repo.

## Releasing

Bump `version` in both `plugins/app-review/.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json` (the check fails if they differ), move the `Unreleased` entries under the new version, then tag it.

## License

MIT. See [LICENSE](LICENSE).
