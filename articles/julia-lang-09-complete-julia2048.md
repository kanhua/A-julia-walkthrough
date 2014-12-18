---
title: julia版2048完成
---


實在不想再拖下去了，今天要來把julia版的2048遊戲做個了結。

2048遊戲在進行的時候，每移動一步之後，程式就會在空白的格子擺上2或4。我的作法是先把board矩陣中空白格子的index都找出來，然後用亂數隨機選出其中一個格子。然後建立一個陣列，有9個2和1個4，同樣也用亂數選取其中一個數字。這個的結果是:有90%的機率會選中2，而有10%機率會選中4。以下就是我的實作:

```julia
function addTile(board)

	flatBoard=reshape(board,size(board,1)*size(board,2))

	# 選出空白格子的index
	freeTileIndex=find(flatBoard.==0)

	# 從1到length(freeTileIndex)隨機選出一個整數newTileIndex
	# 即，freeTileIndex[newTileIndex]就是board要放上新數字的座標
	newTileIndex=rand(1:length(freeTileIndex))

	# 建立一個新的陣列放2和4
	tileToChoose=[ones(Int64,9).*2,4]

	# 同樣也隨機選一個整數，用來選取tileToChoose陣列的其中一個值
	newTile=rand(1:length(tileToChoose))

	assert(flatBoard[freeTileIndex[newTileIndex]]==0)

	# 把選到的值放到選到的陣列上
	flatBoard[freeTileIndex[newTileIndex]]=tileToChoose[newTile]

	#return the new board
	return reshape(flatBoard,size(board,1),size(board,2))

end
```

有了addTile()作為根基，2048盤面初始化的函式就呼之欲出了。我的作法就是建立一個零陣列，在這個陣列上執行addTile()三次，於是就有三個數字直接放在board上面了。
實作如下:


```julia
function initBoard(boardSize=4)
	
	# Initialize a board

	board=zeros(Int64,boardSize,boardSize)	

	for i=1:3
		board=addTile(board)
	end

	return board

end
```

接下來是計分用的函式，我的作法是直接修改前面幾篇已經介紹的merge()函式，讓它同時傳回新的陣列以及加分:

```julia
function merge(line)

	addScore=0
	lineLen=length(line)
	for idx=1:lineLen
		nextidx=idx+1;
		if nextidx<=lineLen
			if line[idx]==line[nextidx]

				addScore=addScore+line[idx]
				line[idx]=line[idx]*2
				line[nextidx]=0
			end

		end
	end

	return line,addScore
end
```
julia允許function傳回多個值，只要用逗點分隔就可以了，當然這麼一改之後，之後連帶還有幾個小函式也要跟著修改，這邊就不列出，請大家參考最後的程式碼就可以了。

底下就附上完整版的julia2048讓大家測試，如果程式碼本身有寫得不夠好的地方請各位先進不吝指教。有了這個框架之後，接下來我們就可以嘗試實作一些AI的策略。因為AI的實作會涉及到大量重覆執行這個2048框架的某些部份，因此我們也會且戰且走，從一些小地方一步一步提升程式的效率。




