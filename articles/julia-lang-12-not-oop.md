# 這不是OOP!

今天比較想講一些有關julia語言的特性和雜談。

在前面的文章以及2048的實作當作，我們幾乎不需要關注太多有關型別(Type)的問題。julia完全可以當作一個像python或是matlab那樣的動態語言來使用，型別的判斷可以完全交給compiler來處理。然而julia的特殊之處就在於，使用者可以在coding的時候透過一些手段來大幅提高執行的效能，讓它可以很接近C的效率。完全把它當作python或是matlab來使用的話那就去python或matlab就可以了，就沒有學習julia這個語言的必要。

在這個系列裡頭，我經常拿julia的語法和其他幾個主流的科學運算上常用的腳本語言(scripting language)作比較，例如python、matlab和R。但是julia在型別的設計和其他語言非常不同。julia在物件導向的支援並不如python這麼全面，而它物件導向的特性和python、C#/Java、C++不太一樣。比方說，在julia裡，實體型別(concrete type)可以繼承抽象型別(abstract type)，但是不能繼承另一個實體型別。也因此，julia的只有type沒有class的概念。這在用慣了全物件導向語言的工程師們看來會覺得綁手綁腳，但在julia的官方文件中，作者認為
While this might at first seem unduly restrictive, it has many beneficial consequences with surprisingly few drawbacks.[原文連結](http://docs.julialang.org/en/release-0.3/manual/types/#types) (原文翻譯:這看似太過綁手綁腳，但卻意外地利大於弊 :p) 在一般教科書的定義裡頭，一個物件導向語言包含了三個要件: 繼承(inheritance)、封裝(encapsulation)、多型(polymorphism)，在julia裡，真正支援的的只有多型，以及一小部份繼承和封裝的特色。而這個設計或許比較接近Golang(我對Golang不熟，有錯請指正)。

今天稍早剛好看到一兩文章在檢討OOP，見[連結1](https://plus.google.com/117268856978520890598/posts/3mr4jRE4hLg)和[連結2](http://www.smashcompany.com/technology/object-oriented-programming-is-an-expensive-disaster-which-must-end)。兩篇長文都認為過度使用OOP的概念和設計只是讓程式碼變得莫名其妙複雜，完全沒有必要。我自己不是專業的軟體從業人員，電腦程式是平常是我的業餘興趣和幫我解決一些專業上面問題的工具，所以我不認為我很適合評論OO到底適不適合用來開發大型系統和軟體，那是我從來沒接觸過的領域。然而，因為OOP語言實在太流行，到處都是，所以在學了C之後，我比較常寫的語言大部份都是OOP或是完全支援OOP的語言，所以經常是用OO的觀點來看問題或是解決問題。在這個初試julia的2048 project，如果julia完整支援封裝的話，我大概也會像javascript版那樣，把board封裝成一個物件。但實際完成board的部份之後就發覺其實沒有封裝也很快樂XD 然而，julia使用這樣的設計並不是出於軟體工程的理由，而只是因為這樣比較的設計比較容易讓編譯器產生有效率的程式碼。所以要充份發揮julia的能力，花時間了解julia的架構和語言細節是完全必要的。


回歸正題，在julia裡，任何的資料都屬於一個type，不管是整數、浮點數或是複數。這個type比較像是C語言裡面的type: 它是一種資料型別，不能在type裡頭加進method或是function，但是使用者可以自訂struct型態的type來放多個不同的變數。但是julia又把type分成抽象型別abstract type和具體型別concrete type。abstract type不能有任何實體物件，只有concrete type可以。

舉個例子，Int64是一個concrete type，它是繼承自一個Integer這個abstract type，而Integer又是繼承自Real。這個繼承的關係會在選擇method的時候發生作用。例如我們定義了函式

```
function f(x::Real,y::Real)
    x-y
end

fucntion f(x::Int64,y::Int64)
    x+y
end
```
則執行f(1,2)時，編譯器會根據引數1和2的型別去找對應該f(x,y)，它找到了f(x::Int64,y::Int64)可以完全對應引數1和2的型別，而得到結果x+y。

但當執行f(1.0, 2.0)時，因為1.0和2.0是浮點數，所以編譯器找不到可以對應到浮點數的型別，因此只能退而求其次，往上一層看看有沒有浮點數的abstract type有沒有定義，於是找到了f(x::Real, y::Real)，就會傳回結果x-y。

julia就是用abstract type結合這種method matching的方法來達成多型，以及維持語言本身的高度彈性。

希望這樣的概念介紹對大家如果讀官方文件能帶來一點幫助。










