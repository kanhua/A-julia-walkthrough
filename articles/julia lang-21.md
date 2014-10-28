前情提要:見IJulia筆記

這個資料集另外一個需要處理的地方是資料型態。舉例來說，Survived這欄其實是布林值，只有0和1的分別，但是把data從csv讀進來之後，它被歸類為浮點數。又如性別欄(Sex)，它只有"male"和"female"兩種，但卻被分為string型別。所以整理data的其中一個重要工作就是把這些資料轉為"分類"而不是數值，它類似R語言底下的factor。我們可以用pool!()來把這類的資料歸類。

```
pool!(df,[:Sex])
pool!(df,[:Survived])
pool!(df,[:Pclass])
```
df[:Sex]等欄位就會被轉成PooledDataArray{UTF8String,Uint8,1}這個型別。PooledArray會包含兩個資料，一個是一組對照表，把female對到1，把male對到2，而表格中每一列的資料都會變成整數1或2的型態。轉成PooledArray可以用來明確標示這一個欄的資料是一種分類。

把這些欄都轉成PooledArray之後，接下來要處理Embarked這個欄位。這個欄位也有一些NA值，但是只有一兩個，而長條圖的分析顯示"S"這個分類佔絕大部份，所以我們就再用array()把這些NA值都換成S。


資料的整理到這邊就幾乎告一段落，其實仍然有一些小地方可以做，例如把旅客名字中的"Mr."或是"Mrs."等頭銜抽取出來，或是把票號"ticket"這欄再做個分類。不過我想就先做到這裡，然後試一下classification tree的效果。

於是我就可以把我們認為會影響生還結果的欄位併在一起，成為一個新的DataFrame:

```
newdata=df[:,[:Pclass,:Age,:Sex,:SibSp,:Parch,:Fare,:Embarked]]
```

接下來就可以試一些classification tree的演算法來做預測。

