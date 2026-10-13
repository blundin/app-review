# Architecture Review Rubric

Sections A, B (decisions and structure), and D follow 007's architect agent (`framework/.claude/agents/architect.md` at commit 166131f). Change them together with that file so both judge structure the same way.

## Contents
- A. Forces checklist
- B. Lenses: decisions, structure, data, security, operations, dependencies, fitness, native-app notes
- C. Severity and calibration
- D. ADR format

## A. Forces checklist

Fill in every item and mark it `stated` or `assumed`, with the evidence for each assumption.

- Team size and skills.
- Product phase, per Beck's 3X: Explore (finding the growth loop), Expand (scaling it), or Extract (running it profitably). Most internal and personal systems have no growth loop and sit in Extract.
- Rate and locus of change: which parts change often, and which rarely.
- Domain-logic complexity.
- The top three architecture characteristics ("-ilities") that matter, and which conflict. Aim for the least-worst architecture, never the maximum of every characteristic.
- Operational maturity: deployment automation, monitoring, and on-call capacity.
- Cost and hosting constraints.
- Reversibility of the decisions already made.

## B. Lenses

### Decisions
- Can the reason for each significant decision be found in an ADR, commit, or doc? Flag costly-to-reverse decisions with no recorded reason.
- Does the code contradict an accepted ADR?
- Was any technology chosen with no forcing characteristic behind it?
- Was an irreversible decision made before the last responsible moment, or left past it so that it got made by default?

### Structure
- How many quanta exist? Synchronous call chains count as one. Flag a distributed monolith: several deployables forming one quantum.
- Any fine-grained or chatty remote calls that pretend a remote call is local?
- Any layer or interface with one implementation and no boundary to justify it? A layer justified only by isolated testing is test-induced design damage. Any abstraction before its third use, unless the module is deep?
- Does tooling enforce module boundaries, or only convention?
- Does domain-logic placement match the chosen pattern (Transaction Script, Active Record, Domain Model)? An anemic model is a flaw only when the code claims to be a Domain Model.
- Which modules are deep, and which are shallow pass-throughs?
- Do the tests let the team change code with confidence, and cost less to change than the code they cover?
- Do commits mix structural and behavioral change? Sample recent history.
- Default stance: one deployable unit first. Splitting needs a part with a different characteristic, a stable boundary, or an organizational seam, and a team able to pay the operational premium.
- Also flag pattern worship, speculative generality, and out-of-context decisions: another company's choice copied without its forces.

### Data
- Does the schema enforce the invariants the domain needs (foreign keys, uniqueness, not-null), or does only application code?
- Are migrations versioned, reversible where practical, and run by the deploy rather than by hand?
- What personal data is stored, why, for how long, and can a user's data be exported and deleted?
- Does any job or integration write the same data from two places?

### Security (system level)
- Where do secrets live? Flag secrets in the repo, in images, in logs, or in shared config files. Cite where a secret lives (file:line, variable name) and never reproduce its value in the report or an issue.
- How do users authenticate, and how are sessions and tokens issued, stored, and expired?
- What is exposed to the internet: ports, admin panels, database listeners, debug endpoints?
- Do processes run with least privilege (no root app processes, scoped API keys, scoped database users)?
- Is TLS enforced with current certificates and security headers?
- Line-level flaws (one unvalidated input, one missing authorization check) are `handoff: code`.

### Operations
- **Deploy:** is it scripted and repeatable, and can it roll back? How long since the last successful deploy from a clean checkout?
- **Backups:** what is backed up, where, how often, and when was a restore last tested? An untested backup counts as no backup until proven.
- **Monitoring:** does someone learn of an outage before users report it? Are errors captured somewhere searchable?
- **Patching:** are OS and runtime security updates applied automatically or on a schedule?
- **Capacity and cost:** does the hosting fit the load with headroom, and does the cost fit the stated constraints?
- **External services:** for each (email, payments, auth), what happens when it fails? For email, check sender authentication (SPF, DKIM, DMARC) and bounce handling.

### Dependencies
- Are the language runtime, framework, and database on supported versions? Flag end-of-life versions with their dates.
- Are dependencies locked, and does anything audit them for known vulnerabilities?
- Is any critical dependency abandoned or maintained by a single person?

### Fitness
- Does any automated check protect each of the top three characteristics (a dependency-rule test, a latency budget, a restore drill, an uptime check)?
- Where none exists, which check would be cheapest to add?

### Native-app notes (iOS)
Replace the server operations checks with these:
- **Release:** is the build and submission process scripted (for example, with Xcode Cloud or fastlane), and can a bad release be halted or followed quickly?
- **Crash and error reporting:** does someone learn of crashes before reviews mention them?
- **Persistence and migration:** do local stores (SwiftData, Core Data, files) migrate safely across app versions, and is user data backed up or synced?
- **Backend coupling:** can older app versions keep working when the backend or API changes?
- **Platform support:** does the deployment target leave out a meaningful share of the app's users, or keep alive APIs Apple has deprecated?

## C. Severity

Each level names the action it requires. The architecture column defines the impact that earns it. Judge every finding against the forces from section A: the same gap can be a Blocker for a system many people rely on and a Minor for a personal tool.

| Severity | Action | Architecture impact |
|---|---|---|
| Blocker | Resolve before the next release. | Data loss with no recovery path, an exposed secret or system-level authentication bypass, an internet-facing component with known exploited vulnerabilities, or a structure that makes a core requirement impossible. |
| Major | Fix before the next release unless the owner records a reason. | An untested restore, no outage detection for a system users rely on, an end-of-life runtime or framework, code that contradicts an accepted ADR, a costly-to-reverse decision with no recorded reason, or a distributed monolith. |
| Minor | Fix when convenient. | Boundaries held only by convention, shallow abstractions, a missing fitness function for a top characteristic, or cost above what the forces justify. |
| Nit | Record only when a stated standard covers it. | Naming or layout conventions with no structural effect. |

Code that contradicts an accepted ADR is Major here, though 007's reviewer makes it a Blocker. This review finds drift that already shipped, which is backlog work; the reviewer gates a merge, where stopping new drift is cheap. A contradiction introduced in a diff stays a Blocker for the code reviewer.

When unsure between two levels, pick the lower and state why in Confidence.

### Calibration example

An inflated finding that ignores the forces:

```
### A-06 · Blocker · operations
**Finding:** There is no staging environment.
**Evidence:** One droplet; deploys go straight to production (repo, deploy.sh).
**Impact:** Changes are untested before release.
```

The forces say one developer, a personal app with a handful of users, and a hobby budget. A staging server doubles hosting and maintenance for little risk reduction, and the evidence shows no failed deploy. The real gap is the missing rollback. Corrected:

```
### A-06 · Minor · operations
**Finding:** Deploys cannot roll back; a bad release stays live until a fix ships.
**Evidence:** deploy.sh pulls main and restarts in place, keeping no previous release (repo, deploy.sh:4-9).
**Force:** One developer with limited time; low cost; availability matters to a small household audience.
**Impact:** A broken deploy means downtime until the developer debugs it, possibly late at night.
**Recommendation:** Keep the previous release directory and add a rollback command that switches the symlink back. A staging environment costs more than the risk it removes.
**Decision needed:** no.
**Confidence:** High.
**Handoff:** none.
```

## D. ADR format

Filename: `docs/adr/NNNN-short-kebab-title.md`, where NNNN is one more than the highest existing number, zero-padded to four digits. Never rewrite an accepted ADR; mark it "superseded by ADR-MMMM" and write a new record.

```
# ADR-NNNN: <Use X for Y>

Status: proposed | accepted | superseded by ADR-MMMM
Date:
Deciders / consulted:

## Context and forces
<forces checklist, each marked stated or assumed; phase; top three characteristics>

## Considered options
1. <option>: gains / sacrifices / quantum impact / reversibility
2. <option>: ...

## Decision
We will <...> because <the dominant force>.

## Consequences
Positive:
Negative:
What becomes harder later:

## Confirmation
Fitness function: <objective check>
Revisit when: <trigger that would flip this decision>
```
