
(in-package #:nab)
(cl-syntax:use-syntax :clump)

(require :cl-mop)

;; constants ------------------------------------------------------------------
(set +data-path+ "/data/")
(set +images-path+ (str +data-path+ "images/"))
(set +time-step+ (/ 1.0 120.0)) ; least amt of time passed between updates

;; globals --------------------------------------------------------------------
(set *running* nil)

;; misc -----------------------------------------------------------------------
(def float->byte (f) (truncate (* 255 f)))

;; add to clump ----------------------------------------------------------------
(defun dig (plist &rest keys)
  (reduce #'(lambda (acc key) (getf acc key))
          keys
          :initial-value plist))

(defsetf dig (plist &rest keys) (new-value)
  ;; Build a setf form like (setf (getf (getf plist :a) :b) new-value)
  `(setf ,(reduce (lambda (acc key) `(getf ,acc ,key)) keys :initial-value plist)
     ,new-value))

(mac dig= (plist value &rest keys)
  (w/uniq copy
    `(= ((,copy (cl-mop:deep-copy ,plist)))
       (setf (dig ,copy ,@keys) ,value)
       ,copy)))

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
