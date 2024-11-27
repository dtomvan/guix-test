(use-modules (guix ci))

(list 
  (channel
        (name 'guix)
		; Hopefully github is faster
        (url "https://github.com/Foundation-Devices/guix-mirror"))
  (channel-with-substitutes-available
       %default-guix-channel
       "https://ci.guix.gnu.org")
	  )
