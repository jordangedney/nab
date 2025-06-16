(in-package #:nab)
(cl-syntax:use-syntax :clump)

(def mk-debug-config ()
  '(:debug (:starting-mode :world
            :enemies-invincible nil
            :hide-hud t)))

(def mk-render-config ()
  '(:render (:width 50
             :height 50
             :window-title "nab"
             :window-mode :fullscreen
             :window-display-index 0
             :vsync t
             :manual-perform-gc t)))

(def mk-audio-config ()
  '(:audio (:sounds-enabled t
            :music-enabled t
            :sound-volume 100
            :music-volume 100
            :game-music :explore)))

(def mk-input-config ()
  '(:input (:buffered-seconds 10)))

(def mk-ui-config ()
  '(:ui (:overlay-scale 2.0
         :overlay-pos (10 10))))

(def mk-main-menu-config ()
  '(:main (:background-image (:texture (:path "background.png"
                                        :width 10
                                        :height 10)
                              :sub-rect (:x 55
                                         :y 55
                                         :width 10
                                         :height 10)
                              :origin-pos (50 50)
                              :top-left-offset (50 50))
           :new-game-button (:type :text
                             :pos (10 10)
                             :selected nil
                             :pressed nil
                             :height 30)
           :quit-button (:type :text
                         :pos (10 10)
                         :selected nil
                         :pressed nil
                         :height 30))))

(def mk-pause-menu-config ()
  '(:pause (:background-image (:texture (:path "background.png"
                                         :width 10
                                         :height 10)
                               :sub-rect (:x 55
                                          :y 55
                                          :width 10
                                          :height 10)
                               :origin-pos (50 50)
                               :top-left-offset (50 50))
            :resume-button (:type :text
                              :pos (10 10)
                              :selected nil
                              :pressed nil
                              :height 30))))

(def mk-menu-config ()
  `(:menu ,(combine-plists (mk-main-menu-config) (mk-pause-menu-config))))

(def mk-configs ()
  (combine-plists
   (mk-debug-config)
   (mk-render-config)
   (mk-audio-config)
   (mk-input-config)
   (mk-ui-config)
   (mk-menu-config)))

;; (dig (mk-configs) :menu :main :background-image :origin-pos) ;; => (50 50)
