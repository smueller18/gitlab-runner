FROM gitlab/gitlab-runner:alpine

ENV DOCKER_IMAGE docker:latest
ENV PRIVILEGED false
ENV SHARE_DOCKER_SOCKET false
ENV SHARE_ZONEINFO true
ENV LOCKED false
ENV ADDITIONAL_OPTIONS ""

RUN git config --system http.sslCAPath /etc/ssl/certs/ca-certificates.crt

COPY entrypoint /
ENTRYPOINT ["/entrypoint"]
