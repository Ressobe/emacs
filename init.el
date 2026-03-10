;; bootstrap straight
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;; straight use pacakge for theme (exception)
(straight-use-package
 '(everforest
   :type git
   :host github
   :repo "Theory-of-Everything/everforest-emacs"))
(load-theme 'everforest-hard-dark t)

;; (straight-use-package
;;  '(gruvbox-theme
;;    :type git
;;    :host github
;;    :repo "greduan/emacs-theme-gruvbox"))
;; (load-theme 'gruvbox-dark-medium)

(use-package emacs
  :init
  (defun my/apply-frame-settings (frame)
    (with-selected-frame frame
      (set-frame-parameter frame 'alpha 95)
      (set-face-attribute 'default frame :font "JetBrainsMono Nerd Font-11")
      (set-fringe-mode 10)))

  (add-hook 'after-make-frame-functions #'my/apply-frame-settings)
  (when (display-graphic-p)
    (my/apply-frame-settings (selected-frame)))


  (setq exec-path (append '("/usr/bin") exec-path))
  (setq-default tab-width 2
		            standard-indent 2
		            indent-tabs-mode nil)

  (setq inhibit-startup-message t
        display-line-numbers-type 'relative
        display-line-numbers-width 4
        ring-bell-function 'ignore
        help-window-select t
        word-wrap nil
        auto-hscroll-mode nil
        auto-window-vscroll nil
        top-margin-width 1
        gc-cons-threshold 100000000)

  (global-so-long-mode 1)
  (electric-pair-mode 1)
  (electric-indent-mode 1)

  :bind
  (("C-x k" . kill-current-buffer)
   ("C-c t" . vterm)
   ("C-c SPC" . completion-at-point)))

(use-package consult
  :demand t
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x C-b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g r" . consult-grep-match)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; The :init configuration is always executed (Not lazy)
  :init
  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  :config
  (setq consult-line-thing 'line
        consult-debug t))

(use-package evil
  :demand t
  :bind (("<escape>" . keyboard-escape-quit))
  :init
  (setq evil-undo-system 'undo-fu
        evil-want-C-u-scroll t
        evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config (evil-collection-init))

(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode))

(with-eval-after-load 'evil
  (evil-set-initial-state 'org-agenda-mode 'normal))

(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-display-icons-p t)
  (setq dashboard-icon-type 'nerd-icons)
  (setq dashboard-week-agenda t))


(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t))

(use-package vertico 
  :demand t
  :init 
  (vertico-mode)
  :config
  (setq vertico-count 20
        vertico-resize nil
        vertico-cycle t))

(use-package marginalia
  :bind (:map minibuffer-local-map ("M-A" . marginalia-cycle))
  :init (marginalia-mode))

(use-package doom-modeline
  :init (doom-modeline-mode 1))

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package magit)

(use-package git-gutter
  :hook (prog-mode . git-gutter-mode)
  :config (setq git-gutter:update-interval 0.2))

(use-package git-gutter-fringe
  :config
  (define-fringe-bitmap 'git-gutter-fr:added [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:modified [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240] nil nil 'bottom))

(defun efs/org-mode-setup () (org-indent-mode))

(use-package org
  :ensure nil
  :hook (org-mode . efs/org-mode-setup)
  :custom
  (org-clock-persistence-insinuate)
  :bind (("C-c c" . org-capture)
         ("C-c a" . org-agenda)
         ("C-c l" . org-store-link))
  :init
  (setq org-directory "~/org")
  :config
  (setq org-M-RET-may-split-line '((default . nil))
        org-insert-heading-respect-content t
        org-log-done 'time
        org-log-into-drawer t
        org-hide-emphasis-markers t
        org-todo-keywords
        '((sequence "TODO(t)" "WAIT(w!)" "CANCEL(c!)" "DONE(d!)")))

  (setq org-agenda-files
        (seq-filter
         (lambda (f)
           (not (string-match-p "/archive/" f)))
         (directory-files-recursively org-directory "\\.org$")))

  (setq org-agenda-custom-commands
        '(("p" "Planning"
           ((tags-todo "+@planning"
                       ((org-agenda-overriding-header "Planning Tasks")))
            (tags-todo "-{.*}"
                       ((org-agenda-overriding-header "Untagged Tasks")))
            (todo ".*" ((org-agenda-files '("~/org/inbox.org"))
                        (org-agenda-overriding-header "Unprocessed Inbox Items")))))

          ("d" "Daily Agenda"
           ((agenda "" ((org-agenda-span 'day)
                        (org-deadline-warning-days 7)))
            (tags-todo "+PRIORITY=\"A\""
                       ((org-agenda-overriding-header "High Priority Tasks")))))

          ("w" "Weekly Review"
           ((agenda ""
                    ((org-agenda-overriding-header "Completed Tasks")
                     (org-agenda-skip-function '(org-agenda-skip-entry-if 'nottodo 'done))
                     (org-agenda-span 'week)))

            (agenda ""
                    ((org-agenda-overriding-header "Unfinished Scheduled Tasks")
                     (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                     (org-agenda-span 'week)))))))


  (setq org-clock-persist 'history)

  (setq org-capture-templates
        '(("t" "Todo" entry
           (file+headline "~/org/inbox.org" "Tasks")
           "* TODO %?\n  %i\n  %a")
          ("j" "Journal" entry
           (file+olp+datetree "~/org/journal.org")
           "* %?\nEntered on %U\n  %i\n  %a"))))

(use-package org-roam
  :custom (org-roam-directory "~/org")
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert))
  :config (org-roam-setup))


(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(use-package undo-fu)
(use-package undo-fu-session
  :after undo-fu
  :config (undo-fu-session-global-mode))

(use-package vterm)

(use-package eshell
  :ensure nil
  :commands (eshell)
  :bind (("C-`" . my/eshell-toggle)
         ("C-c e" . my/eshell-switch))

  :init
  (defvar my/eshell-window-height 0.3)
  (defvar my/eshell-last-buffer nil)

  ;; --------------------------------
  ;; helpers
  ;; --------------------------------

  (defun my/eshell--buffer-name (name)
    (format "*eshell:%s*" name))

  (defun my/eshell--get-or-create (name)
    (let* ((buf-name (my/eshell--buffer-name name))
           (buf (get-buffer buf-name)))
      (unless buf
        (setq buf
              (save-window-excursion
                (eshell)
                (rename-buffer buf-name t)
                (current-buffer))))
      buf))

  (defun my/eshell--display (buf)
    ;; przypisz bufor do aktualnej perspective
    (when (bound-and-true-p persp-mode)
      (persp-add-buffer buf))

    (display-buffer-in-side-window
     buf
     `((side . bottom)
       (slot . 0)
       (window-height . ,my/eshell-window-height)))

    (select-window (get-buffer-window buf))
    (goto-char (point-max))

    (when (bound-and-true-p evil-mode)
      (evil-insert-state)))

  ;; --------------------------------
  ;; toggle current / last
  ;; --------------------------------

  (defun my/eshell-toggle ()
    (interactive)
    (let* ((current (current-buffer))
           (is-eshell (derived-mode-p 'eshell-mode))
           (target
            (cond
             ;; jeśli jesteś w eshellu → toggle jego
             (is-eshell current)
             ;; jeśli nie → użyj ostatniego
             (my/eshell-last-buffer my/eshell-last-buffer)
             ;; fallback → stwórz main
             (t (my/eshell--get-or-create "main")))))
      
      (setq my/eshell-last-buffer target)

      (let ((win (get-buffer-window target)))
        (if win
            (delete-window win)
          (my/eshell--display target)))))

  ;; --------------------------------
  ;; switch / create
  ;; --------------------------------

  (defun my/eshell-switch ()
    (interactive)
    (let* ((buffers (seq-filter
                     (lambda (b)
                       (with-current-buffer b
                         (derived-mode-p 'eshell-mode)))
                     (buffer-list)))
           (names (mapcar
                   (lambda (b)
                     (string-remove-prefix
                      "*eshell:"
                      (string-remove-suffix "*"
                                            (buffer-name b))))
                   buffers))
           (choice (completing-read "Eshell: " names nil nil)))
      (let ((buf (my/eshell--get-or-create choice)))
        (setq my/eshell-last-buffer buf)
        (my/eshell--display buf))))

  ;; --------------------------------
  ;; eshell config
  ;; --------------------------------

  :config
  (setq eshell-history-size 10000
        eshell-scroll-to-bottom-on-input t
        eshell-scroll-to-bottom-on-output t
        eshell-destroy-buffer-when-process-dies t
        eshell-banner-message "")

  (setq eshell-prompt-function
        (lambda ()
          (concat
           (propertize
            (abbreviate-file-name (eshell/pwd))
            'face '(:foreground "#7fbbb3"))
           (propertize " λ "
                       'face '(:foreground "#a7c080")))))

  (setq eshell-prompt-regexp "^[^λ]* λ ")

  ;; zapamiętuj ostatni aktywny
  (add-hook 'eshell-mode-hook
            (lambda ()
              (setq my/eshell-last-buffer (current-buffer)))))

(use-package docker
  :bind ("C-c d" . docker))

(use-package compile
  :defer t
  :hook ((compilation-filter . ansi-color-compilation-filter))
  :config
  (setopt compilation-scroll-output t)
  (setopt compilation-ask-about-save nil)
  (require 'ansi-color))


(defun my/lsp-capf-setup ()
  (add-hook 'completion-at-point-functions
            #'lsp-completion-at-point nil t))

(defun my/lsp-evil-bindings ()
  "Setup evil-normal-state keybinds for lsp-enabled buffers."
  (evil-local-set-key 'normal "gd" #'xref-find-definitions)
  (evil-local-set-key 'normal "gr" #'xref-find-references)
  (evil-local-set-key 'normal "gi" #'xref-find-implementations)
  (evil-local-set-key 'normal "gt" #'xref-find-type-definitions)
  (evil-local-set-key 'normal "rn" #'lsp-rename))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((prog-mode . lsp-deferred)
         (lsp-completion-mode . my/lsp-capf-setup)
         (lsp-mode . my/lsp-evil-bindings))
  :custom
  (read-process-output-max (* 1024 1024))
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-warn-no-matched-clients nil)
  (lsp-completion-no-cache t)
  (lsp-idle-delay 0.2)
  (lsp-keymap-prefix "C-c l")
  (lsp-diagnostics-provider :auto))

(use-package lsp-ui
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-show-code-actions nil)
  (lsp-ui-sideline-show-hover nil)
  (lsp-ui-doc-enable nil)
  (lsp-ui-sideline-delay 0))

(use-package dap-mode)

(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.2)
  (corfu-popupinfo-delay '(0 . 0))
  (corfu-preview-current 'insert)
  (corfu-preselect 'prompt)
  (corfu-on-exact-match t)
  :bind
  (:map corfu-map
        ("C-n" . corfu-next)
        ("C-p" . corfu-previous)
        ("RET" . corfu-insert)
        ("TAB" . corfu-insert)
        ("SPC"  . corfu-insert))
  :init
  (global-corfu-mode)
  (corfu-history-mode))

(use-package nerd-icons-corfu
  :after corfu
  :init
  (add-to-list 'corfu-margin-formatters
               #'nerd-icons-corfu-formatter))

(use-package apheleia
  :hook (prog-mode . apheleia-mode)
  :init
  (setq apheleia-formatters-respect-project-root t)
  :config
  (setf (alist-get 'prettier apheleia-formatters)
        '("npx" "prettier" "--stdin-filepath" filepath)))

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (setq treesit-auto-langs '(javascript typescript tsx css html))
  (treesit-auto-add-to-auto-mode-alist
   '(javascript typescript tsx css html))
  (global-treesit-auto-mode))

(use-package perspective
  :demand t
  :custom
  (persp-mode-prefix-key (kbd "C-c p"))
  (persp-state-default-file
   (expand-file-name "perspectives-state.el" user-emacs-directory))
  :init
  (persp-mode)
  :config
  (defun my/persp-auto-save (&rest _)
    (when (and persp-state-default-file
               (stringp persp-state-default-file))
      (persp-state-save persp-state-default-file)))

  (add-hook 'kill-emacs-hook #'my/persp-auto-save)
  (add-hook 'delete-frame-functions #'my/persp-auto-save)
  (add-hook 'emacs-startup-hook
            (lambda ()
              (when (and persp-state-default-file
                         (file-exists-p persp-state-default-file))
                (persp-state-load persp-state-default-file))))

  (with-eval-after-load 'consult
    (consult-customize consult-source-buffer
                       :hidden t
                       :default nil)

    (add-to-list 'consult-buffer-sources
                 persp-consult-source)))

(use-package newsticker
  :ensure nil
  :commands (newsticker-show-news)
  :init

  ;; --- CSV loader ---
  (defun my/newsticker-load-youtube-csv (file)
    "Load YouTube channels from CSV and return newsticker feed list."
    (when (file-exists-p file)
      (with-temp-buffer
        (insert-file-contents file)
        (let (feeds)
          (dolist (line (split-string (buffer-string) "\n" t))
            (unless (string-prefix-p "#" line) ;; allow comments
              (let* ((parts (split-string line ","))
                     (name (string-trim (car parts)))
                     (id   (string-trim (cadr parts))))
                (when (and name id)
                  (push
                   (list (concat "YouTube - " name)
                         (format "https://www.youtube.com/feeds/videos.xml?channel_id=%s" id)
                         nil nil nil)
                   feeds)))))
          (nreverse feeds)))))

  (let* ((csv-file (expand-file-name "rss/youtube.csv"
                                     user-emacs-directory))
         (youtube-feeds (my/newsticker-load-youtube-csv csv-file)))

    (setq newsticker-url-list
          (append
           '(("Hacker News"
              "https://hnrss.org/frontpage"
              nil nil nil))
           youtube-feeds)))

  (setq newsticker-retrieval-interval 900)

  (defun my/close-newsticker ()
    "Kill all tree-view related buffers."
    (kill-buffer "*Newsticker List*")
    (kill-buffer "*Newsticker Item*")
    (kill-buffer "*Newsticker Tree*"))

  (advice-add 'newsticker-treeview-quit :after 'my/close-newsticker))

(use-package go-mode)
(use-package zig-mode)
(use-package templ-ts-mode)
