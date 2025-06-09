;;;; nab.lisp

(in-package #:nab)
(cl-syntax:use-syntax :clump)

(require :sdl3-raw)

(def mk-appenv () nil)

(def main ()
  (= ((cfgs (mk-configs))
      (window (mk-window cfgs))
      (appenv (mk-appenv)))

     (run-game appenv window)

     (sdl3-raw:sdl-destroy-renderer (dig window :graphics :ren))
     (sdl3-raw:sdl-destroy-window (dig window :graphics :win))))

(def run-game (appenv window)
  (cffi:with-foreign-object (event '(:union sdl3-raw:sdl-event))
    (loop with running = t
          while running do
            (progn
              
              ;; Handle events
              (loop while (sdl3-raw:sdl-poll-event event) do
                (= ((etype (cffi:mem-ref event :uint32)))
                  (progn
                    (format t "Event type: ~A~%" etype)
                    (when (equal etype sdl3-raw:sdl-event-quit)
                      (setf running nil)))))
              
              ;; Draw
              (= ((now (/ (sdl3-raw:sdl-get-ticks) 1000))
                  (red (calc-color now 0.0))
                  (green (calc-color now 2.0))
                  (blue (calc-color now 4.0)))
                
                 (progn
                   (sdl3-raw:sdl-set-render-draw-color
                    (dig window :graphics :ren) red green blue 255)
                   
                   (sdl3-raw:sdl-render-clear (dig window :graphics :ren))
                   (sdl3-raw:sdl-render-present (dig window :graphics :ren))))))))
  
