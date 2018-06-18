# CHANGELOG

## 0.1.3
- Added function definitions using the `bai` keyword

## 0.1.2
- Added a Symbol Table which gets built up from the AST generated from the script
    - Symbol Table keeps track of defined symbols, removing the checks from the interpreter's global_scope
- Collapsed the INTEGER and REAL token types into a single NUMBER type, which matches up with the design spec
- Updated code slightly to work with Crystal 0.25

## 0.1.1
- Added handling for integer division and commenting

## 0.1.0
- The interpreter can finally interpret programs so that's nice
- Assignment statements (`remember €x = 1 like`) now work and variable information is currently stored in a Hash
    - This Hash needs to be replaced with an ADT at a later date
- Moving the repo to using `develop` and `master` branch workflow
