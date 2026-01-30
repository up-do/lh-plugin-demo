# Versions of GHC and stackage resolver, the ones we're on and the next ones
# we're upgrading to.
# GHC_VERSION ?= 9.2.8
# STACKAGE_VERSION ?= lts-20.26
# GHC_VERSION ?= 9.4.7
# STACKAGE_VERSION ?= lts-21.21
# GHC_VERSION ?= 9.6.3
# STACKAGE_VERSION ?= lts-22.6
# GHC_VERSION ?= 9.8.1
# STACKAGE_VERSION ?= nightly-2024-01-26
GHC_VERSION ?= 9.10.3
STACKAGE_VERSION ?= lts-24.28

# For the upgrade, pick a matching pair of ghc-version and stack resolver.
GHC_UPGRADE ?= 9.12.2
STACKAGE_UPGRADE ?= nightly-2025-12-15

# Imports can be relative to the project or relative to importing file.
# ImportRelative works with cabal-3.10 and is the default.
# ProjectRelative works with cabal-3.8.
CABAL_RELATIVITY ?= ImportRelative
