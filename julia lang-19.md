在繼續玩titanic這個data set之前，我想先介紹IJulia這個工具。


### IJulia
首先要介紹的是一個非常好用的工具[IJulia](https://github.com/JuliaLang/IJulia.jl)。IJulia提供了一個讓使用者可以互動式使用julia的工具，它的使用介面類似Mathematica，每個input都對到一個output。看起來像這樣:


有用過Mathematica或是Ipython的朋友們應該對這個介面相當熟悉。IJulia和IPyhton用的也是同一套backend，只不過語言的編譯器不一樣而已。類似這樣的使用者介面非常適合用來分析資料。在分析資料的時候，我們會遇到一種很常見的情況，就是花了很多資料讀進記憶體之後，想稍微改個指令，試一些其他的想法，就要重新把script重新再跑一次。雖然終端機的julia環境可以彌補這個缺點，但是每當需要畫圖的時候又要跳到另一個視窗看結果，但是IJulia可以讓圖表同時在一個視窗裡面。工作告一個段落的時候也可以把結果匯出成一般的julia程式碼檔或是匯出成html把成果分享給別人。這個網頁有一些ijulia的[簡介](http://nbviewer.ipython.org/url/jdj.mit.edu/~stevenj/IJulia%20Preview.ipynb)。

### 安裝IJulia
因為IJulia是建構在IPython之上，所以第一步要先安裝python和ipython。完全沒有python經驗的人可以直接安裝[Anaconda提供的懶人包](http://continuum.io/downloads)，IJulia的官網特別強調不要使用Enthought出的package。

python和ipython安裝好了之後，下一步就是安裝IJulia。如果前一步順利完成的話，ijulia就會變得很簡單。只有在ijulia的指令列輸入

```julia
julia> Pkg.add("IJulia")

```
就可以完成安裝了。而要使用IJulia就只要輸入

```
julia> using IJulia

julia> notebook()
```

julia就會叫出你的預設瀏覽器，出現類似如下的畫面:


然後按New Notebook就會開啟一個新的ijulia筆記本視窗，可以開始進行編輯。


### 分享IJulia的作品

[nbviewer](http://nbviewer.ipython.org)這個網站提供了一個方便分享IJulia的作品的平台。只要把你的ipynb的檔案連結輸入到nbviewer首首的對話框，成功的話nbview會再吐一個回來一個連結給你，而你就可以把這個連結分享出去。我把前一篇文章介紹的幾個指令放到了ijulia裡頭，並且用這個方法分享出來，這是我的[檔案連結](http://nbviewer.ipython.org/gist/kanhua/eba1bac946bab4d89670)


nbviewer本身只提供把ijulia檔案(*.ipynb)轉換成html的介面，本身並不儲存任何資料，所有的資料都是存在你自己的網路空間裡，它可以是dropbox的分享連結，或是github的檔案連結，或是你自己的http伺服器。我自己的作法是把做好的ijulia檔案[貼到gist上面](https://gist.github.com/kanhua/eba1bac946bab4d89670)，然後再把連結輸入到nbviewer裡頭。



