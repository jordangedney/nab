;;;; package.lisp

(defpackage #:nab
  (:use #:clump #:cl-syntax)
  (:local-nicknames (:s :sdl3-raw)
                    (:c :cffi)))
