;;; env.el --- support functions for working with environment variables -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(defun lib/env/getenv-or (env value)
  "Fetch the value of `ENV' or, if it is not set, return `VALUE'."
  (if (getenv env) (getenv env) value))

(provide 'lib/env)

;;; env.el ends here
