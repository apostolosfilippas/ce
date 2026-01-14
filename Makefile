.PHONY: help install clean format lint docs
export PATH := $(HOME)/.local/bin:$(PATH)

###############
##@⭐ Utils
###############
help: ## Show this helpful message
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "   \033[33m%-25s\033[0m %s\n", $$1, $$2} /^##@/ {printf "\n\033[0;32m%s\033[0m\n", substr($$0, 4)} ' $(MAKEFILE_LIST)

###############
##@💻 Setup (using uv)
###############
check-uv: ## Check if uv is installed
	@echo "Checking for uv..."
	@command -v uv >/dev/null 2>&1 || { echo "❗ uv is not installed. Run: curl -LsSf https://astral.sh/uv/install.sh | sh"; exit 1; }
	@echo "✅ uv is installed"

install: check-uv ## Install Python and dependencies using uv
	@echo "📦 Installing Python and dependencies with uv..."
	@uv python install
	@uv sync
	@echo "📦 Installing pre-commit hooks..."
	@uv run pre-commit install
	@echo "✅ Installation complete!"

clean-venv: ## Clean Python venv
	@echo "🧹 Cleaning Python venv..."
	@[ ! -d .venv ] || rm -rf .venv
	@echo "✅ Cleanup complete!"

clean-temp: ## Clean temporary files and caches
	@echo "🧹 Cleaning temp files..."
	@rm -rf temp/*.pdf
	@rm -rf temp/*.csv
	@echo "✅ Cleanup complete!"

###############
##@📦 Dependencies
###############
add: check-uv ## Add a package (usage: make add PKG=package-name)
	@if [ -z "$(PKG)" ]; then echo "❗ Usage: make add PKG=package-name"; exit 1; fi
	@echo "📦 Adding $(PKG)..."
	@uv add $(PKG)
	@echo "✅ $(PKG) added successfully"

remove: check-uv ## Remove a package (usage: make remove PKG=package-name)
	@if [ -z "$(PKG)" ]; then echo "❗ Usage: make remove PKG=package-name"; exit 1; fi
	@echo "📦 Removing $(PKG)..."
	@uv remove $(PKG)
	@echo "✅ $(PKG) removed successfully"

###############
##@🚀 Running
###############
run: check-uv ## Run a Python script (usage: make run SCRIPT=scripts/example.py)
	@if [ -z "$(SCRIPT)" ]; then echo "❗ Usage: make run SCRIPT=scripts/example.py"; exit 1; fi
	@echo "🐍 Running $(SCRIPT)..."
	@uv run python $(SCRIPT)

jupyter: check-uv ## Start Jupyter notebook server
	@echo "📓 Starting Jupyter..."
	@uv run jupyter notebook

###############
##@📄 Notebooks
###############
pdfs: ## Convert all Jupyter notebooks in the scripts/ folder to PDF and save in temp/
	@echo "📓 Converting all Jupyter notebooks to PDF..."
	@make clean-temp
	@set -e; \
	for notebook in scripts/*.ipynb; do \
		if [ -f "$$notebook" ]; then \
			notebook_name=$$(basename "$$notebook" .ipynb); \
			echo "🔄 Converting $$notebook_name.ipynb to PDF..."; \
			uv run jupyter nbconvert --to webpdf --allow-chromium-download "$$notebook" --output-dir temp/ || { echo "❌ Error converting $$notebook"; exit 1; }; \
			echo "✅ $$notebook_name.pdf created successfully"; \
		fi; \
	done
	@echo ""
	@echo "🎉 All notebooks converted to PDF!"
	@echo "📂 PDFs saved in temp/ directory"

run-notebooks: ## Run all Jupyter notebooks from clean slate, stop on any error
	@make clean-temp
	@echo "📓 Running all Jupyter notebooks in order with error checking..."
	@set -e; \
	for notebook in scripts/*.ipynb; do \
		if [ -f "$$notebook" ]; then \
			echo ""; \
			echo "🚀 Running $$notebook..."; \
			uv run jupyter nbconvert --to notebook --execute --inplace "$$notebook" || { echo "❌ Error in $$notebook - stopping execution"; exit 1; }; \
			echo "✅ $$notebook completed successfully"; \
		fi; \
	done
	@echo ""
	@echo "🎉 All notebooks completed successfully!"
