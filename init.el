(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(setq package-enable-at-startup nil)
(package-initialize)

(ido-mode 1)
(ido-everywhere 1)

(global-unset-key (kbd "C-h"))
(global-unset-key (kbd "C-j"))
(global-unset-key (kbd "C-k"))
(global-unset-key (kbd "C-l"))

(defvar global-evil-keys-map (make-sparse-keymap) "Stop overriding my globals!!")
(define-minor-mode global-evil-keys
  :init-value t
  :lighter " global-evil-keys"
  :keymap global-evil-keys-map)
(define-globalized-minor-mode global-evil-keys-mode global-evil-keys global-evil-keys)

(global-evil-keys-mode 1)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-search-module 'evil-search)
  (setq evil-ex-complete-emacs-commands nil)
  (setq evil-vsplit-window-right t)
  (setq evil-vsplit-window-below t)
  (setq evil-shift-round nil)
  :config
  (evil-mode)
  (evil-define-key nil evil-normal-state-map (kbd "SPC f") 'find-file)
  (evil-define-key nil evil-normal-state-map (kbd "SPC b") 'switch-to-buffer)
  (evil-define-key nil evil-visual-state-map (kbd "C-/") 'comment-dwim)
  (evil-define-key nil evil-normal-state-map (kbd "SPC RET") 'evil-ex-nohighlight))

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (delete 'comint evil-collection-mode-list)
  (delete 'term evil-collection-mode-list)
  (evil-collection-init))

(use-package evil-easymotion
  :ensure t
  :config)

(use-package key-chord
  :ensure t
  :after evil
  :init
  :config
  (key-chord-mode 1)
  (setq key-chord-two-keys-delay .15)
  (setq key-chord-one-key-delay .2)
  (key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
  (key-chord-define evil-insert-state-map "kj" 'evil-normal-state)
  (key-chord-define evil-normal-state-map "  " evilem-map))

(use-package general
  :ensure t
  :after evil-collection
  :config
  (general-define-key
   :states 'motion
   :keymaps 'override
   "C-k" 'windmove-up)
  (general-define-key
   :states 'motion
   :keymaps 'override
   "C-j" 'windmove-down)
  (general-define-key
   :states 'motion
   :keymaps 'override
   "C-h" 'windmove-left)
  (general-define-key
   :states 'motion
   :keymaps 'override
   "C-l" 'windmove-right))

(use-package haskell-mode
  :ensure t
  :config
  (setq haskell-interactive-popup-errors 0)
  (setq haskell-process-type 'stack-ghci))

(use-package intero
  :ensure t
  :config
  (add-hook 'haskell-mode-hook #'intero-mode)
  (add-hook 'haskell-mode-hook #'fira-code-mode)
  (evil-define-key 'normal intero-mode-map (kbd "K") 'intero-info)
  (evil-define-key 'normal intero-mode-map (kbd "gd") 'intero-goto-definition)
  (bind-key (kbd "C-k") nil)
  (bind-key (kbd "C-j") nil)
  (bind-key (kbd "C-h") nil)
  (bind-key (kbd "C-l") nil))

(use-package helm
  :ensure t
  :after general
  :config
  (global-set-key (kbd "M-x") 'helm-M-x)
  ;; (general-define-key
  ;;  :states 'normal
  ;;  "SPC f" 'helm-find-files)
  (general-define-key
   :states 'normal
   "SPC b" 'helm-buffers-list))

(use-package projectile
  :ensure t
  :after general
  :config
  (projectile-mode)
  (add-to-list 'projectile-globally-ignored-directories ".ccls-cache"))

(defun contextual-find-file ()
  (interactive)
  (if (projectile-project-p)
      (helm-projectile-find-file)
      (helm-find-files nil)))

(use-package helm-projectile
  :ensure t
  :after general
  :config
  (general-define-key
   :states 'normal
   "SPC f" 'contextual-find-file))

(use-package evil-exchange
  :ensure t
  :config
  (evil-exchange-cx-install))

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package irony
  :ensure t
  :config
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'objc-mode-hook 'irony-mode)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))

(use-package company
  :ensure t
  :config
  (global-company-mode))

(use-package rtags
  :ensure t
  :after 'company
  :config
  (setq rtags-completions-enabled t)
  (push 'copmany-rtags company-backends)
  (setq rtags-display-result-backend 'helm))

(global-flycheck-mode)

(use-package flycheck-rtags
  :ensure t
  :after 'rtags
  :config
  (defun my-flycheck-rtags-setup ()
    (flycheck-select-checker 'rtags)
    (setq-local flycheck-highlighting-mode nil) ;; RTags creates more accurate overlays.
    (setq-local flycheck-check-syntax-automatically nil))
  (add-hook 'c-mode-hook #'my-flycheck-rtags-setup)
  (add-hook 'c++-mode-hook #'my-flycheck-rtags-setup)
  (add-hook 'objc-mode-hook #'my-flycheck-rtags-setup))

; (global-whitespace-mode 1)

(setq ring-bell-function 'ignore)

(defun edit-emacs ()
  (interactive)
  (find-file "~/dotfiles/emacs.d/init.el"))

(unbind-key (kbd "SPC") help-mode-map)

(require 'term)
(evil-define-key 'normal term-mode-map "\C-k" nil)
(evil-define-key 'normal term-mode-map "\C-j" nil)
(evil-define-key 'normal term-mode-map "\C-h" nil)
(evil-define-key 'normal term-mode-map "\C-l" nil)

(tool-bar-mode 0)
(menu-bar-mode 0)

(global-set-key [escape] 'keyboard-escape-quit)

(evil-set-initial-state 'pdf-view-mode 'emacs)

(add-to-list 'load-path "~/.emacs.d/elisp")
(load "fira-loader")

(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)

(desktop-save-mode 1)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)
