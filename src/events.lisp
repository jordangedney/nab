;;;; events.lisp

(in-package #:nab)
(cl-syntax:use-syntax :clump)

(def process-sdl-events (env)
  (dig= env (sdl-events->game-events (get-sdl-events)) :write :messages))
