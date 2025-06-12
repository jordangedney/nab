

(in-package #:nab)
(cl-syntax:use-syntax :clump)

;; just for garbage you don't want to keep.

(def calc-color (time offset)
  (float->byte (+ 0.5 (* 0.5 (sdl3-raw:sdl-sin
                              (+ (coerce time 'double-float)
                                 (* sdl3-raw:sdl-pi-d offset (/ 1 3))))))))




