# 2048遊戲核心完成



在前一篇裡面，我們實作了move和merge兩個函式，接下來我們就把兩個它們組合在一起，變成一個完整的動作。

```julia
function moveMerge(line,direction)

    line=move(line,direction)

    line=merge(line)

    line=move(line,direction)

end
```
如前一篇所解釋的，當遊戲玩家決定了方向之後，每一列就進行三個動作:移動、合併相同的數字、再合併一次。

當然，為了維持凡事必定檢驗的好習慣，一小段unit test是不可少的:

```julia

function testmovemerge()
    println("testing moveMerge()")
    assert(moveMerge([0,2,0,2],1)==[4,0,0,0])
    assert(moveMerge([0,2,0,0],-1)==[0,0,0,2])

    println("test pass")
end

```

有心的讀者我會建議自己再多加幾個test case試試看。

到目前為止，處理2048每一列移動的工具都已經齊備，接下來就是往二維方向的矩陣前進。


#### Julia 多維數值陣列(multidimensional array)的操作

前面有提過，我們會用一個矩陣來儲放2048盤面的值。假說盤面是:


```
  4   .   2   2
  .   .   .   8
 16   4   .   .
 16   .   .   .

current score: xxxx
Enter the next direction:
```

那麼我們可以建立一個矩陣來表示:

```
board=[4 0 2 2; 0 0 0 8; 16 4 0 0; 16 0 0 0]

```

和Matlab一樣，julia用分號來分隔每一列，用空格分格每一行。

取出每一行或是每一列的語法也和matlab/python相同，和matlab的不同之處只在一個是用[]一個是()來作indexing。

亦即

```
board[1,:]
```
會得到board的第一列:[4,0,2,2]

而
```
board[:,1]
```
會得到的第一行:[4;0;16;16]

要特別注意的是，board[1,:]傳回的是一個一維陣列，但是board[:,1]傳回的會是一個二維陣列，有時候需要透過```reshape()```這個內建函式把它轉為一維陣列。


因此，我們需要自訂兩個函式來存取2048矩陣每一行或是每一列的值，我的作法如下:


```julia

function getLine(board,dim,index)

    if dim==1 #處理每一列
        
        return board[index,:]

    elseif dim==2  #處理每一行

        return reshape(board[:,index],size(board,dim))

    end

end


function setLine(board,dim,index,line)


    if dim==1  #處理每一列
        
        board[index,:]=line

    elseif dim==2 #處理每一行

        board[:,index]=reshape(line,1,size(board,dim))

    end

    return board

end
```

getLine用來把矩陣的每一行或是每一列抓出來，然後轉成一個一維陣列，而setLine則用把我們之前用moveMerge這個函式產生的值傳回去。在這兩個函式中，我們用dim這個引數來決定要處理矩陣的行或是列。列方向是1，行的方向是2。處理每一樣的時候，就用reshape來轉換矩陣的維度(dimension)。

有了這兩個小工具之後，盤面移動的函式也就順勢完成了:


```julia
function boardMove(board,direction)

    newBoard=copy(board)

    for rowIdx=1:size(newBoard,abs(direction))

        # 取出行
        line=getLine(newBoard,abs(direction),rowIdx)
        
        newLine=moveMerge(line,direction)
        
        # 把moveMerge傳回的值再放到新的矩陣
        newBoard=setLine(newBoard,abs(direction),rowIdx,newLine)
    end

    return newBoard
end

```

direction是使用者決定移動的方向，direction=2或-2是上下移動，direction=1或-1左右移動，算是配合julia內建的定義讓程式碼變得簡單。

我的實作並不是執行起來最有效率的寫法，但這種寫法可以充分利用2048遊戲本身的對稱性，還有julia的語言特性。犧牲一點小小的效率，就可以省下很多時間在跟一堆for loop或是if戰鬥。

2048的核心幾乎已經完成了，接下來就要進入到使用者介面的部份了。





