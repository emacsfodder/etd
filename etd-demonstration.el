;;; etd-demonstration.el --- Demonstration of ETD
;; -*- lexical-binding: t; no-byte-compile: t; eval: (font-lock-add-keywords nil '(("examples\\|group\\| => " (0 'font-lock-keyword-face)))); -*-
;; 
;; Copyright (C) 2022 Jason Milkins
;;
;; Author: Jason Milkins <jasonm23@gmail.com>
;; Maintainer: Jason Milkins <jasonm23@gmail.com>
;; Created: August 18, 2022
;; Modified: August 18, 2022
;; Version: 0.0.1
;; Keywords: examples tests documentation.
;; Homepage: https://github.com/emacsfodder/etd
;; Package-Requires: ((emacs "24.1"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;  Demonstration of ETD
;;
;;; Code:

(require 'etd)

;;; - - -
;; Example Demonstration:
;;; - - -

(defalias 'group #'etd-group)
(defalias 'examples #'etd-examples)

;;;; Function under test.
(defun example-func-1 (string)
  "Return a copy of STRING."
  string)

(defun example-func-2 (string)
  "Return a reversed copy of STRING."
  (reverse string))

;;; (group: NAME &rest EXAMPLES)
(group "ETD example 1"

 (examples example-func-1
   (example-func-1 "abc") => "abc"
   (example-func-1 "cba") => "cba")

 (examples example-func-2
   (example-func-2 "abc") => "cba"))

(provide 'etd-demonstration)
;;; etd-demonstration.el ends here
