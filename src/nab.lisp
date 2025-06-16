;;;; nab.lisp

(in-package #:nab)
(cl-syntax:use-syntax :clump)

(require :sdl3-raw)

(def main ()
  (= ((env (mk-env)))
     (run env)
     (sdl3-raw:sdl-destroy-renderer (dig env :read :graphics :ren))
     (sdl3-raw:sdl-destroy-window (dig env :read :graphics :win))))

(def draw-game (env)
  (= ((now (/ (sdl3-raw:sdl-get-ticks) 1000))
      (red (calc-color now 0.0))
      (green (calc-color now 2.0))
      (blue (calc-color now 4.0)))

     (progn
       (sdl3-raw:sdl-set-render-draw-color
        (dig env :read :graphics :ren) red green blue 255)

       (sdl3-raw:sdl-render-clear (dig env :read :graphics :ren))
       (sdl3-raw:sdl-render-present (dig env :read :graphics :ren)))))

(def clear-msgs (env) (dig= env nil :write :messages))

(def get-input-events (env) env) ; TODO updateWindow

(def update-window (env) ; TODO better name
  )

(def update-env (env)
  (if (out-of-time? env) env
      (-> env
          clear-msgs
          process-sdl-events
          update-window
          update-time
          update-env)))

(def perform-garbage-collection () (sb-ext:gc :full t))

(def run (env)
  (set *nab--running* t)
  (loop while *nab--running* do
    (= ((new-env (-> env update-game update-lerp)))
       (when (dig new-env :read :closed) (set *running* nil))
       (perform-garbage-collection)
       (draw-game new-env)
       (set env new-env))))

(def update-game (env) env)

;; (sdl3-raw:sdl-get-window-flags (dig (mk-env) :read :graphics :win))

;; (car sdl--prev-sdl-events)
;; (car (sdl--prev-sdl-events))
;; (get-sdl-events)
;; (main)
;; (set *nab--running* nil)



;; (def run-game (env)
;;   (cffi:with-foreign-object (event '(:union sdl3-raw:sdl-event))
;;     (loop with running = t
;;           while running do
;;             (progn
;;               ;; Handle events
;;               (loop while (sdl3-raw:sdl-poll-event event) do
;;                 (= ((etype (cffi:mem-ref event :uint32)))
;;                    (progn
;;                      (format t "Event type: ~A~%" etype)
;;                      (when (event-quit? etype) (setf running nil)))))))))
