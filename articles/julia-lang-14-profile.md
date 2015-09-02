# 程式效能的分析工具profile

之前有提過我對於目前2048遊戲的效率不甚滿意，想要進一步提高程式的效能。在製作這個小品遊戲的時候，為了程式的可讀性，用來許多效率不是那麼高的寫法。例如建立多餘的陣列或是二維矩陣元素的讀取，所以留下了很多可以進一步最佳化的空間。但是我們又希望可以從「最值得」或是「最花時間」的程序著手開始優化。從原始碼開始推敲雖然也是一個方法，但是像julia這類的高階語言，它的後台其實也藏了很多我們自己的程式碼看不到東西，像是garbage collection之類程序。因此我們需要一個工具可以方便監測。

julia的標準函式庫裡面提供了使用者一個工具```@profile```來監測和統計各個函式被呼叫的狀況。在這邊我直接借用官網文件上的原始碼:

```julia
function myfunc()
    A = rand(100, 100, 200)
    maximum(A)
end
```

接著執行

```
@profile myfunc()
Profile.print()
```

 a```@profile```是利用抽樣來進行量測。當@profile作用在```myfunc()```上面時，它會在不同的時間點隨機「量測」目前myfunc()在執行那個部份。以```myfunc()```的例子來說，當@profile隨機進行抽樣的時候，它有可能正在執行```A=rand(100,100,200)```這個部份，也有可能正在執行```maximum(A)```這個部份。

我們接著來看執行上面程式碼之後所得到的結果:


```julia
20 ...3.1/lib/julia/sys.dylib; _start; (unknown line)
 20 ...3.1/lib/julia/sys.dylib; _start; (unknown line)
  20 ....1/lib/julia/sys.dylib; process_options; (unknown line)
   20 loading.jl; include_from_node1; line: 128
    20 ...1/lib/julia/sys.dylib; include; (unknown line)
     19 profile.jl; anonymous; line: 14
      11 random.jl; rand!; line: 130
      1  reduce.jl; _mapreduce; line: 168
       1 reduce.jl; mapreduce_impl; line: 281

```

這段輸出是一個巢狀的結構，每一列可以分為幾個部份，以第一列來說:

```
20 ...3.1/lib/julia/sys.dylib; _start; (unknown line)
```
第一個數字欄位代表的是這段程序被量到正在執行的次數(trackbacks)，第二欄位是這段程序所在的程式碼，第三個欄位是程序/函式的名再，最後一個欄位是程式碼裡的列數(line number)。程序愈內縮就表示它是愈內部的程序。舉個例子來說，第一列的```20 ...3.1/lib/julia/sys.dylib; _start; (unknown line)```被量到了20次，但是這20次裡頭，它都是在執行它內部的其中一個函式```20 ...3.1/lib/julia/sys.dylib; _start; (unknown line)```....以此類推，一直到第五列的```20 ...1/lib/julia/sys.dylib; include; (unknown line)```才開始分家:其中有1次是正在執行```1  ...1/lib/julia/sys.dylib; typeinf_ext; (unknown line)```，而另外19次是正在執行```19 profile.jl; anonymous; line: 14```....以此類推。

除了文字的結果之後，目前也有一個可以將profile結果視覺化的[套件](https://github.com/timholy/ProfileView.jl)可以使用。

今天就介紹到這邊。






