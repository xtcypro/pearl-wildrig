# Stage 1: fetch and verify official WildRig Multi 0.52.3 binary (zero build tools left in final image)
FROM debian:bookworm-slim AS fetch

ARG WILDRIG_VERSION=0.52.3
ARG WILDRIG_SHA256=7308c95f7c8c4c0d82aade61bb4ab3366decae2b9d04ac47b8c1dc6d1bdd2c44

RUN apt-get update -qq \
    && apt-get install -y -qq --no-install-recommends curl ca-certificates tar \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /out \
    && curl --retry 3 --retry-delay 3 --connect-timeout 15 --max-time 120 -fsSL \
        "https://github.com/andru-kun/wildrig-multi/releases/download/${WILDRIG_VERSION}/wildrig-multi-linux-${WILDRIG_VERSION}.tar.gz" \
        -o /tmp/wildrig.tar.gz \
    && echo "${WILDRIG_SHA256}  /tmp/wildrig.tar.gz" | sha256sum -c - \
    && tar -xzf /tmp/wildrig.tar.gz -C /out wildrig-multi \
    && chmod 0755 /out/wildrig-multi \
    && rm -f /tmp/wildrig.tar.gz

# Stage 2: minimal NVIDIA CUDA base (~32 MB) + single static wildrig-multi binary (~29 MB)
FROM nvidia/cuda:12.4.1-base-ubuntu22.04

ENV NVIDIA_DISABLE_REQUIRE=1

LABEL org.opencontainers.image.source="https://github.com/xtcypro/pearl-wildrig" \
      org.opencontainers.image.title="pearl-wildrig" \
      org.opencontainers.image.description="Minimal CUDA base image with pinned WildRig Multi 0.52.3 (zero config/credentials)" \
      org.opencontainers.image.version="0.52.3"

COPY --from=fetch /out/wildrig-multi /opt/miner/wildrig-multi
WORKDIR /opt/miner
CMD ["sleep", "infinity"]
