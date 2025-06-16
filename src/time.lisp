;;;; time.lisp

(in-package #:nab)
(cl-syntax:use-syntax :clump)

(def mk-time ()
  `(:utc ,(get-universal-time)
    :diff-secs 0.0))

(def out-of-time? (env) (< (dig env :game :time :diff-secs) +time-step+))

(def update-time (env)
  (= ((current (get-universal-time))
      (new-diff-secs (+ (- current (dig env :game :time :utc))
                        (dig env :game :time :diff-secs))))
     (-> env
         (dig= current :game :time :utc)
         (dig= current :game :time :diff-secs))))

(def update-lerp (env) env) ; TODO

(out-of-time? (mk-env))
(dig (mk-env) :game :time)
