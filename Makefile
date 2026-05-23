.PHONY: help bootstrap sync restore doctor push status

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

bootstrap: ## Activate this repo into ~/.claude/ (symlinks)
	./bootstrap.sh

sync: ## Snapshot auto-memory into ./memory/
	./sync-memory.sh

restore: ## Restore auto-memory from ./memory/ to ~/.claude/projects/
	./restore-memory.sh

doctor: ## Check that everything is wired up correctly
	./doctor.sh

push: sync ## Sync memory and push everything to GitHub
	git add .
	@git diff --cached --quiet || git commit -m "chore: sync"
	git push

status: ## Show repo + symlink status
	@echo "── Repo status ──"
	@git status --short
	@echo
	@echo "── Symlinks in ~/.claude/ ──"
	@ls -la ~/.claude/ 2>/dev/null | grep -E "^l" || echo "  (no symlinks yet — run 'make bootstrap')"
