# etd - **E**xamples **T**ests **D**ocs

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

# Run the tests.

The `defexample` macro creates/evaluates to `ert-deftests` / `should` expectation tests.  

Run them selectively with `M-x ert` (or use `M-x ert-run-all-tests` to run all the tests.)

# Generate Docs

These commands generate docs:



## In the wild...

For now, the package is only available to install manually. Kurecolor has a
suite of examples here:
https://github.com/emacsfodder/kurecolor/blob/master/kurecolor-examples.el

See the documentation sample at https://emacsfodder.github.io/kurecolor/ (it's Markdown so theme/style is up to you.)

