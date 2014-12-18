---

title: Julia的標準輸入，2048主程式迴圈

---

昨天我們介紹了一些julia標準輸出的指令。今天我們要來介紹julia的標準輸入，並實作2048的主程式迴圈。


### Julia的標準輸入

a```readline()```是julia最常用到的標準輸入指令。```readline()```這個函式會傳回使用者輸入的字串。

我們直接用2048遊戲的使用者輸入來當例子:


```julia
function humanPlayer(board)

	promptStr="請輸入方向(上(K),下(J),左(H),右(L),離開(Q)):"

	print(promptStr)

	return chomp(readline())
end
```

這個函式會先印出一列提示字串。因為julia支援unicode顯示，所以處理unicode的中文字元沒有問題(當然前提是你用的作業系統和終端機也要支援unicode)，接著用```chomp()```這個指令把換行字元去掉。


接下來我們來實作主程式迴圈，同時也用這個主程式迴圈來一次檢視還有那些小零件還沒完成，這個主程式迴圈包括了以下的步驟:

- 把目前盤面印出來
- 玩家輸入下一步移動的方向
- 執行```boardMove()```更新盤面
- 如果這一步有更動盤面，就加入新的數字進去
- 用```gameState()```這個函式來確認遊戲繼續執行，也就是檢查該局是不是已經game over，game over就跳出迴圈


```julia
function gameLoop(player::Function)

	#初始化2048的盤面
	board=initBoard()

	#
	while gameState(board)=="continue"

		
		# 印出目前的盤面
		println(printBoard(board))
		
		# 從玩家接收下一步的指令
		input=player(board)
		
		# 把鍵盤指令轉為在boardMove所定義的方向
		if input=="H" || input=="h"
			moveDir=1
		elseif input=="L" || input=="l"
			moveDir=-1
		elseif input=="K" || input=="k"
			moveDir=2
		elseif input=="J" || input=="j"
			moveDir=-2
		
		elseif input=="Q" || input=="q"
			break
		end

		# 移動盤面
		nextBoard=boardMove(board,moveDir)

		
		# 判斷盤面是否被更動，如果被更動了，就加新的數字進去
		if !((nextBoard.==board)==trues(size(board)...))
			nextBoard=addTile(nextBoard)
		end

		# 用gameState確認遊戲是否可以繼續執行
		if gameState(board)=="playerwin"
			println("Congrats! You Win!")
			break	
		elseif gameState(board)=="playerlost"
			println("Good effort, but try again")
			break
		end

		# 更新盤面
		board=nextBoard

	end
end

```

這裡我們特別為將來要加入AI agent留了一個伏筆:我們在```gameloop()```加了一個function argument，為的是讓```gameloop()```可以從不同的來源讀取下一個動作。由真人進行遊戲時，```input=player(board)```的```player```會指向```humanPlayer()```，即 執行```gameloop(humanPlayer)```來開始遊戲。
而將來我們寫好了2048的AI agent的時候就可以把```player```指向給某個AI agent函式，例如```gameloop(AIagent)```。這也是為什麼我們要在```humanPlayer(board)```的定義中加入```board```這個引數。

離終點線愈來愈近了，只剩下```gameState()```、```addTile()```和```initBoard()```三個小零件，以及計分器，Julia版的2048就可以宣告完成了。
