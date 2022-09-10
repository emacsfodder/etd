# etd - **E**xamples **T**ests **D**ocs

![ETD-illustration](https://user-images.githubusercontent.com/71587/189462116-6405d85c-ff23-4c3f-adc4-5e326ab7970c.png)

Derived from the test/docs functions/macros in [magnars/s.e](https://github.com/magnars/s.el) library.

ETD allows the simple writing of examples as tests and generation of
markdown documents for both functions and examples.

A prototype of this package is dogfooding in https://github.com/emacsfodder/kurecolor. 

## Usage:

ETD provides 2 macros...

Let's test a function....

### defexample (function examples)

```
(defexamples kurecolor-clamp
  (kurecolor-clamp 1 -1 2)  => 1
  (kurecolor-clamp -2 -1 2) => -1
  (kurecolor-clamp 4 -1 2)  => 2)
```

These can be grouped...

### def-example-group (name defexamples)

```
(def-example-group "Kurecolor"
  (defexamples kurecolor-clamp
    (kurecolor-clamp 1 -1 2)  => 1
    (kurecolor-clamp -2 -1 2) => -1
    (kurecolor-clamp 4 -1 2)  => 2))
```

### Operators

The standard match operator `=>` compares the output (on the left) to the expected output (on the right) and passes the test if they are equal.

To make examples using floating point numbers more readable, you can use the approximately equal operator `~>` which compares floating point numbers using lower precision (default is `0.0001`).

For example:

```
(kurecolor-hex-get-saturation "#7FFF7F") => 0.5019607843137255
```
Can be simplified to:
```
(kurecolor-hex-get-saturation "#7FFF7F") ~> 0.5020
```

Note floating point numbers should be rounded at the last decimal place, or use an extra digit beyond the precision boundary, e.g. at the default precision (`0.0001`) the folowing will all be approximately equal:

```
0.4470588235294118
0.44705
0.4471
```

Lists of floats can be approximated too, however, note this is limited to simple lists, nested lists are not supported.

```
(kurecolor-hex-to-rgba "#34729100") => '(0.20392156862745098 0.4470588235294118 0.5686274509803921 0.0)
```
Can be simplified to:
```
(kurecolor-hex-to-rgba "#34729100") ~> '(0.2039 0.4471 0.5686 0.0)
```

# Run the tests.

The `defexample` macro creates/evaluates to `ert-deftests` / `should` expectation tests.  

Run them selectively with `M-x ert` (or use `M-x ert-run-all-tests` to run all the tests.)

# Advanced usage:

## Mocking and error checking tests.

Because ETD is compatible with ERT and uses the same test runner, we recommend composing advanced tests wit `ert-deftest` and using the the matchers from [`ert-expectations`](https://github.com/emacsorphanage/ert-expectations) (which uses [`el-mock`](https://github.com/rejeep/el-mock.el))

# Generate Docs

To generate docs use these commands.

```
M-x etd-create-docs-file-for-buffer 
```
This prompts for a template and a markdown target. It uses the current buffer examples.

```
M-x etd-create-docs-file-for
```
This prompts for an elisp file with etd examples, a readme template and a readme markdown target.

# Template

An ETD template file is a text/markdown file. It should contain two placeholders, 

1. `[[ function-summary ]]`
  - A list of function signatures (name + args), each links to the full function entry in the function-list.
1. `[[ function-list ]]`
  - A list of function definitions, including the function signature, the docstring and the top three examples, so make at least 3 good examples for each function. 

## Projects using ETD

[Kurecolor](https://github.com/emacsfodder/kurecolor) has a suite of examples here:

https://github.com/emacsfodder/kurecolor/blob/master/kurecolor-examples.el

With ETD generated docs at https://emacsfodder.github.io/kurecolor/

(Note: ETD just produces the markdown, styling and conversion to HTML or other formats is handled by other tools, e.g. https://github.com/raphlinus/pulldown-cmark or https://github.com/kivikakk/comrak.  Kurecolor publishes docs using Github gh-pages)

