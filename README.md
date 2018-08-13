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

specの出力の型と推論される出力の型の下限(inf)を, 関数の出力の型とする.
{dialyzer_typesig.erl, 818行}


---

- [dialyzer公式のテスト. 検査できることや警告文の意味の理解の参考に](https://github.com/erlang/otp/tree/master/lib/dialyzer/test)
- [最近変わった仕様: #1722](https://github.com/erlang/otp/pull/1722)
