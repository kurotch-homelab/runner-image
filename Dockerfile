# syntax=docker/dockerfile:1.7

FROM ghcr.io/actions/actions-runner:2.336.0

ARG APT_MIRROR="https://ftp.udx.icscoe.jp/Linux/ubuntu"

LABEL org.opencontainers.image.source="https://github.com/kurotch-homelab/runner-image" \
      org.opencontainers.image.description="Minimal GitHub Actions runner image for Actions Runner Controller" \
      org.opencontainers.image.licenses="MIT"

USER root

# Keep the upstream image small while supplying the runtime library required
# by pnpm 11's standalone executable. Ubuntu archive and security suites are
# both served by the official ICSCoE mirror.
RUN set -eux; \
    test "$(dpkg --print-architecture)" = "amd64"; \
    rm -f /etc/apt/sources.list.d/git-core-ubuntu-ppa-*.list \
          /etc/apt/sources.list.d/git-core-ubuntu-ppa-*.sources; \
    for source_file in \
      /etc/apt/sources.list \
      /etc/apt/sources.list.d/*.list \
      /etc/apt/sources.list.d/*.sources; do \
      [ -f "${source_file}" ] || continue; \
      sed -E -i \
        -e "s|https?://([a-z0-9.-]+\\.)?archive\\.ubuntu\\.com/ubuntu/?|${APT_MIRROR}|g" \
        -e "s|https?://security\\.ubuntu\\.com/ubuntu/?|${APT_MIRROR}|g" \
        "${source_file}"; \
    done; \
    grep -R -F "${APT_MIRROR}" /etc/apt; \
    apt-get update; \
    apt-get install -y --no-install-recommends libatomic1; \
    test -e /usr/lib/x86_64-linux-gnu/libatomic.so.1; \
    rm -rf /var/lib/apt/lists/*

USER runner
