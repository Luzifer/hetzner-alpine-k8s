ARG ALPINE_VERSION=3.17
ARG UID=1000
ARG GID=1000

FROM alpine:$ALPINE_VERSION
ARG UID
ARG GID

SHELL ["/bin/sh", "-exc"]

RUN apk add --no-cache \
      ansible-core \
      jq \
      packer \
 && adduser ansible -u "$UID" -D -h /home/ansible "$GID" \
 && mkdir -p /configs /manifests /cache \
 && chown ansible /manifests /configs /cache

USER ansible
WORKDIR /home/ansible
COPY                  default.json    default.json
COPY                  alpine.pkr.hcl  alpine.pkr.hcl
COPY                  playbook.yml    playbook.yml
COPY --chmod=u=rx,og= entrypoint.sh   entrypoint.sh

VOLUME /cache

ENTRYPOINT ["/bin/sh", "entrypoint.sh"]
CMD ["default.json"]
