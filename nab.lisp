;;;; nab.lisp

(in-package #:nab)
(cl-syntax:use-syntax :clump)

(def mk-window (cfgs) 5)
(def mk-app-env () nil)

(def main ()
  (= ((cfgs (mk-configs))
      (window (mk-window cfgs)))
     (pr window)))

(main)
