;;; etd-examples.el --- Tests for E.T.D. -*- lexical-binding: t; no-byte-compile: t; eval: (font-lock-add-keywords nil '(("examples\\|def-example-group\\| => " (0 'font-lock-keyword-face)))); -*-
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

(defalias 'group #'etd-example-group)
(defalias 'examples #'etd-examples)

;;;; Example Function.
(defun example-func (string)
  "Return a reversed copy of STRING."
  (reverse string))

;; ETD testing ...

(group "Documentation Helper Functions"
 (examples etd--first-three
  (etd--first-three '("one" "two" "three" "four" "five")) => '("one" "two" "three")
  (etd--first-three '(1 2 3 4 5)) => '(1 2 3))

 (examples etd--function-to-md
  (etd--function-to-md
   '(example-func (string) "Return a reversed copy of STRING." ("(example-func \"abc\") => \"cba\"")))
  => "### example-func `(string)`

Return a reversed copy of `string`.

```lisp
(example-func \"abc\") => \"cba\"
```
")

 (examples etd--function-summary
  (etd--function-summary '(first-three (list) ((first-three '("one" "two" "three" "four" "five")))
                           ⇒ '("one" "two" "three")
                           (first-three '(1 2 3 4 5))
                           ⇒ '(1 2 3)))
  => "* [first-three](#first-three-list) `(list)`")

 (examples etd--github-id
   (etd--github-id "foobzz" "(string &optional arg)") => "-foobzz-string-optional-arg"
   (etd--github-id "foobar" "(string list)") => "-foobar-string-list"
   (etd--github-id "foobaz" "(string &rest args)") => "-foobaz-string-rest-args")

 (examples etd--docs--chop-suffix
   (etd--docs--chop-suffix "Boom" "BigBaddaBoom") => "BigBadda"
   (etd--docs--chop-suffix "////" "BigBaddaBoom////") => "BigBaddaBoom"
   (etd--docs--chop-suffix "Badda" "BigBaddaBoom") => "BigBaddaBoom"))

(provide 'etd-examples)
;;; etd-examples.el ends here
