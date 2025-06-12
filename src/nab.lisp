;;;; nab.lisp

(in-package #:nab)
(cl-syntax:use-syntax :clump)

(require :sdl3-raw)

(def main ()
  (= (appenv (mk-appenv))

     (run-game appenv)

     (sdl3-raw:sdl-destroy-renderer (dig appenv :read :graphics :ren))
     (sdl3-raw:sdl-destroy-window (dig appenv :read :graphics :win))))

(def event-quit? (event) (mem event '(sdl3-raw:sdl-event-quit 525 528 769)))

(def run-game (appenv)
  (cffi:with-foreign-object (event '(:union sdl3-raw:sdl-event))
    (loop with running = t
          while running do
            (progn
              ;; Handle events
              (loop while (sdl3-raw:sdl-poll-event event) do
                (= ((etype (cffi:mem-ref event :uint32)))
                   (progn
                     (format t "Event type: ~A~%" etype)
                     (when (event-quit? etype) (setf running nil)))))

              ;; Draw
              (= ((now (/ (sdl3-raw:sdl-get-ticks) 1000))
                  (red (calc-color now 0.0))
                  (green (calc-color now 2.0))
                  (blue (calc-color now 4.0)))

                 (progn
                   (sdl3-raw:sdl-set-render-draw-color
                    (dig appenv :read :graphics :ren) red green blue 255)

                   (sdl3-raw:sdl-render-clear (dig appenv :read :graphics :ren))
                   (sdl3-raw:sdl-render-present (dig appenv :read :graphics :ren))))))))

;; game -----------------------------------------------
