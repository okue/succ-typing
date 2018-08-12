-module(ex2).
-export([
    f/1, t/1
]).

-spec f(number()) -> ooook | ok.
f(1) -> ok;
f(2) -> error.

t(X) when is_integer(X) ->
  ok = f(X).
