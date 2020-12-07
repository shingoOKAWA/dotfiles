;;; init-bindings.el --- sets up basic Emacs bindings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(defvar user/bindings/global-keymap nil
  "Global keymap.")

(defvar user/bindings/global-reverse-keymap nil
  "Global reverse keymap, mapping bindings back to functions.")

(defvar ctl-l-map (make-keymap)
  "Default keymap for \\<ctl-l-map> commands.")

;; Set up prefixes for command groups.
;; TODO: Fix this to bind-key style.
(defcustom user/bindings/view-prefix (kbd "C-x v")
  "Keyboard prefix to use for view commands."
  :type 'key-sequence
  :group 'user)

(defcustom user/bindings/help-prefix (kbd "C-c h")
  "Keyboard prefix to use for help commands."
  :type 'key-sequence
  :group 'user)

(defcustom user/bindings/documentation-prefix (kbd "C-c d")
  "Keyboard prefix to use for documentation commands."
  :type 'key-sequence
  :group 'user)

(defcustom user/bindings/code-prefix (kbd "C-c c")
  "Keyboard prefix to use for code manipulation commands."
  :type 'key-sequence
  :group 'user)

(defcustom user/bindings/code-eval-prefix (kbd "C-c c e")
  "Keyboard prefix to use for code evaluation commands."
  :type 'key-sequence
  :group 'user)

(defcustom user/bindings/vcs-prefix (kbd "C-c v")
  "Keyboard prefix to use for version control commands."
  :type 'key-sequence
  :group 'user)

(defcustom user/bindings/utilities-prefix (kbd "C-c u")
  "Keyboard prefix to use for utility commands."
  :type 'key-sequence
  :group 'user)

(defcustom user/bindings/apps-prefix (kbd "C-c a")
  "Keyboard prefix to use for application commands."
  :type 'key-sequence
  :group 'user)

(defconst user/bindings/prefix-list (list "C-x" "C-c" "C-l")
  "List of the registered prefix keys.")

(defun user/bindings/make-key (keys)
  "Convert `KEYS' into the internal Emacs key representation."
  (kbd (if (listp keys)
           (mapconcat 'identity (mapcar 'eval keys) " ")
         keys)))

(defun user/bindings/get-key (group operation)
  "Get the key from `GROUP' to bind for `OPERATION'."
  (let ((key (cdr (assq operation (cdr (assq group user/bindings/global-keymap))))))
    (if key
        (user/bindings/make-key key)
      (error (format "Group %s does not contain key for %s!"
                     (symbol-name group) (symbol-name operation))))))

(defun user/bindings/get-key-function (group operation)
  "Get the function bound to `GROUP' `OPERATION'."
  (car (cdr (assq operation
                  (cdr (assq group user/bindings/global-reverse-keymap))))))

(defun user/bindings/bind-key-global (group key function)
  "Bind `GROUP' `KEY' to `FUNCTION' globally."
  (let ((rev-group (assq group user/bindings/global-reverse-keymap)))
    (setq user/bindings/global-reverse-keymap
          (append `((,group . ,(append `((,key ,function)) (cdr rev-group))))
                  (delq (assoc group user/bindings/global-reverse-keymap)
                        user/bindings/global-reverse-keymap))))
  (global-set-key (user/bindings/get-key group key) function))

(defun user/bindings/bind-key-local (group key function)
  "Bind `GROUP' `KEY' to `FUNCTION' in the current keymap."
  (local-set-key (user/bindings/get-key group key) function))

(defun user/bindings/merge-keymap-groups (overlay base)
  "Merge `OVERLAY' keymap with `BASE' group."
  (let ((group-name (car base))
        (overlay-keys (cdr overlay))
        (base-keys (cdr base)))
    `((,group-name . ,(append overlay-keys base-keys)))))

(defun user/bindings/global-keymap-overlay (overlay)
  "Load keymap `OVERLAY'."
  (dolist (ovl-group overlay)
    (let ((ovl-gname (car ovl-group))
          (ovl-keys (cdr ovl-group)))
      (dolist (ovl-op (cdr ovl-group))
        (let ((ovl-oname (car ovl-op))
              (ovl-key (cdr ovl-op)))
          ;; TODO: Check that ovl-oname exists.
          (global-set-key (user/bindings/make-key ovl-key)
                          (user/bindings/get-key-function ovl-gname ovl-oname))))
      (let ((orig-group (assq ovl-gname user/bindings/global-keymap))
            (keymap-without-group (assq-delete-all ovl-gname user/bindings/global-keymap)))
        (setq user/bindings/global-keymap
              (append (user/bindings/merge-keymap-groups ovl-group orig-group)
                      keymap-without-group)))))
  t)

(defun user--global-keymap-config ()
  "Initialize the global keymap."
  (setq
   user/bindings/global-keymap
   '((:basic . ((:alternate-paste . "C-M-y")
                (:backward-expr . "C-M-b")
                (:backward-line . "C-p")
                (:backward-word . "M-b")
                (:close . "C-x k")
                (:copy . "C-x C-w")
                (:copy-expr . "C-M-w")
                (:cut . "C-x C-k")
                (:cut-expr . "C-M-k")
                (:cut-word-left . "C-w")
                (:cut-word-right . "M-w")
                (:cycle-paste . "M-y")
                (:del-char-left . "C-h")
                (:del-char-right . "C-d")
                (:forward-expr . "C-M-f")
                (:forward-line . "C-n")
                (:forward-word . "M-f")
                (:narrow-to-function . (user/bindings/view-prefix "n f"))
                (:narrow-to-page . (user/bindings/view-prefix "n p"))
                (:narrow-to-region . (user/bindings/view-prefix "n r"))
                (:open-buffer . "C-x b")
                (:open-buffer-context . "C-x M-b")
                (:open-file . "C-x C-f")
                (:open-file-context . "C-x f")
                (:open-file-tramp . "C-x t")
                (:paste . "C-y")
                (:quit . "C-x C-c")
                (:redo . "M-_")
                (:save . "C-x C-s")
                (:save-as . "C-x M-s")
                (:search-backward . "C-r")
                (:search-files . ("C-l M-f"))
                (:search-forward . "C-s")
                (:select-function . "C-M-h")
                (:select-inside . "M-+")
                (:select-paragraph . "M-h")
                (:selection-all . "C-c M-.")
                (:selection-edit-lines . "C-c M-e")
                (:selection-expand . "M-=")
                (:selection-next . "M-.")
                (:selection-prev . "M-,")
                (:selection-start . "C-SPC")
                (:server-edit . "C-x #")
                (:swoop . "C-l C-s")
                (:swoop-multi . "C-l C-M-s")
                (:undo . "C-_")
                (:view-file . "C-x C-v")
                (:widen . (user/bindings/view-prefix "n w"))
                (:zoom . (user/bindings/view-prefix "z"))))
     (:emacs . ((:describe-all-faces . (user/bindings/help-prefix "M-f"))
                (:describe-bindings . (user/bindings/help-prefix "b"))
                (:describe-char . (user/bindings/help-prefix "c"))
                (:describe-coding . (user/bindings/help-prefix "C"))
                (:describe-command . (user/bindings/help-prefix "i"))
                (:describe-face . (user/bindings/help-prefix "F"))
                (:describe-function . (user/bindings/help-prefix "f"))
                (:describe-key . (user/bindings/help-prefix "k"))
                (:describe-key-extensive . (user/bindings/help-prefix "K"))
                (:describe-language . (user/bindings/help-prefix "L"))
                (:describe-macro . (user/bindings/help-prefix "M-m"))
                (:describe-mode . (user/bindings/help-prefix "m"))
                (:describe-symbol . (user/bindings/help-prefix "s"))
                (:describe-syntax . (user/bindings/help-prefix "S"))
                (:describe-variable . (user/bindings/help-prefix "v"))
                (:elisp-search . (user/bindings/help-prefix "e"))
                (:find-library . (user/bindings/help-prefix "l"))
                (:find-package . (user/bindings/help-prefix "p"))
                (:flip-frame . "C-c M-t")
                (:flop-frame . "C-c C-t")
                (:fullscreen . "C-c <C-return>")
                (:grow-horizontal . "C-c C-f")
                (:grow-vertical . "C-c C-p")
                (:manual . (user/bindings/help-prefix "M"))
                (:profiler-report . (user/bindings/utilities-prefix "p r"))
                (:profiler-start . (user/bindings/utilities-prefix "p p"))
                (:profiler-stop . (user/bindings/utilities-prefix "p P"))
                (:recenter . "C-l l")
                (:redraw . "C-l C-l")
                (:rotate-frame-backward . "C-c M-r")
                (:rotate-frame-forward . "C-c C-r")
                (:search-variable-value . (user/bindings/help-prefix "V"))
                (:shrink-horizontal . "C-c C-b")
                (:shrink-vertical . "C-c C-n")
                (:text-scale-decrease . "C--")
                (:text-scale-increase . "C-+")
                (:text-scale-reset . "C-0")
                (:tutorial . (user/bindings/help-prefix "t"))
                (:where-is . (user/bindings/help-prefix "w"))))
     (:doc . ((:apropos . (user/bindings/documentation-prefix "SPC"))
              (:describe . (user/bindings/documentation-prefix "d"))
              (:describe-function . (user/bindings/documentation-prefix "f"))
              (:describe-variable . (user/bindings/documentation-prefix "v"))
              (:dictionary . (user/bindings/documentation-prefix "D"))
              (:manual . (user/bindings/documentation-prefix "m"))
              (:reference . (user/bindings/documentation-prefix "r"))))
     (:nav . ((:context . ("C-l SPC"))
              (:context-backward . ("C-l C-b"))
              (:context-cycle . ("C-l C-c"))
              (:context-down . ("C-l C-n"))
              (:context-forward . ("C-l C-f"))
              (:context-up . ("C-l C-p"))
              (:file-dependencies . ("C-l d"))
              (:find-references . ("C-l M-r"))
              (:find-symbol . ("C-l s"))
              (:find-todos . ("C-l M-t"))
              (:find-virtuals . ("C-l v"))
              (:follow-symbol . ("C-l j"))
              (:functions/toc . ("C-l t"))
              (:go-back . ("C-l b"))
              (:go-forward . ("C-l f"))
              (:goto-line . ("C-l g"))
              (:history . ("C-l h"))
              (:jump-spec-impl . ("C-l i"))
              (:next . ("C-l n"))
              (:open . (user/bindings/utilities-prefix "o"))
              (:references . ("C-l r"))
              (:scroll-down . "M-p")
              (:scroll-up . "M-n")
              (:switch-spec-impl . ("C-l h"))))
     (:code . ((:align . ((if (display-graphic-p) "C-x C-5" "C-x C-]")))
               (:auto-complete . "C-TAB")
               (:bookmark-next . "C-c b n")
               (:bookmark-prefix . "C-c b")
               (:bookmark-prev . "C-c b p")
               (:bookmark-toggle . "C-c b v")
               (:clean . (user/bindings/code-prefix "M-c"))
               (:comment . "M-;")
               (:compilation-result . (user/bindings/view-prefix "c"))
               (:compile . (user/bindings/code-prefix "c"))
               (:complete . "TAB")
               (:context-demote . (user/bindings/code-prefix "N"))
               (:context-promote . (user/bindings/code-prefix "P"))
               (:disassemble . (user/bindings/code-prefix "D"))
               (:document . (user/bindings/code-prefix "="))
               (:enumerate . (user/bindings/code-prefix "e"))
               (:eval-buffer . (user/bindings/code-eval-prefix "b"))
               (:eval-expression . ("C-x C-e"))
               (:eval-function . (user/bindings/code-eval-prefix "f"))
               (:eval-selection . (user/bindings/code-eval-prefix "s"))
               (:fill-paragraph . ((if (display-graphic-p) "C-x C-4" "C-x C-\\")))
               (:generate-test . (user/bindings/code-prefix "M-t"))
               (:insert-dependency . (user/bindings/code-eval-prefix "M-d"))
               (:itemize . (user/bindings/code-prefix "b"))
               (:join-line . ((if (display-graphic-p) "C-x C-6" "C-x C-^")))
               (:library-list . (user/bindings/code-prefix "l"))
               (:macro-expand . (user/bindings/code-eval-prefix "m"))
               (:refactor-extract . (user/bindings/code-prefix "M-x"))
               (:refactor-rename . (user/bindings/code-prefix "M-r"))
               (:repl . (user/bindings/code-prefix "M-r"))
               (:run . (user/bindings/code-prefix "r"))
               (:spellcheck-add-word . (user/bindings/code-prefix "S"))
               (:spellcheck-word . (user/bindings/code-prefix "s"))
               (:test . (user/bindings/code-prefix "t"))
               (:thesaurus-lookup . (user/bindings/code-prefix "t"))
               (:tidy . ("C-x ="))
               (:try-complete . "TAB")
               (:unwrap-expr . "C-M-d")
               (:update-index . (user/bindings/code-prefix "i"))
               (:virtual . (user/bindings/code-prefix "v"))
               (:warnings/errors . (user/bindings/code-prefix "E"))
               (:whitespace-auto-cleanup . (user/bindings/code-prefix "w"))))
     (:debug . ((:break . (user/bindings/code-prefix "b"))
                (:break-temporary . (user/bindings/code-prefix "t"))
                (:continue . (user/bindings/code-prefix "c"))
                (:continue-stack . (user/bindings/code-prefix "f"))
                (:continue-until . (user/bindings/code-prefix "u"))
                (:next . (user/bindings/code-prefix "n"))
                (:run . (user/bindings/code-prefix "r"))
                (:show-value . (user/bindings/code-prefix "p"))
                (:stack-down . (user/bindings/code-prefix "n"))
                (:stack-up . (user/bindings/code-prefix "p"))
                (:start . (user/bindings/code-prefix "d"))
                (:step . (user/bindings/code-prefix "s"))
                (:step-instruction . (user/bindings/code-prefix "i"))
                (:trace . (user/bindings/code-prefix "T"))
                (:watch . (user/bindings/code-prefix "w"))))
     (:vcs . ((:add-buffer . (user/bindings/vcs-prefix "a"))
              (:clone . (user/bindings/vcs-prefix "c"))
              (:describe . (user/bindings/vcs-prefix "d"))
              (:find-file . ("C-c p"))
              (:gutter . (user/bindings/vcs-prefix "g"))
              (:history . (user/bindings/vcs-prefix "h"))
              (:mergetool . (user/bindings/vcs-prefix "m"))
              (:next-action . (user/bindings/vcs-prefix "SPC"))
              (:review . (user/bindings/vcs-prefix "r"))
              (:search . (user/bindings/vcs-prefix "M-s"))
              (:status . (user/bindings/vcs-prefix "s"))
              (:time-machine . (user/bindings/vcs-prefix "t"))
              (:version . (user/bindings/vcs-prefix "v"))))
     (:util . ((:annotate-buffer . (user/bindings/utilities-prefix "a"))
               (:draw . (user/bindings/utilities-prefix "g"))
               (:diff . (user/bindings/utilities-prefix "d"))
               (:dumb-diff . (user/bindings/utilities-prefix "M-d"))
               (:ace-jump-mode . ("C-l a"))
               (:ecb-toggle . (user/bindings/utilities-prefix "e"))
               (:google . (user/bindings/utilities-prefix "s"))
               (:google-at-point . (user/bindings/documentation-prefix "s RET"))
               (:google-selection . (user/bindings/documentation-prefix "s SPC"))
               (:stack-overflow-search . (user/bindings/documentation-prefix "s"))
               (:notifications . (user/bindings/utilities-prefix "n"))
               (:perspective . ("C-x x s"))
               (:presentation . (user/bindings/utilities-prefix "P"))
               (:popwin-close . (user/bindings/view-prefix "0"))
               (:popwin-buffer . (user/bindings/view-prefix "p"))
               (:popwin-messages . (user/bindings/view-prefix "m"))
               (:undo-tree . (user/bindings/utilities-prefix "u"))
               (:wc-mode . (user/bindings/utilities-prefix "w"))
               (:docker . (user/bindings/utilities-prefix "d"))))
     (:apps . ((:agenda . (user/bindings/apps-prefix "a"))
               (:browse . (user/bindings/apps-prefix "b"))
               (:browse-external . (user/bindings/apps-prefix "B"))
               (:calculator . (user/bindings/apps-prefix "c"))
               (:capture-task . (user/bindings/apps-prefix "M-t"))
               (:cheat-sh . (user/bindings/apps-prefix "C"))
               (:convert-unit . (user/bindings/apps-prefix "M-c"))
               (:daemons . (user/bindings/apps-prefix "M-d"))
               (:elnode . (user/bindings/apps-prefix "E"))
               (:email . (user/bindings/apps-prefix "e"))
               (:feed-reader . (user/bindings/apps-prefix "f"))
               (:information-db . (user/bindings/apps-prefix "D"))
               (:instant-messenger . (user/bindings/apps-prefix "I"))
               (:ipython-notebook . (user/bindings/apps-prefix "N"))
               (:irc . (user/bindings/apps-prefix "i"))
               (:music . (user/bindings/apps-prefix "m"))
               (:notes . (user/bindings/apps-prefix "n"))
               (:packages . (user/bindings/apps-prefix "M-p"))
               (:processes . (user/bindings/apps-prefix "p"))
               (:sage . (user/bindings/apps-prefix "S"))
               (:services . (user/bindings/apps-prefix "P"))
               (:shell . (user/bindings/apps-prefix "s"))
               (:stack-exchange . (user/bindings/apps-prefix "x"))
               (:statistics . (user/bindings/apps-prefix "R"))
               (:todo . (user/bindings/apps-prefix "t"))
               (:weather . (user/bindings/apps-prefix "w")))))))

(defun user--bindings-config ()
  "Initialize key bindings."
  (global-unset-key (kbd "C-l"))
  (define-prefix-command 'ctl-l-map)
  (global-set-key (kbd "C-l") 'ctl-l-map)
  (user--global-keymap-config)
  ;; Alias C-x C-m to M-x which is a bit awkward to reach.
  (global-set-key (kbd "C-x C-m") 'execute-extended-command)
  (global-set-key (kbd "C-x m") 'execute-extended-command))

(user--bindings-config)

(provide 'init-bindings)

;;; init-bindings.el ends here
