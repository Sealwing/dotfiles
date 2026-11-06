;;; -*- lexical-binding: t -*-

;; GLOBAL

(setq inhibit-startup-message t)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file :no-error-if-file-is-missing)

(setq make-backup-files nil)
(setq auto-save-default nil)

(setq project-mode-line 1)

(add-to-list 'default-frame-alist '(undecorated . t))

; keys
(keymap-global-set "C-}" 'outline-next-heading)
(keymap-global-set "C-{" 'outline-previous-heading)
; buffer
(keymap-global-set "C-c b b" 'consult-buffer)
(keymap-global-set "C-c b h" 'split-window-horizontally)
(keymap-global-set "C-c b v" 'split-window-vertically)
(keymap-global-set "C-c b c" 'delete-window)
(keymap-global-set "C-c h" 'windmove-left)
(keymap-global-set "C-c l" 'windmove-right)
(keymap-global-set "C-c k" 'windmove-up)
(keymap-global-set "C-c j" 'windmove-down)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
; (package-refresh-contents)

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
    (load-theme 'doom-nord-aurora t)
    ;; Enable flashing mode-line on errors
    (doom-themes-visual-bell-config)
    ;; Enable custom neotree theme (nerd-icons must be installed!)
    (doom-themes-neotree-config)
    ;; Corrects (and improves) org-mode's native fontification.
    (doom-themes-org-config))

;; PACKAGES

; PATH variables
(use-package exec-path-from-shell
  :ensure t
  :init
  (when (memq window-system '(mac ns x pgtk))
    (exec-path-from-shell-initialize))
  (when (daemonp)
    (exec-path-from-shell-initialize)))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

(use-package magit
  :ensure t
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

; languages

(use-package zig-mode)

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-enable-file-watchers nil)
  :hook (
	 (lsp-mode . (lsp-enable-which-key-integration)))
  :config
  (setq lsp-idle-delay 1)
  :commands (lsp lsp-deferred))

(use-package lsp-ui
  :config
  (setq lsp-ui-sideline-show-diagnostics t)
  :commands lsp-ui-mode)

(use-package lsp-pyright
  :custom (lsp-pyright-langserver-command "pyright")
  :hook (python-mode . (lambda ()
			 (require 'lsp-pyright)
			 (lsp-deferred))))

(use-package lsp-zig
  :hook (zig-mode . (lambda ()
		      (require 'lsp-zig)
		      (lsp-deferred))))

; navigation/search

(use-package consult
  :bind (
	 ("C-c M-x" . consult-mode-command)
	 ("C-x b" . consult-buffer)
	 ("M-s a" . consult-ripgrep)
	 ("M-s m" . consult-man)
	 ("M-g g" . consult-goto-line)
	 ("M-g M-g" . consult-goto-line)
	 ("M-g m" . consult-mark)
	 ("M-g o" . consult-outline)
	 ("M-g e" . consult-compile-error)
	 ("M-g l" . consult-flymake)
	 ))

; Completion window setup
(use-package vertico
  :custom
  (vertico-count 7)
  (vertico-scroll-margin 0)
  (vertico-resize t)
  (vertico-cycle t)
  :init
  (vertico-mode))

(use-package corfu
  :ensure t
  :custom
  (corfu-cycle t)
  (corfu-quit-at-boundary nil)
  (corfu-quit-no-match nil)
  (corfu-preview-current t)
  (corfu-preselect 'prompt)
  :init
  (global-corfu-mode)
  :config
  (set-face-attribute 'corfu-current nil
		      :box "#048f96")
  )

(use-package orderless
  :custom
  (completion-styles '(basic flex orderless))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t))

; emacs config

(use-package emacs
  :custom
  (context-menu-mode t)
  (tab-always-indent 'complete)
  (text-mode-ispell-word-completion nil)
  (enable-recursive-minibuffers t)
  (read-extended-command-predicate #'command-completion-default-include-p))
