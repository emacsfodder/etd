;;; etd.el --- Examples to Tests and Docs -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2023 Jason M23
;;
;; Author: Jason M23 <jasonm23@gmail.com>
;;
;; Created: August 14, 2022
;; Modified: September 10, 2022
;; Version: 2.1.0
;; Keywords: lisp tools extensions
;;
;; Homepage: https://github.com/emacsfodder/kurecolor
;; Package-Requires: ((emacs "24.4"))
;; License: GPL-3.0
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;; Derived from the test/docs functions/macros in magnars/s.el library.
;;
;; ETD allows the simple writing of examples as tests and generation of
;; markdown documents for both etd--functions and examples.
;;
;; Currently this package is dogfooding in emacsfodder/kurecolor and will be
;; backported to magnars/s.el for further testing at a suitable time. It
;; will be released to MELPA shortly after that.
;;
;; ## Usage:
;;
;; The easiest way to understand how to use `etd' is to check out
;; `kurecolor-examples.el' in this folder.
;;
;;; Code:

(require 'ert)
(require 'cl-lib)

(defvar etd-float-precision 0.0001)
(defvar etd-function-to-md-template
  "### %s %s

%s

```lisp
%s
```
")

(defvar etd-basic-template
  "[[ function-list ]]

[[ function-docs ]]
")

(defvar etd--testing t "When set to t run tests, when set to nil generate documents.")
(defvar etd--functions '() "Collected functions.")

(defun etd--zip (x y)
  "Zip lists X & Y together as a list of cons cells."
  (when (and (etd--listsp x y)
             (etd--length= x y))
    (let (result
          (c 0)
          (l (length x)))
      (while (< c l)
        (push (cons (nth c x) (nth c y)) result)
        (setq c (1+ c)))
      (reverse result))))

(defun etd--listsp (&rest lists)
  "Return non-nil if all LISTS satisfy `listp'."
  (cl-reduce
   (lambda (c l) (and c (listp l)))
   lists))

(defun etd--compare-flat-lists (x y fn)
  "Compare two flat lists X & Y using FN."
  (cl-reduce
   (lambda (c l) (and c (funcall fn (car l) (cdr l))))
   (etd--zip x y)))

(defun etd--length= (x y)
  "Test (length= X Y)."
  (= (length x) (length y)))

(defun etd--approximate-equal (x y)
  "Test approximate equality of X and Y."
  (if (and (listp x) (etd--listsp x y))
      (etd--lists-approx-equal x y)
    (etd--approx-equal x y)))

(defun etd--approx-equal (x y)
  "Test approximate equality.

In `etd-examples' use the form  X `~>' Y.

Corresponding floating points will be approximated by
`etd-float-precision'"
  (or (= x y)
      (equal x y)
      (and (floatp x) (floatp y)
           (< (/ (abs (- x y))
                 (max (abs x) (abs y)))
              etd-float-precision))))

(defun etd--lists-approx-equal (x y)
  "Test approximate equality of X and Y, lists of floating point numbers.

In `etd-examples' use the from  X `~>' Y.

Corresponding floating points will be approximated by
`etd-float-precision'"
   (and (etd--listsp x y)
    (and (etd--length= x y))
    (and (etd--compare-flat-lists x y #'etd--approx-equal))))

(defun etd--example-to-test (cmd idx example)
  "Create one `ert-deftest' from CMD, IDX and EXAMPLE."
  (let ((test-name (intern (format "%s-%02i" cmd idx)))
        (actual (car example))
        (operator (nth 1 example))
        (expected (nth 2 example)))
    (cond
      ((string= "=>" operator)
       `(ert-deftest ,test-name ()
           (should (equal-including-properties ,actual ,expected))))

      ((string= "~>" operator)
       `(ert-deftest ,test-name ()
           (should (etd--approximate-equal ,actual ,expected)))))))

(defun etd--examples-to-tests (cmd examples)
  "Create `ert-deftest' for CMD and each of the EXAMPLES."
  (let (result (idx 0))
    (while examples
      (setq idx (1+ idx))
      (setq result (cons (etd--example-to-test cmd idx examples) result))
      (setq examples (cdr (cddr examples))))
    (nreverse result)))

(defmacro etd-examples (cmd &rest examples)
  "CMD and EXAMPLES to ert-deftests."
  (declare (indent 1))
  (if etd--testing
      `(progn
        ,@(etd--examples-to-tests cmd examples))
   `(add-to-list #'etd--functions (list (etd--get-function-info #',cmd)
                                    (etd--examples-to-strings #',examples)))))

(defmacro etd-group (group &rest examples)
  "GROUP of EXAMPLES for docs."
  (declare (indent 1))
  (if etd--testing
      `(progn ,@examples)
   `(progn
      (add-to-list #'etd--functions ,group)
      ,@examples)))

(defun etd--example-to-string (example)
  "EXAMPLE to string."
  (let ((actual (car example))
        (expected (nth 2 example)))
    (cl-reduce
     (lambda (str regexp)
       (replace-regexp-in-string
        (car regexp) (cdr regexp)
        str t t))
     '(("\r" . "\\r")
       ("\t" . "\\t")
       ("\\\\\\?" . "?"))
     :initial-value (format "%S\n ⇒ %S" actual expected))))

(defun etd--examples-to-strings (examples)
  "Create strings from list of EXAMPLES."
  (let (result)
    (while examples
      (setq result (cons (etd--example-to-string examples) result))
      (setq examples (cdr (cddr examples))))
    (nreverse result)))

(defun etd--get-function-info (function-name)
  "Retrieve the name, arguments and docstring of FUNCTION-NAME.

Used internally to collate functions for documentation.

Note, this is only useful for user defined functions/macros."
  (let ((function-object (symbol-function function-name)))
    (pcase function-object
      (`(lambda ,args ,docstring ,_)
       (list function-name args docstring))
      (`(closure ,_ ,args ,docstring ,_)
       (list function-name args docstring))
      (`(macro closure ,_ ,args ,docstring ,_)
       (list function-name args docstring))
      (`(macro lambda ,args ,docstring ,_)
       (list function-name args docstring)))))

(defun etd--quote-and-downcase (str)
  "Wrap STR in backquotes for markdown."
   (format " `%s` " (downcase str)))

(defun etd--quote-docstring (docstring)
  "Quote DOCSTRING."
  (if (null docstring)
      ""
    (let ((case-fold-search nil))
     (replace-regexp-in-string
       "\\\\="
       ""
       (replace-regexp-in-string
         "\\([a-z]+\\)`\\([a-z]+\\)"
         "\\1'\\2"
         (replace-regexp-in-string
           "`\\(.*?\\)'"
           " `\\1` "
           (replace-regexp-in-string
            "\\b\\([A-Z][A-Z0-9-]*\\)\\b"
            #'etd--quote-and-downcase
            docstring t)))))))

(defun etd--function-summary (fn-info)
  "Create a markdown summary of FN-INFO."
  (if (stringp fn-info)
      (format "\n### %s \n" fn-info)
    (let* ((cmd (car fn-info))
           (command-name (car cmd))
           (signature (cadr cmd)))
      (format "* [%s](#%s) %s"
              command-name
              (etd--github-id command-name signature)
              (if signature (format "`%s`" signature) "")))))

(defun etd--function-info-to-md (fn-info)
  "FN-INFO to markdown."
  (if (stringp fn-info)
      (format "\n### %s \n" fn-info)
    (let* ((cmd (car fn-info))
           (command-name (car cmd))
           (signature (or (format "`%s`" (nth 1 cmd)) ""))
           (docstring (etd--quote-docstring (nth 2 cmd)))
           (fn-examples (cadr fn-info)))
      (format etd-function-to-md-template
              command-name
              signature
              docstring
              (mapconcat 'identity
                         (etd--first-three fn-examples)
                         "\n")))))

(defun etd--docs--chop-suffix (suffix s)
  "Remove SUFFIX from S."
  (let ((pos (- (length suffix))))
    (if (and (>= (length s) (length suffix))
             (string= suffix (substring s pos)))
        (substring s 0 pos)
      s)))

(defun etd--github-id (command-name signature)
  "Generate GitHub anchor id using COMMAND-NAME and SIGNATURE."
  (etd--docs--chop-suffix
   "-"
   (replace-regexp-in-string
    "[^a-zA-Z0-9-]+"
    "-"
    (format "%S %S"
            command-name
            (if signature
                signature
              "")))))

(defun etd--first-three (example-list)
  "Select first 3 examples from EXAMPLE-LIST."
    (pcase example-list
     (`(,first ,second ,third . ,_)
      (list first second third))
     (`(,first ,second . ,_)
      (list first second))
     (`(,first . ,_)
      (list first))))

(defun etd--simplify-quotes ()
  "Simplify quotes in buffer."
  (goto-char (point-min))
  (while (search-forward "(quote nil)" nil t)
    (replace-match "'()"))
  (goto-char (point-min))
  (while (search-forward "(quote " nil t)
    (forward-char -7)
    (let ((p (point)))
      (forward-sexp 1)
      (delete-char -1)
      (goto-char p)
      (delete-char 7)
      (insert "'"))))

(defun etd--goto-and-remove (s)
  "Goto S in buffer and remove it."
  (goto-char (point-min))
  (search-forward s)
  (delete-char (- (length s))))

(defun etd--create-docs-file (template readme)
  "Create README from TEMPLATE internal func."
  (let ((etd--functions (nreverse etd--functions)))
    (with-temp-file readme
     (insert-file-contents-literally template)
     (etd--goto-and-remove "[[ function-list ]]")
     (insert (mapconcat #'etd--function-summary etd--functions "\n"))
     (etd--goto-and-remove "[[ function-docs ]]")
     (insert (mapconcat #'etd--function-info-to-md etd--functions "\n"))
     (etd--simplify-quotes))))

(defun etd-create-docs-file-for-buffer (template readme)
  "Create README from TEMPLATE."
  (interactive "fSelect Template: \nFSelect README.md file: ")
  (setq etd--testing nil)
  (setq etd--functions '())
  (eval-buffer)
  (etd--create-docs-file template readme)
  (setq etd--testing t)
  (eval-buffer))

(defun etd--write-basic-template (file)
  "Write basic template to FILE."
  (with-temp-file file
    (insert etd-basic-template)))

(defun etd-create-template-file (file)
  "Create a basic template FILE.
User confirmation of existing FILE overwrite."
  (interactive "FNew Template filename: ")
  (if (file-exists-p file)
      (when (y-or-n-p (format "Template %s exists, overwrite?" file)) (etd--write-basic-template file))
    (etd--write-basic-template file)))

(defun etd-create-docs-file-for (examples-file template readme)
  "Using EXAMPLES-FILE and TEMPLATE create README."
  (interactive "fSelect Examples file: \nfSelect Template: \nFSelect README.md file: ")
  (setq etd--testing nil)
  (setq etd--functions '())
  (load-file examples-file)
  (etd--create-docs-file template readme))

(defun etd-debug-examples (examples-file)
  "List the functions tested in EXAMPLES-FILE."
  (interactive "fSelect Examples file: ")
  (setq etd--testing nil)
  (setq etd--functions '())
  (load-file examples-file)
  (mapcar 'print (reverse etd--functions)))

(provide 'etd)
;;; etd.el ends here
