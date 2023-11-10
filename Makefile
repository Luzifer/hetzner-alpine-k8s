ALPINE_VERSION:=3.18
PACKER_VERSION:=1.8.7-r3
ANSIBLE_CORE_VERSION:=2.14.5-r0
JQ_VERSION:=1.6-r3

ENVRUN_VERSION:=v0.7.1
YQ_VERSION:=v4.31.2

export DOCKER_BUILDKIT:=1

default:

config.json: yq_$(YQ_VERSION)
	./yq_$(YQ_VERSION) -ojson . config.yaml | jq -S . >config.json

create-snapshot: docker-build config.json envrun_$(ENVRUN_VERSION)
	./envrun_$(ENVRUN_VERSION) -- docker run --rm -i \
		-e "HCLOUD_TOKEN" \
		-v "$(CURDIR):/config:ro" \
		registry.local/alpine-on-hetzner:latest \
		/config/config.json

docker-build:
	docker build \
		--build-arg ALPINE_VERSION=$(ALPINE_VERSION) \
		--build-arg PACKER_VERSION=$(PACKER_VERSION) \
		--build-arg ANSIBLE_CORE_VERSION=$(ANSIBLE_CORE_VERSION) \
		--build-arg JQ_VERSION=$(JQ_VERSION) \
		-t registry.local/alpine-on-hetzner \
		./alpine-on-hetzner

# --- Tools

envrun_$(ENVRUN_VERSION):
	curl -sSfL "https://github.com/Luzifer/envrun/releases/download/$(ENVRUN_VERSION)/envrun_linux_amd64.tar.gz" | tar -xz
	mv envrun_linux_amd64 $@

yq_$(YQ_VERSION):
	curl -sSfLo $@ "https://github.com/mikefarah/yq/releases/download/$(YQ_VERSION)/yq_linux_amd64"
	chmod +x $@

.PHONY: config.json
