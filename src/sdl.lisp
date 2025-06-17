;;;; sdl.lisp

(in-package #:nab)
(cl-syntax:use-syntax :clump)

(def event-quit? (event) (mem event '(s:sdl-event-quit 525 528 769)))

(def get-sdl-error (header)
  (format t "~a: ~a~%" header
          (c:foreign-string-to-lisp (s:sdl-get-error))))

;; sdl-events ------------------------------------------------------------------

(def poll-sdl-events (&optional (parse-fn #'parse-event))
  (c:with-foreign-object (event 's:sdl-event)
    (loop while (s:sdl-poll-event event)
          ;; you can't just collect events, you've got to convert them to lisp
          ;; here (parse-fn) before you can access them.
          collect (call parse-fn event))))

(def parse-event (event-ptr)
  (= ((event-type-ind (c:mem-ref event-ptr :uint32))
      (struct-type (gethash event-type-ind
                            *sdl--event-type-to-struct-table*
                            's:sdl-common-event))
      (slots (c:foreign-slot-names struct-type)))
     (loop for s in slots
           collect (cons
                    s (c:foreign-slot-value event-ptr
                                            `(:struct ,struct-type) s)))))

(defvar sdl--prev-sdl-events nil)
(def get-sdl-events ()
  (= ((r (poll-sdl-events)))
     (set sdl--prev-sdl-events
          (-> (cons r sdl--prev-sdl-events) (take 5)))
     r))

;; Note: GPT generated. Don't trust!
;; This mapping must exist as the info isn't in the header code, just the comment
(gethash s:sdl-event-keyboard-added *sdl--event-type-to-struct-table*)
(defparameter *sdl--event-type-to-struct-table*
  (listtab 
  `((,s:sdl-event-keyboard-added              s:sdl-keyboard-device-event)
    (,s:sdl-event-keyboard-removed            s:sdl-keyboard-device-event)
    (,s:sdl-event-key-down                    s:sdl-keyboard-event)
    (,s:sdl-event-key-up                      s:sdl-keyboard-event)
    (,s:sdl-event-text-editing                s:sdl-text-editing-event)
    (,s:sdl-event-text-input                  s:sdl-text-input-event)
    (,s:sdl-event-text-editing-candidates     s:sdl-text-editing-candidates-event)
    (,s:sdl-event-mouse-motion                s:sdl-mouse-motion-event)
    (,s:sdl-event-mouse-button-down           s:sdl-mouse-button-event)
    (,s:sdl-event-mouse-button-up             s:sdl-mouse-button-event)
    (,s:sdl-event-mouse-wheel                 s:sdl-mouse-wheel-event)
    (,s:sdl-event-mouse-added                 s:sdl-mouse-device-event)
    (,s:sdl-event-mouse-removed               s:sdl-mouse-device-event)
    (,s:sdl-event-window-shown                s:sdl-window-event)
    (,s:sdl-event-window-hidden               s:sdl-window-event)
    (,s:sdl-event-window-exposed              s:sdl-window-event)
    (,s:sdl-event-window-moved                s:sdl-window-event)
    (,s:sdl-event-window-resized              s:sdl-window-event)
    (,s:sdl-event-window-focus-gained         s:sdl-window-event)
    (,s:sdl-event-window-focus-lost           s:sdl-window-event)
    (,s:sdl-event-window-close-requested      s:sdl-window-event)
    (,s:sdl-event-display-added               s:sdl-display-event)
    (,s:sdl-event-display-removed             s:sdl-display-event)
    (,s:sdl-event-joystick-axis-motion        s:sdl-joy-axis-event)
    (,s:sdl-event-joystick-ball-motion        s:sdl-joy-ball-event)
    (,s:sdl-event-joystick-hat-motion         s:sdl-joy-hat-event)
    (,s:sdl-event-joystick-button-down        s:sdl-joy-button-event)
    (,s:sdl-event-joystick-button-up          s:sdl-joy-button-event)
    (,s:sdl-event-joystick-added              s:sdl-joy-device-event)
    (,s:sdl-event-joystick-removed            s:sdl-joy-device-event)
    (,s:sdl-event-joystick-battery-updated    s:sdl-joy-battery-event)
    (,s:sdl-event-gamepad-axis-motion         s:sdl-gamepad-axis-event)
    (,s:sdl-event-gamepad-button-down         s:sdl-gamepad-button-event)
    (,s:sdl-event-gamepad-button-up           s:sdl-gamepad-button-event)
    (,s:sdl-event-gamepad-added               s:sdl-gamepad-device-event)
    (,s:sdl-event-gamepad-removed             s:sdl-gamepad-device-event)
    (,s:sdl-event-gamepad-remapped            s:sdl-gamepad-device-event)
    (,s:sdl-event-gamepad-touchpad-down       s:sdl-gamepad-touchpad-event)
    (,s:sdl-event-gamepad-touchpad-up         s:sdl-gamepad-touchpad-event)
    (,s:sdl-event-gamepad-touchpad-motion     s:sdl-gamepad-touchpad-event)
    (,s:sdl-event-gamepad-sensor-update       s:sdl-gamepad-sensor-event)
    (,s:sdl-event-finger-down                 s:sdl-touch-finger-event)
    (,s:sdl-event-finger-up                   s:sdl-touch-finger-event)
    (,s:sdl-event-finger-motion               s:sdl-touch-finger-event)
    (,s:sdl-event-finger-canceled             s:sdl-touch-finger-event)
    (,s:sdl-event-drop-file                   s:sdl-drop-event)
    (,s:sdl-event-drop-text                   s:sdl-drop-event)
    (,s:sdl-event-drop-begin                  s:sdl-drop-event)
    (,s:sdl-event-drop-complete               s:sdl-drop-event)
    (,s:sdl-event-drop-position               s:sdl-drop-event)
    (,s:sdl-event-clipboard-update            s:sdl-clipboard-event)
    (,s:sdl-event-sensor-update               s:sdl-sensor-event)
    (,s:sdl-event-audio-device-added          s:sdl-audio-device-event)
    (,s:sdl-event-audio-device-removed        s:sdl-audio-device-event)
    (,s:sdl-event-audio-device-format-changed s:sdl-audio-device-event)
    (,s:sdl-event-camera-device-added         s:sdl-camera-device-event)
    (,s:sdl-event-camera-device-removed       s:sdl-camera-device-event)
    (,s:sdl-event-camera-device-approved      s:sdl-camera-device-event)
    (,s:sdl-event-camera-device-denied        s:sdl-camera-device-event)
    (,s:sdl-event-render-targets-reset        s:sdl-render-event)
    (,s:sdl-event-render-device-reset         s:sdl-render-event)
    (,s:sdl-event-render-device-lost          s:sdl-render-event)
    (,s:sdl-event-pen-down                    s:sdl-pen-touch-event)
    (,s:sdl-event-pen-up                      s:sdl-pen-touch-event)
    (,s:sdl-event-pen-motion                  s:sdl-pen-motion-event)
    (,s:sdl-event-pen-axis                    s:sdl-pen-axis-event)
    (,s:sdl-event-pen-proximity-in            s:sdl-pen-proximity-event)
    (,s:sdl-event-pen-proximity-out           s:sdl-pen-proximity-event)
    (,s:sdl-event-pen-button-down             s:sdl-pen-button-event)
    (,s:sdl-event-pen-button-up               s:sdl-pen-button-event)
    (,s:sdl-event-quit                        s:sdl-quit-event))))
