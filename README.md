# Flavorium

> A personal coffee experiment journal — document, analyze, and improve every brew
> until you discover the recipe that brings out the best in each coffee bean.

A full-stack learning project built as a **monorepo**, with a primary focus on
learning **GraphQL end-to-end**.

📄 See [FEATURES.md](./FEATURES.md) for the product spec and [ERD.md](./ERD.md) for the data model.

---

## Monorepo layout

```text
flavorium/
├── apps/
│   ├── web/   # Frontend — TanStack Router/Start + Apollo Client
│   └── api/   # Backend  — Apollo Server + GraphQL + Prisma (Postgres)
├── packages/  # Shared code (e.g. generated GraphQL types) — added as needed
├── FEATURES.md
├── ERD.md
└── pnpm-workspace.yaml
```

Managed with **pnpm workspaces**.

## Prerequisites

- Node.js >= 20
- pnpm 10.x (`corepack enable` or `npm i -g pnpm`)
- Docker (for local PostgreSQL) — *coming with the backend setup*

## Getting started

```bash
# install everything across the workspace
pnpm install

# run the frontend (http://localhost:3000)
pnpm dev:web

# run the backend (once implemented)
pnpm dev:api
```

## Root scripts

| Command | What it does |
|---------|--------------|
| `pnpm dev:web` | Start the frontend dev server |
| `pnpm dev:api` | Start the backend dev server |
| `pnpm build`   | Build every workspace package |
| `pnpm lint`    | Lint every package |
| `pnpm test`    | Run tests across packages |

Target a single package directly with `--filter`:

```bash
pnpm --filter @flavorium/web dev
pnpm --filter @flavorium/api dev
```

## Status

🚧 Early setup. Frontend is scaffolded (TanStack Start); backend (`apps/api`) is a
placeholder to be built next. See the Decisions Log in [FEATURES.md](./FEATURES.md).
