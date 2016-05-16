# commonjs_of_ocaml
> Import and export CommonJS modules in js_of_ocaml

[![Build Status](https://travis-ci.org/AngryLawyer/commonjs_of_ocaml.svg?branch=master)](https://travis-ci.org/AngryLawyer/commonjs_of_ocaml)

Working with Javascript CommonJS modules in js_of_ocaml can be difficult. ```commonjs_of_ocaml``` seeks to make things easier with a simple module and ppx syntax extension.

## Installing / Getting started

You'll need `opam` to install this module.

```shell
opam install commonjs_of_ocaml
```

Alternatively, you can install from the repo itself

```shell
git clone https://github.com/AngryLawyer/commonjs_of_ocaml.git
cd commonjs_of_ocaml
opam pin add commonjs_of_ocaml .
```

Include ```commonjs``` and ```commonjs_ppx``` in your ```-packages``` switch with ```ocamlbuild``` and you're on your way.

You can require ```commonjs``` compliant Javascript packages into your OCaml files as follows:

```ocaml
let my_module = [%require "./my_module"]
```

Alternatively, if you're working in a situation where you want to provide a fallback if a ```commonjs``` loader is not available, or a module is not available:

```ocaml
let my_module = [%require_or_default "./my_module" my_fallback_variable]
```

This, internally, wraps a try block around the require statement, and is useful for libraries where users may be attaching their modules directly to the DOM window where they're not using a ```commonjs``` loader.

You can also expose your OCaml library to ```commonjs```, for easy calling from native Javascript:

```ocaml
let () =
  CommonJS.export my_module
```

When you want to test your library, simply feed the js file produced by ```js_of_ocaml``` through a tool such as [Browserify](http://browserify.org) and your OCaml code should be bundled with its dependencies.

An example of importing and using the PPX is included in the tests directory.
## Developing

The project uses [oasis](http://oasis.forge.ocamlcore.org/) for building.
You'll need ```js_of_ocaml``` installed to do this.

If you need to edit this project, clone the project:

```shell
git clone https://github.com/AngryLawyer/commonjs_of_ocaml.git
cd commonjs_of_ocaml
ocaml setup.ml -configure
ocaml setup.ml -build
```

To run the test suite:

```shell
ocaml setup.ml -configure --enable-tests
ocaml setup.ml -test
```

## Why?
Packages such as [Browserify](http://browserify.org/) work by looking for calls to ```require``` in the Javascript AST. The code ```js_of_ocaml``` produces is minified in such a way that it's difficult for tools to find dependencies it has.

By using a PPX, we can embed the raw string requiring the Javascript module.

## Contributing
Fork the repo and make a pull request, and I'm more than happy to take a look!

## Licensing
This project is MIT licensed.
