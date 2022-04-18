;;; emacs_customization.el --- description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2020 John Doe
;;
;; Author: John Doe <http://github/asuli>
;; Maintainer: John Doe <john@doe.com>
;; Created: September 15, 2020
;; Modified: September 15, 2020
;; Version: 0.0.1
;; Keywords:
;; Homepage: https://github.com/asuli/emacs_customization
;; Package-Requires: ((emacs 26.3) (cl-lib "0.5"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  description
;;
;;; Code:



;;(provide 'emacs_customization)
(setq org-capture-templates
      '(
	("h" "HDL" entry (file+headline "~/GitHub/Work/verilogLibrary/hdl.org" "Tasks")
    "* TODO %?\n  %i\n  %a")
	("d" "DigitalOcean" entry (file+headline "~/GitHub/Work/digitalOcean.org" "Tasks")
	 "* TODO %?\n  %i\n  %a")
	("o" "osx" entry (file+headline "~/GitHub/Work/osx.org" "Tasks")
	 "* TODO %?\n  %i\n  %a")
	)
      )

;;; emacs_customization.el ends here
