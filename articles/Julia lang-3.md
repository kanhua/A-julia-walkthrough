
今天要開始來實作board物件幾個核心的function。下面是個2048盤面的例子:

```
  4   .   2   2
  .   .   .   8
 16   4   .   .
 16   .   .   .

current score: xxxx
Enter the next direction:
```

我們用一個4x4的矩陣來存放2048這個遊戲中每個位置的值。當使用者輸入左和右的使用，我們就把每一列取出來處理。
以上頭例子的第一列[4,0,2,2]為例，當使用者把指頭滑向左邊的時候，有三個動作會發生:

1)移動(move): 第一列的數字會由原本的[4,0,2,2]變成[4,2,2,0]

2)合併(merge): 2和2是相同數字，因此要相加，所以得到 [4,0,4,0]

3)再移動一次: 得到[4,4,0,0]

同理，當處理上下方向的時候，就把每一行取出來做相同的動作就可以了，以上面的例子來說，第一行就是[4,0,16,16], 然後執行上面的三個步驟，完全一樣。


### move 的實作

來介紹一下我決定採取的演算法。繼續以```[4,0,2,2]```為例:
1. 把這個```array```裡頭所以非零的元素取出來，形成一個新的```array```，即: [4,2,2]
2. 依玩家所下的指令，在這個```array```的左邊或是右邊補零。即，如果玩家的指令為向右，我們就在左邊補零，成為```[0,4,2,2]```

寫成Julia的code就會像下面這樣:

```julia
function move(line,direction)
    
    # 計算array的長度
    lineLen=length(line)

    
    # 取出array裡非零的元素
    nonZeroLine=line[line.>0]

    
    # 補零
    if direction >0
        newLine=[nonZeroLine,zeros(Int64,lineLen-length(nonZeroLine))]
    elseif direction < 0
        newLine=[zeros(Int64,lineLen-length(nonZeroLine)),nonZeroLine]
    end


    return newLine
end
```

在上面的範例裡頭，

```
if...elseif...end
```
還有
```
function...return....end
```
的定義就是你看到的那樣，但有幾件要注意的事:

- Julia的if條件判斷式只能傳回true或false，不接受數值型態或是空集合物件。所以像 ``` if 1 else ...end```都會出現error。

- Julia的function預設是pass-by-sharing，這點和python相同。當function parameter是mutable type的時候是pass-by-reference但immutable type是pass-by-value 

- 我們可以指定function parameter的型別，但是不指定也沒關係。比方說，move也可以寫成


```julia
function move(line::Array{Int64,1},direction::Int64)
....
....
end
```

這在某些情況底下會帶來一些方便，而且也可以在速度上增加一些最佳化的空間。

Matlab的使用者應該會覺得Julia處理array的指令相當親切，但還有是有些不同:

- 首先，Julia的indexing是用```[]```而不是```()```

- ```zeros(N)```在Matlab裡頭會傳回一個NxN的零矩陣，但是Julia會傳回一個一維的N-element array

對python的使用者來說，最不能習慣的應該是Julia的index是從1開始而不是零。

從上面的程式碼我們也可以看到，把兩個array串接起來的語法非常簡單，只要用```[arrayA, arrayB]```就可以了，這是承襲Matlab的設計。


### merge的實作

我的Merge function的實作大概是這樣

```julia
function merge(line)

    lineLen=length(line)
    for idx=1:lineLen
        nextidx=idx+1;
        if nextidx<=lineLen
            if line[idx]==line[nextidx]

                line[idx]=line[idx]*2
                line[nextidx]=0
            end

        end
    end

    return line
end
```
就是把相鄰且相同元素相加而已。我覺得有點醜，但一時間想不到更簡潔的寫法。前面有提過，function parameter在julia裡頭是pass-by-sharing，所以引數```line```的內容其實已經被更動了，有沒有傳回最後的值其實不是那麼重要。


進行下一步之前，我們可以準備一些test case，然後用```assert()```來檢查以上兩個function是不是功能正常:


```julia
function testmove()

    println("testint move():")
    assert(move([0,0,2,2],1)==[2,2,0,0])
    assert(move([0,2,0,2],-1)==[0,0,2,2])
    println("test pass")

end

function testmerge()
    
    println("testing merge():")
    assert(merge([0,2,2,0])==[0,4,0,0])
    assert(merge([0,2,0,2])==[0,2,0,2])
    assert(merge([4,4,8,8])==[8,0,16,0])
    println("test pass!")

end
```

2048遊戲最核心的部份就幾乎完成了。我們下回見。





