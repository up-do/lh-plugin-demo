# LiquidHaskell as a GHC Plugin

This repo demonstrates how to use [LiquidHaskell](https://github.com/ucsd-progsys/liquidhaskell) as a GHC plugin.

`lh-plugin-demo.cabal` shows

- how to tell GHC to invoke the plugin
- how to specify the relevant LH wrapper packages as dependencies

## Building with Projects

You will need to have a supported GHC in your PATH when building with Cabal.
Stack will install the appropriate GHC version for you by default unless you
have it configured not to do that and pick up system GHC versions.

```
$ stack config set system-ghc true --global
$ stack config set install-ghc false --global
```

This is recommended if you use [GHCup](https://www.haskell.org/ghcup/) to manage
your GHC versions.

We supply `ghc-x.y.z.stack.yaml` Stack projects and `ghc-x.y.z.cabal.project`
Cabal projects for each supported GHC version; `9.2.8`, `9.4.7`, `9.6.3`,
`9.8.1`, `9.10.1`, `9.12.2`, `9.14.1`.

All but `ghc-9.14.1.*` projects depend on relevant LH packages from **hackage**.

- build using Stack with `stack build --stack.yaml=ghc-x.y.z.stack-yaml`
- build using Cabal with `cabal build all --project-file=ghc-x.y.z.cabal.project`

The `ghc-9.14.1.*` projects depend on relevant LH packages from **github**.

## Building using Cabal without a Project

We supply no `cabal.project` and no such project is needed for the releases of
`liquidhaskell` in hackage. The dependency solver `cabal-install:exe:cabal` uses
should pick the appropriate LH dependency versions for each compiler.

- build with `cabal build all`

## GHCi Integration

By virtue of being a plugin, you now get LH errors

- when you (re)load in GHCi.

- from all editor plugins based on `ghci` integration

### GHCID

VSCode running `ghcid` in a terminal

![ghcid](ghcid.gif)

### VSCode

VSCode with the `Simple GHC (Haskell) Integration` plugin

![VS Code](vscode.gif)

Note that, by default, the extension uses Haddock, which used to be incompatible with LiquidHaskell before `ghc-9.14.1`. This repo includes custom .vscode settings to disable haddock, but you can also do it manually in the extension settings by removing ```:set -haddock``` from the ```Ghc Simple › Startup Commands: All``` section.

### Emacs

![Doom/Emacs with `dante`](emacs.gif)


### Vim

Vim/Neovim with `ALE` and the `stack-build` linter

![Vim/Neovim with `ALE` and the `stack-build` linter](vim.png)

## GHCID Integration

Additionally, [`ghcid`](https://github.com/ndmitchell/ghcid) produces LH errors on recompilation

For `stack`-based projects, run with

```
$ ghcid -c "stack ghci"
```

For `cabal`-based projects, run with

```
$ ghcid -c "cabal v2-repl"
```

## Importing Specifications across Packages

The plugin also ensures that specifications written for one
package are used when checking client packages. For an example,
see the associated [lh-plugin-demo-client package](https://github.com/ucsd-progsys/lh-plugin-demo-client/).

