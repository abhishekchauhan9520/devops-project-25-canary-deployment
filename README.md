# Project 25 — Canary / Progressive Deployment

A production-style canary deployment lab that progressively shifts traffic to a new release while enforcing health gates and providing an explicit rollback path.

## Promotion model

```text
Stable 100%
   ↓
Canary 5%
   ↓ health gate
Canary 25%
   ↓ health gate
Canary 50%
   ↓ health gate
Canary 100%
```

The project separates application health from traffic control. The Kubernetes manifests provide stable and canary workloads; `scripts/gate.sh` models automated SLO gates on error rate and p95 latency; `scripts/promote.sh` models controlled promotion stages.

## Health gates

Default thresholds:

- Error rate <= 1%
- p95 latency <= 500 ms

Override them with `MAX_ERROR_RATE` and `MAX_P95_MS` when testing.

## Production implementation note

The example deliberately keeps traffic shifting abstract so it can be implemented with NGINX Ingress, a service mesh such as Istio, or a progressive-delivery controller such as Argo Rollouts. In a real cluster, the promotion script should call the chosen traffic controller and then query real metrics before each stage.

## Commands

```bash
bash tests/test_project.sh
./scripts/gate.sh 0.005 250
./scripts/promote.sh 5
./scripts/promote.sh 25
./scripts/promote.sh 50
./scripts/promote.sh 100
./scripts/rollback.sh
```

## Operational mindset

The important design is not the percentages; it is the sequence of **observe → gate → promote → observe → promote**, with automatic abort and rollback when health objectives are violated.
