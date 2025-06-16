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
               :cl-mop
               )
  :components ((:file "package")
               (:file "scratch")
               (:file "sdl")
               (:file "events")
               (:file "util")
               (:file "game")
               (:file "env")
               (:file "configs")
               (:file "file-cache")
               (:file "window")
               (:file "time")
               (:file "nab")))
