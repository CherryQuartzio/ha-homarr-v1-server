FROM ghcr.io/homarr-labs/homarr:latest

# Copy data for add-on
COPY startup.sh /
RUN chmod 777 /startup.sh /app/entrypoint.sh /app/run.sh

CMD [ "/startup.sh" ]