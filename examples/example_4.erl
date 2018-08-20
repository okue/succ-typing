-module(example_4).
-export([local/1]).

local(_X) ->
  f(a).

f(X) ->
  case X of
    ok -> ok;
    _ -> throw(a)
  end.
