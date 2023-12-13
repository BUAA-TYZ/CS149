Summary
---
- Use mulitple condition variables, which is efficient.
- An error very unusual: i put the `unlock()` before the `nofify_one()`, which causes some segment faults or deadlock from time to time.