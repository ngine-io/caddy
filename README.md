# Custom Caddy Web Proxy

Custom [Caddy](https://caddyserver.com/) image built with [xcaddy](https://github.com/caddyserver/xcaddy) and the following plugins:

- [pteich/caddy-tlsconsul](https://github.com/pteich/caddy-tlsconsul)
- [greenpau/caddy-security](https://github.com/greenpau/caddy-security)
- [caddy-dns/infomaniak](https://github.com/caddy-dns/infomaniak)

## Image

```
docker pull ghcr.io/ngine-io/caddy:2
```

Images are built for `linux/amd64` and `linux/arm64`.

| Tag | Example | Mutable |
|---|---|---|
| `<caddy version>-<revision>` | `2.10.0-1` | no |
| `<major>.<minor>` | `2.10` | yes |
| `<major>` | `2` | yes |
| `latest` | `latest` | yes |

## Updating

All versions are defined in [VERSION](VERSION). [Renovate](https://docs.renovatebot.com/) opens PRs for new Caddy and plugin versions. Patch releases are merged automatically once the build passes.

- When bumping `CADDY_IMAGE_TAG`, reset `IMAGE_REVISION` to `1`.
- To rebuild the same Caddy version (e.g. plugin update), increment `IMAGE_REVISION`.

Pushes to `main` and `stable-*` branches build and push the image. Pull requests only build and test it.
