# @flavorium/api

GraphQL backend for Flavorium.

**Stack (to be implemented):** Apollo Server · GraphQL · Prisma ORM · PostgreSQL.

This is currently a placeholder package that reserves the workspace slot. The backend
will be scaffolded next — see the data model and decisions in the root
[FEATURES.md](../../FEATURES.md) and [ERD.md](../../ERD.md).

## Planned structure

```text
apps/api/
├── prisma/
│   └── schema.prisma        # Bean, Bag, Brew (+ forward-compat User)
├── src/
│   ├── index.ts             # Apollo Server bootstrap
│   ├── schema/              # GraphQL typeDefs
│   ├── resolvers/           # GraphQL resolvers
│   └── context.ts           # Prisma client + request context
└── package.json
```
