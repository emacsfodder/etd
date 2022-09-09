;;; etd-examples.el --- Tests for E.T.D.
;; -*- lexical-binding: t; eval: (font-lock-add-keywords nil '(("defexamples\\|def-example-group\\| => " (0 'font-lock-keyword-face)))); -*-
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
;;
;;  Tests for E.T.D.
;;
;;; Code:

(require 'etd)

;;;; Example Function.
(defun example-func (string)
  "Return a reversed copy of STRING."
  (reverse string))

;; ETD testing ...

(def-example-group "Documentation Helper Functions"
 (defexamples first-three
  (first-three '("one" "two" "three" "four" "five")) => '("one" "two" "three")
  (first-three '(1 2 3 4 5)) => '(1 2 3))

 (defexamples function-to-md
  (function-to-md
   '(example-func (string) "Return a reversed copy of STRING." ("(example-func \"abc\") => \"cba\"")))
  => "### example-func `(string)`

Return a reversed copy of `string`.

```lisp
(example-func \"abc\") => \"cba\"
```
")

 (defexamples function-summary
  (function-summary '(first-three (list) ((first-three '("one" "two" "three" "four" "five")))
                      ⇒ '("one" "two" "three")
                      (first-three '(1 2 3 4 5))
                      ⇒ '(1 2 3)))
  => "* [first-three](#first-three-list) `(list)`")

 (defexamples github-id
   (github-id "foobzz" "(string &optional arg)") => "-foobzz-string-optional-arg"
   (github-id "foobar" "(string list)") => "-foobar-string-list"
   (github-id "foobaz" "(string &rest args)") => "-foobaz-string-rest-args")

 (defexamples docs--chop-suffix
   (docs--chop-suffix "Boom" "BigBaddaBoom") => "BigBadda"
   (docs--chop-suffix "////" "BigBaddaBoom////") => "BigBaddaBoom"
   (docs--chop-suffix "Badda" "BigBaddaBoom") => "BigBaddaBoom")

 (defexamples example-to-should-1
   (example-to-should-1)))

(provide 'etd-examples)
;;; etd-examples.el ends here
