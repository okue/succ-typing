-module(ex1).
-export([
    f/1, t/1
  , f2/1, t2/1
]).

-spec f(integer()) -> ook | error.
f(1) -> ok;
f(2) -> error.

t(X) when is_integer(X) ->
  ok = f(X).

-spec f2(integer()) -> error.
f2(1) -> ok;
f2(2) -> error.

t2(X) when is_integer(X) ->
  ok = f2(X).