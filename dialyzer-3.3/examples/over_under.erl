-module(over_under).
-export([t1/2, t2/2, t3/2, t4/2]).
-dialyzer([no_return]).

%% GET FROM https://github.com/erlang/otp/tree/master/lib/dialyzer/test

%% this spec matches the behaviour of the code
-spec normal(integer()) -> ok | error.
normal(1) -> ok;
normal(2) -> error.
 t1(X, Y) when is_integer(X), is_integer(Y) ->
    ok = normal(X),
    error = normal(Y),
    ok.

%% this spec has a typo, which should cause anyone trying to match on
%% `ok = typo(X)' to get a warning, because `ok' is not in the spec
-spec typo(integer()) -> ook | error.
typo(1) -> ok;
typo(2) -> error.
t2(X, Y) when is_integer(X), is_integer(Y) ->
    ok = typo(X),  % warning expected - not allowed according to spec
    error = typo(Y),
    ok.

%% this is overspecified, which should cause anyone trying to match on
%% `maybe = over(X)' to get a warning, because `maybe' is not in the spec
%%
%% この例は, v3.3より前でも警告が出る
%% specの型が強いので, specは捨てない
-spec over(integer()) -> yes | no.
over(1) -> yes;
over(2) -> no;
over(_) -> maybe.
t4(X, Y) when is_integer(X), is_integer(Y) ->
    yes = over(X),
    no = over(Y),
    maybe = over(X + Y), % warning expected - not in spec
    ok.

%% this is underspecified, and should cause a warning for trying
%% to match on `no = under(X)', because it cannot succeed and either
%% the spec should be updated or the code should be extended
%%
%% この例は, v3.3より前でも警告が出る
%% specの出力の型が緩い場合は, extra_rangeエラーが出てこのspecは捨てられていた
-spec under(integer()) -> yes | no | maybe.
under(1) -> yes;
under(_) -> maybe.
t3(X, Y) when is_integer(X), is_integer(Y) ->
    yes = under(X),
    no = under(Y),  % warning expected - spec or code needs fixing
    maybe = under(X + Y),
    ok.
