;;;; env.lisp

(in-package #:nab)
(cl-syntax:use-syntax :clump)

;; TODO
;; why do both window and appenv-read contain references to graphics and window
;; state? I'm going to merge the Window type and the EnvReadData for now ...
;; until I see a reason not to.
(def mk-env-read (cfgs window)
  (combine-plists
   window
   `(:configs ,cfgs)
   '(:file-cache nil)))

(def mk-env-write ()
  '(:messages nil))

(def mk-env ()
  (= ((cfgs (mk-configs))
      (window (mk-window cfgs))
      (read (mk-env-read cfgs window))
      (write (mk-env-write)))
     `(:read ,read
       :write ,write
       :game ,(mk-game)
       )))
