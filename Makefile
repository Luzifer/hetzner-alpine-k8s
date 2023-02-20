ALPINE_VERSION:=3.17.0
PACKER_VERSION:=1.8.4-r2
ANSIBLE_CORE_VERSION:=2.13.6-r0
JQ_VERSION:=1.6-r2

export DOCKER_BUILDKIT:=1

default:

config.json:
	yq -ojson . config.yaml | jq -S . >config.json

create-snapshot: docker-build config.json
	envrun -- docker run --rm -i \
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

.PHONY: config.json
