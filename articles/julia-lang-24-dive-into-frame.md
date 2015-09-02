# 深入了解DataFrame的結構

延續前一篇，我們今天繼續深入來看DataFrame的內部構造。

昨天我們花了一點篇幅介紹了parametric type，有了這個概念之後，接下來我們就來看DataFrame這個Type是怎麼定義的:

```
type DataFrame <: AbstractDataFrame
    columns::Vector{Any}
    colindex::Index

    function DataFrame(columns::Vector{Any}, colindex::Index)
		...
	end
end
```

我們可以發現它包含了兩個子元素:columns和colindex。
columns的Type是Vector{Any}，Vector{Any}和Array{Any,1}完全等價，可以看作是Array{Any,1}的別名(alias)。二維陣列Array{Any,2}也有別名，是Matrix{Any}。前面有提過，Any這個型別是julia所有內建型別的母型別，所有內建的型別都會繼承Any。
colindex的Type是Index，Index是這個package另外定義的型別，它的定義是這樣:


```
type Index <: AbstractIndex   

    lookup::Dict{Symbol, Indices}

    names::Vector{Symbol}

end
```

Index包含了lookup和names兩個子元素。lookup是Dict型別。Dict的作用就像是python裡的dictionary，也就是一個hash table的資料結構。Symbol是一個非常有趣的系統內建型別，我們之後會有專文討論，Indices也是一個自訂的型別，它的定義是

```
typealias Indices Union(Real, AbstractVector{Real})
```
也就是說，它其實就是Union(Real,AbstractVector{Real})，Union的作用是表示Indices可以是Real或是AbstractVector{Real}。

我也現在就用之前的Titanic data來當例子，讓大家有個比較實際的感覺。

第一步一樣是先把資料讀進來

```
df=readtable("train.csv")
```
再來執行df.columns，會得到下面的結果:


```
12-element Array{Any,1}:
 [1,2,3,4,5,6,7,8,9,10  …  882,883,884,885,886,887,888,889,890,891]                                                                                                                                                               
 [0,1,1,1,0,0,0,0,1,1  …  0,0,0,0,0,0,1,0,1,0]                                                                                                                                                                                    
 [3,1,3,1,3,3,1,3,3,2  …  3,3,2,3,3,2,1,3,1,3]                                                                                                                                                                                    
 UTF8String["Braund, Mr. Owen Harris","Cumings, Mrs. John Bradley (Florence Briggs Thayer)","Heikkinen, Miss. Laina","Futrelle, Mrs. Jacques Heath (Lily May Peel)","Allen, Mr. William Henry","Moran, Mr. James","McCarthy, Mr. Timothy J","Palsson, Master. Gosta Leonard","Johnson, Mrs. Oscar W (Elisabeth Vilhelmina Berg)","Nasser, Mrs. Nicholas (Adele Achem)"  …  "Markun, Mr. Johann","Dahlberg, Miss. Gerda Ulrika","Banfield, Mr. Frederick James","Sutehall, Mr. Henry Jr","Rice, Mrs. William (Margaret Norton)","Montvila, Rev. Juozas","Graham, Miss. Margaret Edith","Johnston, Miss. Catherine Helen \"Carrie\"","Behr, Mr. Karl Howell","Dooley, Mr. Patrick"]

......
```
上面只列出一部份的結果。前面我們提到df.columns是一個一維的陣列，而這個一組陣列的每一個元素又都是一個陣列，分別是資料中每一行的資料，這也符合julia多維陣列的儲存慣例。

df.colindex包含了兩個元素lookup和names，我們分別來看它們裡頭裝了什麼:

這是df.colindex.lookup:

```
Dict{Symbol,Union(AbstractArray{Real,1},Real)} with 12 entries:
  :Survived    => 2
  :PassengerId => 1
  :Parch       => 8
  :Fare        => 10
  :Name        => 4
  :Pclass      => 3
  :Sex         => 5
  :Cabin       => 11
  :SibSp       => 7
  :Embarked    => 12
  :Ticket      => 9
  :Age         => 6
```
它就是一個Dict，把欄位的名稱對到這個欄位的資料在df.columns中的index。

而df.colindex.names則是:

```
12-element Array{Symbol,1}:
 :PassengerId
 :Survived   
 :Pclass     
 :Name       
 :Sex        
 :Age        
 :SibSp      
 :Parch      
 :Ticket     
 :Fare       
 :Cabin      
 :Embarked   
```
它就只是一個存放所有欄位名稱的陣列。

這個就是DataFrame的構成，接下來我想花一些篇幅解釋Symbol這個型別，以及它在DataFrame的功用。
