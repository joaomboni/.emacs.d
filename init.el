;; Remover boas vindas
(setq inhibit-startup-message t)

;; fonte jetbrains - 1° pacman -S ttf-jetbrains-mono
(set-face-attribute 'default nil :font "JetBrains Mono-11" :weight 'bold)  ;; Tamanho da fonte 12

;; Ativar electric-pair-mode globalmente
(electric-pair-mode 1)

;; Configura espaco tab
(setq-default tab-width 4)

;; Remover menus
(tool-bar-mode -1)

;; Numeros nas linhas
(global-display-line-numbers-mode t)

;; highlight para C/C++
(global-font-lock-mode 1)

;; Reconhecer funções de bibliotecas padrão
(setq font-lock-maximum-decoration t)

;;Reconhecer funções de bibliotecas externas
(add-hook 'c-mode-hook #'font-lock-mode)

;;Semantic reconhece funções
(require 'semantic)
(semantic-mode 1)

(global-semantic-decoration-mode 1)
(global-semantic-idle-summary-mode 1)
(global-semantic-idle-local-symbol-highlight-mode 1)

(defun my-semantic-highlight-functions ()
  "Ativar destaque para chamadas de função usando Semantic."
  (global-semantic-idle-local-symbol-highlight-mode 1))

(add-hook 'c-mode-hook 'my-semantic-highlight-functions)
(add-hook 'c++-mode-hook 'my-semantic-highlight-functions)

;; Highlight nas chamadas das funções
(defun my-c-mode-font-lock ()
 "Destacar chamadas de função no modo C."
 (font-lock-add-keywords
  nil
  '(("\\<\\(\\sw+\\)\\s-*(" 1 font-lock-function-name-face))))

(add-hook 'c-mode-hook 'my-c-mode-font-lock)
(add-hook 'c++-mode-hook 'my-c-mode-font-lock)



;; Tratar conexão remota como projeto
(setq project-vc-merge-submodules nil)

(setq treemacs-no-load-time-warnings t) ;; Remove avisos ao abrir remotos
(setq treemacs-follow-after-init t) ;; Seguir diretório após abrir

;; caching no Tramp
(setq remote-file-name-inhibit-cache nil)

;; Integração Tramp e Dired
;;(treemacs-follow-mode 1)


;; TEMAS

;; Install the Monokai Pro theme
;(use-package monokai-pro-theme
 ; :ensure t
 ; :config
 ; (load-theme 'monokai-pro-spectrum t))


  ;;Terminal zsh
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


;; Autosugestão para c / c++
;; sudo dnf5 install clangd necessário instalar
;; Instala e ativa o company-mode para autocomplete
(use-package company
  :ensure t
  :hook (prog-mode . company-mode)
  :config
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0.0))

;; Configurar lsp-mode corretamente para C e C++
(use-package lsp-mode
  :ensure t
  :hook ((c-mode c++-mode) . lsp)
  :commands lsp
  :config
  (setq lsp-enable-snippet nil)
  (setq lsp-idle-delay 0.1))

;; Integrar company-mode com lsp-mode
(use-package company
  :after lsp-mode
  :config
  (setq company-backends '(company-capf))) ;; Usar capf do LSP

(use-package treemacs
  :ensure t
  :config
  (setq treemacs-is-never-other-window t)
  (add-hook 'emacs-startup-hook 'treemacs))
;; Habilitar a funcionalidade de redimensionamento de janelas com o mouse
(window-divider-mode 1)


;; Configurações adicionais para aprimorar a experiência com LSP
(use-package lsp-treemacs
  :commands lsp-treemacs-errors-list)

(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode))

;; Redefine C-z para desfazer
(global-set-key (kbd "C-z") 'undo-tree-undo)
(global-set-key (kbd "C-S-z") 'undo-tree-redo) ;; C-S-z para refazer undo-tree


(use-package try
  :ensure t)

(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol)

(use-package which-key
  :ensure t
  :config (which-key-mode))

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


(defun insert-html-template ()
  "Insere um template HTML básico."
  (interactive)
  (insert
   "<!DOCTYPE html>\n"
   "<html lang=\"en\">\n"
   "<head>\n"
   "    <meta charset=\"UTF-8\">\n"
   "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n"
   "    <title>Document</title>\n"
   "</head>\n"
   "<body>\n"
   "    \n"
   "</body>\n"
   "</html>\n"))

(global-set-key (kbd "C-c h") 'insert-html-template)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(company-lsp yaml-mode xml-format which-key web-mode undo-tree try rust-mode monokai-pro-theme magit lsp-ui lsp-treemacs lsp-ivy js2-mode git-gutter flycheck emmet-mode diff-hl company auto-complete-clang ac-php)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
