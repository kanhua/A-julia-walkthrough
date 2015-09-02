# 用julia玩kaggle之整理data

這一篇的主題是用julia來整理有點殘缺的資料。讀者們可以先看之前[ijulia notebook](http://nbviewer.ipython.org/gist/kanhua/eba1bac946bab4d89670)來複習一下目前的進度。

在處理這些資料之前，要先決定我們要用什麼模型來預測生還者。我想要demo的作法是用前幾天的文章中介紹的random forest來預測生還者。這個模型中，我不會用到全部的欄位，例如像旅客編號就是我想要捨棄的部份。

這個資料集中，有很多欄位都是未知數，會造成統計上以及資料分析上的困擾，所以我們要來決定用什麼策略來填補這些資料上的空白，也就是DataFrame中出現NA值的地方。

首先要先找出資料裡頭的NA值，之前有提NA其實是一個Type，它無法做任何的運算，所以也不能用

```
x==NA

```
來判斷x是否為NA。

julia提供了isna()來解決這個需求。我們沿用之前的變數命名，df這個DataFrame是已經讀進來的titanic traning set

```
isna(df[:Age])
```

會傳回一個bitArray

```
891-element BitArray{1}:
 false
 false
 false
 false
 false
  true
 false
 false
 false
 false
 false
 false
 false
     ⋮
 false
 false
 false
 false
 false
 false
 false
 false
 false
  true
 false
 false
 ```

另一個好用的函式是dropna()，它的功能是把所有含有NA的列都去掉，像是這樣:

```
dropna(df[:Age])

```
就會得到結果:

```
714-element Array{Float64,1}:
 22.0
 38.0
  ⋮  
 26.0
 32.0
```
原本的DataArray含有891個元素，丟掉了NA之後就只剩714個。


再來要介紹的有關NA的函數是array(DataArray,x)，它可以把DataArray中所有NA都換成x。例如，我們可以把Age這一欄中的值全都換成平均值，像這樣


```
averageAge=mean(df[!isna(df[:Age]),:Age]) # 求出平均值
df[:Age]=array(df[:Age],averageAge)  # 把平均值填入原來的df[:Age]
```

今天就先介紹到這邊。

