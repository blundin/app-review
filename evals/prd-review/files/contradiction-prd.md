# Potluck Planner PRD

## Problem
Hosts of small potlucks collect dish sign-ups in group chats and end up with five desserts and no main dish. Guests forget what they promised to bring.

## Primary user
A host planning a potluck for 8 to 30 guests, sending one link to the whole guest list.

## Core job
Get a balanced menu by letting guests claim dishes from categories the host sets.

## Requirements
- R1. The host creates an event with dish categories and a cap per category.
- R2. Guests open the event link and claim a dish in a category that still has room.
- R3. A guest can return to the link days later, see the dish they claimed, and change or cancel it.
- R4. The host sees every claim with the guest's name.
- R5. The day before the event, the host receives a summary email.

## Success metrics
- M1. 80% of events reach at least one claim in every category before the event date, measured from event records.

## Non-goals
- No guest accounts, logins, or stored guest emails. Guests type a name and claim.
- No recipes or nutrition data.

## Constraints
- Free hosting tier; one developer.
