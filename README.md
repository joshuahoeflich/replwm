# replwm
A hackable X11 window manager written in Common LISP.

## What About Stumpwm?

Stumpwm is a multi-paradigm tiling window manager descended from Ratpoison with a 15,000 line code base. By contrast, Replwm aims to implement DWM-style dynamic tiling atop a tiny core; redefining everything from core primitives (like X11 event handlers) to key-bindings and layouts via the REPL should be easy. Testing your changes should be simple as well, as Replwm ships with a small library built beside it to facilitate REPL driven TDD. Thus, the key features of the project are:

- Dynamic Tiling
- Small code base
- Extensible and hackable testing utilities

None of this is finished yet, of course, and contributions are welcome. The project is currently in the pre-alpha phase (nothing is implemented yet); if you’re a Lisp hacker, feel free to contribute ideas and/or code!

## Research-ish Thoughts

What would a DSL extension language implemented with Racket look like? What about Emacs integration? How do we make better cross-lisp integration possible?

## Developing
You'll need:
- sbcl
- git
- A Unix-based operating system running X11 (e.g., Linux)
- libX11
- libXinerama
- Xephyr (for experimenting)

Use `make xrepl` to spin up an X-Server inside this one which you can use to develop.

## Testing

