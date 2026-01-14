# Computing Essentials

## 📚 Description
This is the hands-on portion of our Computing Essentials class.
- We will be using Python 3.13
- We use **uv** for Python version management and package management
- We will cover foundational development tools and practices

My hope is that this course will give you the essential skills to work effectively as a developer.


## 📋 Prerequisites 

### 1. Install uv (Python Package Manager)

**macOS / Linux:**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**Windows (PowerShell):**
```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

After installation, restart your terminal and verify:
```bash
uv --version
```

### 2. Clone this repository
```bash
git clone <repository-url>
cd ce
```

### 3. Install Python and dependencies
```bash
make install
```

This will:
- Install Python 3.13 (if not already installed)
- Create a virtual environment
- Install all required packages


## 🗺️ Roadmap

| Class | Topic | Script | Key Concepts |
|-------|-------|--------|--------------|
| 1 | **Getting Started** | `1.getting-started.ipynb` | GitHub, uv, terminal, Cursor, notebooks, LiteLLM |


## 🛠️ Quick Reference

### Common Commands

```bash
# Install everything
make install

# Add a new package
make add PKG=package-name

# Remove a package
make remove PKG=package-name

# Run a Python script
make run SCRIPT=scripts/example.py

# Start Jupyter notebook
make jupyter

# See all available commands
make help
```

### Running Python with uv

```bash
# Run a script
uv run python scripts/example.py

# Open Python REPL
uv run python

# Install a package
uv add package-name
```


## 📁 Project Structure

```
ce/
├── README.md           # This file
├── Makefile            # Build automation
├── pyproject.toml      # Project configuration (dependencies, Python version)
├── .python-version     # Python version pinning
├── assets/             # Images and static files
├── data/               # Data files for exercises
├── homework/           # Homework assignments
├── scripts/            # Lecture notebooks and scripts
└── temp/               # Temporary files (gitignored)
```
