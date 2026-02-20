(setq package-enable-at-startup nil)

(setq scroll-margin 5
      scroll-conservatively 10000
      scroll-step 1
      next-screen-context-lines 5
      scroll-preserve-screen-position t
      fast-but-imprecise-scrolling t)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode 1)
(blink-cursor-mode 0)
(show-paren-mode 1)
(visual-line-mode -1)


(dolist (dir '("auto-save" "backups" "lock"))
  (let ((path (expand-file-name dir user-emacs-directory)))
    (unless (file-directory-p path)
      (make-directory path t))))

(setq backup-directory-alist `(("." . ,(locate-user-emacs-file "backups")))
      vc-make-backup-files t
      version-control t
      kept-old-versions 0
      kept-new-versions 10
      delete-old-versions t
      backup-by-copying t)

(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-save/" user-emacs-directory) t)))

(setq lock-file-name-transforms
      `((".*" ,(expand-file-name "lock/" user-emacs-directory) t)))

(fset 'yes-or-no-p 'y-or-n-p)


(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))

;; Line numbers in prog-mode
(add-hook 'prog-mode-hook
          (lambda ()
            (setq-local display-line-numbers-width 4)
            (display-line-numbers-mode 1)))

;; YAML indentation
(add-hook 'yaml-mode-hook
          (lambda ()
            (setq yaml-indent-offset 2)))

;; Disable line numbers in some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                vterm-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))
