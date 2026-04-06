ARG BUILD_FROM=ghcr.io/homarr-labs/homarr:latest
ARG APP_BASE=ghcr.io/hassio-addons/base:20.0.2

FROM ${APP_BASE} AS ha_base

FROM ${BUILD_FROM}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Ensure bash exists for startup wrapper
RUN if command -v apk >/dev/null 2>&1; then \
			apk add --no-cache bash jq; \
		elif command -v apt-get >/dev/null 2>&1; then \
			apt-get update && apt-get install -y --no-install-recommends bash jq && rm -rf /var/lib/apt/lists/*; \
		fi

# Bring in bashio from Home Assistant base while keeping Homarr runtime dependencies
COPY --from=ha_base /usr/lib/bashio /usr/lib/bashio
COPY --from=ha_base /usr/bin/bashio /usr/bin/bashio

# Add-on startup wrapper
COPY startup.sh /app/startup.sh
RUN chmod +x /app/startup.sh \
		&& chmod +x /app/entrypoint.sh /app/run.sh

CMD ["/app/startup.sh"]