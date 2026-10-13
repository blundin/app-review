# ADR-0001: Use SQLite for persistence

Status: accepted
Date: 2023-02-11

## Context and forces
One household, one small server, one developer. Operational simplicity outranks concurrency.

## Decision
We will use SQLite in a file on the server because it removes a database process to operate and back up.

## Consequences
Backups are a file copy. Concurrent writes are limited, which fits one household.
