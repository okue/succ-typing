#!/usr/bin/env bash
FILE=examples/ex1.erl
echo $FILE
./bin/dialyzer -n $FILE #-Wspecdiffs
# typer $FILE
