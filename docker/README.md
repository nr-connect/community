# Official NR Connect Node-RED Docker Image (`ghcr.io/nr-connect/node-red`)

This directory contains the exact, auditable `Dockerfile` and wrapper `entrypoint.sh` used by our public GitHub Actions workflow to build and publish `ghcr.io/nr-connect/node-red` (`linux/amd64` and `linux/arm64`).

## Exact diff from `nodered/node-red:latest`

- **Base image:** `docker.io/nodered/node-red:latest` (exact upstream manifest digest is stamped in the `org.opencontainers.image.base.digest` label on every build).
- **Non-root user:** Runs as the default non-root `USER node-red` and never modifies Node-RED's `settings.js` or core runtime.
- **Installed additions (only 3 items):**
  1. `@nr-connect/node-red` installed directly from **public npm** into `/usr/src/node-red` (0 runtime dependencies, keeps `/data` cleanly mountable).
  2. The SHA-256-verified `cloudflared` connector binary pre-installed in `/usr/local/bin/` for the target architecture.
  3. A 36-line wrapper [`entrypoint.sh`](./entrypoint.sh) that optionally installs `@flowfuse/node-red-dashboard` (`NR_CONNECT_INSTALL_DASHBOARD=true`) or seeds the starter demo (`NR_CONNECT_STARTER_FLOW=true`), then `exec`s the official `/usr/src/node-red/entrypoint.sh "$@"`.

## Verify build provenance

Every image published from this repository includes a SLSA build provenance attestation and SBOM. You can cryptographically verify that an image came unmodified from this public workflow:

```bash
gh attestation verify oci://ghcr.io/nr-connect/node-red:latest -o nr-connect
```

## Tags & automatic rebuilds

- `:latest` — latest `@nr-connect/node-red` on the latest `nodered/node-red`
- `:X.Y` — tracks patch updates within a minor release
- `:X.Y.Z` — pinned plugin semver tag (also pin by `@sha256:...` digest for strict immutability)
- Rebuilt automatically every day whenever `nodered/node-red:latest` or `@nr-connect/node-red` updates.

## Build it yourself (or use stock `nodered/node-red`)

You do not need our pre-built image to use NR Connect:

- **Stock Node-RED image:** Run `docker.io/nodered/node-red:latest` and install `@nr-connect/node-red` from **Manage palette** (or `npm install @nr-connect/node-red` in `/data`).
- **Build locally from this directory:**
  ```bash
  docker build -t my-nr-connect-nodered .
  ```
