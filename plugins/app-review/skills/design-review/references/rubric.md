# Design Review Rubric

## Contents
- A. Lenses: heuristics, consistency, hierarchy, copy, platform
- B. Interface states
- C. Extracting the implied design system
- D. Severity and calibration

## A. Lenses

### Heuristics

Apply Nielsen's ten usability heuristics, with these checks weighted highest for small apps:

1. **Visibility of status.** Every action gets feedback within a second: a pressed state, a spinner, a toast, or the result itself. Silent saves and silent failures are findings.
2. **Error prevention and recovery.** Destructive actions confirm or offer undo. Forms validate before submit where they can, and error messages say what went wrong and how to fix it. A user can always back out of a flow without losing work they meant to keep.
3. **Recognition over recall.** Users pick from visible options rather than remembering codes, names, or earlier screens.
4. **Match to the user's world.** Labels use the primary user's words, never database field names or internal jargon.
5. **User control.** Users can cancel, go back, and dismiss. Nothing traps them in a modal or a multi-step flow.

At lower weight, also check flexibility and efficiency (repeat users have shortcuts such as defaults, recent items, or keyboard shortcuts) and help (a user stuck on the core job can find an answer without leaving the app). Consistency and minimalist design are covered by the consistency and hierarchy lenses.

### Consistency

Judge each screen against the baseline from Step 2. The same action looks and behaves the same everywhere; the same kind of information appears in the same place. Name the baseline value each departure breaks.

### Hierarchy

Each screen has one obvious primary action and one obvious focal point. Check that the core job's next step is the most prominent thing on its screen, that grouping and spacing show what belongs together, and that nothing secondary outshouts it.

### Copy

Interface text is short, specific, and in the user's words. Buttons name the action ("Save changes," never "OK" or "Submit"). Empty states say what goes here and how to add the first one. Error messages name the problem and the fix, without blame or codes. Terminology matches across screens.

### Platform

Apply the platform reference read in Step 1. A convention broken on the core path weighs more than one broken elsewhere.

## B. Interface states

For each core and first-run screen, check each state that applies:

| State | It must |
|---|---|
| Empty | Explain what will appear here and offer the action that fills it. A blank list is a finding. |
| Loading | Show progress within a second and keep the layout stable; prefer skeletons or inline spinners to a blank screen. |
| Partial | Make sense with one item, or with some fields missing, without broken layout. |
| Error | Say what failed, keep the user's input, and offer a retry or a way out. |
| Success | Confirm the result where the user is looking, then get out of the way. |
| Offline | (When the app depends on the network.) Say the connection is lost and what still works. |

## C. Extracting the implied design system

From the code, collect:

- **Web:** CSS custom properties, Tailwind or other theme config, values in stylesheets and inline styles, and shared components.
- **iOS:** asset catalog color sets, `Color` and `Font` extensions, custom `ViewModifier`s and `ButtonStyle`s, and shared views.

Count how often each color, type size, spacing value, and corner radius appears. Values that recur form the inferred standard. A value that appears once or twice, or sits close to a recurring value (a 14px gap beside a dominant 16px), is a consistency candidate. Group components by purpose and flag purposes served by more than one component, such as two primary button styles.

## D. Severity

Each level names the action it requires. The design column defines the impact that earns it.

| Severity | Action | Design impact |
|---|---|---|
| Blocker | Resolve before the next release. | The primary user cannot complete or recover from a core-job step, the interface reports success on failure, or a destructive action loses data with no confirmation or undo. |
| Major | Fix before the next release unless the owner records a reason. | Users will likely make errors or abandon: missing feedback on a core action, a missing error or empty state on a core screen, a misleading control, a platform convention broken on the core path, or a layout that breaks on a common device or viewport. |
| Minor | Fix when convenient. | Inconsistency with the baseline, weak hierarchy, unclear copy, or a missing state outside the core path. |
| Nit | Record only when a stated standard covers it. | Small spacing or alignment drift, or wording preferences, with no effect on comprehension. |

When unsure between two levels, pick the lower and state why in Confidence.

### Calibration example

An inflated finding:

```
### D-09 · Major · consistency
**Finding:** Primary buttons use two different blues.
**Evidence:** Settings "Save" uses #2563EB; Home "Add item" uses #1D4ED8 (code).
**Impact:** Looks unprofessional.
```

Both buttons read as primary, users act on both correctly, and "looks unprofessional" names no user impact. The departure is real and needs a standard chosen. Corrected:

```
### D-09 · Minor · consistency
**Finding:** Primary buttons use two blues; the baseline has no single primary color.
**Evidence:** #2563EB in 11 places, including Settings "Save"; #1D4ED8 in 2 places, including Home "Add item" (code).
**Impact:** Weakens the visual signal for the primary action and invites further drift.
**Recommendation:** Adopt #2563EB, the recurring value, as the primary token and replace both uses of #1D4ED8.
**Decision needed:** which blue is the canonical primary color.
**Confidence:** High.
**Handoff:** none.
```
