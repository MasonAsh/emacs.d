(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes (quote (tsdh-dark)))
 '(evil-collection-setup-minibuffer t)
 '(haskell-interactive-popup-errors nil)
 '(inhibit-startup-screen t)
 '(org-format-latex-options
   (quote
    (:foreground default :background default :scale 2.0 :html-foreground "Black" :html-background "Transparent" :html-scale 1.0 :matchers
		 ("begin" "$1" "$" "$$" "\\(" "\\["))))
 '(package-selected-packages
   (quote
    (company-quickhelp yasnippet-snippets evil-magit magit rust-mode multi-line flycheck-rtags rtags use-package key-chord irony intero helm-projectile general evil-surround evil-exchange evil-easymotion evil-collection)))
 '(safe-local-variable-values
   (quote
    ((gdb-default-command-line eval concat "gdb -i=mi bin/"
			       (file-name-base buffer-file-name))
     (gdb-default-command-line eval
			       (concat "gdb -i=mi bin/"
				       (file-name-base buffer-file-name)))
     (gdb-default-command-line concat "gdb -i=mi bin/"
			       (file-name-base buffer-file-name))
     (compile-command concat "make -k "
		      (file-name-base buffer-file-name))
     (gdb-command-name concat "gdb -i=mi bin/"
		       (file-name-base buffer-file-name)))))
 '(whitespace-style
   (quote
    (face trailing tabs empty indentation::space space-after-tab space-before-tab tab-mark))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
