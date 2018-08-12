#!/usr/bin/env bash
FILE=examples/ex2.erl
echo $FILE
./bin/dialyzer -n $FILE -Wspecdiffs
# typer $FILE
