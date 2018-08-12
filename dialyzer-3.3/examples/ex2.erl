-module(ex2).
-export([
    f/1, t/1
    , fib/1
]).

% -spec f(1 | 2 | 3) -> ooook | ok.
-spec f(1) -> ook;
       (2) -> error.
f(1) -> ok;
f(2) -> error.

t(X) when is_integer(X) ->
  ok = f(X).

fib(0) -> 1;
fib(1) -> 1;
fib(X) -> fib(X-1) + fib(X-2).
