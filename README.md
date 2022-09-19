# **E**xamples **T**ests **D**ocs (ETD)
### Minimalist unit testing in Emacs, with documentation generation as a side effect.


![ETD-illustration](https://user-images.githubusercontent.com/71587/189462116-6405d85c-ff23-4c3f-adc4-5e326ab7970c.png)

Derived from the test/docs functions/macros in [magnars/s.el](https://github.com/magnars/s.el) library.

ETD allows the simple writing of examples as tests and generation of
markdown documents for both functions and examples.

It generates tests using Emacs Regression Testing (ERT) so it can be used alongside a standard ert suite.

## Usage:

ETD provides 2 macros `etd-group` and  `etd-examples` which can be grouped.

```
(etd-group "Kurecolor"
  (etd-examples kurecolor-clamp
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

The `etd-examples` macro creates/evaluates to `ert-deftests` / `should` expectation tests.  

Run them selectively with `M-x ert` (or use `M-x ert-run-all-tests` to run all the tests.)

### Batch mode Emacs

To run the tests from the terminal or using a CI, ETD uses the standard method for any ERT suite. Assuming a project has `examples.el` (which includes `(require 'etd)`) the simplest command would be.

```
emacs --batch -l path-to/examples.el -f ert-run-all-tests-batch-and-exit
```
If `etd` is not in the Emacs `load-path` you can do:

```
emacs --batch -l path-to/etd.el -l path-to/examples.el -f ert-run-all-tests-batch-and-exit
```

For an example using github workflows CI, [see Kurecolor's workflow](https://github.com/emacsfodder/kurecolor/blob/master/.github/workflows/kurecolor-tests.yml) and [scripts](https://github.com/emacsfodder/kurecolor/tree/master/bin)

# Advanced usage:

## Mocking and error checking tests.

Because ETD is compatible with ERT and uses the same test runner, it's recommended that advanced tests that require mocking, or error handling use `ert-deftest` and the extensive/convenient matchers from [`ert-expectations`](https://github.com/emacsorphanage/ert-expectations) (which in turn, uses [`el-mock`](https://github.com/rejeep/el-mock.el) for mocking.)

# Generate Docs

## Template

An ETD template file is a text/markdown file. It should contain two placeholders, 

```
[[ function-summary ]]
```

Which will be replaced by the list of function signatures (name + args).
Each one links to the full function entry in the `[[ function-list ]]`.

``` 
[[ function-list ]]
```
 
Which will be replaced by the list of function entries. Each one includes function signature, docstring (formatted for markdown) and the top three examples, make those top 3 good examples.

[See etd-example-template](./etd-examples-template)

[Docs generated for Kurecolor](https://emacsfodder.github.io/kurecolor/)

## Commands to generate docs...

To generate docs use these commands.

```
M-x etd-create-docs-file-for-buffer 
```
This prompts for a template and a markdown target. It uses the current buffer examples.

```
M-x etd-create-docs-file-for
```
This prompts for an elisp file with etd examples, a readme template and a readme markdown target.

# Projects using ETD

[Kurecolor](https://github.com/emacsfodder/kurecolor) has a suite of examples here:

https://github.com/emacsfodder/kurecolor/blob/master/kurecolor-examples.el

With ETD generated docs at https://emacsfodder.github.io/kurecolor/

(Note: ETD just produces the markdown, styling and conversion to HTML or other formats is handled by other tools, e.g. https://github.com/raphlinus/pulldown-cmark or https://github.com/kivikakk/comrak.  Kurecolor publishes docs using Github gh-pages)

