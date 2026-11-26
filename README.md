# pearl-wildrig

Minimal `linux/amd64` container image pairing `nvidia/cuda:12.4.1-base-ubuntu22.04` with the pinned, SHA-256-verified official `wildrig-multi 0.52.3` binary at `/opt/miner/wildrig-multi`.

Contains no wallet addresses, pool URLs, API keys, or startup credentials — runtime arguments are supplied by the launcher command.
