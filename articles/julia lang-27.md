julia另一種常見的parallel computing模式是直接把for loop的運作平行化，像這樣:

```
@parallel for i=1:10000
	rand()
end
```

要特別特別注意的是，下面這個例子在julia裡是不成立的:

```
a=zeros(N)
@parallel for i=1:10000
	a[i]=rand()
end
```
這個迴圈的每一輪都要修改array a的值，這個寫法在julia不允許。array a必須要用另外一種可以被平行處理的陣列儲存才行。

寫到這裡，我想一個例子來實際試一下parallel computing。下面這個程式範例是用蒙地卡羅法(Monte Carlo)來計算圓周率pi。蒙地卡羅在數值方法的運用非常廣。它的本質就是用大量的隨機資料找出規則。用蒙地卡羅法求圓周率的方法如下:


簡單來說，這個方法就是用隨機選取落在正方形中的二維座標(x,y)。假設正方形的邊長是2R，圓形的半徑是R，如果x^2+y^2<R^2，就表示這個點是在圓形裡面。如果隨機點數量夠大的話，我們就可以從落在圓形裡的點的數目和落在圓形之外的點的數目的比值，會很接近圓形的面積比上圓形之外的面積，進而可以從這個關係求出圓周率pi。


使用python或是matlab的話，通常我們會用以下的寫法來避免使用迴圈以致程式的效率不彰:

```
function estimate_pi_vec()
	# Vectorized way of calculating Pi
	# This style is commonly seen in python or Matlab/Octave to avoid for loops

	samplenum=100000000
	mc_x=rand(samplenum,1)
	mc_y=rand(samplenum,1)

	R=0.5
	mc_x=mc_x-R
	mc_y=mc_y-R

	mc_l2=mc_x.^2+mc_y.^2

	r_sq=R^2

	return sum(int(mc_l2.<r_sq))*4/samplenum
end
```

但這個寫法的缺點是會佔用到大量的記憶體，而使用julia的好處就是使用迴圈不會付出很多執行效率上的代價，同時也可以引進平行運算的方法，像這樣

```
function estimate_pi_loop(samplenum::Int64)
	
	R=0.5

	r_sq=R^2
	#incircle=convert(Uint64,0)
	incircle=0

	incircle=@parallel (+) for i=1:samplenum

		mc_x=rand()-R
		mc_y=rand()-R
		mc_l2=mc_x.^2+mc_y.^2

		int(mc_l2<r_sq)
	end

	return incircle*4/samplenum

end
```

程式碼incircle=@parallel (+) for i=1:samplenum的意思是把for迴圈最後一行指令傳回的值相加起來，全部加到incircle這個變數中。



以下是我自己實測的結果:
使用三個行程時，10^10個亂數點，執行時間約21.9秒

```
$ julia -p 3 monte_carlo_pi.jl 
pi=3.1415854148
elapsed time: 21.955739032 seconds (15895304 bytes allocated)
```

完全不使用平行運算，同樣10^10亂數點，執行時間大約一分鐘。

```
$ julia monte_carlo_pi.jl 
pi=3.14160138
elapsed time: 59.497772514 seconds (8692576 bytes allocated)
```

今天就介紹到這邊，完整的程式碼可以到[這裡](https://gist.github.com/kanhua/b0f47473bfde7dbca7fc)下載。




