---
title: 深入julia的型別(type)
---

今天繼續講一些有關type的實際操作，算是比較偏向語法細節的介紹。我的目的是用我自己在julia學習經驗，向大家介紹一些這個type和

julia語言裡用```::```來連結一個實體(instance)和type。```::```的英文念作"an instance of"(中文翻作xxx為某個type的實體，但中文講起就是沒有辦法像英文那麼簡潔啊)
不過```::```在julia裡並不是用來宣告某個值的型別，它的功能比較接近assertion，例如:


```
julia> x=3
3

julia> x::Int
3
```
在這個例子中，我們先指定x=3，接下來用執行x::Int，一切都沒什麼異樣。


然後，當我們執行x::Int32時就出現了assertion error，這是因為系統預設整數為Int64，以下就是執行結果。
```
julia> x::Int32
ERROR: type: typeassert: expected Int32, got Int64

julia> x::Int64
3

```
問題來了，如果硬要使用Int32作為整數3的型別呢? 我們可以用```convert()```這個函式進行型別強制轉換:

```
julia> x=convert(Int32,x)
3

julia> x::Int32
3
```
在上面這個例子中，3這個整數就被強制轉為Int32了。

之前有提過，這裡也要再次提醒讀者，x本身是沒有型別的，它只是一個變數名稱，或是可以看作一個標籤，真正有型別的是x這個變數所指向的實體。


接下來我們來介紹有關抽象型別(abstract type)的語法。

前一段我們介紹過```::```是an instance of，對於抽象型別julia也有對應的```<:```，可理解為a subtype of，舉個例子:

```
julia> Int32<:Real
true

julia> Int32<:FloatingPoint
false

```
根據系統內設的定義，Int32是<:Real的subtype，所以傳回true，反之Int32<:不是FloatingPoint的subtype，所以傳回false。

如果使用者要自定type之間的繼承關係，可以使用```abstract```這個keyword，像是這樣:

```
abstract Real <: Number

```

在一些OOP語言裡，會有一個最最基本的物件在金字塔的頂端，而程式的所有物件都會繼承自這個基本物件。julia的type系統也有類似的設計，在julia裡這個type叫做Any，所以的type都是從這裡衍生出來的。

今天花太多時間在debug新的2048AI，所以只能寫到這裡，再不發文鐵人生活就要中斷了，大家晚安。

