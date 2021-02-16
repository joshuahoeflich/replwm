;; -*- lexical-binding: t -*-
;; For a convenient editing experience, load this file into Emacs before you
;; start hacking on the project. It will handle making sure all the files
;; you need are loaded for you.

(defun replwm/load-project-package ()
  "Load the files which define our project into Sly."
  (sly-eval '(asdf:load-system 'replwm/test)))

(add-hook 'sly-connected-hook 'replwm/load-project-package)
