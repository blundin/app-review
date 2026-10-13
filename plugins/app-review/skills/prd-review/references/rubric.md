# PRD Review Rubric

## A. Elements

Score each element Present, Thin, or Missing.

| Element | Present means | Common Thin patterns |
|---|---|---|
| Problem | Names a specific problem, who has it, how they cope today, and why that coping fails. | States a solution as the problem ("users need a dashboard"). Describes a market, with no person in it. |
| Primary user | One primary user, described by situation and need. Secondary users, if any, are named as secondary. | Five equal personas. Demographics with no situation. "Everyone." |
| Core job | One sentence stating what the primary user hires the app to do, phrased as an outcome the user wants. | A feature list stands in for the job. Several jobs with no ranking. |
| Requirements | Each requirement is testable: a reviewer can watch the app and say yes or no. Each traces to the core job or a named secondary job. | Adjectives with no threshold ("fast," "simple," "intuitive"). Requirements that trace to no job. |
| Success metrics | Each metric has a number, a target, a time window, and a stated data source. At least one metric measures the core job. | Vanity counts (signups, page views) with no link to the job. Targets with no window. |
| Non-goals | An explicit list of what the app will not do, including at least one thing a reasonable user might expect. | Missing, or only trivial exclusions nobody would ask for. |
| Constraints | Platform, hosting, budget, privacy, and regulatory limits that shape the build. | Constraints buried in requirements, or stated with no reason. |
| Open questions | Known unknowns, each with an owner or a decision date. | Missing in an early PRD, which usually means the unknowns went unexamined. |

## B. Cross-cutting checks

Run each check across the whole document.

1. **Contradictions.** Two sections that cannot both hold: a requirement that violates a non-goal, a metric the requirements never enable, a constraint a requirement ignores. Cite both locations.
2. **Missing scenarios.** For the core job, check that the PRD addresses each scenario: first use with an empty account, the second user in a shared account, errors and failed actions, a user returning after months away, a phone in hand, and a user who leaves or deletes their account. A scenario counts as addressed when the PRD states the expected behavior or explicitly scopes it out.
3. **Unstated assumptions.** Beliefs the PRD depends on without saying so: that users will invite others, that email reaches inboxes, that users already own some device or account, that data from another system is available. Name each assumption and what breaks if it is false.
4. **Solution in place of need.** Requirements that dictate screens, components, or technology where the need could be met other ways. Recommend restating the need and moving the prescription to a design note, unless a real constraint requires it.
5. **Traceability.** Every requirement traces to a job, and every job has at least one requirement and one metric. List the orphans in both directions.
6. **Scope against constraints.** Whether the requirements plausibly fit the stated constraints (one developer, a single droplet, a hobby budget). Flag scope that the constraints cannot carry; leave estimation to the user.

## C. Severity

Each level names the action it requires. The PRD column defines the impact that earns it.

| Severity | Action | PRD impact |
|---|---|---|
| Blocker | Resolve before building. | A builder would have to guess the product's direction, or product-review could not trace against the PRD. Missing or Thin problem, primary user, or core job always lands here, as does a contradiction involving the core job. |
| Major | Fix before building unless the owner records a reason. | A builder would ship something that diverges from intent in a way users notice, or success could not be measured. Most untestable requirements, missing core-job metrics, and unaddressed core scenarios land here. |
| Minor | Fix when convenient. | Low-cost orphan requirements, missing owners on open questions, or constraints stated without a reason. |
| Nit | Record only when a stated standard covers it. | Phrasing and formatting that change no meaning. |

When unsure between two levels, pick the lower and state why.
