;;;; appenv.lisp

(in-package #:nab)
(cl-syntax:use-syntax :clump)

;; why do both window and appenv-read contain references to graphics and window
;; state? TODO
(def mk-appenv-read (cfgs window)
  `(:window ,window))

(def mk-appenv-write ()
  '(:messages nil))

(def mk-appenv (cfgs window)
  `(:read ,(mk-appenv-read cfgs window)
    :write ,(mk-appenv-write)))

(mk-appenv 3 5)

(-> (mk-appenv 3 5)
    (dig :write ))
