# Rideshare Board PRD

## Problem
Parents at a small school coordinate weekday carpools in a group text. Requests scroll away, two parents often both drive, and no one can see at a glance which mornings still need a driver. Parents patch this with a shared spreadsheet that nobody updates after the first week.

## Primary user
A parent who drives in a carpool of 3 to 6 families and checks it on a phone, usually the evening before.

Secondary user: a parent who rides but rarely drives.

## Core job
See which school runs this week still need a driver, and claim one in under 30 seconds.

## Requirements
- R1. The week view shows each morning and afternoon run with its driver, or "Needs driver."
- R2. A parent claims an open run with one tap; the run shows their name within 2 seconds.
- R3. A parent can release a claimed run up to 12 hours before it starts; later releases require the parent to name a replacement.
- R4. At 7 pm each day, any parent in the carpool receives an email listing tomorrow's runs that still need a driver.
- R5. A parent joins a carpool from an invite link and reaches the week view without creating a password (email magic link).

## Success metrics
- M1. 90% of runs have a driver 24 hours before they start, measured weekly from run records, by week 4 of use.
- M2. Median time from opening the app to claiming a run under 30 seconds, measured from client events, by week 2.

## Non-goals
- No route planning or maps.
- No payments or cost splitting.
- No native mobile app; mobile web only.

## Constraints
- One developer, evenings only.
- Hosted on a single small VPS; email through a transactional provider.
- Stores names and emails only; no children's data.

## Open questions
- Should a carpool have an admin who can remove members? Owner: the developer, decide before beta.
