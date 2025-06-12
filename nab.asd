;;;; nab.asd

(asdf:defsystem #:nab
  :description "Describe nab here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :pathname "src"
  :depends-on (:clump
               :cl-syntax
               :cffi
               :sdl3-raw
               :bordeaux-threads
               :trivial-channels
               )
  :components ((:file "package")
               (:file "scratch")
               (:file "util")
               (:file "configs")
               (:file "file-cache")
               (:file "window")
               (:file "appenv")
               (:file "nab")))
