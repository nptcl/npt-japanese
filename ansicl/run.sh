#!/bin/sh

npt --script main.lisp
#sbcl --load main.lisp
#clisp main.lisp
#ccl -l main.lisp

