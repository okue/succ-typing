### Tips

**underspecs**

strictly more allowing than the success typing = specが弱い.
凡そ, "specで書かれている関数の返り値の型が, success typingで推論できない"


**overspecs**

strictly less allowing than the success typing = specが強い.
凡そ, "success typingで推論される関数の返り値の型が, specに書かれていない"

```erl
%% overspec
-spec hoge(number()) -> 1 | 2.
hoge(X) when X > 0   -> 1;
hoge(X) when X =:= 0 -> 2;
hoge(X) when X < 0   -> 3.

%% underspec
-spec hoge(number()) -> 1 | 2 | 4.
hoge(X) when X > 0   -> 1;
hoge(X) when X =:= 0 -> 2.
```

overspecsとunderspecsは排反ではない.

```erl
%% overspec and underspec
-spec hoge(number()) -> 1 | 2 | 4.
hoge(X) when X > 0   -> 1;
hoge(X) when X =:= 0 -> 2;
hoge(X) when X < 0   -> 3.
```

(**-Wspecdiffs** は, overspecsとunderspecsの両方の警告に加えて, CONTRACT_NOT_EQUAL警告を出す)

specの型とsuccess typingの型で明らかな食い違いがある場合は, invalid_contract警告が出る.
"入力の型または出力の型について, specの型とsuccess typingの型で共通部分がない"など.


**exported functionとlocal function**

exported functionとlocal functionでは, 推論される型が異なる.
ローカル関数の場合, そのモジュール内でどのような引数で呼ばれているかを見て, 推論される出力の型を小さくしてくれる.
`f(1 | 2) -> good | bad` というローカル関数があって, 引数は常に1で, 返り値はgoodしかありえないなら, `f(1) -> good` と推論する.


**race conditions**

おそらく, ets, register, unregisterらへんの警告を出す.


**specと推論される型**

明らかな間違いがない限りspecの型と推論される型を組み合わせて, 推論が進む.
明らかな間違いというのは, 推論される入出力の型とspecの型に共通部分がないこと.
a | b -> c | dと推論される関数に, a -> c | eと書くのは許される.
a -> eは, 出力の型が間違いと見なされ警告が出る.

古いバージョンのDialyzerでは, specの出力の型と推論される出力の型で下限(inf)がnone()になる場合は, specが捨てられていた.
v3.3では, 捨てられなくなっている.


**specの型と推論される型の組み合わせ方**

specの出力の型と推論される出力の型の下限(inf)を, 関数の出力の型として推論を進める.
{dialyzer_typesig.erl, 818行}


```erl
-spec f(integer()) -> ook | error.
f(1) -> ok;
f(2) -> error.

t(X) when is_integer(X) ->
  ok = f(X).

t2(X) when is_integer(X) ->
  error = f(X).
```

例えば上では, fは `(1 | 2) -> ok | error` と推論される.
fにspecが書かれていない場合, fはokまたはerrorを返す可能性があるので, 関数t, t2はパターンマッチに成功しうる.
したがって, t, t2には型 `(1 | 2) -> ok`, `(1 | 2) -> error` が付く.


しかし, 今回fには, `(integer()) -> ook | error` というtypoを含むspecが書かれている.
関数t, t2におけるパターンマッチが成功するか否かを推論するとき, 推論されたfの型に加えてspecの内容が利用される.

推論された型 `(1 | 2) -> ok | error` と specの型 `(integer()) -> ook | error` の出力の型を組み合わせ,
fの返り値の型は inf(ok | error, ook | error) = error の部分型としてパターンマッチの箇所を推論する.

tについて, fの返り値はerrorの部分型, つまりerrorなのでokとマッチしえないので, 型が付かないと警告が起こる.

t2について, fの返り値はerrorでパターンマッチに成功するので, t2には `(1 | 2) -> error` 型がつく.


**警告の例**

1. 関数適用f(3)の引数の型が, Success typingで推論されない場合: {dialyzer.erl, 496行}

```erl
f(1) -> ok;
f(2) -> error.

t(X) when is_integer(X) ->
  ok = f(3).

%% ex1.erl:15: Function t/1 has no local return
%% ex1.erl:16: The call ex1:f(3) will never return since it differs in the 1st argument from the success typing arguments: (1 | 2)
```


2. 関数適用f(3)の引数の型が, Success typingにもspecにも反する場合: {dialyzer.erl, 496行}

```erl
-spec f(1) -> ok;
       (2) -> error.
f(1) -> ok;
f(2) -> error.

t(X) when is_integer(X) ->
  ok = f(3).

%% ex1.erl:15: Function t/1 has no local return
%% ex1.erl:16: The call ex1:f(3) will never return since the success typing is (1 | 2) -> 'error' | 'ok' and the contract is (1) -> 'ok'; (2) -> 'error'
```


3. 関数適用f(3)の引数の型が, specに反する場合: {dialyzer.erl, 496行}

```erl
-spec f(2) -> error.
f(1) -> ok;
f(2) -> error.

t(X) when is_integer(X) ->
  ok = f(1).

%% ex1.erl:14: Function t/1 has no local return
%% ex1.erl:15: The call ex1:f(1) breaks the contract (2) -> 'error'
```


**build_plt時のファイルやディレクトリの指定**

`-c` または何も付けずにディレクトリを指定すると, ディレクトリ下のBEAMファイルを探す.
`-r` でディレクトリを指定すると, ディレクトリ下のBEAMファイルを再帰的に探す.
`--apps` で名前を指定すると, 該当するディレクトリ直下のebin以下からBEAMファイルを再帰的に探す.


---

- [dialyzer公式のテスト. 検査できることや警告文の意味の理解の参考に](https://github.com/erlang/otp/tree/master/lib/dialyzer/test)
- [最近変わった仕様: #1722](https://github.com/erlang/otp/pull/1722)
