# Makefile for local development (Ubuntu 24.04)
# ---------------------------------------------
# Usage:
#   make                # bootstraps vcpkg, installs deps, configures & builds
#   make vcpkg-bootstrap  # clone & bootstrap vcpkg if missing
#   make vcpkg-install    # install vcpkg.json dependencies
#   make configure        # run cmake configure into ./build
#   make build            # build from ./build
#   make clean            # remove ./build directory
#
# Notes:
#   • Ensure git is installed (for cloning vcpkg).
#   • You can override defaults via environment, e.g.:
#       make CMAKE_BUILD_TYPE=Debug VCPKG_TRIPLET=x64-linux-debug

# ----------------------------
# VARIABLES (tweak as needed)
# ----------------------------
# Where to clone/browse vcpkg
VCPKG_ROOT       ?= $(CURDIR)/vcpkg
VCPKG_EXECUTABLE := $(VCPKG_ROOT)/vcpkg

# Triplet to use for vcpkg; adjust if you need a different target
VCPKG_TRIPLET    ?= x64-linux

# Directory where CMake will place all build artifacts
BUILD_DIR        := build

# Build type (Release, Debug, etc.)
CMAKE_BUILD_TYPE ?= Release

# Number of parallel jobs for the build step
# If MAKEFLAGS is set (e.g. "-j2"), this picks up the number; otherwise defaults to 2
PARALLEL_JOBS    ?= $(or $(MAKEFLAGS),2)

# Path to the vcpkg toolchain file (once vcpkg is bootstrapped)
VCPKG_TOOLCHAIN_FILE := $(VCPKG_ROOT)/scripts/buildsystems/vcpkg.cmake

# ------------------------------------
# DEFAULT TARGET: run everything in one
# ------------------------------------
.PHONY: all
all: vcpkg-bootstrap vcpkg-install configure build

# ----------------------------------
# 1) Bootstrapping vcpkg (if needed)
# ----------------------------------
.PHONY: vcpkg-bootstrap
vcpkg-bootstrap:
	@if [ ! -x "$(VCPKG_EXECUTABLE)" ]; then \
	  echo ">> Cloning vcpkg into $(VCPKG_ROOT)…"; \
	  git clone https://github.com/microsoft/vcpkg.git "$(VCPKG_ROOT)"; \
	  echo ">> Bootstrapping vcpkg…"; \
	  cd "$(VCPKG_ROOT)" && ./bootstrap-vcpkg.sh --disableMetrics; \
	else \
	  echo ">> vcpkg already bootstrapped."; \
	fi

# ----------------------------------------
# 2) Install dependencies from vcpkg.json
# ----------------------------------------
.PHONY: vcpkg-install
vcpkg-install: vcpkg-bootstrap
	@echo ">> Installing vcpkg dependencies (triplet=$(VCPKG_TRIPLET))…"
	@"$(VCPKG_EXECUTABLE)" install --triplet "$(VCPKG_TRIPLET)"

# -------------------------------------
# 3) Run CMake configure into ./build
# -------------------------------------
.PHONY: configure
configure: vcpkg-install
	@echo ">> Running CMake configure (BuildType=$(CMAKE_BUILD_TYPE))…"
	@cmake -S . -B "$(BUILD_DIR)" \
		-DCMAKE_TOOLCHAIN_FILE="$(VCPKG_TOOLCHAIN_FILE)" \
		-DVCPKG_TARGET_TRIPLET="$(VCPKG_TRIPLET)" \
		-DCMAKE_BUILD_TYPE="$(CMAKE_BUILD_TYPE)"

# ------------------------------------
# 4) Build the project (using cmake)
# ------------------------------------
.PHONY: build
build: configure
	@echo ">> Building project (parallel=$(PARALLEL_JOBS))…"
	@cmake --build "$(BUILD_DIR)" --parallel "$(PARALLEL_JOBS)"

# -----------------------
# 5) Clean all artifacts
# -----------------------
.PHONY: clean
clean:
	@echo ">> Removing build directory: $(BUILD_DIR)"
	@rm -rf "$(BUILD_DIR)"

# -------------------------------------------------
# (Optional) A shortcut for a full rebuild from scratch
# -------------------------------------------------
.PHONY: rebuild
rebuild: clean all

# --------------------
# .PHONY declarations
# --------------------
.PHONY: all vcpkg-bootstrap vcpkg-install configure build clean rebuild
