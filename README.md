# OCaml Assignment 3: Compiler Components for WHILE Language

## Overview

This README accompanies the third assignment for the "Programming Languages" course (קורס שפות תכנות), focusing on developing foundational components of a compiler for the WHILE programming language using OCaml. The assignment encompasses the creation of a lexer, parser, reducer, and a set of utilities, along with a comprehensive suite of tests to verify the implementation.

## File Descriptions

- `utils.ml`: Contains utility functions that support the operations of other components in the compiler architecture, such as string manipulation and error handling.

- `lexer.ml`: Implements the lexical analyzer (lexer) that converts a sequence of characters into a sequence of tokens, preparing the input for parsing.

- `parser.ml`: Defines the parser that constructs an abstract syntax tree (AST) from the sequence of tokens produced by the lexer, representing the program's syntactical structure.

- `reducer.ml`: Provides the functionality to transform the AST into a simpler form, applying reductions based on the semantics of the WHILE language.

- `tests.ml`: Includes a comprehensive set of tests to verify the correct operation of the lexer, parser, reducer, and utility functions, ensuring the integrity of the compiler components.

## Compilation and Execution

The solution is compatible with OCaml version 4.02 and does not require the Core library. To compile the project, use the following command:

```sh
ocamlc -o tests utils.ml lexer.ml parser.ml reducer.ml tests.ml
```

After compilation, the tests can be run with:

```sh
./tests
```

## Objective

The primary objective of this assignment is to gain hands-on experience in implementing essential components of a compiler for a programming language. Through this exercise, students are expected to apply theoretical concepts from the "Programming Languages" course, bridging the gap between abstract language theory and practical compiler construction.
