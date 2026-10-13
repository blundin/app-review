# Tracker Adapter: GitHub Issues

Performs the operations in `tracker.md` against GitHub issues. The target is `owner/repo` from the config. Never guess the repository name; if the config has none, ask.

## Choose a path

Pick the first path the session supports, and use it for every operation in the run.

1. **GitHub tool available** (a connector or MCP server exposing issues): use its tools to list, create, comment on, and change the state of issues. Report issue numbers and URLs.
2. **Shell with an authenticated `gh` CLI:** run `gh auth status` first. If it passes, run the commands below directly and report the URLs.
3. **Neither:** give the user the commands below to run, and ask them to paste back the output of any list command. Write them in fish unless the user names another shell; fish has no heredocs, so never emit bash heredocs for fish users.

## Operations

**find:** list every issue with the review label, open or closed, and compare each body's `app-review-fp:` line with the fingerprint. Never rely on GitHub search to match it; search splits on punctuation.

```fish
gh issue list --repo $repo --label product-review --state all --limit 500 --json number,state,title,labels,body,comments
```

If the result holds 500 issues, say the match may be incomplete.

**list open:**

```fish
gh issue list --repo $repo --label handoff:design --state open --limit 500 --json number,title,labels,body,comments
```

**create:** create the labels once per repo; `--force` makes reruns safe.

```fish
set repo owner/repo
for l in prd-review product-review design-review architecture-review severity:blocker severity:major severity:minor severity:nit handoff:product handoff:design handoff:architecture handoff:accessibility handoff:code handoff:prd
    gh label create $l --repo $repo --force
end
```

Then one command per issue. Pipe the body through `printf` and read it with `--body-file -`. Each argument to `printf` becomes one line. Escape single quotes inside single-quoted strings as `\'`:

```fish
printf '%s\n' \
    '**Finding:** New users cannot invite a second household member.' \
    '**Evidence:** /settings/members returns 404 (observed).' \
    '**Impact:** Households that need a second member cannot use the app together, a meaningful segment.' \
    '**Recommendation:** Ship the invite flow in PRD section 4.1.' \
    '**Confidence:** High' \
    '' \
    '_From product-review on 2026-10-13 as P-03._' \
    'app-review-fp: product-review.trace.settings-members.invite-flow-missing' \
| gh issue create --repo $repo \
    --title '[product-review] New users cannot invite a second household member' \
    --label product-review --label severity:major \
    --body-file -
```

**comment:**

```fish
printf '%s\n' \
    'Seen again by product-review on 2026-11-02 as P-01.' \
    '**Evidence:** /settings/members still returns 404 (observed).' \
| gh issue comment 41 --repo $repo --body-file -
```

**pickup:** a comment whose first line is the marker:

```fish
printf '%s\n' \
    'app-review-pickup: design-review' \
    'Picked up by design-review on 2026-11-02 as D-03 (#57).' \
| gh issue comment 33 --repo $repo --body-file -
```

**close** and **reopen:**

```fish
gh issue close 41 --repo $repo --comment 'Fixed: /settings/members now sends invites (observed by product-review on 2026-11-02).'
gh issue reopen 12 --repo $repo --comment 'Present again: seen by product-review on 2026-11-02 as P-05.'
```
