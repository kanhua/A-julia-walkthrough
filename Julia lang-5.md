在前面的幾篇我們大致完成了2048遊戲的核心演算法，雖然還缺一些小零件包括

- 加入新的數字
- 起始化2048的盤面
- 計算分數
- 決定遊戲的終點(2048達成或是game over)

不過我決定先把這些擱在一旁，今天先來製作輸出的部份。


### Julia的標準輸出

在Julia裡，```print()```和```println()```是最常用輸出函式。和python類似，你可以把幾乎任何型別(type)的物件丟到```print()```或```println()```裡頭，然後程式會依照型別內建的定義來輸出字串。```println()```只是在執行```print()```之後附上一個換行```\n```字元，其他沒什麼不同。



有的時候我們需要自定輸出的格式(format specifier)，julia目前是借用C/C++定義的```printf()```和```sprintf()```以及對應的格式來作。例如

```julia
julia> @printf("%3.2f",3.141615926)
3.14

julia> @printf("%3.4E",3.141615926)
3.1416E+00

```

NB: ```printf()```和```sprintf()```的前面要加上```@```。```@printf()```和```@sprintf```在julia裡面並不是函式，而是巨集(macro)。julia提供了一個很方便的指令```macroexpand()```來檢視這個巨集的定義:

```julia
julia> macroexpand(:(@printf("%3.2f",3.141615926)))
quote 
    #130#out = Base.Printf.STDOUT
    #131###x#7831 = 3.141615926
    local #136#neg, #135#pt, #134#len, #129#exp, #132#do_out, #133#args
    if Base.Printf.isfinite(#131###x#7831)
        (#132#do_out,#133#args) = Base.Printf.fix_dec(#130#out,#131###x#7831,"",3,2,'f')
        if #132#do_out
            (#134#len,#135#pt,#136#neg) = #133#args
            #136#neg && Base.Printf.write(#130#out,'-')
            Base.Printf.print_fixed(#130#out,2,#135#pt,#134#len)
        end
    else 
        Base.Printf.write(#130#out,begin  # printf.jl, line 143:
                if Base.Printf.isnan(#131###x#7831)
                    "NaN"
                else 
                    if (#131###x#7831 Base.Printf.< 0)
                        "-Inf"
                    else 
                        "Inf"
                    end
                end
            end)
    end
    Base.Printf.nothing
end

```
問題來了，printf在C/C++裡是函式，在其他許多程式語言裡頭也是函式，為什麼要julia要用巨集來做這件事呢?
關於這個問題，Julia的作者在[stack overflow](http://stackoverflow.com/questions/19783030/in-julia-why-is-printf-a-macro-instead-of-a-function)上面有回答。簡單的說，主要是為了效能上的考量，讓程式可以在執行期間選擇有效率的code來輸出，達到非常逼進C的效率。在這邊我建議讀者可以把不同的```macroexpand()```指令去試試不同的```@printf()```指令，像是```@printf("%3d",3)```,```@printf("constant string\n")````。


回到2048遊戲。我們接下來要做的是把盤面轉成string，底下是我的實作:


```julia
function printBoard(board)

	boardStr=""
	for rowIdx=1:size(board,1)
		for colIdx=1:size(board,2)
			tmpStr=@sprintf("%6d",board[rowIdx,colIdx])
			boardStr=string(boardStr,tmpStr)
		end
		boardStr=string(boardStr,"\n")
	end
	return boardStr
end
```
這個函式的功能是把board這個矩陣輸出成字串。julia沒有定義```concat()```這類的函式或是```+```運算子來把兩個字串接在一起，取而代之的是用```string()```來直接形成一個新的字串。

接下來我們可以寫一些test case來測試輸出的結果:


```julia
function testprintBoard()
	println(printBoard([0 0 0 0;0 0 0 0;0 0 0 0;0 0 0 0]))
	println(printBoard([1024 0 0 0;0 1024 0 0;0 0 1024 0; 0 0 0 1024]))
end
```

假日不要寫太多code，所以就在這邊先打住，祝大家有個愉快的周末 :)
