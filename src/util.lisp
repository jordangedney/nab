
(in-package #:nab)
(cl-syntax:use-syntax :clump)

(def float->byte (f) (truncate (* 255 f)))

(def get-sdl-error (header)
  (format t "~a: ~a~%" header
          (cffi:foreign-string-to-lisp (sdl3-raw:sdl-get-error))))

;; add to clump ----------------------------------------------------------------
(defun dig (plist &rest keys)
  (reduce #'(lambda (acc key) (getf acc key))
          keys
          :initial-value plist))

(defun combine-plists (&rest plists)
  (loop with result = nil
        for plist in (reverse plists)
        do (loop for (k v) on plist by #'cddr
                 do (setf (getf result k) v))
        finally (return result)))
;; -----------------------------------------------------------------------------


;; this is trash I think:
(defmacro quote-sublists (form)
  (labels ((walk (x)
           (cond
             ((atom x) x)
             ((and (listp x) (not (eq (car x) 'quote)))
              ;; if it's a list but not already quoted, quote it
              (if (every #'atom x)
                  `(quote ,x)
                  (mapcar #'walk x)))
             (t x))))
  (walk form)))
