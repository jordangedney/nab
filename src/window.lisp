;;;; window.lisp

(in-package #:nab)
(cl-syntax:use-syntax :clump)

(require :cffi)
(require :sdl3-raw)

(def configure-window (cfgs win)
  ;; set fullscreen
  )

(def configure-renderer (cfgs ren)
  ;; set vsync
  ;; set target texture
  ;; set standard def / high def
  ;; set blend mode (alpha)
  )

(def mk-graphics (cfgs win ren)
  `(:graphics (:win ,win
               :ren ,ren 
               :fonts nil ; TODO
               :cursors nil ; TODO
               :draw-calls-ref nil ; TODO
               :camera-pos (0 0) ; TODO
               :camera-offset (0 0) ; TODO
               :camera-space :world-space ; TODO
               :lerp 0 ; TODO
               :clip-rect nil ; TODO
               :texture-manager nil))) ; TODO

;; TODO
(def mk-input-state (cfgs)
  '(:input-state (:inactive nil
                  :key-state-pressed  nil
                  :key-state-released  nil
                  :key-hold-state  nil
                  :key-hold-prev-state  nil
                  :mouse-state-pressed  nil
                  :mouse-state-released  nil
                  :mouse-hold-state  nil
                  :mouse-hold-prev-state  nil
                  :mouse-wheel-event-data  nil
                  :mouse-pos nil ; TODO
                  :mouse-world-pos nil ; TODO
                  :mouse-moved nil
                  :gamepad-manager nil ; TODO
                  :text-buffer ""
                  :last-used-input-type :mouse-keyboard
                  :last-gamepad-type :xbox-360
                  :pressed-input-raw-data nil ; TODO
                  :input-alias-raw-data-map nil))) ; TODO

(def mk-window (cfgs)
  ;; TODO delete?:
  (sb-posix:setenv "LANG" "en_US.UTF-8" 1)

  (sdl3-raw:sdl-init sdl3-raw:sdl-init-video)
  (sdl3-raw:sdl-init sdl3-raw:sdl-init-events)
  (sdl3-raw:sdl-init sdl3-raw:sdl-init-gamepad)

  (cffi:with-foreign-string (title (dig cfgs :render :window-title))
    (cffi:with-foreign-objects ((win :pointer) (ren :pointer))
      (if (sdl3-raw:sdl-create-window-and-renderer
           title
           (dig cfgs :render :width)
           (dig cfgs :render :height)
           sdl3-raw:sdl-window-opengl ; use opengl
           win
           ren)

          (= ((window (cffi:mem-ref win :pointer))
              (renderer (cffi:mem-ref ren :pointer)))

             (configure-window cfgs window)
             (configure-renderer cfgs renderer)

             (combine-plists
              (mk-graphics cfgs window renderer)
              (mk-input-state cfgs)
              '(:closed nil)))))))
