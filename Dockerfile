ARG CADDY_IMAGE_TAG

FROM caddy:$CADDY_IMAGE_TAG-builder AS builder

ARG CADDY_PLUGIN_TLSCONSUL
ARG CADDY_PLUGIN_SECURITY
ARG CADDY_PLUGIN_DNS_INFOMANIAK

RUN xcaddy build \
    --with github.com/pteich/caddy-tlsconsul@$CADDY_PLUGIN_TLSCONSUL \
    --with github.com/greenpau/caddy-security@$CADDY_PLUGIN_SECURITY \
    --with github.com/caddy-dns/infomaniak@$CADDY_PLUGIN_DNS_INFOMANIAK

FROM caddy:$CADDY_IMAGE_TAG
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
