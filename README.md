# etd - **E**xamples **T**ests **D**ocs

Derived from the test/docs functions/macros in [magnars/s.e](https://github.com/magnars/s.el) library.

ETD allows the simple writing of examples as tests and generation of
markdown documents for both functions and examples.

Currently a prototype of this package is dogfooding in emacsfodder/kurecolor.  
This repo will be used by kurecolor when it is suitable to release on MELPA.  

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

The `defexample` macro creates/evaluates to `ert-deftests` / `should` expectation tests.  So running `ert` will give you a set of tests (one for each `defexamples`)

Kurecolor has a suite of examples here: https://github.com/emacsfodder/kurecolor/blob/master/kurecolor-examples.el

You can also generate documentation from the examples/groups.  See the sample at https://emacsfodder.github.io/kurecolor/ (just from Markdown so theme/style is up to you.)

