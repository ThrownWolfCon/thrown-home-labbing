# Common tasks. Run `make help` to list them.

GRAFANA_TOOLKIT := https://github.com/grafana/writers-toolkit.git
VALE_STYLES     := .vale/styles

.PHONY: help
help: ## List available tasks
	@grep -E '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*## "}; {printf "  %-12s %s\n", $$1, $$2}'

.PHONY: serve
serve: ## Preview the site at http://localhost:1313 with live reload
	hugo server --buildDrafts

.PHONY: build
build: ## Build the site into public/
	hugo --gc --minify

.PHONY: vale-sync
vale-sync: ## Fetch the Grafana Writers' Toolkit Vale style and sync packages
	rm -rf .vale/.toolkit
	git clone --quiet --depth 1 --filter=blob:none --sparse $(GRAFANA_TOOLKIT) .vale/.toolkit
	git -C .vale/.toolkit sparse-checkout set vale/Grafana/styles
	rm -rf $(VALE_STYLES)/Grafana $(VALE_STYLES)/config/dictionaries $(VALE_STYLES)/config/scripts
	cp -r .vale/.toolkit/vale/Grafana/styles/Grafana $(VALE_STYLES)/
	mkdir -p $(VALE_STYLES)/config
	cp -r .vale/.toolkit/vale/Grafana/styles/config/dictionaries $(VALE_STYLES)/config/
	cp -r .vale/.toolkit/vale/Grafana/styles/config/scripts $(VALE_STYLES)/config/ 2>/dev/null || true
	rm -rf .vale/.toolkit
	vale sync

.PHONY: vale
vale: ## Check prose with Vale
	vale content/

.PHONY: markdownlint
markdownlint: ## Check Markdown structure with markdownlint-cli2
	npx --yes markdownlint-cli2 "content/**/*.md"

.PHONY: lint
lint: vale markdownlint ## Run all linters
