;;
;;
;;
;;   𝓙.𝓞𝓹𝓹𝓵𝓲𝓰𝓮𝓻 
;;
;;
;;

;; Better defaults
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(horizontal-scroll-bar-mode -1)
(menu-bar-mode -1)
(delete-selection-mode 1)

(setq user-emacs-directory (expand-file-name "~/.config/emacs/"))
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(setq backup-directory-alist `(("." . ,(expand-file-name "backups" user-emacs-directory))))
(setq auto-save-file-name-transforms `((".*" ,(expand-file-name "auto-saves/" user-emacs-directory) t)))
(setq url-history-file (expand-file-name "url/history" user-emacs-directory))
(setq recentf-save-file (expand-file-name "recentf" user-emacs-directory))

(setq column-number-mode t)
(setq line-number-mode t)

(fset 'yes-or-no-p 'y-or-n-p)

(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(setq ring-bell-function 'ignore)
(setq visible-bell nil)

(setq-default cursor-type 'bar)
(setq-default frame-title-format nil)

(setq-default window-divider-default-bottom-width 1)
(setq-default window-divider-default-top-width 1)
(window-divider-mode 1)

(setq-default frame-resize-pixelwise t)
(setq-default default-frame-alist '((internal-border-width . 20)))

(setq-default default-frame-alist
              (append '((left-fringe . 0)
                        (right-fringe . 0))
                      default-frame-alist))

;; Use straight with use-package
(setq straight-use-package-by-default t)

(let ((bootstrap-file (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

;; Fonts
(set-face-attribute 'default nil :font "Fira Code" :height 120)

;; Use tree-sitter
(setq major-mode-remap-alist
      '((python-mode . python-ts-mode)
        (js-mode . js-ts-mode)
        (css-mode . css-ts-mode)
        (yaml-mode . yaml-ts-mode)
        (bash-mode . bash-ts-mode)
        (c-mode . c-ts-mode)
        (c++-mode . c++-ts-mode)
        (json-mode . json-ts-mode)
        (java-mode . java-ts-mode)
        (typescript-mode . typescript-ts-mode)))

(setq treesit-language-source-alist
   '((bash "https://github.com/tree-sitter/tree-sitter-bash")
     (cmake "https://github.com/uyha/tree-sitter-cmake")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     (go "https://github.com/tree-sitter/tree-sitter-go")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (make "https://github.com/alemuller/tree-sitter-make")
     (markdown "https://github.com/ikatyang/tree-sitter-markdown")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

(unless (file-directory-p treesit-language-source-directory)
  (make-directory treesit-language-source-directory t)
  (mapc #'treesit-install-language-grammar
        (mapcar #'car treesit-language-source-alist)))

;; Packages
(use-package vertico
  :straight t
  :init
  (vertico-mode))

(use-package orderless
  :straight t
  :custom
  (completion-styles '(orderless))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :straight t
  :init
  (marginalia-mode))

(use-package consult
  :straight t)

(use-package embark
  :straight t
  :bind
  (("C-." . embark-act)))

(use-package embark-consult
  :straight t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package dired
  :straight nil
  :ensure nil
  :custom
  (dired-listing-switches "-alh --group-directories-first")
  :bind
  (:map dired-mode-map
	("RET" . dired-find-alternate-file)
        ("<backspace>" . (lambda () (interactive) (find-alternate-file "..")))))

(use-package dired-sidebar
  :straight t
  :commands (dired-sidebar-toggle-sidebar)
  :custom
  (dired-sidebar-theme 'nerd)
  (dired-sidebar-use-term-integration t)
  (dired-sidebar-use-custom-font t))

(use-package diredfl
  :straight t
  :hook (dired-mode . diredfl-mode))

(use-package all-the-icons
  :straight t
  :config
  (unless (find-font (font-spec :name "all-the-icons"))
    (all-the-icons-install-fonts t)))

(use-package all-the-icons-dired
  :straight t
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package doom-modeline
  :straight t
  :init
  (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 15)
  (doom-modeline-bar-width 3)
  (doom-modeline-minor-modes nil)
  (doom-modeline-icon t)
  (doom-modeline-major-mode-icon t)
  (doom-modeline-buffer-file-name-style 'truncate-upto-project))

(use-package doom-themes
  :straight t
  :config
  (load-theme 'doom-tokyo-night t)
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t))

(use-package markdown-mode
  :straight t
  :mode ("\\.md\\'" "\\.markdown\\'")
  :custom
  (markdown-command "pandoc"))

(use-package recentf
  :straight nil
  :ensure nil
  :init
  (recentf-mode 1)
  :custom
  (recentf-max-saved-items 200)
  (recentf-auto-cleanup 'never)
  (recentf-exclude '("^/tmp/" "^/ssh:"))
  :config
  (add-to-list 'recentf-exclude "\\.gpg$"))

(use-package rainbow-delimiters
  :straight t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package windmove
  :straight nil
  :ensure nil
  :config
  (windmove-default-keybindings 'shift))

(use-package org
  :straight t
  :config
  (setq org-hide-emphasis-markers t)
  (setq org-startup-indented t)
  (setq org-ellipsis " ▾"))

(use-package org-roam
  :straight t
  :custom
  (org-roam-directory (file-truename "~/org-roam"))
  (org-roam-v2-ack t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture))
  :config
  (org-roam-db-autosync-mode))

(use-package org-superstar
  :straight t
  :hook (org-mode . org-superstar-mode))

(use-package org-download
  :straight t
  :hook ((org-mode dired-mode) . org-download-enable))

(use-package toc-org
  :straight t
  :hook ((org-mode markdown-mode) . toc-org-mode))

(use-package ox-hugo
  :straight t
  :after ox)

(use-package deft
  :straight t
  :custom
  (deft-directory "~/Documents/org")
  (deft-extensions '("org" "md" "txt"))
  (deft-recursive t)
  :bind ("C-c n d" . deft))

(use-package vterm
  :straight t
  :custom
  (vterm-always-compile-module t)
  (vterm-max-scrollback 10000))