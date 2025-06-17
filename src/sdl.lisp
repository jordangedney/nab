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

(defvar sdl--prev-sdl-events nil)
(def get-sdl-events ()
  (= ((r (poll-sdl-events)))
     (set sdl--prev-sdl-events
          (-> (cons r sdl--prev-sdl-events) (take 5)))
     r))

(def event-mapping ()
  '(
    (s:sdl-event-keyboard-added   s:sdl-keyboard-device-event)
    (s:sdl-event-keyboard-removed s:sdl-keyboard-device-event)
    (s:sdl-event-key-down         s:sdl-keyboard-event)
    (s:sdl-event-key-up           s:sdl-keyboard-event)
    ))

;; Currently unparsed events:
;; CommonEvent DisplayEvent WindowEvent KeyboardDeviceEvent TextEditingEvent
;; TextEditingCandidatesEvent TextInputEvent MouseDeviceEvent MouseMotionEvent
;; MouseWheelEvent JoyAxisEvent JoyBallEvent JoyHatEvent
;; JoyButtonEvent JoyDeviceEvent JoyBatteryEvent GamepadAxisEvent
;; GamepadButtonEvent GamepadDeviceEvent GamepadTouchpadEvent GamepadSensorEvent
;; AudioDeviceEvent CameraDeviceEvent RenderEvent TouchFingerEvent
;; PenProximityEvent PenMotionEvent PenTouchEvent PenButtonEvent PenAxisEvent
;; DropEvent ClipboardEvent SensorEvent QuitEvent UserEvent
;; 
;; sdl-event-ptr -> (sdl-event-key-down "A" 0 T nil), or w/e
;; should return all events, which is a firehose so filter it down elsewhere
(def parse-event (event-ptr)
  (= ((event-type (c:mem-ref event-ptr 's:sdl-event-type))) ; sdl-event-key-up, etc
     (cons event-type
           (case event-type
             s:sdl-event-key-down (get-keyboard event-ptr)
             s:sdl-event-key-up (get-keyboard event-ptr)
             s:sdl-event-mouse-button-down (get-mouse-button event-ptr)
             s:sdl-event-mouse-button-up (get-mouse-button event-ptr)
             t nil))))

(def parse-event (event-ptr)
  (= ((event-type (c:mem-ref event-ptr 's:sdl-event-type))) ; sdl-event-key-up, etc
     (get-event-type-data
      event-ptr
      event-type
      (c:foreign-slot-names
       (get-hash event-type *sdl--event-type-to-struct-table*)))))

(mac get-event-type-data (ptr event-type accessors)
  `(c:with-foreign-slots
       (,accessors (c:mem-aref ,ptr ',event-type) (:struct ,event-type))
     (list ,@accessors)))

(def parse-event (event-ptr)
  (= ((event-type (c:mem-ref event-ptr 's:sdl-event-type)) ; sdl-event-key-up, etc
      (event-ind (c:mem-ref event-ptr :uint32))
      (et (gethash event-ind *sdl--event-type-to-struct-table*
                's:sdl-common-event))
      (slots (c:foreign-slot-names
              (gethash event-ind *sdl--event-type-to-struct-table*
                       's:sdl-common-event))))
     (eval 
     `(c:with-foreign-slots
          (,slots
           (c:mem-aref ,event-ptr ',et) (:struct ,et))
        (list ,@slots))))
  )

(def parse-event (event-ptr)
  (= ((event-type (c:mem-ref event-ptr 's:sdl-event-type)) ; sdl-event-key-up, etc
      (event-ind (c:mem-ref event-ptr :uint32))
      (et (gethash event-ind *sdl--event-type-to-struct-table*
                's:sdl-common-event))
      (slots (c:foreign-slot-names
              (gethash event-ind *sdl--event-type-to-struct-table*
                       's:sdl-common-event))))
     (loop for slot in slots
           collect (cons slot
                         (c:foreign-slot-value event-ptr
                                               `(:struct ,et) slot)))))

(main)
(set *nab--running* nil)

(set bar (poll-sdl-events))
(pr bar)

(print bar)
(defun parse-event (event-ptr)
  (let* ((event-type (c:mem-ref event-ptr 's:sdl-event-type))
         (struct-type (gethash event-type *sdl--event-type-to-struct-table*
                               's:sdl-common-event)))
    (loop for slot in (c:foreign-slot-names struct-type)
          collect (cons slot (c:foreign-slot-value event-ptr `(:struct ,struct-type) slot)))))


(def get-mouse-button (event-ptr) ; MouseButtonEvent
  (get-event-type-data
   event-ptr s:sdl-mouse-button-event
   (s:button s:down s:clicks s:padding s:x s:y)))

(def get-keyboard (event-ptr) ; KeyboardEvent
  (c:with-foreign-slots ((s:key s::mod s:down s:repeat)
                         (c:mem-aref event-ptr 's:sdl-keyboard-event)
                         (:struct s:sdl-keyboard-event))
    (list (s:sdl-get-key-name s:key) s::mod s:down s:repeat)))


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
