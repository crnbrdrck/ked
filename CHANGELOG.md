# CHANGELOG

## 0.1.2
- Added a Symbol Table which gets built up from the AST generated from the script
    - Symbol Table keeps track of defined symbols, removing the checks from the interpreter's global_scope

## 0.1.1
- Added handling for integer division and commenting

## 0.1.0
- The interpreter can finally interpret programs so that's nice
- Assignment statements (`remember €x = 1 like`) now work and variable information is currently stored in a Hash
    - This Hash needs to be replaced with an ADT at a later date
- Moving the repo to using `develop` and `master` branch workflow
