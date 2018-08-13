-module(example_2).
-compile(export_all).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% v3.2.4
% -spec hoge0('a' | number()) -> 'bad' | number().
% -spec foo0() -> number().
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% v3.3
% -spec hoge0('a' | number()) -> 'bad' | number().
% -spec foo0() -> number().
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hoge0(X) when is_number(X) -> X;
hoge0(a) -> bad.

foo0() -> hoge0(a) + 1.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% v3.2.4
% -spec foo1() -> none().
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% v3.3
% -spec foo1() -> none().
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-spec hoge1 (X) -> bad      when X :: a;
            (X) -> number() when X :: number().
hoge1(X) when is_number(X) -> X;
hoge1(a) -> bad.

foo1() -> hoge1(a) + 1.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% v3.2.4
% -spec hoge2('a' | number()) -> 'bad' | 1.
% -spec foo2() -> 2.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% v3.3
% -spec hoge2('a' | number()) -> 'bad' | 1.
% -spec foo2() -> 2.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hoge2(X) when is_number(X) -> 1;
hoge2(a) -> bad.

foo2() -> hoge2(a) + 1.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% v3.2.4
% -spec foo3() -> none().
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% v3.3
% -spec foo3() -> none().
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% spec                             succ-type
% ((a -> bad) | number() -> 1) vs. (a | number()) -> (1 | bad)
%
-spec hoge3 (X) -> bad      when X :: a;
            (X) -> 1        when X :: number().
hoge3(X) when is_number(X) -> 1;
hoge3(a) -> bad.

foo3() -> hoge3(a) + 1.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% v3.2.4
% -spec foo4() -> 2.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% v3.3
% -spec foo3() -> none().
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% spec                                    succ-type
% ((a -> bad) | number() -> number()) vs. (a | number()) -> (1 | bad)
%
-spec hoge4 (X) -> bad      when X :: a;
            (X) -> number() when X :: number().
hoge4(X) when is_number(X) -> 1;
hoge4(a) -> bad.

foo4() -> hoge4(a) + 1.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
