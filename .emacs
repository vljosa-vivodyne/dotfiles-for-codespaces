(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(setq visible-bell t)
(menu-bar-mode -1)

(setq-default cursor-in-non-selected-windows nil)

(setq create-lockfiles nil)

(setq transient-mark-mode nil)

(set-default 'truncate-lines t)

(global-auto-revert-mode t)

(global-set-key (kbd "C-x C-k") 'kill-region)

(global-set-key (kbd "M-g") 'goto-line)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(add-hook 'write-file-hooks 'delete-trailing-whitespace)

(setq-default require-final-newline t)

(setq backup-directory-alist `(("." . "~/.emacs.d/saves")))
(setq backup-by-copying t
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(use-package magit
  :ensure t
  :config
  (setq magit-define-global-key-bindings 'recommended)
  (setq magit-git-executable "/opt/homebrew/bin/git"))

(use-package markdown-mode :ensure t)

(use-package windmove
  :ensure t
  :config
  (windmove-default-keybindings))

(use-package quelpa :ensure t)
(use-package quelpa-use-package :ensure t)

(use-package copilot
  :quelpa (copilot :fetcher github
                   :repo "copilot-emacs/copilot.el"
                   :branch "main"
                   :files ("dist" "*.el"))
  :config
  (add-hook 'prog-mode-hook 'copilot-mode)
  (define-key copilot-completion-map (kbd "M-RET") 'copilot-accept-completion)
  (define-key copilot-completion-map (kbd "C-M-<return>") 'copilot-accept-completion-by-word)
  (add-to-list 'warning-suppress-types '(copilot copilot-no-mode-indent)))

(use-package projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (projectile-mode +1)
  (setq projectile-create-missing-test-files nil) ; TODO: Make it put them in the right place
  )

(defvar lsp-client-settings (make-hash-table :test 'equal))

(use-package lsp-mode
;;  :load-path "~/src/lsp-mode"
;;  :hook (rust-mode rust-ts-mode)
;;  :custom (lsp-semantic-tokens-enable t)
  )

(defun ljosa-lsp-pyright-locate-python ()
  (or (executable-find (f-expand "bin/python" (lsp-pyright-locate-venv)) t)
      (lsp-pyright-locate-python)))

(defun ljosa-lsp-pyright-locate-python ()
  (f-expand "bin/python" (lsp-pyright-locate-venv)))

(setq lsp-pyright-multi-root nil) ; Must be set before lsp-pyright is loaded. https://github.com/emacs-lsp/lsp-pyright/issues/19#issuecomment-930596080

(defvar lsp-client-settings (make-hash-table :test 'equal)) ; Original does not set :test, so values with string keys cannot be replaced.

(use-package lsp-pyright
  :ensure t
  :config
  ;; Fix pyright not using the right virtualenv in devcontainers.
  ;; Still requires lsp-restart-workspace.
  (lsp-register-custom-settings
   '(("python.pythonPath" ljosa-lsp-pyright-locate-python)))

  (define-key lsp-mode-map (kbd "C-c C-l") lsp-command-map)
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                          (lsp))))

(use-package iswitchb
  :config
  (iswitchb-mode 1))

(use-package yaml-mode :ensure t)

(use-package git-link :ensure t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(git-link yaml-mode lsp-pyright projectile markdown-mode magit use-package modus-themes)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
