(defun write-yellow (string)
  "Write a yellow string to the terminal."
  (format t "~c[~A~c[~A~A~c[~A~%" #\ESC "1m" #\ESC "33m"
          string #\ESC "0m"))

(defun write-indented (string)
  "Write an indented string to the terminal."
  (format t "~A~A~%" #\tab string))

(defun show-line-help (line)
  "Take a line in the Makefile and display an appropriate help message."
  (let* ((sep (or (search ": ## " line) (return-from show-line-help)))
         (command (subseq line 0 sep))
         (help (subseq line (+ sep 5) (length line))))
    (write-yellow command)
    (write-indented help)))

(defmacro do-line (s-list &body code)
  "Perform side effects for every line in a stream; analagous to DO-LIST."
  (let ((eof (gensym))
        (s (first s-list))
        (line (second s-list)))
    `(let ((,eof (list nil)))
       (do ((,line (read-line ,s nil ,eof)
                   (read-line ,s nil ,eof)))
           ((eq ,line ,eof) nil)
         ,@code))))

(defun display-make-help ()
  "Display a help message for the Makefile."
  (with-open-file (s (merge-pathnames "Makefile") :if-does-not-exist nil)
    (if s
        (do-line (s line)
          (show-line-help line))
        (write-line "Makefile not found."))))

(display-make-help)


