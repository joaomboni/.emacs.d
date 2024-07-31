;; Remover boas vindas
(setq inhibit-startup-message t)

;; fonte jetbrains - 1° pacman -S ttf-jetbrains-mono
(set-face-attribute 'default nil :font "JetBrains Mono-12")  ;; Tamanho da fonte 12

;; Ativar electric-pair-mode globalmente
(electric-pair-mode 1)

;; Configura espaco tab
(setq-default tab-width 4)

;; Remover menus
(tool-bar-mode -1)

;; Numeros nas linhas
(global-display-line-numbers-mode t)

;; Alterar a cor dos comentários para um tom mais opaco
(custom-set-faces
 '(font-lock-comment-face ((t (:foreground "#6c757d" :italic t)))))


  ;;terminal zsh
(defun open-ansi-term-zsh-bottom ()
  "Abrir um terminal `ansi-term` usando `zsh` na parte inferior do buffer."
  (interactive)
  ;; Divide a janela horizontalmente e move o foco para a janela inferior
  (split-window-vertically)
  (other-window 1)
  ;; Abre `ansi-term` com `zsh` na janela inferior
  (ansi-term "/bin/zsh"))
;; Atribuir uma tecla de atalho para abrir o terminal `ansi-term` com `zsh` na parte inferior
(global-set-key (kbd "C-c t") 'open-ansi-term-zsh-bottom)

; Adiciona repositórios MELPA para instalar pacotes
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; Atualiza a lista de pacotes se necessário
(unless package-archive-contents
  (package-refresh-contents))

;; Instala use-package se não estiver instalado
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; Carrega use-package e configura para garantir que todos os pacotes sejam instalados automaticamente
(require 'use-package)
(setq use-package-always-ensure t)

;; TEMAS
;(use-package spacemacs-theme
 ; :ensure t
  ;:defer t
  ;:init (load-theme 'spacemacs-dark t))

(use-package timu-macos-theme
  :ensure t
  :defer t
  :init (load-theme 'timu-macos t))
(customize-set-variable 'timu-macos-flavour "dark")


(use-package try
  :ensure t)

(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol)

(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package treemacs
  :ensure t
  :config
  (setq treemacs-is-never-other-window t)
  (add-hook 'emacs-startup-hook 'treemacs))



;; Habilitar a funcionalidade de redimensionamento de janelas com o mouse
(window-divider-mode 1)

;; Personalizar a aparência das divisórias (opcional)
;; (setq window-divider-default-right-width 3)
;; (setq window-divider-default-places 'right-only)
(use-package auto-complete
  :ensure t
  :config
  (require 'auto-complete-config)
  (ac-config-default)
  (setq ac-auto-start nil)
  (setq ac-quick-help-delay 0.5)
  (define-key ac-mode-map [(control tab)] 'auto-complete)

  (defun my-ac-config ()
    (setq-default ac-sources '(ac-source-abbrev ac-source-dictionary ac-source-words-in-same-mode-buffers))
    (add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)
    (add-hook 'ruby-mode-hook 'ac-ruby-mode-setup)
    (add-hook 'css-mode-hook 'ac-css-mode-setup)
    (add-hook 'auto-complete-mode-hook 'ac-common-setup)
    (global-auto-complete-mode t))

  (my-ac-config))

(use-package auto-complete-clang
  :ensure t
  :config
  (defun my-ac-cc-mode-setup ()
    (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources)))
  (add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup))

(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode))

;; Redefine C-z para desfazer
(global-set-key (kbd "C-z") 'undo-tree-undo)
(global-set-key (kbd "C-S-z") 'undo-tree-redo) ;; C-S-z para refazerackage undo-tree

;; Company Mode
(use-package company
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.0)   ;; Tempo de espera para sugestões aparecerem
  (setq company-minimum-prefix-length 1)) ;; Número mínimo de caracteres para iniciar autocompletar

;;Linguagens WEB
;; Web Mode
(use-package web-mode
  :mode ("\\.html?\\'" "\\.css\\'" "\\.php\\'" "\\.js\\'")
  :config
  (setq web-mode-markup-indent-offset 2) ;; Indentação para HTML
  (setq web-mode-css-indent-offset 2)    ;; Indentação para CSS
  (setq web-mode-code-indent-offset 2)   ;; Indentação para código (JS, PHP, etc.)
  (setq web-mode-enable-auto-quoting nil)) ;; Desativa auto-quoting

;; JS2 Mode
(use-package js2-mode
  :mode "\\.js\\'"
  :config
  (setq js2-basic-offset 2)) ;; Indentação para JS



;;PHP
;; Instalar e configurar lsp-mode para PHP
(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (php-mode . lsp-deferred)
  :config
  (setq lsp-clients-php-server-command "/usr/bin/intelephense"
        lsp-prefer-flymake nil))


;; Configurações adicionais para aprimorar a experiência com LSP
(use-package lsp-treemacs
  :commands lsp-treemacs-errors-list)

;; Instalar php-mode para arquivos PHP
(use-package php-mode
  :ensure t
  :mode ("\\.php\\'" . php-mode))

;; Configuração adicional para garantir destaque de sintaxe
(global-font-lock-mode t)

;; Adicionar highlight para funções nativas do PHP
(font-lock-add-keywords 'php-mode
  '(("\\<\\(substr\\|strlen\\|array_push\\|implode\\|explode\\|in_array\\|is_int\\|print_r\\|echo\\)\\>" . font-lock-function-name-face)))

;; Configuração adicional para garantir destaque de sintaxe
(add-hook 'php-mode-hook
          (lambda ()
            (font-lock-mode 1)))


;; Configuração para exibir erro no modo php
(add-hook 'php-mode-hook
          (lambda ()
            (setq-local eldoc-documentation-function 'php-eldoc-function)
            (eldoc-mode t)))





;; Configuração do lsp-ui
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-use-webkit t
        lsp-ui-doc-delay 0.5
        lsp-ui-doc-include-signature t
        lsp-ui-sideline-enable t
        lsp-ui-sideline-show-hover t
        lsp-ui-sideline-show-code-actions t
        lsp-ui-sideline-show-diagnostics t))


;; Flycheck
(use-package flycheck
  :hook (after-init . global-flycheck-mode)
  :config
  (setq flycheck-check-syntax-automatically '(save mode-enabled))) ;; Verifica sintaxe ao salvar e ativar modo


;; YAML Mode
(use-package yaml-mode
  :ensure t
  :mode "\\.yml\\'"
  :hook (yaml-mode . lsp-deferred)
  :config
  (setq yaml-indent-offset 2) ;; Indentação para YAML
  
  ;; Função para indentar todo o buffer YAML
  (defun my-yaml-reformat-buffer ()
    "Reformat the entire YAML buffer."
    (interactive)
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "^\\( *\\)\\(.*\\)$" nil t)
        (replace-match (concat (make-string (* yaml-indent-offset (current-indentation)) ? )
                               (match-string 2)))
        (forward-line 1))))

  ;; Associar a função a um atalho de teclado (exemplo: C-c C-f)
  (define-key yaml-mode-map (kbd "C-c C-f") 'my-yaml-reformat-buffer))


;; XML 
(use-package xml-format
  :demand t
  :after nxml-mode)
(global-set-key (kbd "C-c m") 'xml-format-buffer)




;;intelephense no PATH do emacs
(let ((php-bin-dir "/usr/bin/intelephense"))
  (setenv "PATH" (concat php-bin-dir ":" (getenv "PATH")))
  (add-to-list 'exec-path php-bin-dir))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(which-key web-mode undo-tree try lsp-ui lsp-pyright lsp-ivy js2-mode flycheck ccls auto-complete-clang)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

