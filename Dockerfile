FROM eclipse-temurin:25-jre

WORKDIR /data

RUN apt-get update && apt-get install -y --no-install-recommends tini \
  screen \
  && rm -rf /var/lib/apt/lists/*

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
