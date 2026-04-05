FROM ghcr.io/homarr-labs/homarr:latest

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]