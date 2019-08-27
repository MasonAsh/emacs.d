(defun my-correct-symbol-bounds (pretty-alist)
  "Prepend a TAB character to each symbol in this alist,
this way compose-region called by prettify-symbols-mode
will use the correct width of the symbols
instead of the width measured by char-width."
  (mapcar (lambda (el)
	    (setcdr el (string ?\t (cdr el)))
	    el)
	  pretty-alist))

(defun my-ligature-list (ligatures codepoint-start)
  "Create an alist of strings to replace with
codepoints starting from codepoint-start."
  (let ((codepoints (-iterate '1+ codepoint-start (length ligatures))))
    (-zip-pair ligatures codepoints)))

(setq my-fira-code-ligatures
      (let* ((ligs '("www" "**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\"
		     "{-" "[]" "::" ":::" ":=" "!!" "!=" "!==" "-}"
		     "--" "---" "-->" "->" "->>" "-<" "-<<" "-~"
		     "#{" "#[" "##" "###" "####" "#(" "#?" "#_" "#_("
		     ".-" ".=" ".." "..<" "..." "?=" "??" ";;" "/*"
		     "/**" "/=" "/==" "/>" "//" "///" "&&" "||" "||="
		     "|=" "|>" "^=" "$>" "++" "+++" "+>" "=:=" "=="
		     "===" "==>" "=>" "=>>" "<=" "=<<" "=/=" ">-" ">="
		     ">=>" ">>" ">>-" ">>=" ">>>" "<*" "<*>" "<|" "<|>"
		     "<$" "<$>" "<!--" "<-" "<--" "<->" "<+" "<+>" "<="
		     "<==" "<=>" "<=<" "<>" "<<" "<<-" "<<=" "<<<" "<~"
		     "<~~" "</" "</>" "~@" "~-" "~=" "~>" "~~" "~~>" "%%"
		     "x" ":" "+" "+" "*")))
	(my-correct-symbol-bounds (my-ligature-list ligs #Xe100))))

;; nice glyphs for haskell with hasklig
(defun my-set-hasklig-ligatures ()
  "Add hasklig ligatures for use with prettify-symbols-mode."
  (setq prettify-symbols-alist
	(append my-hasklig-ligatures prettify-symbols-alist))
  (prettify-symbols-mode))

(add-hook 'intero-mode-hook 'my-set-hasklig-ligatures)
