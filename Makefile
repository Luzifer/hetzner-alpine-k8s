ENVRUN_VERSION := 0.7.3
PACKER_VERSION := 1.11.2
YQ_VERSION := 4.44.3

ENVRUN := ./envrun_$(ENVRUN_VERSION)
PACKER := ./packer_$(PACKER_VERSION)
YQ := ./yq_$(YQ_VERSION)

default:

build/%.yaml: $(ENVRUN) $(PACKER) $(YQ)
	$(YQ) -ojson . $*.yaml | jq -S . >config.json
	$(PACKER) init alpine.pkr.hcl
	$(ENVRUN) -- $(PACKER) build -var-file=config.json alpine.pkr.hcl

# --- Tools

tools: $(ENVRUN) $(PACKER) $(YQ)

$(ENVRUN):
	rm envrun_*
	curl -sSfL "https://github.com/Luzifer/envrun/releases/download/v$(ENVRUN_VERSION)/envrun_linux_amd64.tar.gz" | tar -xz
	mv envrun_linux_amd64 $@

$(PACKER):
	rm packer_*
	curl -sSfLo packer.zip "https://releases.hashicorp.com/packer/$(PACKER_VERSION)/packer_$(PACKER_VERSION)_linux_amd64.zip"
	unzip packer.zip
	rm packer.zip
	mv packer $@

$(YQ):
	rm yq_*
	curl -sSfLo $@ "https://github.com/mikefarah/yq/releases/download/v$(YQ_VERSION)/yq_linux_amd64"
	chmod +x $@

.PHONY: config.json
