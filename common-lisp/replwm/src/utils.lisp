(in-package #:replwm)

(defmacro with (bindings &rest code)
  (let ((let-lists (loop :for (var defn) :on bindings :by #'cddr :while defn
                         :collect (list var defn))))
    `(let* (,@let-lists)
       ,@code)))

(defmacro with-catch (err-clause &body code)
  (let ((err (first err-clause))
        (err-catch (rest err-clause)))
    `(handler-case
         (progn ,@code)
       (t (,err) ,@err-catch))))
