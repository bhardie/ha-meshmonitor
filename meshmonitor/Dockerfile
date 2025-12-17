ARG BUILD_FROM
FROM $BUILD_FROM

# Install nothing extra - use the prebuilt MeshMonitor image
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
