;;; init-bindings.el --- sets up basic Emacs bindings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(defvar user/global-keymap nil
  "Global keymap.")

(defvar user/global-reverse-keymap nil
  "Global reverse keymap, mapping bindings back to functions.")

(defvar ctl-l-map (make-keymap)
  "Default keymap for \\<ctl-l-map> commands.")

;; Set up prefixes for command groups.
(defcustom user/view-prefix (kbd "C-x v")
  "Keyboard prefix to use for view commands."
  :type 'key-sequence
  :group 'user)

(defcustom user/help-prefix (kbd "C-c h")
  "Keyboard prefix to use for help commands."
  :type 'key-sequence
  :group 'user)

(defcustom user/documentation-prefix (kbd "C-c d")
  "Keyboard prefix to use for documentation commands."
  :type 'key-sequence
  :group 'user)

(defcustom user/code-prefix (kbd "C-c c")
  "Keyboard prefix to use for code manipulation commands."
  :type 'key-sequence
  :group 'user)

(defcustom user/code-eval-prefix (kbd "C-c c e")
  "Keyboard prefix to use for code evaluation commands."
  :type 'key-sequence
  :group 'user)

(defcustom user/vcs-prefix (kbd "C-c v")
  "Keyboard prefix to use for version control commands."
  :type 'key-sequence
  :group 'user)

(defcustom user/utilities-prefix (kbd "C-c u")
  "Keyboard prefix to use for utility commands."
  :type 'key-sequence
  :group 'user)

(defcustom user/apps-prefix (kbd "C-c a")
  "Keyboard prefix to use for application commands."
  :type 'key-sequence
  :group 'user)

(defconst user/prefix-list (list "C-x" "C-c" "C-l")
  "List of the registered prefix keys.")

(defun user/make-key (keys)
  "Convert `KEYS' into the internal Emacs key representation."
  (kbd (if (listp keys)
           (mapconcat 'identity (mapcar 'eval keys) " ")
         keys)))

(defun user/get-key (group operation)
  "Get the key from `GROUP' to bind for `OPERATION'."
  (let ((key (cdr (assq operation (cdr (assq group user/global-keymap))))))
    (if key
        (user/make-key key)
      (error (format "Group %s does not contain key for %s!"
                     (symbol-name group) (symbol-name operation))))))

(defun user/get-key-function (group operation)
  "Get the function bound to `GROUP' `OPERATION'."
  (car (cdr (assq operation
                  (cdr (assq group user/global-reverse-keymap))))))

(defun user/bind-key-global (group key function)
  "Bind `GROUP' `KEY' to `FUNCTION' globally."
  (let ((rev-group (assq group user/global-reverse-keymap)))
    (setq user/global-reverse-keymap
          (append `((,group . ,(append `((,key ,function)) (cdr rev-group))))
                  (delq (assoc group user/global-reverse-keymap)
                        user/global-reverse-keymap))))
  (global-set-key (user/get-key group key) function))

(defun user/bind-key-local (group key function)
  "Bind `GROUP' `KEY' to `FUNCTION' in the current keymap."
  (local-set-key (user/get-key group key) function))

(defun user/merge-keymap-groups (overlay base)
  "Merge `OVERLAY' keymap with `BASE' group."
  (let ((group-name (car base))
        (overlay-keys (cdr overlay))
        (base-keys (cdr base)))
    `((,group-name . ,(append overlay-keys base-keys)))))

(defun user/global-keymap-overlay (overlay)
  "Load keymap `OVERLAY'."
  (dolist (ovl-group overlay)
    (let ((ovl-gname (car ovl-group))
          (ovl-keys (cdr ovl-group)))
      (dolist (ovl-op (cdr ovl-group))
        (let ((ovl-oname (car ovl-op))
              (ovl-key (cdr ovl-op)))
          ;; TODO: Check that ovl-oname exists.
          (global-set-key (user/make-key ovl-key)
                          (user/get-key-function ovl-gname ovl-oname))))
      (let ((orig-group (assq ovl-gname user/global-keymap))
            (keymap-without-group (assq-delete-all ovl-gname user/global-keymap)))
        (setq user/global-keymap
              (append (user/merge-keymap-groups ovl-group orig-group)
                      keymap-without-group)))))
  t)

(defun user--global-keymap-config ()
  "Initialize the global keymap."
  (setq
   user/global-keymap
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
                (:narrow-to-function . (user/view-prefix "n f"))
                (:narrow-to-page . (user/view-prefix "n p"))
                (:narrow-to-region . (user/view-prefix "n r"))
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
                (:widen . (user/view-prefix "n w"))
                (:zoom . (user/view-prefix "z"))))
     (:emacs . ((:describe-all-faces . (user/help-prefix "M-f"))
                (:describe-bindings . (user/help-prefix "b"))
                (:describe-char . (user/help-prefix "c"))
                (:describe-coding . (user/help-prefix "C"))
                (:describe-command . (user/help-prefix "i"))
                (:describe-face . (user/help-prefix "F"))
                (:describe-function . (user/help-prefix "f"))
                (:describe-key . (user/help-prefix "k"))
                (:describe-key-extensive . (user/help-prefix "K"))
                (:describe-language . (user/help-prefix "L"))
                (:describe-macro . (user/help-prefix "M-m"))
                (:describe-mode . (user/help-prefix "m"))
                (:describe-symbol . (user/help-prefix "s"))
                (:describe-syntax . (user/help-prefix "S"))
                (:describe-variable . (user/help-prefix "v"))
                (:elisp-search . (user/help-prefix "e"))
                (:find-library . (user/help-prefix "l"))
                (:find-package . (user/help-prefix "p"))
                (:flip-frame . "C-c M-t")
                (:flop-frame . "C-c C-t")
                (:fullscreen . "C-c <C-return>")
                (:grow-horizontal . "C-c C-f")
                (:grow-vertical . "C-c C-p")
                (:manual . (user/help-prefix "M"))
                (:profiler-report . (user/utilities-prefix "p r"))
                (:profiler-start . (user/utilities-prefix "p p"))
                (:profiler-stop . (user/utilities-prefix "p P"))
                (:recenter . "C-l l")
                (:redraw . "C-l C-l")
                (:rotate-frame-backward . "C-c M-r")
                (:rotate-frame-forward . "C-c C-r")
                (:search-variable-value . (user/help-prefix "V"))
                (:shrink-horizontal . "C-c C-b")
                (:shrink-vertical . "C-c C-n")
                (:text-scale-decrease . "C--")
                (:text-scale-increase . "C-+")
                (:text-scale-reset . "C-0")
                (:tutorial . (user/help-prefix "t"))
                (:where-is . (user/help-prefix "w"))))
     (:doc . ((:apropos . (user/documentation-prefix "SPC"))
              (:describe . (user/documentation-prefix "d"))
              (:describe-function . (user/documentation-prefix "f"))
              (:describe-variable . (user/documentation-prefix "v"))
              (:dictionary . (user/documentation-prefix "D"))
              (:manual . (user/documentation-prefix "m"))
              (:reference . (user/documentation-prefix "r"))))
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
              (:open . (user/utilities-prefix "o"))
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
               (:clean . (user/code-prefix "M-c"))
               (:comment . "M-;")
               (:compilation-result . (user/view-prefix "c"))
               (:compile . (user/code-prefix "c"))
               (:complete . "TAB")
               (:context-demote . (user/code-prefix "N"))
               (:context-promote . (user/code-prefix "P"))
               (:disassemble . (user/code-prefix "D"))
               (:document . (user/code-prefix "="))
               (:enumerate . (user/code-prefix "e"))
               (:eval-buffer . (user/code-eval-prefix "b"))
               (:eval-expression . ("C-x C-e"))
               (:eval-function . (user/code-eval-prefix "f"))
               (:eval-selection . (user/code-eval-prefix "s"))
               (:fill-paragraph . ((if (display-graphic-p) "C-x C-4" "C-x C-\\")))
               (:generate-test . (user/code-prefix "M-t"))
               (:insert-dependency . (user/code-eval-prefix "M-d"))
               (:itemize . (user/code-prefix "b"))
               (:join-line . ((if (display-graphic-p) "C-x C-6" "C-x C-^")))
               (:library-list . (user/code-prefix "l"))
               (:macro-expand . (user/code-eval-prefix "m"))
               (:refactor-extract . (user/code-prefix "M-x"))
               (:refactor-rename . (user/code-prefix "M-r"))
               (:repl . (user/code-prefix "M-r"))
               (:run . (user/code-prefix "r"))
               (:spellcheck-add-word . (user/code-prefix "S"))
               (:spellcheck-word . (user/code-prefix "s"))
               (:test . (user/code-prefix "t"))
               (:thesaurus-lookup . (user/code-prefix "t"))
               (:tidy . ("C-x ="))
               (:try-complete . "TAB")
               (:unwrap-expr . "C-M-d")
               (:update-index . (user/code-prefix "i"))
               (:virtual . (user/code-prefix "v"))
               (:warnings/errors . (user/code-prefix "E"))
               (:whitespace-auto-cleanup . (user/code-prefix "w"))))
     (:debug . ((:break . (user/code-prefix "b"))
                (:break-temporary . (user/code-prefix "t"))
                (:continue . (user/code-prefix "c"))
                (:continue-stack . (user/code-prefix "f"))
                (:continue-until . (user/code-prefix "u"))
                (:next . (user/code-prefix "n"))
                (:run . (user/code-prefix "r"))
                (:show-value . (user/code-prefix "p"))
                (:stack-down . (user/code-prefix "n"))
                (:stack-up . (user/code-prefix "p"))
                (:start . (user/code-prefix "d"))
                (:step . (user/code-prefix "s"))
                (:step-instruction . (user/code-prefix "i"))
                (:trace . (user/code-prefix "T"))
                (:watch . (user/code-prefix "w"))))
     (:vcs . ((:add-buffer . (user/vcs-prefix "a"))
              (:clone . (user/vcs-prefix "c"))
              (:describe . (user/vcs-prefix "d"))
              (:find-file . ("C-c p"))
              (:gutter . (user/vcs-prefix "g"))
              (:history . (user/vcs-prefix "h"))
              (:mergetool . (user/vcs-prefix "m"))
              (:next-action . (user/vcs-prefix "SPC"))
              (:review . (user/vcs-prefix "r"))
              (:search . (user/vcs-prefix "M-s"))
              (:status . (user/vcs-prefix "s"))
              (:time-machine . (user/vcs-prefix "t"))
              (:version . (user/vcs-prefix "v"))))
     (:util . ((:annotate-buffer . (user/utilities-prefix "a"))
               (:draw . (user/utilities-prefix "g"))
               (:diff . (user/utilities-prefix "d"))
               (:dumb-diff . (user/utilities-prefix "M-d"))
               (:ace-jump-mode . ("C-l a"))
               (:ecb-toggle . (user/utilities-prefix "e"))
               (:google . (user/utilities-prefix "s"))
               (:google-at-point . (user/documentation-prefix "s RET"))
               (:google-selection . (user/documentation-prefix "s SPC"))
               (:stack-overflow-search . (user/documentation-prefix "s"))
               (:notifications . (user/utilities-prefix "n"))
               (:perspective . ("C-x x s"))
               (:presentation . (user/utilities-prefix "P"))
               (:popwin-close . (user/view-prefix "0"))
               (:popwin-buffer . (user/view-prefix "p"))
               (:popwin-messages . (user/view-prefix "m"))
               (:undo-tree . (user/utilities-prefix "u"))
               (:wc-mode . (user/utilities-prefix "w"))
               (:docker . (user/utilities-prefix "d"))))
     (:apps . ((:agenda . (user/apps-prefix "a"))
               (:browse . (user/apps-prefix "b"))
               (:browse-external . (user/apps-prefix "B"))
               (:calculator . (user/apps-prefix "c"))
               (:capture-task . (user/apps-prefix "M-t"))
               (:cheat-sh . (user/apps-prefix "C"))
               (:convert-unit . (user/apps-prefix "M-c"))
               (:daemons . (user/apps-prefix "M-d"))
               (:elnode . (user/apps-prefix "E"))
               (:email . (user/apps-prefix "e"))
               (:feed-reader . (user/apps-prefix "f"))
               (:information-db . (user/apps-prefix "D"))
               (:instant-messenger . (user/apps-prefix "I"))
               (:ipython-notebook . (user/apps-prefix "N"))
               (:irc . (user/apps-prefix "i"))
               (:music . (user/apps-prefix "m"))
               (:notes . (user/apps-prefix "n"))
               (:packages . (user/apps-prefix "M-p"))
               (:processes . (user/apps-prefix "p"))
               (:sage . (user/apps-prefix "S"))
               (:services . (user/apps-prefix "P"))
               (:shell . (user/apps-prefix "s"))
               (:stack-exchange . (user/apps-prefix "x"))
               (:statistics . (user/apps-prefix "R"))
               (:todo . (user/apps-prefix "t"))
               (:weather . (user/apps-prefix "w")))))))

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
