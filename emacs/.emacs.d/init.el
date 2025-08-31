;; -*- lexical-binding: t; -*-
;;; package --- Core package configuration
;;; Commentary:
;; This section configures the core packages used in the setup.
;;; Code:
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(setq use-package-always-ensure t   ;; Automatically install missing packages
      use-package-always-defer t)   ;; Defer loading by default for faster startup

;; Make sure Emacs daemon (via launchd) sees Homebrew's node
(when (eq system-type 'darwin)
  (let ((brew-bin
         (cond
          ((file-directory-p "/opt/homebrew/bin") "/opt/homebrew/bin") ; Apple Silicon
          ((file-directory-p "/usr/local/bin")   "/usr/local/bin"))))  ; Intel
    (when brew-bin
      (setenv "PATH" (concat brew-bin ":" (getenv "PATH")))
      (add-to-list 'exec-path brew-bin))))

;; ---------------------------------------
;; UI enhancements and core packages
;; ---------------------------------------

;; Company for auto-completion
(use-package company
  :hook (after-init . global-company-mode)
  :config
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.0))

;; Flycheck for diagnostics
(use-package flycheck
  :hook (prog-mode . flycheck-mode))

;; LSP mode (shared config for all languages)
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((python-mode . lsp-deferred)
         (go-mode . lsp-deferred))
  :init
  (setq lsp-keymap-prefix "C-c l") ;; Prefix for LSP commands
  :config
  (setq lsp-prefer-flymake nil     ;; Use flycheck instead of flymake
        lsp-disabled-clients '(pyls pylsp ruff ty-ls semgrep-ls)))

;; LSP UI extras
(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-sideline-enable t
        lsp-ui-sideline-show-hover t
        lsp-ui-doc-show-with-cursor t))

;; Helpful key hints
(use-package which-key
  :ensure t
  :init
  (which-key-mode 1))

;; --- Nerd Icons ---
(use-package nerd-icons
  :ensure t
  :config
  ;; installa i font automaticamente se non li trova
  (unless (member "Symbols Nerd Font Mono" (font-family-list))
    (ignore-errors (nerd-icons-install-fonts t))))

;; --- Doom Modeline ---
(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode)
  :init
  ;; alza un po' l'altezza della modeline
  (setq doom-modeline-height 25
        doom-modeline-bar-width 3
        doom-modeline-buffer-file-name-style 'truncate-with-project
        doom-modeline-icon t
        doom-modeline-major-mode-icon t
        doom-modeline-minor-modes nil
        doom-modeline-enable-word-count t
        doom-modeline-env-enable-python t))

;; Tema per Doom Emacs
(use-package doom-themes
  :ensure t
  :init
  ;; Carica il tema DOPO l'avvio completo
  :hook (after-init . (lambda () (load-theme 'doom-one t)))
  ;;(add-hook 'after-init-hook
  ;;          (lambda ()
  ;;            (load-theme 'doom-one t)))
  :config
  ;; Configura extra cose di doom-themes
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

;; 📦 Vertico: completamento verticale minimal
(use-package vertico
  :ensure t
  :init
  (vertico-mode 1) ;; abilita vertico globally
  ;; Mostra più candidati se vuoi
  (setq vertico-count 15
        vertico-resize t
        vertico-cycle t)) ;; ciclo quando scorri oltre la fine

;; 📖 Marginalia: aggiunge descrizioni accanto agli elementi
(use-package marginalia
  :ensure t
  :after vertico
  :init
  (marginalia-mode 1))

;; 🔍 Consult: comandi di ricerca e gestione migliorati
(use-package consult
  :ensure t
  :bind
  (("C-s"     . consult-line)           ;; 🔍 Cerca nel buffer corrente
   ("C-c s"   . consult-ripgrep)        ;; 🌐 Cerca in tutti i file (richiede ripgrep)
   ("C-x b"   . consult-buffer)         ;; 📄 Switch buffer + recenti
   ("C-x C-r" . consult-recent-file)    ;; 🕑 Lista file recenti
   ("M-g g"   . consult-goto-line)))      ;; 🔢 Vai a linea specifica


;; 🗂 Projectile: gestione progetti
(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :config
  ;; Usa ripgrep per le ricerche se disponibile
  (when (executable-find "rg")
    (setq projectile-generic-command "rg --files --hidden --glob '!.git/'"))
  ;; Fai sì che consult usi Vertico con Projectile
  (setq projectile-completion-system 'default)
  (setq projectile-project-search-path '("~/Projects" "~/go/src")))

;; 🧠 Orderless: fuzzy search smart
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

;; 🧹 Embark + which-key (opzionale per azioni contestuali)
(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)        ;; Azioni contestuali
   ("C-;" . embark-dwim)))     ;; Azione predefinita per contesto

(use-package embark-consult
  :after (embark consult)
  :ensure t)

;; Magit for Git
(use-package magit
  :ensure t
  :defer t
  :commands (magit-status magit-dispatch)
  :config
  (setq magit-display-buffer-function
        #'magit-display-buffer-same-window-except-diff-v1))


;; Async support for Magit and others
(use-package async
  :defer t)

;; Evil mode for Vim keybindings
(use-package evil
  :demand t
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-undo-system 'undo-redo)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; ---------------------------------------
;; Python IDE: Pyright + Black
;; ---------------------------------------

;; Add pyright to PATH if needed
(setenv "PATH" (concat (getenv "PATH") ":~/.npm/bin"))
(add-to-list 'exec-path "~/.npm/bin")

;; Pyright for Python LSP
(use-package lsp-pyright
  :after lsp-mode
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp-deferred)))
  :config
  (setq lsp-pyright-python-executable-cmd "python3"))

;; Black formatter for Python
(use-package blacken
  :hook (python-mode . blacken-mode)
  :config
  (setq blacken-line-length 88
        blacken-only-if-project-is-black-configured t))

;; Set Python shell
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt")

;; Virtual environments
(use-package virtualenvwrapper
  :ensure t
  :init
  (setq venv-location (getenv "WORKON_HOME")) ;; usually ~/.virtualenvs
  :config
  (venv-initialize-interactive-shells) ;; if you use M-x shell
  (venv-initialize-eshell)             ;; if you use eshell
)

;; ---------
;; Lisp IDE
;; ---------
;; SLY (Common Lisp IDE for Emacs)
(setq inferior-lisp-program
      (or (executable-find "sbcl")
          "/usr/local/bin/sbcl")) ; Intel Homebrew default; change if needed

(setq sly-use-slynk-bundled 'always)

(use-package sly
  :ensure t
  :defer t
  :hook (sly-connected . sly-mrepl))

;; Epub reader.
(use-package nov
  :ensure t
  :mode ("\\.epub\\'" . nov-mode))

;; ---------------------------------------
;; Go IDE: gopls + goimports
;; ---------------------------------------

;; Ensure gopls and goimports are installed:
;; go install golang.org/x/tools/gopls@latest
;; go install golang.org/x/tools/cmd/goimports@latest

(use-package go-mode
  :mode "\\.go\\'"
  :hook ((before-save . gofmt-before-save))
  :config
  ;; Use goimports instead of gofmt to auto-fix imports
  (setq gofmt-command "goimports"))

;; Extra Go keybindings
(with-eval-after-load 'go-mode
  (define-key go-mode-map (kbd "C-c C-r") 'lsp-rename)
  (define-key go-mode-map (kbd "C-c C-a") 'lsp-execute-code-action)
  (define-key go-mode-map (kbd "C-c C-d") 'lsp-describe-thing-at-point)
  (define-key go-mode-map (kbd "C-c C-f") 'gofmt))

(use-package copilot
  :ensure t
  :defer t
  :init
  ;; (setq copilot-node-executable "/opt/homebrew/bin/node")
  ;; mute Copilot warnings
  (add-to-list 'warning-suppress-types '(copilot))
  :config
  ;; if Copilot can't infer indent, return 2 instead of warning
  (advice-add 'copilot--infer-indentation-offset :around
              (lambda (orig &rest args)
                (or (ignore-errors (apply orig args)) 2)))
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . copilot-accept-completion)
              ("TAB" . copilot-accept-completion)
              ("C-TAB" . copilot-accept-completion-by-word)))

(use-package crontab-mode
  :ensure t
  :mode ("crontab\\'" . crontab-mode))

;; ---------------------------------------
;; C++ IDE (clangd assumed)
;; ---------------------------------------

;; Add C++ language standard for Flycheck
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flycheck-clang-language-standard "c++2b")
 '(flycheck-gcc-language-standard "c++2b")
 '(inhibit-startup-screen t)
 '(initial-scratch-message nil)
 '(package-selected-packages nil)
 '(scroll-step 1))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Disable menu bar
(menu-bar-mode -1)
(which-key-mode t)

(provide 'init)
;;; init.el ends here
