;;; etd-examples.el --- Tests for E.T.D. -*- lexical-binding: t; no-byte-compile: t; eval: (font-lock-add-keywords nil '(("examples\\|group\\| => " (0 'font-lock-keyword-face)))); -*-
;;
;; Copyright (C) 2022 Jason Milkins
;;
;; Author: Jason Milkins <jasonm23@gmail.com>
;; Maintainer: Jason Milkins <jasonm23@gmail.com>
;; Created: August 18, 2022
;; Modified: August 18, 2022
;; Version: 2.0.0
;; Keywords: examples tests documentation.
;; Homepage: https://github.com/emacsfodder/etd
;; Package-Requires: ((emacs "24.1"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Tests for E.T.D.
;;
;;; Code:

(require 'etd)

(defalias 'group #'etd-group)
(defalias 'examples #'etd-examples)

;;;; Example Function.
(defun example-func (str)
  "Return a reversed copy of STR."
  (reverse str))

;; ETD testing ...

(group "Documentation Helper Functions"
  (examples etd--function-summary
    (etd--function-summary
      (etd--get-function-info 'etd--github-id)
     => "\n* [github-id](#github-id) `(command-name signature)`"))

  (examples etd--github-id
    (etd--github-id "foobzz" "(string &optional arg)") => "-foobzz-string-optional-arg"
    (etd--github-id "foobar" "(string list)") => "-foobar-string-list"
    (etd--github-id "foobaz" "(string &rest args)") => "-foobaz-string-rest-args")

  (examples etd--docs--chop-suffix
    (etd--docs--chop-suffix "Boom" "BigBaddaBoom") => "BigBadda"
    (etd--docs--chop-suffix "////" "BigBaddaBoom////") => "BigBaddaBoom"
    (etd--docs--chop-suffix "Badda" "BigBaddaBoom") => "BigBaddaBoom")

  (examples etd--get-function-info
    (etd--get-function-info 'etd--quote-and-downcase) => '(etd--quote-and-downcase (str) "Wrap STR in backquotes for markdown.")
    (etd--get-function-info 'etd-examples) => '(etd-examples (cmd &rest examples) "CMD and EXAMPLES to ert-deftests.")
    (etd--get-function-info 'insert) => nil
    (etd--get-function-info 'etd-group) => '(etd-group (group &rest examples) "GROUP of EXAMPLES for docs."))

  (examples etd--quote-and-downcase
    (etd--quote-and-downcase "STRING") => " `string` ")

  (examples etd--quote-docstring
    (etd--quote-docstring "This is a TEST docstring.") => "This is a  `test`  docstring."
    (etd--quote-docstring "Docstring X `~>' Y.") => "Docstring   `x`  `~>`   `y` ."))

(group "Utility Functions"
  (examples etd--zip
     (etd--zip '(1 3 5) '(2 4 6)) => '((1 . 2) (3 . 4) (5 . 6))))

(group "Matchers"
  (examples etd--listsp
     (etd--listsp '(1) '(1 2 3) '("a" "b")) => t
     (etd--listsp '() nil '("a" "b")) => nil)

  (examples etd--compare-flat-lists
     (etd--compare-flat-lists '(1 2) '(1 2) 'eql) => t
     (etd--compare-flat-lists '(1 2) '(1 2) 'equal) => t)

  (examples etd--length=
     (etd--length= '(12 1) '(12)) => nil
     (etd--length= "hello" "world") => t
     (etd--length= '("1" "2") '("a" "b")) => t)

  (examples etd--approx-equal
     (etd--approx-equal 1.1112 1.1113) => t
     (etd--approx-equal 1.1112 1.111) => nil)

  (examples etd--lists-approx-equal
     (etd--lists-approx-equal '(1.1113 1.1112) '(1.1112 1.1113)) => t
     (etd--lists-approx-equal '(1.113 1.1112) '(1.2 1.111)) => nil))

(provide 'etd-examples)
;;; etd-examples.el ends here
