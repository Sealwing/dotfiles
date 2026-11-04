;; GLOBAL

(setq inhibit-startup-message t)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq display-line-numbers 'relative)

(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file :no-error-if-file-is-missing)

(setq make-backup-files nil)

(setq project-mode-line 1)

(add-to-list 'default-frame-alist '(undecorated . t))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(package-refresh-contents)

;; THEME

(set-face-attribute
    'default nil
    :height 145
    :width  'expanded
    :weight 'light
    :family "Lilex Nerd Font Mono") 

(use-package doom-themes
    :ensure t
    :custom
    ;; Global settings (defaults)
    (doom-themes-enable-bold t)   ; if nil, bold is universally disabled
    (doom-themes-enable-italic t) ; if nil, italics is universally disabled
    :config
    (load-theme 'doom-one t)
    ;; Enable flashing mode-line on errors
    (doom-themes-visual-bell-config)
    ;; Enable custom neotree theme (nerd-icons must be installed!)
    (doom-themes-neotree-config)
    ;; Corrects (and improves) org-mode's native fontification.
    (doom-themes-org-config))

;; MAGIT

(use-package magit
  :ensure t)
