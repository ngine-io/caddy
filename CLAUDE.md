# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Builds a custom Caddy Docker image (xcaddy + plugins tlsconsul, caddy-security, dns/infomaniak) for linux/amd64 and linux/arm64 and publishes it to `ghcr.io/ngine-io/caddy`. Ported from gitlab.com/ngine/docker-images/caddy.

## How the pieces fit

- `VERSION` is the single source of truth for every version. It is read in three places, so its format matters:
  - CI greps `^[A-Z_]+=` lines into `$GITHUB_ENV`, so entries must stay plain `KEY=value` with no quotes or spaces.
  - Renovate's regex manager in `renovate.json` matches a `# renovate: datasource=... depName=...` comment on the line directly above each value. Keep that comment adjacent when editing.
  - Each value is passed as a `--build-arg` into `Dockerfile`.
- Adding a plugin means changing four files in step: a `VERSION` entry with its Renovate comment, an `ARG` and `--with` in `Dockerfile`, a `build-args` line in `.github/workflows/build.yml`, and the module name in the workflow's smoke-test loop.
- Image tags are derived in the `merge` job from `CADDY_IMAGE_TAG` + `IMAGE_REVISION`: `<ver>-<rev>`, `<major>.<minor>`, `<major>`, `latest`. Reset `IMAGE_REVISION` to 1 on a Caddy bump; increment it to rebuild the same Caddy version (e.g. a plugin-only update).
- `.github/workflows/build.yml` builds each architecture on a native runner (`ubuntu-24.04` / `ubuntu-24.04-arm`, no QEMU), pushes by digest, then the `merge` job combines the digests into one multi-arch manifest with `docker buildx imagetools create`. On PRs it only builds and tests locally (`caddy:test`); nothing is pushed.
- Renovate auto-merges patch updates once checks pass. Minor and major updates need review.

## Local build

```sh
set -a; source <(grep -E '^[A-Z_]+=' VERSION); set +a
docker build \
  --build-arg CADDY_IMAGE_TAG --build-arg CADDY_PLUGIN_TLSCONSUL \
  --build-arg CADDY_PLUGIN_SECURITY --build-arg CADDY_PLUGIN_DNS_INFOMANIAK \
  -t caddy:test .
docker run --rm caddy:test caddy list-modules | grep -E 'consul|^security$|infomaniak'
```
