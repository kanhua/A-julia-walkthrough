在前面的文章裡面，我們用julia完成了2048的基本架構。有了這個基本架構之後，就可以用它來做一些有趣的事情。

我們可以從一個簡單的問題開始:假如完全用隨機的方式選下一步(就是閉著眼睛玩的意思)，大概會得到多少分呢?

首先我們可來實作一個random player的agent來取代gameloop裡的humanPlayer，這是我們在設計遊戲的主程式迴圈gameloop所預留的伏筆。


```julia
function randomAgent(board)

	legalMoves=getLegalMoves(board)

	lmIndex=rand(1:length(legalMoves))

	return legalMoves[lmIndex]
	
end
```

這個函式會先執行```getLegalMoves(board)```，這個函式的功能是用來找出"合法"的下一步，也就是遊戲的所以下一步的選項。legalMoves這個陣列沒有任何元素時就表示game over。而這個getLegalMoves已經包含在2048遊戲主架構的code裡面，就不再多做介紹。

我的方法是跑這個遊戲至少1000次，然後把結果圖的分布畫出來。

julia的資料視覺化有兩種方法。第一種是透過python使用matplotlib，另一種方法是根植於繪圖套件Gadfly。Gadfly的官網就開宗明義的說這個套件是參照ggplot2設計的，對於常使用這個套件的R使用者應該會覺得很熟悉。套件的安裝非常簡單，只要在julia的指令列打入Pkg.add("Gadfly")就可以了。


```julia
using julia2048
using Gadfly

# 跑10000次模擬
numberOfTrials=10000
scores=zeros(numberOfTrials)
for i=1:length(scores)
	scores[i]=julia2048.gameLoop(julia2048.randomAgent)
end

#畫圖
p=plot(x=scores,Geom.histogram,Guide.xlabel("score"),Guide.ylabel("occurences"))
draw(PNG("myplot.png", 12cm, 6cm), p)
```
以下就是我跑了10000次遊戲的結果。從這張可以很清楚的看到，隨便亂玩所得到的分數大概就在幾百分左右，運氣好一點的話可以拉到1000，要突破2000的話，玩個10000次大概有一次可以達成。

今天就先到這邊，我們之後會來介紹一些不同的AI策略。