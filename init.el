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
  :global
  :lighter " global-evil-keys"
  :keymap global-evil-keys-map)
(define-globalized-minor-mode global-evil-keys-mode global-evil-keys global-evil-keys)

(global-evil-keys-mode)

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
  ;; (evil-define-key nil evil-normal-state-map (kbd "SPC b") 'switch-to-buffer)
  (evil-define-key nil evil-visual-state-map (kbd "C-/") 'comment-dwim)
  (evil-define-key nil evil-normal-state-map (kbd "SPC RET") 'evil-ex-nohighlight)
  (dolist (state '(normal visual insert))
  (evil-make-intercept-map
   (evil-get-auxiliary-keymap global-evil-keys-map state t t)
   state)))

(use-package evil-collection
  :after evil magit
  :ensure t
  :custom (evil-collection-setup-minibuffer t)
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

(defvar gdb-default-command-line nil "Default option to pass to gdb.")

(defun compile-and-debug()
  "Compile and run a program."
  (interactive)
  (call-interactively 'recompile)
  (gdb gdb-default-command-line))

(use-package general
  :ensure t
  :after evil-collection
  :config
  (general-define-key
   :states '(motion normal)
   :keymaps 'global-evil-keys-map
   "C-j" 'windmove-down)
  (general-define-key
   :states '(motion normal)
   :keymaps 'global-evil-keys-map
   "C-k" 'windmove-up)
  (general-define-key
   :states '(motion normal)
   :keymaps 'global-evil-keys-map
   "C-h" 'windmove-left)
  (general-define-key
   :states '(motion normal)
   :keymaps 'global-evil-keys-map
   "C-l" 'windmove-right)
  (general-define-key
   :states 'normal
   :keymaps '(c-mode-map c++-mode-map objc-mode-map)
   "<f5>" 'compile-and-debug)
  (general-create-definer leader-key-def
    :states '(normal motion emacs)
    :keymap 'global-evil-keys
    :prefix "SPC"))

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
   :keymaps 'global-evil-keys-map
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
   :keymaps 'global-evil-keys-map
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

(use-package company-quickhelp
  :ensure t
  :config
  (company-quickhelp-mode))

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

(use-package multi-line
  :after general
  :ensure t
  :config
  (general-define-key
   :states 'normal
   "gS" 'multi-line)
  (setq-default multi-line-current-strategy
              (multi-line-strategy
               :respace (multi-line-default-respacers
                         (make-instance 'multi-line-always-newline)))))

(use-package rust-mode
  :ensure t)

(use-package magit
  :ensure t)

(use-package evil-magit
  :ensure t
  :after magit)

(use-package yasnippet
  :ensure t
  :after general
  :config
  (yas-reload-all)
  (general-define-key
   :states 'insert
   "TAB" 'yas-maybe-expand)
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :ensure t
  :after yasnippet)

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

(define-minor-mode org-latex-auto-export-mode
  "Auto exports to pdf in org-mode when enabled"
  :init-value nil
  :lighter "Org Latex Auto Export"
  :keymap nil
  :global nil
  (interactive (list (or current-prefix-arg 'toggle)))
  (let ((enable
	 (if (eq arg 'toggle)
	     (not org-latex-auto-export-mode) ; this is the mode's mode variable
	   (> (prefix-numeric-value arg) 0))))
    (if enable
	(add-hook 'after-save-hook 'org-latex-export-to-pdf nil t)
      (remove-hook 'after-save-hook 'org-latex-export-to-pdf t))))

(require 'display-line-numbers)
(setq display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

(defun risky-local-variable-p (sym &optional _ignored) nil)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)
