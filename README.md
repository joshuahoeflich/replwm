# replwm
A hackable X11 window manager written in Common LISP.

## What About Stumpwm?

Stumpwm is a multi-paradigm tiling window manager descended from Ratpoison with a 15,000 line code base. By contrast, Replwm aims to implement DWM-style dynamic tiling atop a tiny core; redefining everything from core primitives (like X11 event handlers) to key-bindings and layouts via the REPL should be easy. Testing your changes should be simple as well, as Replwm ships with a small library built beside it to facilitate REPL driven TDD. Thus, the key features of the project are:

- Dynamic Tiling
- Small code base
- Extensible and hackable testing utilities

None of this is finished yet, of course, and contributions are welcome. The project is currently in the pre-alpha phase (nothing is implemented yet); if you’re a Lisp hacker, feel free to contribute ideas and/or code!

## Developing
You'll need:
- sbcl
- git
- A Unix-based operating system running X11 (e.g., Linux)
- libX11
- libXinerama
- Xephyr (for experimenting)
- Direnv (for handling environment variables)

To get started, clone the repository *recursively* with the following command:

```
git clone --recursive https://github.com/joshuahoeflich/replwm
```

Why do you need to add that flag? Simple: We use `git submodules` to ensure that all dependencies for this project besides the system-level ones *live inside this repository.* You don't need to worry about QuickLisp or any other package manager that relies on transient state in the `$HOME` directory; everything you need lives in the folder you clone.

Once you're in the repository, make sure to source the environment variables in the `.envrc` file into your shell. Once you're finished hacking, make sure to unsource them as well, such that you don't have any surprising errors while working on other projects. [I use direnv to automate that process away.](https://direnv.net/) [If you use Emacs, check out emacs-direnv for some nice integrations.](https://github.com/wbolster/emacs-direnv) You can compile a working binary with

```
make build
```

And get more information about the things you can do with

```
make help
```

Note that the project isn't finished yet, so `make build` is a stub.

## Testing
Instead of relying on a framework like 5AM, we use a simple, composable testing library called `wm-test` that lives in `src/wm-test`.
