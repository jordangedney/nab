;;;; nab.asd

(asdf:defsystem #:nab
  :description "Describe nab here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (:clump :cl-syntax :sdl2)
  :components ((:file "package")
               (:file "util")
               (:file "configs")
               (:file "window")
               (:file "nab")))
