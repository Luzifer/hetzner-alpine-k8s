# Luzifer / hetzner-alpine-k8s

This repo is derived from the [MathiasPius/alpine-on-hetzner](https://github.com/MathiasPius/alpine-on-hetzner) build tooling.

It contains a modified version of the packer / ansible setup to create a snapshot containing a Kubernetes-ready setup.

## Usage

- Create an `.env` file containing an `HCLOUD_TOKEN=someimportanttoken`
- Execute `make build/<your YAML config, i.e. config.yaml>`
