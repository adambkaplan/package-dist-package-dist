.PHONY: lint

IS_WORKTREE := $(shell git -C $(CURDIR) worktree list 2>/dev/null | grep -q "$(CURDIR)" && echo "yes" || echo "no")

# If worktree, fetch common git directory path
ifeq ($(IS_WORKTREE), yes)
GIT_COMMON_DIR := $(shell git -C $(CURDIR) rev-parse --git-common-dir)
endif

# Build Docker run command
ifeq ($(IS_WORKTREE), yes)
DOCKER_VOLUMES := -v $(GIT_COMMON_DIR):$(GIT_COMMON_DIR) -v $(CURDIR):/tmp/lint
else
DOCKER_VOLUMES := -v $(CURDIR):/tmp/lint
endif

# Main target
lint:
	@echo "Running Super-Linter..."
	docker run --rm -e RUN_LOCAL=true -e DEFAULT_BRANCH=main $(DOCKER_VOLUMES) ghcr.io/super-linter/super-linter:latest