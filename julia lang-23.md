昨天大致完成了模型的cross validation，把昨天的程式稍微模組化，然後使用apply_forest()來產生預測結果，寫入檔案之後，就可以把它上傳到Kaggle了。分數大約是0.75左右。差強人意但也不算太壞，因為這邊所有模型的參數都是我自己憑感覺下的，應該還有一點再優化的空間。由於我們這個系列文章是以介紹julia的語言和特性為主，所以接下來的工作就讓有興趣的讀者們繼續研究。我的ijulia notebook一樣是放在[nbviewer上歡迎大家下載指教](http://nbviewer.ipython.org/gist/kanhua/bf4a75884f3cb2934364)。

前面我們用了DataFrame這個資料結構來存放表格式的資料，接下來我想花一些時間對這個資料結構做個比較深入的介紹。DataFrame這個package雖然是目前julia社群用來處理表格式資料的主流，但它的官方說明文件實在是很殘缺不齊，如果沒有花時間深入研究它的code來了解它的基本架構的話就沒辦法做用自如。我自己花了一點時間看DataFrame package的code之後覺得它還蠻有趣的，也發現它也很適合當一些julia進階語法的應用實例。


首先是Parametric Type。Parameteric Type的功能有點類似C++裡的Template。假設我們定義了一個名為長方型(Rect)的type，它包含兩個子元素，長(width)和寬(height)，但是width以及的height的Type還沒確定下來，它們可以是整數，也可以是浮點數。

```
type Rect{T}
  width::T
  height::T
end
```

T可以是任何Type。如果你只想把julia當成像python那樣的語言來使用，那麼parametric type在你的程式碼裡頭幾乎不需要出現。因為Rect這個Type寫這樣子也是完全可以的:

```
type Rect
  width
  height
end
```

這兩個寫法其中一個重要的分別在於，前者可以讓編譯器有機會在編譯時期就把code最佳化，但是不指定type的寫法只能讓julia在執行期才決定變數的Type。比方說，如果我們已經確定四邊型的長和寬都是整數的話，那麼我們就可以把計算面積的函式寫成這樣:

```
function area(Rect{Int64})

	return Rect.width*Rect.height

end
```
如果不用parametric type的話，會是這樣:

```
function area(Rect)

	return Rect.width*Rect.height

end
```

在第一種寫法的情形下，編譯器就可以把area()函式針對整數相乘最差化，而且我們也可以針對不同型別而有不同的做法，例如，如果長和寬是字串的話，那麼面積顯然就不能直接相乘了，而必須轉換型別:

```
function area(Rect{String})

	return int(Rect.width)*int(Rect.height)

end
```
而這個轉換Type的動作是julia編譯器無法代勞的。

當然如果你很堅持不用parametric type，這個function也可以寫成這樣:

```
function area(Rect)
	
	if typeof(Rect.width)==ASCIIString
		width=float(Rect.width)
	else
		width=Rect.width
	end

	if typeof(Rect.height)==ASCIIString
		height=float(Rect.height)
	else
		height=Rect.height
	end

	return width*height
end

```

不是不行，但是執行的效能就會差一些。julia的可以寫得像python，也可以寫得像C/C++，當寫得比較像C/C++的時候就會跑得比較快，而parametric type這個設計就是為了讓你的julia　code更靠近C/C++用的。







