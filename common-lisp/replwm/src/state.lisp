(in-package #:replwm)

(defvar *wm-state* nil
  "Global singleton holding all window manager state.
If you want to play with the internals of the window manager while
hacking at a REPL, feel free to modify this variable there at your
whim. Otherwise, prefer less stateful abstractions.")

#|
If these accessors become tedious to maintain, consider writing a macro
or using the MOP tools SBCL provides.
|#

(defstruct wm-connection display screen root)

(defstruct wm-handlers handle-list on-event on-exit)

(defstruct wm connection handlers)

(defmethod wm-display ((w wm))
  (wm-connection-display (wm-connection w)))

(defmethod wm-screen ((w wm))
  (wm-connection-screen (wm-connection w)))

(defmethod wm-root ((w wm))
  (wm-connection-root (wm-connection w)))

(defmethod wm-on-event ((w wm))
  (wm-handlers-on-event (wm-handlers w)))

(defmethod wm-on-exit ((w wm))
  (wm-handlers-on-exit (wm-handlers w)))

(defmethod wm-handle-list ((w wm))
  (wm-handlers-handle-list (wm-handlers w)))
