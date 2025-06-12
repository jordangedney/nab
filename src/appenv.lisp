;;;; appenv.lisp

(in-package #:nab)
(cl-syntax:use-syntax :clump)

;; TODO
;; why do both window and appenv-read contain references to graphics and window
;; state? I'm going to merge the Window type and the AppEnvReadData for now ...
;; until I see a reason not to.
(def mk-appenv-read (cfgs window)
  (combine-plists
   window
   `(:configs ,cfgs)
   '(:file-cache nil)))

(def mk-appenv-write ()
  '(:messages nil))

(def mk-appenv ()
  (= ((cfgs (mk-configs))
      (window (mk-window cfgs))
      (read (mk-appenv-read cfgs window))
      (write (mk-appenv-write)))
     `(:read ,read
       :write ,write)))

