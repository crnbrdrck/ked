# ked
![Travis Master Status](https://img.shields.io/travis/crnbrdrck/ked/master.svg)
[![Latest Release](https://img.shields.io/github/tag/crnbrdrck/ked.svg)](https://github.com/crnbrdrck/ked/releases/latest)


The first scripting language of [The People's Republic of Cork](http://en.wikipedia.org/wiki/Cork_\(city\)).

# Note


## Table Of Contents
- [ked-lang Documentation](#ked-lang-documentation)
- [But Why?](#but-why)
- [Installation](#installation)
- [Usage](#usage)
- [Dev Roadmap](#dev-roadmap)
    - [v0.1](#v0.1)
    - [v0.2](#v0.2)
    - [Interpreter Tutorial](#interpreter-tutorial)
    - [Implemented Features](#implemented-features)
- [Contributing](#contributing)
    - [Contributors](#contributors)

## ked-lang Documentation
See the original [documentation](http://adam-lynch.github.io/ked/) showcasing the initial design of the language.

There will also be documentation more akin to a reference available sometime (not right now basically) at https://crnbrdrck.xyz/ked.

## But Why?
This interpreter is being built by me ([crnbrdrck](https://github.com/crnbrdrck)), in the wonderful Crystal Programming Language.

I will be following [Writing an Interpreter in Go](https://interpreterbook.com/) for this new write up of the ked language, but obviously will be translating to Crystal as best I can.

This should not only help me with my Crystal, but also maybe help me learn Go as a side product?

I'm doing this for a few reasons;
1. I wanted to learn how interpreters function
2. I wanted another project to do in Crystal
3. I've known about Ked for a while and always assumed it was an actual programming language so I wanted to make it real
4. For the fun of it

## Installation

1. Ensure that *Crystal* is installed on your machine: https://crystal-lang.org/docs/installation/
2. Clone this repo from the master branch: `git clone git@github.com:crnbrdrck/ked.git`
3. Build the binary: `make`
    - The binary will be saved to `./bin/`
4. (Optionally) Install the binary to your path: `sudo make install`

To remove, simply do `sudo make clean` which will clean up any directories and files made by the install process

## Usage

```
Usage:
  ked [options] feen.ked - Run the script called 'feen.ked'

  Options:
    -d, --debug                      Print the status of the global variable scope after running the script
    -h, --help                       Show this help message
    -v, --version                    Print version information
```

- `ked feen.ked` - Run the script named 'feen.ked'
- `ked -d feen.ked` - Same as above but also prints the current state of the interpreter's global variable state table to stdout
- `ked -v` - Check the current version of `ked` installed

## Dev Roadmap
A little way of checking the progress of the development of the `ked` programming language

### v0.1
Any releases at this version were written following [this tutorial](https://ruslanspivak.com/lsbasi-part1/) and they work somewhat.

This code is still available under [releases](https://github.com/crnbrdrck/ked/releases), and is viewable on the [lsbasi-archive](https://github.com/crnbrdrck/ked/tree/lsbasi-archive) branch.

### v0.2 and onwards
These are the versions that are being built following the *Interpreter in Go* book.

Hopefully it will be better and more fully featured, but I will still be having to translate both Go into Crystal and Monkey (the language developed in the book) into Ked.

### Book Chapters
Below is a list of the chapters in the [book](https://interpreterbook.com/) that I am following.

This list can be used to see at a glance the dev status of the project

- [ ] Chapter 1: Lexing
- [ ] Chapter 2: Parsing
- [ ] Chapter 3: Evaluation
- [ ] Chapter 4: Extending The Interpreter
- [ ] The Lost Chapter

### Implemented Features
This is an ever growing list of the current features supported in the `ked` language.
If this list grows too big I'll probably group things together to give it a semblance of structure

***NOTE**: Anything in the list below marked with an asterisk was something not in the original design doc and is open to debate*

- Nothing right now because I'm starting from scratch

For more info, see the [CHANGELOG](CHANGELOG.md) to see what changed and when

## Contributing

1. Fork it ( https://github.com/[your-github-name]/ked/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

**Please make all Pull Requests to the `develop` branch and not the master branch**

## Contributors

Pull-requests encouraged, but contributions are accepted in any form, including [issues](https://github.com/crnbrdrck/ked/issues).

### Contributors
- [adam-lynch](https://github.com/adam-lynch/) - original designer of the Ked language
- [crnbrdrck](https://github.com/crnbrdrck) Ciaran Broderick - developed interpreter in crystal
