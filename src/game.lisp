;;;; game.lisp

(in-package #:nab)
(cl-syntax:use-syntax :clump)

;; game -----------------------------------------------

(def mk-player ()
  '(:pos (0 0)
    :vel (0 0)
    :dir :left
    :sprite nil))

(def mk-world ()
  '(:player nil
    :level nil
    :ui nil
    ))

(def mk-game ()
  `(:mode :main-menu
    :prev-mode :main-menu
    :world ,(mk-world)
    ;; menu is in here too.. but its already in the (app)env?
    :time ,(mk-time)))
