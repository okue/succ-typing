-module(over_under).
-export([hoge/1]).

-spec hoge(number()) -> 1 | 2 | 4.
hoge(X) when X > 0   -> 1;
hoge(X) when X =:= 0 -> 2;
hoge(X) when X < 0   -> 3.
