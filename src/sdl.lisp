;;;; sdl.lisp

(in-package #:nab)
(cl-syntax:use-syntax :clump)

(def event-quit? (event) (mem event '(s:sdl-event-quit 525 528 769)))

(def get-sdl-error (header)
  (format t "~a: ~a~%" header
          (c:foreign-string-to-lisp (s:sdl-get-error))))

;; sdl-events ------------------------------------------------------------------

;; (defvar x
;;   (c:with-foreign-object (event '(:union s:sdl-event))
;;     (if (s:sdl-poll-event event)
;;         (c:mem-ref event 's:sdl-common-event))))
;; 
;; (defvar z 
;;   (c:with-foreign-object (event 's:sdl-event)
;;     (if (s:sdl-poll-event event)
;;         event)))
;; 
;; (defvar e 
;;   (c:with-foreign-object (event '(:union s:sdl-event))
;;     (if (s:sdl-poll-event event)
;;         event)))

;; (c:foreign-enum-value 's:sdl-event-type 's:sdl-event-quit) => 256
;; (c:foreign-enum-keyword-list 's:sdl-event-type)

;; (c:foreign-enum-keyword
;;  's:sdl-event-type
;;  (c:mem-ref z :uint32))
;; 
;; (prn z)
;; (pr (eq x e))
;; (defvar evs (poll-sdl-events))
;; (pr evs)
;; 
;; (set evs (poll-sdl-events-raw))

;; (def get-event-type (event)
;;   (c:foreign-enum-keyword 's:sdl-event-type
;;                              (c:mem-ref event :uint32)))

;; (def get-event-type (event) (-> event (c:mem-ref :uint32) int->sdl-event))

;; (def poll-sdl-event ()
;;   (c:with-foreign-object (event 's:sdl-event)
;;     (if (s:sdl-poll-event event)
;;         (c:mem-ref event 's:sdl-event-type)
;;         nil)))

(def poll-sdl-events ()
  (c:with-foreign-object (event 's:sdl-event)
    (loop while (s:sdl-poll-event event)
          collect (c:mem-ref event 's:sdl-event-type))))

(def poll-sdl-events ()
  (c:with-foreign-object (event 's:sdl-event)
    (loop while (s:sdl-poll-event event)
          collect (parse-event event))))

(def get-timestamp (event)
 (c:foreign-slot-value
  (c:mem-aref event 's:sdl-common-event)
  '(:struct s:sdl-common-event)
  's:timestamp))

(def get-keydown (event)
 (c:foreign-slot-value
  (c:mem-aref event 's:sdl-keyboard-event)
  '(:struct s:sdl-keyboard-event)
  's:key))

(str s:sdl-scancode-a)

(code-char 97)

(s:sdl-get-key-from-scancode )
(def get-keydown (event)
  (c:with-foreign-slots ((s:scancode
                          s:key
                          s::mod
                          s:down
                          s:repeat)
                         (c:mem-aref event 's:sdl-keyboard-event)
                         (:struct s:sdl-keyboard-event))
    (list (code-char s:key) s::mod s:down s:repeat)))

(def parse-event (event)
  (case (c:mem-ref event 's:sdl-event-type)
    
    s:sdl-event-key-down `(:down ,(get-keydown event))
    t nil))

    ;; s:sdl-event-poll-sentinel `(:sen ,(get-timestamp event))
    ;; t (c:mem-ref event 's:sdl-event-type)))

;; (parse-event (car test))
;; 
(main)
(set *nab--running* nil)
; ;; ;; (poll-sdl-event)
;; ;; (defvar test nil)
(set bar (poll-sdl-events))
;;      
;; (pr bar)
;; (pr (map [c:mem-ref _ 's:sdl-event-type] test ))
;; (set ku (last test))
;; 
;; (c:mem-ref ku 's:sdl-keyboard-event)
;; 
;; (prn ku)

(def int->keyword (i) (c:foreign-enum-keyword 's:sdl-event-type i))
(def event-pointer->int (e) (c:mem-ref e :uint32))
(def event-pointer->keyword (e) (-> e event-pointer->int int->keyword))
;; (def poll-sdl-events () (map #'event-pointer->keyword (poll-sdl-events-raw)))

;; (def poll-sdl-events ()
;;   (c:with-foreign-object (event '(:union s:sdl-event))
;;     (loop while (s:sdl-poll-event event)
;;           collect (c:mem-ref event :uint32))))

;; (def get-sdl-events () (map #'int->sdl-event (poll-sdl-events)))
(defvar sdl--prev-sdl-events nil)
(def get-sdl-events ()
  (= ((r (map #'int->sdl-event (poll-sdl-events))))
     (set sdl--prev-sdl-events
          (-> (cons r sdl--prev-sdl-events) (take 5)))
     r))

;; TODO This probably should be done with autowrap,
;;      but I can't figure it out
(def int->sdl-event (n) (gethash n -sdl-event-mapping))
(set -sdl-event-mapping 
     (listtab (map #'reverse
                   `((:first 0)
                     (:quit 256)
                     (:terminating 257)
                     (:low-memory 258)
                     (:will-enter-background 259)
                     (:did-enter-background 260)
                     (:will-enter-foreground 261)
                     (:did-enter-foreground 262)
                     (:locale-changed 263)
                     (:system-theme-changed 264)
                     (:display-orientation 337)
                     (:display-added 338)
                     (:display-removed 339)
                     (:display-moved 340)
                     (:display-desktop-mode-changed 341)
                     (:display-current-mode-changed 342)
                     (:display-content-scale-changed 343)
                     (:display-first 337)
                     (:display-last 343)
                     (:window-shown 514)
                     (:window-hidden 515)
                     (:window-exposed 516)
                     (:window-moved 517)
                     (:window-resized 518)
                     (:window-pixel-size-changed 519)
                     (:window-metal-view-resized 520)
                     (:window-minimized 521)
                     (:window-maximized 522)
                     (:window-restored 523)
                     (:window-mouse-enter 524)
                     (:window-mouse-leave 525)
                     (:window-focus-gained 526)
                     (:window-focus-lost 527)
                     (:window-close-requested 528)
                     (:window-hit-test 529)
                     (:window-iccprof-changed 530)
                     (:window-display-changed 531)
                     (:window-display-scale-changed 532)
                     (:window-safe-area-changed 533)
                     (:window-occluded 534)
                     (:window-enter-fullscreen 535)
                     (:window-leave-fullscreen 536)
                     (:window-destroyed 537)
                     (:window-hdr-state-changed 538)
                     (:window-first 514)
                     (:key-up 769)
                     (:text-editing 770)
                     (:text-input 771)
                     (:keymap-changed 772)
                     (:keyboard-added 773)
                     (:keyboard-removed 774)
                     (:text-editing-candidates 775)
                     (:mouse-motion 1024)
                     (:mouse-button-down 1025)
                     (:mouse-button-up 1026)
                     (:mouse-wheel 1027)
                     (:mouse-added 1028)
                     (:mouse-removed 1029)
                     (:joystick-axis-motion 1536)
                     (:joystick-ball-motion 1537)
                     (:joystick-hat-motion 1538)
                     (:joystick-button-down 1539)
                     (:joystick-button-up 1540)
                     (:joystick-added 1541)
                     (:joystick-removed 1542)
                     (:joystick-battery-updated 1543)
                     (:joystick-update-complete 1544)
                     (:gamepad-axis-motion 1616)
                     (:gamepad-button-down 1617)
                     (:gamepad-button-up 1618)
                     (:gamepad-added 1619)
                     (:gamepad-removed 1620)
                     (:gamepad-remapped 1621)
                     (:gamepad-touchpad-down 1622)
                     (:gamepad-touchpad-motion 1623)
                     (:gamepad-touchpad-up 1624)
                     (:gamepad-sensor-update 1625)
                     (:gamepad-update-complete 1626)
                     (:gamepad-steam-handle-updated 1627)
                     (:finger-down 1792)
                     (:finger-up 1793)
                     (:finger-motion 1794)
                     (:finger-canceled 1795)
                     (:clipboard-update 2304)
                     (:drop-file 4096)
                     (:drop-text 4097)
                     (:drop-begin 4098)
                     (:drop-complete 4099)
                     (:drop-position 4100)
                     (:audio-device-added 4352)
                     (:audio-device-removed 4353)
                     (:audio-device-format-changed 4354)
                     (:sensor-update 4608)
                     (:pen-proximity-in 4864)
                     (:pen-proximity-out 4865)
                     (:pen-down 4866)
                     (:pen-up 4867)
                     (:pen-button-down 4868)
                     (:pen-button-up 4869)
                     (:pen-motion 4870)
                     (:pen-axis 4871)
                     (:camera-device-added 5120)
                     (:camera-device-removed 5121)
                     (:camera-device-approved 5122)
                     (:camera-device-denied 5123)
                     (:render-targets-reset 8192)
                     (:render-device-reset 8193)
                     (:render-device-lost 8194)
                     (:private0 16384)
                     (:private1 16385)
                     (:private2 16386)
                     (:private3 16387)
                     (:poll-sentinel 32512)
                     (:user 32768)
                     (:last 65535)
                     (:enum-padding 2147483647)))))

(defparameter *event-type-to-accessor*
  '((:controlleraxismotion . :caxis)
    (:controllerbuttondown . :cbutton)
    (:controllerbuttonup . :cbutton)
    (:controllerdeviceadded . :cdevice)
    (:controllerdeviceremapped . :cdevice)
    (:controllerdeviceremoved . :cdevice)
    (:dollargesture . :dgesture)
    (:dropfile . :drop)
    (:fingermotion . :tfinger)
    (:fingerdown . :tfinger)
    (:fingerup . :tfinger)
    (:joyaxismotion . :jaxis)
    (:joyballmotion . :jball)
    (:joybuttondown . :jbutton)
    (:joybuttonup . :jbutton)
    (:joydeviceadded . :jdevice)
    (:joydeviceremoved . :jdevice)
    (:joyhatmotion . :jhat)
    (:keydown . :key)
    (:keyup . :key)
    (:mousebuttondown . :button)
    (:mousebuttonup . :button)
    (:mousemotion . :motion)
    (:mousewheel . :wheel)
    (:multigesture . :mgesture)
    (:syswmevent . :syswm)
    (:textediting . :edit)
    (:textinput . :text)
    (:userevent . :user)
    (:lisp-message . :user)
    (:windowevent . :window)))

;; ---------------------------------------------

;; data Event
;;   = WindowEvent
;;     { eventType :: !Word32
;;     , eventTimestamp :: !Word32
;;     , windowEventWindowID :: !Word32
;;     , windowEventEvent :: !Word8
;;     , windowEventData1 :: !Int32
;;     , windowEventData2 :: !Int32
;;     }
;;   | KeyboardEvent
;;     { eventType :: !Word32
;;     , eventTimestamp :: !Word32
;;     , keyboardEventWindowID :: !Word32
;;     , keyboardEventState :: !Word8
;;     }
;;   | TextEditingEvent
;;     { eventType :: !Word32
;;     , eventTimestamp :: !Word32
;;     , textEditingEventWindowID :: !Word32
;;     , textEditingEventText :: ![CChar]
;;     , textEditingEventStart :: !Int32
;;     , textEditingEventLength :: !Int32
;;     }
;;   | TextInputEvent
;;     { eventType :: !Word32
;;     , eventTimestamp :: !Word32
;;     , textInputEventWindowID :: !Word32
;;     , textInputEventText :: ![CChar]
;;     }
;;   | KeymapChangedEvent
;;     { eventType :: !Word32
;;     , eventTimestamp :: !Word32
;;     }
;;   | MouseMotionEvent
;;     { eventType :: !Word32
;;     , eventTimestamp :: !Word32
;;     , mouseMotionEventWindowID :: !Word32
;;     , mouseMotionEventWhich :: !Word32
;;     , mouseMotionEventState :: !Word32
;;     , mouseMotionEventX :: !Int32
;;     , mouseMotionEventY :: !Int32
;;     , mouseMotionEventXRel :: !Int32
;;     , mouseMotionEventYRel :: !Int32
;;     }
;;   | MouseButtonEvent
;;     { eventType :: !Word32
;;     , eventTimestamp :: !Word32
;;     , mouseButtonEventWindowID :: !Word32
;;     , mouseButtonEventWhich :: !Word32
;;     , mouseButtonEventButton :: !Word8
;;     , mouseButtonEventState :: !Word8
;;     , mouseButtonEventClicks :: !Word8
;;     , mouseButtonEventX :: !Int32
;;     , mouseButtonEventY :: !Int32
;;     }
;;   | MouseWheelEvent
;;     { eventType :: !Word32
;;     , eventTimestamp :: !Word32
;;     , mouseWheelEventWindowID :: !Word32
;;     , mouseWheelEventWhich :: !Word32
;;     , mouseWheelEventX :: !Int32
;;     , mouseWheelEventY :: !Int32
;;     , mouseWheelEventDirection :: !Word32
;;     }
;;   | JoyAxisEvent
;;     { eventType :: !Word32
;;     , eventTimestamp :: !Word32
;;     , joyAxisEventWhich :: !JoystickID
;;     , joyAxisEventAxis :: !Word8
;;     , joyAxisEventValue :: !Int16
;;     }
;;   | JoyBallEvent
;;     { eventType :: !Word32
;;     , eventTimestamp :: !Word32
;;     , joyBallEventWhich :: !JoystickID
;;     , joyBallEventBall :: !Word8
;;     , joyBallEventXRel :: !Int16
;;     , joyBallEventYRel :: !Int16
;;     }
;;   | JoyHatEvent
;;     { eventType :: !Word32
;;     , eventTimestamp :: !Word32
;;     , joyHatEventWhich :: !JoystickID
;;     , joyHatEventHat :: !Word8
;;     , joyHatEventValue :: !Word8
;;     }
;;   | JoyButtonEvent
;;     { eventType :: !Word32
;;     , eventTimestamp :: !Word32
;;     , joyButtonEventWhich :: !JoystickID
;;     , joyButtonEventButton :: !Word8
;;     , joyButtonEventState :: !Word8
;;     }
;;   | JoyDeviceEvent
;;     { eventType :: !Word32
;;     , eventTimestamp :: !Word32
;;     , joyDeviceEventWhich :: !Int32
;;     }
;;   | ControllerAxisEvent
;;     { eventType :: !Word32
;;     , eventTimestamp :: !Word32
;;     , controllerAxisEventWhich :: !JoystickID
;;     , controllerAxisEventAxis :: !Word8
;;     , controllerAxisEventValue :: !Int16
;;     }
;;   | ControllerButtonEvent
;;     { eventType :: !Word32
;;     , eventTimestamp :: !Word32
;;     , controllerButtonEventWhich :: !JoystickID
;;     , controllerButtonEventButton :: !Word8
;;     , controllerButtonEventState :: !Word8
;;     }
;;   | ControllerDeviceEvent
;;     { eventType :: !Word32
;;     , eventTimestamp :: !Word32
;;     , controllerDeviceEventWhich :: !Int32
;;     }
;;   | AudioDeviceEvent
;;     { eventType :: !Word32
;;     , eventTimestamp :: !Word32
;;     , audioDeviceEventWhich :: !Word32
;;     , audioDeviceEventIsCapture :: !Word8
;;     }
;;   | QuitEvent
;;     { eventType :: !Word32
;;     , eventTimestamp :: !Word32
;;     }
;;   | UserEvent
;;     { eventType :: !Word32
;;     , eventTimestamp :: !Word32
;;     , userEventWindowID :: !Word32
;;     , userEventCode :: !Int32
;;     , userEventData1 :: !(Ptr ())
;;     , userEventData2 :: !(Ptr ())
;;     }
;;   | SysWMEvent
;;     { eventType :: !Word32
;;     , eventTimestamp :: !Word32
;;     , sysWMEventMsg :: !SysWMmsg
;;     }
;;   | TouchFingerEvent
;;     { eventType :: !Word32
;;     , eventTimestamp :: !Word32
;;     , touchFingerEventTouchID :: !TouchID
;;     , touchFingerEventFingerID :: !FingerID
;;     , touchFingerEventX :: !CFloat
;;     , touchFingerEventY :: !CFloat
;;     , touchFingerEventDX :: !CFloat
;;     , touchFingerEventDY :: !CFloat
;;     , touchFingerEventPressure :: !CFloat
;;     }
;;   | MultiGestureEvent
;;     { eventType :: !Word32
;;     , eventTimestamp :: !Word32
;;     , multiGestureEventTouchID :: !TouchID
;;     , multiGestureEventDTheta :: !CFloat
;;     , multiGestureEventDDist :: !CFloat
;;     , multiGestureEventX :: !CFloat
;;     , multiGestureEventY :: !CFloat
;;     , multiGestureEventNumFingers :: !Word16
;;     }
;;   | DollarGestureEvent
;;     { eventType :: !Word32
;;     , eventTimestamp :: !Word32
;;     , dollarGestureEventTouchID :: !TouchID
;;     , dollarGestureEventGestureID :: !GestureID
;;     , dollarGestureEventNumFingers :: !Word32
;;     , dollarGestureEventError :: !CFloat
;;     , dollarGestureEventX :: !CFloat
;;     , dollarGestureEventY :: !CFloat
;;     }
;;   | DropEvent
;;     { eventType :: !Word32
;;     , eventTimestamp :: !Word32
;;     , dropEventFile :: !CString
;;     }
;;   | ClipboardUpdateEvent
;;     { eventType :: !Word32
;;     , eventTimestamp :: !Word32
;;     }
;;   | UnknownEvent
;;     { eventType :: !Word32
;;     , eventTimestamp :: !Word32
;;     }
;;   deriving (Eq, Show, Typeable)
;; 
;; instance Storable Event where
;;   sizeOf _ = (#size SDL_Event)
;;   alignment _ = (#alignment SDL_Event)
;;   peek ptr = do
;;     typ <- (#peek SDL_Event, common.type) ptr
;;     timestamp <- (#peek SDL_Event, common.timestamp) ptr
;;     case typ of
;;       (#const SDL_QUIT) ->
;;         return $! QuitEvent typ timestamp
;;       (#const SDL_WINDOWEVENT) -> do
;;         wid <- (#peek SDL_Event, window.windowID) ptr
;;         event <- (#peek SDL_Event, window.event) ptr
;;         data1 <- (#peek SDL_Event, window.data1) ptr
;;         data2 <- (#peek SDL_Event, window.data2) ptr
;;         return $! WindowEvent typ timestamp wid event data1 data2
;;       (#const SDL_SYSWMEVENT) -> do
;;         msg <- (#peek SDL_Event, syswm.msg) ptr
;;         return $! SysWMEvent typ timestamp msg
;;       (#const SDL_KEYDOWN) -> key $ KeyboardEvent typ timestamp
;;       (#const SDL_KEYUP) -> key $ KeyboardEvent typ timestamp
;;       (#const SDL_TEXTEDITING) -> do
;;         wid <- (#peek SDL_Event, edit.windowID) ptr
;;         text <- peekArray (#const SDL_TEXTEDITINGEVENT_TEXT_SIZE) $ (#ptr SDL_Event, edit.text) ptr
;;         start <- (#peek SDL_Event, edit.start) ptr
;;         len <- (#peek SDL_Event, edit.length) ptr
;;         let upToNull = takeWhile (/= 0) text
;;         return $! TextEditingEvent typ timestamp wid upToNull start len
;;       (#const SDL_TEXTINPUT) -> do
;;         wid <- (#peek SDL_Event, text.windowID) ptr
;;         text <- peekArray (#const SDL_TEXTINPUTEVENT_TEXT_SIZE) $ (#ptr SDL_Event, text.text) ptr
;;         let upToNull = takeWhile (/= 0) text
;;         return $! TextInputEvent typ timestamp wid upToNull
;;       (#const SDL_KEYMAPCHANGED) ->
;;         return $! KeymapChangedEvent typ timestamp
;;       (#const SDL_MOUSEMOTION) -> do
;;         wid <- (#peek SDL_Event, motion.windowID) ptr
;;         which <- (#peek SDL_Event, motion.which) ptr
;;         state <- (#peek SDL_Event, motion.state) ptr
;;         x <- (#peek SDL_Event, motion.x) ptr
;;         y <- (#peek SDL_Event, motion.y) ptr
;;         xrel <- (#peek SDL_Event, motion.xrel) ptr
;;         yrel <- (#peek SDL_Event, motion.yrel) ptr
;;         return $! MouseMotionEvent typ timestamp wid which state x y xrel yrel
;;       (#const SDL_MOUSEBUTTONDOWN) -> mouse $ MouseButtonEvent typ timestamp
;;       (#const SDL_MOUSEBUTTONUP) -> mouse $ MouseButtonEvent typ timestamp
;;       (#const SDL_MOUSEWHEEL) -> do
;;         wid <- (#peek SDL_Event, wheel.windowID) ptr
;;         which <- (#peek SDL_Event, wheel.which) ptr
;;         x <- (#peek SDL_Event, wheel.x) ptr
;;         y <- (#peek SDL_Event, wheel.y) ptr
;;         direction <- (#peek SDL_Event, wheel.direction) ptr
;;         return $! MouseWheelEvent typ timestamp wid which x y direction
;;       (#const SDL_JOYAXISMOTION) -> do
;;         which <- (#peek SDL_Event, jaxis.which) ptr
;;         axis <- (#peek SDL_Event, jaxis.axis) ptr
;;         value <- (#peek SDL_Event, jaxis.value) ptr
;;         return $! JoyAxisEvent typ timestamp which axis value
;;       (#const SDL_JOYBALLMOTION) -> do
;;         which <- (#peek SDL_Event, jball.which) ptr
;;         ball <- (#peek SDL_Event, jball.ball) ptr
;;         xrel <- (#peek SDL_Event, jball.xrel) ptr
;;         yrel <- (#peek SDL_Event, jball.yrel) ptr
;;         return $! JoyBallEvent typ timestamp which ball xrel yrel
;;       (#const SDL_JOYHATMOTION) -> do
;;         which <- (#peek SDL_Event, jhat.which) ptr
;;         hat <- (#peek SDL_Event, jhat.hat) ptr
;;         value <- (#peek SDL_Event, jhat.value) ptr
;;         return $! JoyHatEvent typ timestamp which hat value
;;       (#const SDL_JOYBUTTONDOWN) -> joybutton $ JoyButtonEvent typ timestamp
;;       (#const SDL_JOYBUTTONUP) -> joybutton $ JoyButtonEvent typ timestamp
;;       (#const SDL_JOYDEVICEADDED) -> joydevice $ JoyDeviceEvent typ timestamp
;;       (#const SDL_JOYDEVICEREMOVED) -> joydevice $ JoyDeviceEvent typ timestamp
;;       (#const SDL_CONTROLLERAXISMOTION) -> do
;;         which <- (#peek SDL_Event, caxis.which) ptr
;;         axis <- (#peek SDL_Event, caxis.axis) ptr
;;         value <- (#peek SDL_Event, caxis.value) ptr
;;         return $! ControllerAxisEvent typ timestamp which axis value
;;       (#const SDL_CONTROLLERBUTTONDOWN) -> controllerbutton $ ControllerButtonEvent typ timestamp
;;       (#const SDL_CONTROLLERBUTTONUP) -> controllerbutton $ ControllerButtonEvent typ timestamp
;;       (#const SDL_CONTROLLERDEVICEADDED) -> controllerdevice $ ControllerDeviceEvent typ timestamp
;;       (#const SDL_CONTROLLERDEVICEREMOVED) -> controllerdevice $ ControllerDeviceEvent typ timestamp
;;       (#const SDL_CONTROLLERDEVICEREMAPPED) -> controllerdevice $ ControllerDeviceEvent typ timestamp
;;       (#const SDL_AUDIODEVICEADDED) -> audiodevice $ AudioDeviceEvent typ timestamp
;;       (#const SDL_AUDIODEVICEREMOVED) -> audiodevice $ AudioDeviceEvent typ timestamp
;;       (#const SDL_FINGERDOWN) -> finger $ TouchFingerEvent typ timestamp
;;       (#const SDL_FINGERUP) -> finger $ TouchFingerEvent typ timestamp
;;       (#const SDL_FINGERMOTION) -> finger $ TouchFingerEvent typ timestamp
;;       (#const SDL_DOLLARGESTURE) -> dollargesture $ DollarGestureEvent typ timestamp
;;       (#const SDL_DOLLARRECORD) -> dollargesture $ DollarGestureEvent typ timestamp
;;       (#const SDL_MULTIGESTURE) -> do
;;         touchId <- (#peek SDL_Event, mgesture.touchId) ptr
;;         dTheta <- (#peek SDL_Event, mgesture.dTheta) ptr
;;         dDist <- (#peek SDL_Event, mgesture.dDist) ptr
;;         x <- (#peek SDL_Event, mgesture.x) ptr
;;         y <- (#peek SDL_Event, mgesture.y) ptr
;;         numFingers <- (#peek SDL_Event, mgesture.numFingers) ptr
;;         return $! MultiGestureEvent typ timestamp touchId dTheta dDist x y numFingers
;;       (#const SDL_CLIPBOARDUPDATE) ->
;;         return $! ClipboardUpdateEvent typ timestamp
;;       (#const SDL_DROPFILE) -> do
;;         file <- (#peek SDL_Event, drop.file) ptr
;;         return $! DropEvent typ timestamp file
;;       x | x >= (#const SDL_USEREVENT) -> do
;;         wid <- (#peek SDL_Event, user.windowID) ptr
;;         code <- (#peek SDL_Event, user.code) ptr
;;         data1 <- (#peek SDL_Event, user.data1) ptr
;;         data2 <- (#peek SDL_Event, user.data2) ptr
;;         return $! UserEvent typ timestamp wid code data1 data2
;;       _ -> return $! UnknownEvent typ timestamp
;;     where
;;     key f = do
;;       wid <- (#peek SDL_Event, key.windowID) ptr
;;       state <- (#peek SDL_Event, key.state) ptr
;;       repeat' <- (#peek SDL_Event, key.repeat) ptr
;;       keysym <- (#peek SDL_Event, key.keysym) ptr
;;       return $! f wid state repeat' keysym
;; 
;;     mouse f = do
;;       wid <- (#peek SDL_Event, button.windowID) ptr
;;       which <- (#peek SDL_Event, button.which) ptr
;;       button <- (#peek SDL_Event, button.button) ptr
;;       state <- (#peek SDL_Event, button.state) ptr
;;       clicks <- (#peek SDL_Event, button.clicks) ptr
;;       x <- (#peek SDL_Event, button.x) ptr
;;       y <- (#peek SDL_Event, button.y) ptr
;;       return $! f wid which button state clicks x y
;; 
;;     joybutton f = do
;;       which <- (#peek SDL_Event, jbutton.which) ptr
;;       button <- (#peek SDL_Event, jbutton.button) ptr
;;       state <- (#peek SDL_Event, jbutton.state) ptr
;;       return $! f which button state
;; 
;;     joydevice f = do
;;       which <- (#peek SDL_Event, jdevice.which) ptr
;;       return $! f which
;; 
;;     controllerbutton f = do
;;       which <- (#peek SDL_Event, cbutton.which) ptr
;;       button <- (#peek SDL_Event, cbutton.button) ptr
;;       state <- (#peek SDL_Event, cbutton.state) ptr
;;       return $! f which button state
;; 
;;     controllerdevice f = do
;;       which <- (#peek SDL_Event, cdevice.which) ptr
;;       return $! f which
;; 
;;     audiodevice f = do
;;       which <- (#peek SDL_Event, adevice.which) ptr
;;       iscapture <- (#peek SDL_Event, adevice.iscapture) ptr
;;       return $! f which iscapture
;; 
;;     finger f = do
;;       touchId <- (#peek SDL_Event, tfinger.touchId) ptr
;;       fingerId <- (#peek SDL_Event, tfinger.fingerId) ptr
;;       x <- (#peek SDL_Event, tfinger.x) ptr
;;       y <- (#peek SDL_Event, tfinger.y) ptr
;;       dx <- (#peek SDL_Event, tfinger.dx) ptr
;;       dy <- (#peek SDL_Event, tfinger.dy) ptr
;;       pressure <- (#peek SDL_Event, tfinger.pressure) ptr
;;       return $! f touchId fingerId x y dx dy pressure
;; 
;;     dollargesture f = do
;;       touchId <- (#peek SDL_Event, dgesture.touchId) ptr
;;       gestureId <- (#peek SDL_Event, dgesture.gestureId) ptr
;;       numFingers <- (#peek SDL_Event, dgesture.numFingers) ptr
;;       err <- (#peek SDL_Event, dgesture.error) ptr
;;       x <- (#peek SDL_Event, dgesture.x) ptr
;;       y <- (#peek SDL_Event, dgesture.y) ptr
;;       return $! f touchId gestureId numFingers err x y
;;   poke ptr ev = case ev of
;;     WindowEvent typ timestamp wid event data1 data2 -> do
;;       (#poke SDL_Event, common.type) ptr typ
;;       (#poke SDL_Event, common.timestamp) ptr timestamp
;;       (#poke SDL_Event, window.windowID) ptr wid
;;       (#poke SDL_Event, window.event) ptr event
;;       (#poke SDL_Event, window.data1) ptr data1
;;       (#poke SDL_Event, window.data2) ptr data2
;;     KeyboardEvent typ timestamp wid state repeat' keysym -> do
;;       (#poke SDL_Event, common.type) ptr typ
;;       (#poke SDL_Event, common.timestamp) ptr timestamp
;;       (#poke SDL_Event, key.windowID) ptr wid
;;       (#poke SDL_Event, key.state) ptr state
;;       (#poke SDL_Event, key.repeat) ptr repeat'
;;       (#poke SDL_Event, key.keysym) ptr keysym
;;     TextEditingEvent typ timestamp wid text start len -> do
;;       (#poke SDL_Event, common.type) ptr typ
;;       (#poke SDL_Event, common.timestamp) ptr timestamp
;;       (#poke SDL_Event, edit.windowID) ptr wid
;;       pokeArray ((#ptr SDL_Event, edit.text) ptr) text
;;       (#poke SDL_Event, edit.start) ptr start
;;       (#poke SDL_Event, edit.length) ptr len
;;     TextInputEvent typ timestamp wid text -> do
;;       (#poke SDL_Event, common.type) ptr typ
;;       (#poke SDL_Event, common.timestamp) ptr timestamp
;;       (#poke SDL_Event, text.windowID) ptr wid
;;       pokeArray ((#ptr SDL_Event, text.text) ptr) text
;;     KeymapChangedEvent typ timestamp -> do
;;       (#poke SDL_Event, common.type) ptr typ
;;       (#poke SDL_Event, common.timestamp) ptr timestamp
;;     MouseMotionEvent typ timestamp wid which state x y xrel yrel -> do
;;       (#poke SDL_Event, common.type) ptr typ
;;       (#poke SDL_Event, common.timestamp) ptr timestamp
;;       (#poke SDL_Event, motion.windowID) ptr wid
;;       (#poke SDL_Event, motion.which) ptr which
;;       (#poke SDL_Event, motion.state) ptr state
;;       (#poke SDL_Event, motion.x) ptr x
;;       (#poke SDL_Event, motion.y) ptr y
;;       (#poke SDL_Event, motion.xrel) ptr xrel
;;       (#poke SDL_Event, motion.yrel) ptr yrel
;;     MouseButtonEvent typ timestamp wid which button state clicks x y -> do
;;       (#poke SDL_Event, common.type) ptr typ
;;       (#poke SDL_Event, common.timestamp) ptr timestamp
;;       (#poke SDL_Event, button.windowID) ptr wid
;;       (#poke SDL_Event, button.which) ptr which
;;       (#poke SDL_Event, button.button) ptr button
;;       (#poke SDL_Event, button.state) ptr state
;;       (#poke SDL_Event, button.clicks) ptr clicks
;;       (#poke SDL_Event, button.x) ptr x
;;       (#poke SDL_Event, button.y) ptr y
;;     MouseWheelEvent typ timestamp wid which x y direction -> do
;;       (#poke SDL_Event, common.type) ptr typ
;;       (#poke SDL_Event, common.timestamp) ptr timestamp
;;       (#poke SDL_Event, wheel.windowID) ptr wid
;;       (#poke SDL_Event, wheel.which) ptr which
;;       (#poke SDL_Event, wheel.x) ptr x
;;       (#poke SDL_Event, wheel.y) ptr y
;;       (#poke SDL_Event, wheel.direction) ptr direction
;;     JoyAxisEvent typ timestamp which axis value -> do
;;       (#poke SDL_Event, common.type) ptr typ
;;       (#poke SDL_Event, common.timestamp) ptr timestamp
;;       (#poke SDL_Event, jaxis.which) ptr which
;;       (#poke SDL_Event, jaxis.axis) ptr axis
;;       (#poke SDL_Event, jaxis.value) ptr value
;;     JoyBallEvent typ timestamp which ball xrel yrel -> do
;;       (#poke SDL_Event, common.type) ptr typ
;;       (#poke SDL_Event, common.timestamp) ptr timestamp
;;       (#poke SDL_Event, jball.which) ptr which
;;       (#poke SDL_Event, jball.ball) ptr ball
;;       (#poke SDL_Event, jball.xrel) ptr xrel
;;       (#poke SDL_Event, jball.yrel) ptr yrel
;;     JoyHatEvent typ timestamp which hat value -> do
;;       (#poke SDL_Event, common.type) ptr typ
;;       (#poke SDL_Event, common.timestamp) ptr timestamp
;;       (#poke SDL_Event, jhat.which) ptr which
;;       (#poke SDL_Event, jhat.hat) ptr hat
;;       (#poke SDL_Event, jhat.value) ptr value
;;     JoyButtonEvent typ timestamp which button state -> do
;;       (#poke SDL_Event, common.type) ptr typ
;;       (#poke SDL_Event, common.timestamp) ptr timestamp
;;       (#poke SDL_Event, jbutton.which) ptr which
;;       (#poke SDL_Event, jbutton.button) ptr button
;;       (#poke SDL_Event, jbutton.state) ptr state
;;     JoyDeviceEvent typ timestamp which -> do
;;       (#poke SDL_Event, common.type) ptr typ
;;       (#poke SDL_Event, common.timestamp) ptr timestamp
;;       (#poke SDL_Event, jdevice.which) ptr which
;;     ControllerAxisEvent typ timestamp which axis value -> do
;;       (#poke SDL_Event, common.type) ptr typ
;;       (#poke SDL_Event, common.timestamp) ptr timestamp
;;       (#poke SDL_Event, caxis.which) ptr which
;;       (#poke SDL_Event, caxis.axis) ptr axis
;;       (#poke SDL_Event, caxis.value) ptr value
;;     ControllerButtonEvent typ timestamp which button state -> do
;;       (#poke SDL_Event, common.type) ptr typ
;;       (#poke SDL_Event, common.timestamp) ptr timestamp
;;       (#poke SDL_Event, cbutton.which) ptr which
;;       (#poke SDL_Event, cbutton.button) ptr button
;;       (#poke SDL_Event, cbutton.state) ptr state
;;     ControllerDeviceEvent typ timestamp which -> do
;;       (#poke SDL_Event, common.type) ptr typ
;;       (#poke SDL_Event, common.timestamp) ptr timestamp
;;       (#poke SDL_Event, cdevice.which) ptr which
;;     AudioDeviceEvent typ timestamp which iscapture -> do
;;       (#poke SDL_Event, common.type) ptr typ
;;       (#poke SDL_Event, common.timestamp) ptr timestamp
;;       (#poke SDL_Event, adevice.which) ptr which
;;       (#poke SDL_Event, adevice.iscapture) ptr iscapture
;;     QuitEvent typ timestamp -> do
;;       (#poke SDL_Event, common.type) ptr typ
;;       (#poke SDL_Event, common.timestamp) ptr timestamp
;;     UserEvent typ timestamp wid code data1 data2 -> do
;;       (#poke SDL_Event, common.type) ptr typ
;;       (#poke SDL_Event, common.timestamp) ptr timestamp
;;       (#poke SDL_Event, user.windowID) ptr wid
;;       (#poke SDL_Event, user.code) ptr code
;;       (#poke SDL_Event, user.data1) ptr data1
;;       (#poke SDL_Event, user.data2) ptr data2
;;     SysWMEvent typ timestamp msg -> do
;;       (#poke SDL_Event, common.type) ptr typ
;;       (#poke SDL_Event, common.timestamp) ptr timestamp
;;       (#poke SDL_Event, syswm.msg) ptr msg
;;     TouchFingerEvent typ timestamp touchid fingerid x y dx dy pressure -> do
;;       (#poke SDL_Event, common.type) ptr typ
;;       (#poke SDL_Event, common.timestamp) ptr timestamp
;;       (#poke SDL_Event, tfinger.touchId) ptr touchid
;;       (#poke SDL_Event, tfinger.fingerId) ptr fingerid
;;       (#poke SDL_Event, tfinger.x) ptr x
;;       (#poke SDL_Event, tfinger.y) ptr y
;;       (#poke SDL_Event, tfinger.dx) ptr dx
;;       (#poke SDL_Event, tfinger.dy) ptr dy
;;       (#poke SDL_Event, tfinger.pressure) ptr pressure
;;     MultiGestureEvent typ timestamp touchid dtheta ddist x y numfingers -> do
;;       (#poke SDL_Event, common.type) ptr typ
;;       (#poke SDL_Event, common.timestamp) ptr timestamp
;;       (#poke SDL_Event, mgesture.touchId) ptr touchid
;;       (#poke SDL_Event, mgesture.dTheta) ptr dtheta
;;       (#poke SDL_Event, mgesture.dDist) ptr ddist
;;       (#poke SDL_Event, mgesture.x) ptr x
;;       (#poke SDL_Event, mgesture.y) ptr y
;;       (#poke SDL_Event, mgesture.numFingers) ptr numfingers
;;     DollarGestureEvent typ timestamp touchid gestureid numfingers err x y -> do
;;       (#poke SDL_Event, common.type) ptr typ
;;       (#poke SDL_Event, common.timestamp) ptr timestamp
;;       (#poke SDL_Event, dgesture.touchId) ptr touchid
;;       (#poke SDL_Event, dgesture.gestureId) ptr gestureid
;;       (#poke SDL_Event, dgesture.numFingers) ptr numfingers
;;       (#poke SDL_Event, dgesture.error) ptr err
;;       (#poke SDL_Event, dgesture.x) ptr x
;;       (#poke SDL_Event, dgesture.y) ptr y
;;     ClipboardUpdateEvent typ timestamp -> do
;;       (#poke SDL_Event, common.type) ptr typ
;;       (#poke SDL_Event, common.timestamp) ptr timestamp
;;     DropEvent typ timestamp file -> do
;;       (#poke SDL_Event, common.type) ptr typ
;;       (#poke SDL_Event, common.timestamp) ptr timestamp
;;       (#poke SDL_Event, drop.file) ptr file
;;     UnknownEvent typ timestamp -> do
;;       (#poke SDL_Event, common.type) ptr typ
;;       (#poke SDL_Event, common.timestamp) ptr timestamp
