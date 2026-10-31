---
type: module
package: core
module: shared
status: implemented
---
# core.shared (module)

Package: [[core]]

## Purpose

Building blocks used by every module: the base error type and the creation and update timestamps.

## Concepts

- Errors: [[core.DomainError]], [[core.NotFoundError]], [[core.InvalidUpdatedAtError]]
- Value objects: [[core.CreatedAt]], [[core.UpdatedAt]]
- Services: [[core.UuidService]]
- Mothers: `PrimitiveMother` (random primitives built on `dart:math`), `CreatedAtMother`, `UpdatedAtMother`
