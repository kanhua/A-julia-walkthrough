今天譲我們再回到2048。其實這篇文章本來應該早幾天推出來的，但是因為之前在debug這個程式，所以就把次序交換一下，先寫一些其他的內容墊檔。今天下午才發現程式碼裡頭犯了兩個很蠢的錯誤導致程式跑出來的結果一直不如預期。

大部份的2048的AI都會先設計一個evaluation function來計算目前2048的盤面是好是壞。例如:

這個盤面
```
 0  0  0  0
 8  4  4  0
16  2  2  0
64  2  2  0

```

應該會比這個盤面

```
 0   0  0  0
 8  16  2  0
 4   2  4  0
 2  64  2  0
```

來得好一些。於是我們就根據這些反覆玩遊戲之後所累積下來的經驗，搭配一些已知的戰略，設計一些evalutaion function。接著再用一adversarial search的方法，如min-man, alpha beta pruning或是expectimax去找出最好的結果，然後移動下一步。

今天要介紹的這個AI實作非常有趣，實作上也不困難(雖然我被兩個小bug困了好久)，它完全不需要evaluation function，只要隨機一步一步往下search，讓電腦自己決定最好的下一步。原作者的javascript版本在[這裡](http://ronzil.github.io/2048-AI/)，同時也有[原始碼](https://github.com/ronzil/2048-AI)和相關說明。

它的作法是這樣:假設在目前的盤面，我們可以選擇的方向是「上」和「右」，這時候AI要決定那個是比較好的選擇。於是AI就先走「上」，然後用隨機決定下一步一直到遊戲結束，看得到多少分數，如此重覆100次或是更多，再把最終分數平均。接著AI走「右」，也是用隨機的方式走到底，記下分數，重覆100次，把分數平均。然後比較「上」和「右」分別得到的分數的大小，走分數比較多的那一步。

前面我們有介紹過，單純用隨機的方式只能夠得到幾千分，但是用這個種方法卻可以大幅提高遊戲的分數。在每一步重覆一百次取平均的條件下，幾乎每一次都能夠到達2048以上。

以下的函式就是我的實作:

```julia
function iterativeRandomAgent(board)

	startLegalMoves=getLegalMoves(board)
	evalScores=zeros(length(startLegalMoves))
	evalSteps=zeros(length(startLegalMoves))
	forwardRuns=100

	# 這個迴圈開始分析目前盤面每一個下一步的好壞
	for legalMoveIdx=1:length(startLegalMoves)

		predictExtraScores=zeros(forwardRuns)
		predictExtraSteps=zeros(forwardRuns)

		# 這個迴圈開始隨機把遊戲走到底，然後重覆測試100次
		for i=1:forwardRuns
			extraGameScore=0
			totalSteps=1
			nextBoard,scorediff=boardMove(board,startLegalMoves[legalMoveIdx])
			extraGameScore=extraGameScore+scorediff
			nextBoard=addTile(nextBoard)
			legalMoves=getLegalMoves(nextBoard)

			# 判斷遊戲是否結束，結束的話就跳出這個 while 迴圈，不然的話就走到底
			while length(legalMoves) > 0

				input=legalMoves[rand(1:length(legalMoves))]
				nnextBoard,scorediff=boardMove(nextBoard,input)	
				extraGameScore=extraGameScore+scorediff
				nnextBoard=addTile(nnextBoard)
				totalSteps=totalSteps+1
				legalMoves=getLegalMoves(nnextBoard)
				nextBoard=copy(nnextBoard)
			end

			predictExtraScores[i]=extraGameScore
			predictExtraSteps[i]=totalSteps
		end		
		evalScores[legalMoveIdx]=mean(predictExtraScores)
		evalSteps[legalMoveIdx]=mean(predictExtraSteps)

	end

	# 選出得到分數最高的下一步。
	if length(evalScores)>1
		maxIndex=findfirst(evalScores.==max(evalScores...))
	else
		maxIndex=1
	end
	return startLegalMoves[maxIndex]
end
```

完整的程式碼待我稍後整理好之後再放上來。
