-module(example_3).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 3.2.4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-export([hoge/1, foo/0]).
%
% Typer infers:
% -spec hoge('a' | number()) -> 'bad' | 1.
% -spec foo() -> 2.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -export([foo/0]).
%
% Typer infers:
% -spec hoge('a') -> 'bad'.
% -spec foo() -> none().
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Version 3.3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -export([hoge/1, foo/0]).
%
% Typer outputs are:
% -spec hoge('a' | number()) -> 'bad' | 1.
% -spec foo() -> none().
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% -export([foo/0]).
%
% Typer outputs are:
% -spec hoge('a') -> 'bad'.
% -spec foo() -> none().
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-spec hoge (X) -> bad      when X :: a;
           (X) -> number() when X :: number().
hoge(X) when is_number(X) -> 1;
hoge(a) -> bad.

foo() ->
  _ = hoge(a) + 1.