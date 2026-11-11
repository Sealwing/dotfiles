;;; -*- lexical-binding: t -*-

;; GLOBAL

(setq inhibit-startup-message t)
(setq warning-minimum-level :error)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode 1)

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file :no-error-if-file-is-missing)

(setq make-backup-files nil)
(setq auto-save-default nil)

(setq project-mode-line 1)

(add-to-list 'default-frame-alist '(undecorated . t))


(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
; (package-refresh-contents)

;; THEME

(set-face-attribute
    'default nil
    :height 145
    :width  'expanded
    :weight 'normal
    :family "Lilex Nerd Font Mono")

(use-package catppuccin-theme
  :ensure t
  :init
  (setq catppuccin-flavor 'macchiato) ;; or 'frappe, 'macchiato, or 'mocha
  :config
  (load-theme 'catppuccin-theme))
  
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

(use-package zig-mode
  :ensure t
  :hook (
	 ; on file open configure outline, since zig mode doesn't do that
	 (zig-mode . (lambda ()
		       (setq-local
			outline-regexp
			"\\(fn\\|pub\\|\\|inline\\|const\\|var\\|test\\) ")))))
  
(use-package lsp-mode
  :ensure t
  :init
  (setq lsp-keymap-prefix "C-c i")
  (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-enable-file-watchers nil)
  :hook (
	 (lsp-mode . (lsp-enable-which-key-integration)))
  :config
  (setq lsp-idle-delay 1)
  :commands (lsp lsp-deferred))

(use-package lsp-ui
  :ensure t
  :config
  (setq lsp-ui-sideline-show-diagnostics t)
  :commands lsp-ui-mode)

(use-package lsp-pyright
  :ensure t
  :custom (lsp-pyright-langserver-command "pyright")
  :hook (python-mode . (lambda ()
			 (require 'lsp-pyright)
			 (lsp-deferred))))

;; (use-package dap-mode
;;   :ensure t
;;   :config
;;   (require 'dap-mode)
;;   (setq dap-auto-configure-features '(sessions locals controls tooltip))
;;   (require 'dap-python)
;;   ;; if you installed debugpy, you need to set this
;;   ;; https://github.com/emacs-lsp/dap-mode/issues/306
;;   (setq dap-python-debugger 'debugpy)
;;   )

; navigation/search

(use-package consult
  :ensure t
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
  :ensure t
  :custom
  (vertico-count 7)
  (vertico-scroll-margin 0)
  (vertico-resize t)
  (vertico-cycle t)
  :config
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
  :ensure t
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

(add-to-list 'compilation-error-regexp-alist-alist
	     '(pyright-cmd .
	       ("^\s*\\(/.*\\):\\([0-9]+\\):\\([0-9]+\\) - error" 1 2 3 )

	       )
	     )

(add-to-list 'compilation-error-regexp-alist 'pyright-cmd)

;; KEYMAPS
					; outline
(keymap-global-set "C-c C-n" 'outline-next-heading)
(keymap-global-set "C-c C-p" 'outline-previous-heading)
(keymap-global-set "C-}" 'outline-next-heading) ; convenient for denser files
(keymap-global-set "C-{" 'outline-previous-heading)
(keymap-global-set "C-c C-o c" 'outline-hide-entry)
(keymap-global-set "C-c C-o o" 'outline-show-entry)
(keymap-global-set "C-c C-o h" 'outline-hide-body)
(keymap-global-set "C-c C-o s" 'outline-show-all)
					; window/buffer
(keymap-global-set "C-c b b" 'consult-buffer)
(keymap-global-set "C-c b h" 'split-window-below)
(keymap-global-set "C-c b v" 'split-window-right)
(keymap-global-set "C-c b c" 'delete-window)
(keymap-global-set "C-c h" 'windmove-left)
(keymap-global-set "C-c l" 'windmove-right)
(keymap-global-set "C-c k" 'windmove-up)
(keymap-global-set "C-c j" 'windmove-down)
					; compilie/terminal
(keymap-global-set "C-c C-c" 'compile)
(keymap-global-set "C-c C-z" 'term)
