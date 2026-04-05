ARG BUILD_FROM=ghcr.io/hassio-addons/base:latest
ARG HOMARR_IMAGE=ghcr.io/homarr-labs/homarr:latest

FROM ${HOMARR_IMAGE} AS homarr_runtime

FROM ${BUILD_FROM}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Ensure bash is available in both Alpine/Debian based images
RUN if command -v apk >/dev/null 2>&1; then \
			apk add --no-cache bash; \
		elif command -v apt-get >/dev/null 2>&1; then \
			apt-get update && apt-get install -y --no-install-recommends bash && rm -rf /var/lib/apt/lists/*; \
		fi

# Bring the Homarr runtime from upstream image into selected base image
COPY --from=homarr_runtime /app /app

# Add-on startup wrapper
COPY startup.sh /app/startup.sh
RUN chmod +x /app/startup.sh \
		&& chmod +x /app/entrypoint.sh /app/run.sh

CMD ["/app/startup.sh"]