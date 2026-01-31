CABAL_VIA ?= dhall2cabal

# How to generate project-nix/ghc-$(GHC_VERSION)/sha256map.nix?
# This is copied from ghc-$(GHC_VERSION).sha256map.nix.
#  - false to generate from *.dhall inputs via sha256map.hs.
#  - true to generate from stack.yaml via sha256map.py.
SHA256MAP_VIA_PYTHON ?= false

# To use installed executables instead of *.hs scripts, set these to true.
SHA256MAP_HS_EXE ?= false
PKG_GROUPS_HS_EXE ?= false
PKGS_SORTED_HS_EXE ?= false
PKGS_UPGRADE_DONE_HS_EXE ?= false

include project-versions.mk
include updo/Makefile

project-nix/ghc-%/sha256map.nix: ghc-%.sha256map.nix
	mkdir -p $(@D) && cp $^ $@

# We don't want to have files named *.dhall2stack.yaml and *.dhall2cabal.project
# so we rename them.
ghc-$(GHC_VERSION).stack.yaml: ghc-$(GHC_VERSION).dhall2stack.yaml
	cp $^ $@
	
ghc-$(GHC_VERSION).stack.yaml.lock: ghc-$(GHC_VERSION).dhall2stack.yaml.lock
	cp $^ $@
	
ghc-$(GHC_UPGRADE).stack.yaml: ghc-$(GHC_UPGRADE).dhall2stack.yaml
	cp $^ $@
	
ghc-$(GHC_UPGRADE).stack.yaml.lock: ghc-$(GHC_UPGRADE).dhall2stack.yaml.lock
	cp $^ $@
	
ghc-$(GHC_VERSION).cabal.project: ghc-$(GHC_VERSION).dhall2cabal.project
	cp $^ $@
	
ghc-$(GHC_UPGRADE).cabal.project: ghc-$(GHC_UPGRADE).dhall2cabal.project
	cp $^ $@

.PHONY: ghc-projects
ghc-projects: \
	ghc-$(GHC_VERSION).stack.yaml \
	ghc-$(GHC_VERSION).stack.yaml.lock \
	ghc-$(GHC_VERSION).cabal.project \

.PHONY: ghc-upgrade-projects
ghc-upgrade-projects: \
	ghc-$(GHC_UPGRADE).stack.yaml \
	ghc-$(GHC_UPGRADE).stack.yaml.lock \
	ghc-$(GHC_UPGRADE).cabal.project
	
.PHONY: all
all: \
  projects \
  project-nix/ghc-$(GHC_VERSION)/sha256map.nix \
  project-versions.nix

# To make stack.yaml or cabal.project and no other, mark the file we copy from
# as intermediate. This is all we want when not doing a GHC upgrade.
#
# Comment out these .INTERMEDIATE targets to allow these files to be kept.
.INTERMEDIATE: cabal.project
.INTERMEDIATE: cabal.upgrade.project
.INTERMEDIATE: stack.yaml
.INTERMEDIATE: stack.yaml.lock
.INTERMEDIATE: stack.upgrade.yaml
.INTERMEDIATE: stack.upgrade.yaml.lock
.INTERMEDIATE: ghc-$(GHC_VERSION).$(CABAL_VIA).project
.INTERMEDIATE: ghc-$(GHC_UPGRADE).$(CABAL_VIA).project
.INTERMEDIATE: ghc-$(GHC_VERSION).$(STACK_VIA).yaml
.INTERMEDIATE: ghc-$(GHC_UPGRADE).$(STACK_VIA).yaml
.INTERMEDIATE: ghc-$(GHC_VERSION).$(STACK_VIA).yaml.lock
.INTERMEDIATE: ghc-$(GHC_UPGRADE).$(STACK_VIA).yaml.lock
.INTERMEDIATE: ghc-$(GHC_VERSION).sha256map.nix
.INTERMEDIATE: ghc-$(GHC_UPGRADE).sha256map.nix
	
# If true, generate the sha256map from the stack.yaml with python,
# overriding the recipe for this target.
ifeq ($(SHA256MAP_VIA_PYTHON), true)
ghc-$(GHC_VERSION).sha256map.nix: stack.yaml
	updo/project-nix/sha256map.py <$^ >$@
ghc-$(GHC_UPGRADE).sha256map.nix: stack.upgrade.yaml
	updo/project-nix/sha256map.py <$^ >$@
endif

.DEFAULT_GOAL := all

UPDO_VERSION ?= 011be290d1d7ebcb2f8776565c9b50c7c843ba77
UPDO_URL := https://github.com/cabalism/updo/archive/${UPDO_VERSION}.tar.gz

updo/Makefile:
	rm -rf updo
	curl -sSL ${UPDO_URL} | tar -xz
	mv updo-* updo
	chmod +x $$(grep -RIl '^#!' updo)
