;;; etd-demonstration.el --- Demonstration of ETD
;; -*- lexical-binding: t; no-byte-compile: t; eval: (font-lock-add-keywords nil '(("defexamples\\|def-example-group\\| => " (0 'font-lock-keyword-face)))); -*-
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

;;;; Function under test.
(defun example-func-1 (string)
  "Return a copy of STRING."
  string)

(defun example-func-2 (string)
  "Return a reversed copy of STRING."
  (reverse string))

;;; (def-example-group: GROUP &rest EXAMPLES)
(def-example-group "ETD example 1"

 (defexamples example-func-1
   (example-func-1 "abc") => "abc"
   (example-func-1 "cba") => "cba")

 (defexamples example-func-2
   (example-func-2 "abc") => "cba"))

(provide 'etd-demonstration)
;;; etd-demonstration.el ends here
