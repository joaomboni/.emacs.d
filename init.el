;; Remover boas vindas
(setq inhibit-startup-message t)

(set-face-attribute 'default nil :font "JetBrains Mono-12")  ;; Ajuste o tamanho da fonte conforme necessário

;; Configura espaco tab
(setq-default tab-width 4)

;; Remover menus
(tool-bar-mode -1)

;; Numeros nas linhas
(global-display-line-numbers-mode t)

;; Tamanho da fonte
;;(set-face-attribute 'default nil :height 100)


;; Adiciona repositórios MELPA para instalar pacotes
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


(use-package try
  :ensure t)

(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package auto-complete
  :ensure t
  :init
  (progn
    (ac-config-default)
    (global-auto-complete-mode t)))

(use-package treemacs
  :ensure t
  ;;:bind
  ;;(:map global-map
  ;;("C-x j"
  :config
  (setq treemacs-is-never-other-window t)
  (add-hook 'emacs-startup-hook 'treemacs))

;;(global-set-key (kbd "C-x j") 'treemacs)

;; Habilitar a funcionalidade de redimensionamento de janelas com o mouse
(window-divider-mode 1)

;; Personalizar a aparência das divisórias (opcional)
;; (setq window-divider-default-right-width 3)
;; (setq window-divider-default-places 'right-only)



;;temas
;(use-package spacemacs-theme
 ; :ensure t
  ;:defer t
  ;:init (load-theme 'spacemacs-dark t))

(use-package timu-macos-theme
  :ensure t
  :defer t
  :init (load-theme 'timu-macos t))
(customize-set-variable 'timu-macos-flavour "dark")

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

;; Company Mode
(use-package company
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.0)   ;; Tempo de espera para sugestões aparecerem
  (setq company-minimum-prefix-length 1)) ;; Número mínimo de caracteres para iniciar autocompletar

;; Auto-Complete
(use-package auto-complete
  :config
  (ac-config-default))

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

;; Python Mode
(use-package python-mode
  :mode "\\.py\\'"
  :hook (python-mode . lsp-deferred) ;; Usa LSP (Language Server Protocol) para autocompletar avançado
  :config
  (setq python-indent-offset 4)) ;; Indentação para Python

;; Rust Mode
(use-package rust-mode
  :mode "\\.rs\\'"
  :hook (rust-mode . lsp-deferred)
  :config
  (setq rust-format-on-save t)) ;; Formata o código ao salvar

;; C/C++ Mode
(use-package cc-mode
  :mode ("\\.c\\'" "\\.cpp\\'" "\\.h\\'")
  :hook ((c-mode . lsp-deferred)
         (c++-mode . lsp-deferred))
  :config
  (setq c-basic-offset 4) ;; Indentação para C/C++
  (setq-default c-basic-offset 4))

;; Java Mode
(use-package lsp-java
  :config (add-hook 'java-mode-hook 'lsp))

;; YAML Mode
(use-package yaml-mode
  :mode "\\.yml\\'"
  :hook (yaml-mode . lsp-deferred)
  :config
  (setq yaml-indent-offset 2)) ;; Indentação para YAML

(use-package xml-format
  :demand t
  :after nxml-mode)
(global-set-key (kbd "C-c m") 'xml-format-buffer)

;; php Mode
(use-package php-mode
  :mode "\\.php\\'"
  :hook (php-mode . lsp-deferred)
  :config
  (setq php-format-on-save t)  ;; Formatar ao salvar (se aplicável)
  (add-hook 'php-mode-hook
            (lambda ()
			  (set (make-local-variable 'company-backends) '(company-capf))
              (company-mode t)
			  (lsp-deferred)
			  (font-lock-add-keywords nil
                '(("\\<\\([a-zA-Z_][a-zA-Z0-9_]*\\)\\s-*(" 1 font-lock-function-name-face)))
              (setq tab-width 4)          ;; Largura da tabulação
              (setq indent-tabs-mode nil) ;; Usar espaços em vez de tabs
              (setq c-basic-offset 4))))  ;; Nível de indentação

(use-package lsp-php
  :ensure nil
  :after php-mode
  :custom
  (lsp-php-server-command "/usr/bin/php")) ;; Ajuste o caminho do servidor de linguagem PHP

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

;; Flycheck
(use-package flycheck
  :hook (after-init . global-flycheck-mode)
  :config
  (setq flycheck-check-syntax-automatically '(save mode-enabled))) ;; Verifica sintaxe ao salvar e ativar modo

;; LSP Mode
(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook ((python-mode . lsp-deferred)
         (js-mode . lsp-deferred)
         (web-mode . lsp-deferred)
         (rust-mode . lsp-deferred)
         (c-mode . lsp-deferred)
         (c++-mode . lsp-deferred)
         (java-mode . lsp-deferred)
         (yaml-mode . lsp-deferred)
		 (php-mode . lsp-deferred))
         ;;(nxml-mode . lsp-deferred))
  :config
  (setq lsp-enable-snippet nil));; Desativa snippets, se preferir
  ;;(setq lsp-completion-provider))
  ;;(setq lsp-prefer-capf t)) ;; Usa completion-at-point-functions para autocompletar


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

;;(use-package company-lsp
 ;; :commands company-lsp)

;; Configurações adicionais para aprimorar a experiência com LSP
(use-package lsp-treemacs
  :commands lsp-treemacs-errors-list)

(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol)

(use-package which-key
  :config
  (which-key-mode))



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(treemacs)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
