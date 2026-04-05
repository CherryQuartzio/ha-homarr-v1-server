FROM ghcr.io/homarr-labs/homarr:latest

# Copy data for add-on
COPY startup.sh /app/
RUN chmod 777 /app/startup.sh /app/entrypoint.sh /app/run.sh

CMD [ "/app/startup.sh" ]