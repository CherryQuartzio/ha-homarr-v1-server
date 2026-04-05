FROM ghcr.io/homarr-labs/homarr:latest

# Copy data for add-on
COPY startup.sh /
RUN chmod a+x /startup.sh

CMD [ "/startup.sh" ]