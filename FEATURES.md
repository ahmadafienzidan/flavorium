# Flavorium

> **A personal coffee experiment journal that helps coffee enthusiasts document, analyze, and improve every brew until they discover the recipe that brings out the best in each coffee bean.**

---

# Vision

Flavorium is more than a coffee tracker. It is a **Coffee Experiment Journal** that helps users discover the best brewing recipe for every coffee bean through continuous experimentation.

Instead of only recording brewing history, the application focuses on documenting the learning process—allowing users to compare experiments, identify improvements, and refine recipes over time.

---

# Problem Statement

Coffee enthusiasts often experience situations like:

* Forgetting the recipe that produced an amazing cup.
* Repeating the same experiments because previous notes are scattered.
* Having no simple way to compare brewing parameters across multiple attempts.
* Losing track of which recipe worked best for a specific bean.

Flavorium aims to solve these problems by organizing every brew into a structured journey.

---

# Target Users

* Home brewers
* Specialty coffee enthusiasts
* Beginners learning manual brewing
* Anyone who enjoys experimenting with coffee recipes

Supported brewing methods include:

* V60
* Origami
* Kalita Wave
* AeroPress
* French Press
* Espresso
* and more

---

# Core Concept

The application revolves around **Coffee Beans**, but a bean is split into two roles: the **bean identity** (stable info) and the physical **bags** you actually buy.

```text
Coffee Bean  (identity: name, origin, roastery, process, roast level)
    │
    ├── Bag #1   (250g, roast 8 Jul, bought 10 Jul)
    ├── Bag #2   (200g, roast 14 Jul, bought 15 Jul)   ← refill = new bag
    │
    └── Brews
         ├── Brew #1   (-18g, rating 4)
         ├── Brew #2   (-18g, rating 5) ⭐  Best Recipe
         └── Brew #3   (-18g, rating 3)
```

Each brew belongs to a bean and contributes to discovering the optimal recipe. Buying more of the same bean adds a new **Bag** (each bag carries its own roast date), while the remaining inventory is always **calculated** from all bags minus everything consumed by brews.

---

# Data Model (MVP)

> Every table carries a `userId` column (defaults to `1`) so multi-user can be enabled later without a rewrite. Auth/login is **not** built yet.

## Bean — the coffee identity (stable)

| Field | Notes |
|-------|-------|
| id | |
| userId | default `1` (forward-compat) |
| name | |
| origin | |
| roastery | |
| process | e.g. Washed, Natural, Honey |
| roastLevel | e.g. Light, Medium, Dark |
| notes | free text |
| favorite | boolean |
| createdAt | |

## Bag — a physical bag you bought (a bean has many bags)

| Field | Notes |
|-------|-------|
| id | |
| beanId | FK → Bean |
| roastDate | **per bag** — each bag can have a different roast batch |
| amountGrams | initial weight of this bag |
| purchaseDate | when it was bought / restocked |
| createdAt | |

> **Inventory is a ledger, not a stored number.** Remaining coffee for a bean = `sum(bag.amountGrams) − sum(brew.coffeeDose)`. Refilling the same bean just adds a new Bag row.

## Brew — a single brewing session (a bean has many brews)

| Field | Notes |
|-------|-------|
| id | |
| beanId | FK → Bean |
| method | V60, AeroPress, Espresso, … |
| grinder | |
| grindSetting | |
| coffeeDose | grams — also what decrements inventory |
| waterAmount | grams / ml |
| waterTemp | |
| brewTime | |
| rating | overall 1–5 |
| **acidity** | tasting scale 1–5 |
| **sweetness** | tasting scale 1–5 |
| **bitterness** | tasting scale 1–5 |
| **body** | tasting scale 1–5 |
| **aftertaste** | tasting scale 1–5 |
| notes | free text |
| brewedAt | |

> **Brew Ratio is NOT stored** — it is computed on the fly as `waterAmount ÷ coffeeDose`.
> **Inventory consumption is aggregate** — a brew reduces the bean's total remaining stock; you don't pick which specific bag it came from.

---

# MVP Scope

The first usable product covers exactly this slice:

1. **Coffee Library** — list & manage beans
2. **Bean Detail** — bean info, inventory (from ledger), brew history, best recipe
3. **Brew Journal** — record a brewing session (params + tasting attributes + rating)
4. **Best Recipe** — auto-highlight the highest-rated brew per bean
   * Tie-breaker: if multiple brews share the top rating → **most recent wins**

Everything below is intentionally **out of the MVP** (see "Later").

---

# Core Features (Full Product)

## 1. Coffee Library
Manage all owned coffee beans (name, origin, roastery, process, roast level, notes, favorite). Remaining inventory shown per bean, computed from the bag ledger.

## 2. Bean Detail
A dedicated page per bean: bean info, inventory, bag history, brew history, best recipe, timeline, statistics.

## 3. Brew Journal
Record every brewing session with full parameters, structured tasting attributes (acidity, sweetness, bitterness, body, aftertaste), overall rating, and notes. Photos come later.

## 4. Best Recipe
Automatically highlight the highest-rated recipe for each bean (tie-breaker: most recent).

## 5. Inventory (Ledger)
Track remaining coffee as `bags − consumption`. Refilling the same bean adds a new bag with its own roast date and purchase date.

```text
Bag 250g + Bag 200g = 450g
   − Brew 18g − Brew 18g − …
   = remaining (auto-calculated)
```

## 6. Dashboard
Overview of personal brewing activity: active beans, total brews, average rating, favorite method, favorite origin, coffee consumed.

## 7. Statistics
Average rating, most brewed bean, favorite origin, favorite method, monthly activity, brewing frequency.

## 8. Recipe Collection
Save personal favorite recipes for reuse on the same or similar beans.

## 9. User Profile
Display name, avatar, bio, brewing preferences, personal statistics. (Meaningful once multi-user lands.)

---

# Later / Out of MVP

Deferred on purpose to keep the project shippable at every milestone.

## Coffee Journey (Timeline)
Visual timeline showing how recipes evolve for a bean over time.

## Compare / Diff Between Brews
Side-by-side comparison of two brews — "changed grind 18→16, rating went 4→5". This is the feature that makes Flavorium a true *experiment* journal, but it comes after the MVP is solid.

## Multi-User
Real accounts, auth, and per-user data. Schema is already forward-compatible via `userId`; only auth needs to be switched on.

## Community
Public profiles, follow users, share recipes, like brews, comments.

## Search
Search by bean, origin, roastery, brewing method, user.

## Realtime
GraphQL Subscriptions: shared recipe updates, new public brews, live notifications.

---

# UX Goals

The application should feel fast and modern.

* URL as State
* Optimistic UI
* Skeleton Loading
* View Transition API
* Keyboard Shortcuts
* Command Palette
* Responsive Layout
* Dark Mode
* Coffee Theme

---

# Technical Goals

This project is intended as a **full-stack learning project**, with a primary focus on **learning GraphQL end-to-end**.

Architecture decision: the **GraphQL backend is a separate service** from the frontend (chosen for the "purest" GraphQL learning experience). The TanStack app acts purely as a GraphQL client via Apollo Client.

```text
┌────────────────────────┐        GraphQL         ┌──────────────────────────┐
│  Frontend (TanStack)   │  ───────────────────▶  │  Backend (Apollo Server) │
│  React + Apollo Client │  ◀───────────────────  │  GraphQL + Prisma        │
└────────────────────────┘                        └────────────┬─────────────┘
                                                                │
                                                        ┌───────▼────────┐
                                                        │  PostgreSQL    │
                                                        └────────────────┘
```

## Frontend
* React
* TypeScript
* TanStack Router / Start
* Apollo Client
* Biome
* Vitest

## Backend
* Node.js
* Apollo Server
* GraphQL
* Prisma ORM

## Database
* PostgreSQL

## Infrastructure
* Docker + Docker Compose (local Postgres)
* Jenkins (CI/CD — part of the learning goals)

---

# Decisions Log

Locked decisions from planning (keep this updated as the project evolves):

| Topic | Decision |
|-------|----------|
| App name | **Flavorium** |
| Architecture | Separate GraphQL backend (Apollo Server + Prisma + Postgres); frontend is Apollo Client only |
| Users | Single-user now; schema forward-compatible via `userId` (default `1`); auth added later |
| MVP | Coffee Library → Bean Detail → Brew Journal → Best Recipe |
| Bean vs Bag | Roast date lives on the **Bag** (per purchase); bean holds stable identity |
| Inventory | **Ledger** — remaining = sum(bags) − sum(brew doses); never stored as a mutable number |
| Brew tasting | Overall rating **+** structured scales (acidity, sweetness, bitterness, body, aftertaste) |
| Best Recipe | Highest rating; tie-breaker → **most recent** |
| Brew Ratio | **Computed** (`water ÷ dose`), never stored |
| Compare/Diff | Deferred to post-MVP |
| CI/CD | Jenkins (intentionally, to learn it) |

---

# Development Philosophy

* Build incrementally.
* Keep the application usable at every milestone.
* Prefer simplicity over unnecessary dependencies.
* Treat the project like a real production product.
* Document architectural decisions along the way.

---

# Long-Term Vision

Flavorium should become a place where coffee enthusiasts can not only record what they brewed, but also understand **why one recipe worked better than another**.

Every coffee bean should tell a story.

Every brew should be an experiment.

Every experiment should make the next cup even better.
