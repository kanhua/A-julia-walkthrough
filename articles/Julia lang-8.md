今天要介紹的是矩陣或是向量元素的搜尋。

julia的基本元素搜尋語法和matlab/octave很接近，都是:

```
find(某條件式)
```
find()傳回的值是符合這個條件式的index

讓我們直接看一個例子:

我們想要找一個陣列A=[-1,-2,0,1,2]中大於零的元素，find(A.>0)就可以傳回所有A中大於零元素的index，放到julia的terminal中實作結果如下:
```
julia> A=[-1,-2,0,1,2]
5-element Array{Int64,1}:
 -1
 -2
  0
  1
  2


julia> find(A.>0)
2-element Array{Int64,1}:
 4
 5

```
如果我們只看A.>0回傳的結果:

```
julia> A.>0
5-element BitArray{1}:
 false
 false
 false
  true
  true
```
就可以很清楚的發現，find(X)這個函式本質上其實是要找出X的值為true的元素，而X的型別只能是一個布林陣列。因為julia是一個強型別(strong type)語言，所以不像matlab的find()函式可以用整數來當引數。

另一個和Matlab有點不同的地方是，julia的find()函式只能用來處理一維陣列。如果要處理二維陣列，就要用findnz()這個函式，只不過findnz()會傳回三個陣列:符合條件的row index, 符合條件的column index，以及符合條件的值。用例子來解釋會比較清楚:


```
julia> A=[1 -1 -1; 2 2 1]
2x3 Array{Int64,2}:
 1  -1  -1
 2   2   1

julia> findnz(A.==1)
([1,2],[1,3],Bool[true,true])

```

所以滿足A.==1的條件的就是A[1,1]和A[2,3]

有了這個些知識，我們就可以很快地寫出一個小function來計算2048盤面的空格數量:

```
function getFreeTiles(board)

	i,j,v=findnz(board.==0)

	return length(i)

end
```

今天小弟工作比較忙，就先寫到這裡。


