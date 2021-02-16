(require 'uiop)

(defun list-dirs ()
  (string-right-trim
   ":"
   (reduce
    (lambda (acc el)
      (let ((dir-string (directory-namestring el)))
        (when dir-string
          (concatenate 'string (string-right-trim "/" dir-string) ":" acc))))
    (uiop:directory* "src/*")
    :initial-value "")))

(write-line (list-dirs))
