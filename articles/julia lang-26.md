### julia 的平行運算

之前我們有說過julia的其中一個特色是平行運算。目前幾個主流的科學運算語言(R/Python/Matlab)一開始的的時候都沒有內建平行運算的功能，它們都需要額外的套件來達成。身為新時代的科學計算語言，julia出道的時候就具備了平行運算的功能。

然而，julia的平行運算模式是比較低階(low-level)的，而不是使用主流MPI模式。使用者必須自己指定主行程(process)之外的其他行程應該作些什麼事情，但是julia的對於parallel函式的封裝設計又不會讓這些低階操作太過於瑣碎難用。我自己感覺這還蠻符合julia語言在設計上的一貫風格:試圖在效率和易用之間找到一個平衡，讓使用者稍微多花一點心思，卻能在執行效率上得到很大的回報。

julia的平行運算包含了兩個主要的原始結構: 遠端物件位址(remote reference)和遠端物件呼叫(remote call)。這裡的"遠端"表示的是process之間關係，主process以外的process都可以視為遠端。

remote reference是一個物件位址。這個物件裡面裝的可以讓某個process執行的東西，而reference call則是某個process用來請另一個process執行某個函式的呼叫請求。

直接來看個例子會比較清楚。

在啟動julia的時候就要先決定要分配幾個process給julia的程式:

```
> julia -p 2
```

上面這個指令用來分配了兩個額外的行程給julia，在進入julia主程式之後可以執行nprocs()來確認目前julia用了幾個process:

```
julia> nprocs()
3
```

結果顯示目前有三個process為julia所用。

接著就來看個例子:

```
julia> r=remotecall(2,rand,2,2)
```
在上面這個例子中，remotecall(2,rand,100,100)的意思是請process#2執行rand(100,100)這個函式，然後傳回r，r是一個remote reference。

remotecall執行之後，process#2就開始執行rand(100,100)，由於目前所在的主process是process#1，所以rand(100,100)是在背景執行。我們可以用fetch()函式來取回這個remote reference所得到的結果:


```
julia> fetch(r)
2x2 Array{Float64,2}:
 0.804123  0.957619 
 0.601292  0.0142232
```

如果fetch(r)執行時，r的運算結果還沒完成，主process就會等它完成才進行下一個指令。以上就是julia parallel programming的基本款。

這個基本款的變型是@spawnat巨集，它和remotecall類似，不一樣的地方是它可以用來執行一個expression，例如:

```
julia>s=@spawnat 2 rand(100)+rand(100)

```
上面這行指令就是對process#2送出一個請求，執行rand(100)+rand(100)，同樣也是傳回一個remote reference s。需要傳回結果時，就用fetch(s)把計算的結果送回主process。

以上就是julia的parallel programming的基本概念和型態。
