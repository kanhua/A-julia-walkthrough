在這個30天的系列裡頭，我想用project-oriented的方法來介紹Julia:先把2048這個小遊戲化整為零，拆成一個一個小部份。當要開始寫某個小部份code的時候再來介紹需要的語法和函式就可以了。
我並不想把程式語言按著說明手冊一個一個介紹下來，因為我不覺得我可以用30天部落格的形式做得比Julia官方的說明手冊好。

在開始介紹Julia的語法和特性之前，先來定義一下這個2048小遊戲所要達到的效果:

我們想要實際作出的2048小遊戲大概是像下圖這樣:

```
  .   .   .   2
  .   .   .   8
 16   4   .   .
  .   .   .   .

current score: xxxx
Enter the next direction:

```

使用介面就是使用基本的輸出輸入。因為是學習目的，界面有點醜，也只能將就將就，畢竟user-friendly不是最重要的考量。另外，為了讓程式再簡化一點，上下左右鍵我們選擇vim-like的定義:

K: 上

J: 下

H: 左

L: 右

使用者每移動一步之後，程式會隨機選擇一個空格放上新的數字，90%的機率會放2，而10%的機率會放上4。每次合併後，新的分數是舊的分數加上被合併格子的數字的兩倍。

因此這個遊戲會有兩個主要部份(或是物件):
第一個是board物件，它掌管目前2048盤面的狀況，當使用者輸入方向時，它會把盤面演化到下一步，並判斷遊戲能否再繼續進行。

第二個是game物件，它扮演了電腦和玩家中間的介面，它處理玩家的輸入的指令，然後把最新盤面的狀面印在螢幕上。

第三個部份是AI代理人(AI agent), 把這個小遊戲實作出來之後，之後就可以在這個框架再加上一個AI agent，讓程式自己去找尋通往2048的道路。

讓我們再把主題拉回到Julia，

### Julia的安裝

Julia的安裝非常簡單，想省事的人只要去[官網下載](http://julialang.org/downloads/)已經編譯好的binary file就可以了。

用homebrew的MacOS使用者也可以用homebrew來安裝，我自己也是使用Homebrew來安裝Julia。目前Julia的安裝並沒有在官方的homebrew formula裡頭，而是由Julia lang的團隊在維護，有需要人可以去[這個網頁](https://github.com/staticfloat/homebrew-julia)看使用說明。

NB: 用Homebrew安裝時可能會有gcc版本的問題，有時候可能需要把homebrew原本安裝的gcc移除之後，重新安裝新版本的gcc，詳情請見這個[連結](https://github.com/staticfloat/homebrew-julia/issues/116)。從github issues上面的回應狀況來看，Julia的維護團隊回應還蠻快的。真的遇到了問題，issues也爬過了，就不要吝於回報，Julia的維護團隊也鼓勵使用者這麼做。

安裝之後執行Julia，會看到類似如下的畫面:


鍵入```1+1```然後按```Enter```，出現```2```的話就表示安裝成功了XD


### 初試Julia:

我個人認為最短的時間熟悉Julia基本操作的方法是花一個小時看MIT的這個[tutorial](https://www.youtube.com/watch?v=37L1OMk_3FU)。它是Julia的team在MIT辦的一個小tutorial，覺得不想花太久時間跟一票MIT師生在那邊瞎耗的人可以直接下載該課程的投影片檔[投影片檔](https://raw.github.com/JuliaLang/julia-tutorial/master/LightningRound/IAP_2013_Lightning.pdf)。然後自己動手把指令一個一個打上去，花不到半小時的時間，就可以很快地對這個語言有個初步的感覺。Python/Matlab/Octave的使用者應該會覺得有些語法很熟悉。

工具準備好，也稍微熟悉了一下之後，明天我們就捲起袖子來實作2048。

