;; init-macos.el --- Initialize macOS settings configurations.	-*- lexical-binding: t -*-

;;; Commentary:
;;
;; for macOS System Settings
;; 

;;; Code:

(require 'init-const)

;; macOS switch meta key.
(when IS-MAC
  (setq mac-command-modifier 'meta
        mac-option-modifier 'super
        mac-control-modifier 'control
        mac-right-option-modifier 'hyper))

;; 加载系统的环境变量
(use-package exec-path-from-shell
  :if IS-MAC
  :demand t
  :custom
  (exec-path-from-shell-variables '("PATH" "GOROOT" "GOPATH" "GO111MODULE" "EMACS_MODULE_HEADER_ROOT"))
  :config
  ;; (setq exec-path-from-shell-arguments '("-l")
  ;;       exec-path-from-shell-variables '("PATH" "GOROOT" "GOPATH" "MANPATH" "CLASSPATH" "RIME_PATH" "PKG_CONFIG_PATH"))

  (setenv "LD_LIBRARY_PATH" (concat (getenv "LD_LIBRARY_PATH") ":/opt/homebrew/lib"))
  
  (exec-path-from-shell-initialize))

;; A patch to enhance exec-path-from-shell
(use-package cache-path-from-shell
  :load-path "localelpa/cache-path-from-shell")

;; Display dividers between windows
(setq window-divider-default-places t
      window-divider-default-bottom-width 1
      window-divider-default-right-width 1)

(when (display-graphic-p)
  (add-hook 'window-setup-hook #'window-divider-mode)
  (setq ns-use-native-fullscreen nil))

;; Emacs-plus patch : https://github.com/d12frosted/homebrew-emacs-plus
(when IS-MAC
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark)) ; light or dark - depending on your theme
  (setq ns-use-thin-smoothing t)  ; Render thinner fonts
  (setq ns-pop-up-frames nil)     ; Don't open a file in a new frame
  ;; If using OSX, the colors and fonts look a bit wonky, so let's fix that
  (setq ns-use-srgb-colorspace t)
  (setq frame-resize-pixelwise t)
  (setq mac-allow-anti-aliasing t)      ; Anti-aliasinga
  (add-hook 'after-load-theme-hook
            (lambda ()
              (let ((bg (frame-parameter nil 'background-mode)))
                (set-frame-parameter nil 'ns-appearance bg)
                (setcdr (assq 'ns-appearance default-frame-alist) bg)))))

;; Maximized Window when startup
(set-frame-parameter nil 'fullscreen (if IS-WINDOWS
                                         'fullboth 'maximized))

;; delete files by moving to trash in macOS
;; https://github.com/lunaryorn/osx-trash.el
(use-package osx-trash
  :if IS-MAC
  :config
  (setq delete-by-moving-to-trash t)      ; Deleting files go to OS's trash folder
  (osx-trash-setup))

;;================================================================================
;; integrate use-package with =:ensure-system-package=
(use-package use-package-ensure-system-package
  :disabled t)
;;================================================================================

(provide 'init-macos)
;;; init-macos.el ends here
