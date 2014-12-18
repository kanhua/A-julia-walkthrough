---
title: 雜談: 為什麼julia的速度可以接近C甚至更快?
---

今天想先暫停一下julia的實作，想來聊一下julia的效能。

先前有提到，julia的優越之處是它的執行效能，它的(官網首頁)[http://julialang.org]有一些benchmark結果給大家比較。如果code有符合一些最佳化的條件的話，它的執行速度很接近C甚至比C還快，但是它卻又是一個高階的動態語言(dynamical language)。在本系列前面幾集的介紹中，相信大家多少也有些體會。julia是怎麼辦到的呢?

julia能夠達到這樣的執行速度，並不是因為它用了非常特別的編譯器，例如Javascript v8engine這類的超級神器做最佳化。julia的編譯器是根基於LLVM之上，LLVM是開放的，julia可以拿來用，其他語言當然也可以。真的讓julia的速度高過其他動態語言一截的，是julia語言本身的設計。julia同時支援static type和dynamic type。亦即，在定義函數的引數時，可以宣告它的型別，也可以不宣告。以一個簡單的費比那西數列的遞迴計算為例，function的宣告可以寫成


```julia
function fib(N::Uint64)
  ....
end
```

或是

```julia
function fib(N)
  ....
end
```

第一種寫法直接宣告了引數的型別一定是unsigned integer。第二種寫法不指定引數的型別，N可以是任意物件，物件的型別就讓編譯器或是在執行期讓程式來判斷。

julia和python都是強型別(strong type)的語言，在這兩個語言的設計裡，變數的本身沒有型別，變數指向的值才有型別，而且不同型別的值不會自動轉換。這句話也是不是很清楚，舉個例子:

```
x=3
```
在這個例子中，x在julia和python的設計裡就只是一個指標，指向3這個值，而3這個值是一個整數(integer)，而也許在程式的某個地方，x會被重新指向到另一個型別的值，例如

```
x='three'
```
甚至是一個函式
```
x=somefunction()
```
但是有一個很重要的限制，就是不同型別的值不能做運算，除非有另外的定義。例如x='a'+1這個在javascript是可以的，但在python和julia就不行。

為什麼python和julia的設計(似乎)很類似，但執行的效能卻差很多呢?這是因為julia在編譯的過程會進行type inference，也就是在執行期去推理程式裡頭每個函數引數的型別，然後進行最佳化。以上面的fib(N)例子來說，如果程式裡有很明確的線索讓編譯器知道該傳入的型別，那就會用該型別來實作並進行最佳化。舉例來說，同樣是3+3，在最低層的機器語言中，浮點數相加(3.0+3.0)和整數相加(3+3)所需要的最佳化的code是不一樣的。

當然，如果程式碼本身內部所提供的線索不足以讓編譯器決定型別，那編譯器就不會進行最佳化，執行的效率就會降下來。

所以，讓julia達到高效率是有條件的。julia提供了static type機制，讓使用者可以指定型別，加快執行效率，也同時具備了dynamic type的彈性，但是大量使用的後果就是減低執行速度。

打了這麼落落長一篇，其實結論就一句話: 你的julia程式寫得愈像C，速度就會愈接近C/Fortran，寫得愈像python，速度也會愈接近python。

底下放上兩段簡單的程式碼讓大家實測julia和python的速度差別:

```julia
function fib(N::Uint64)

	if N==0
		return 0
	elseif N==1
		return 1
	else
		return fib(N-1)+fib(N-2)
	end

end


time=@elapsed(fib(convert(Uint64,10)))

println(time)
```

```python
def fib(N):
	if N==0:
		return 0
	elif N==1:
		return 1
	else:
		return fib(N-1)+fib(N-2)
	

if __name__=="__main__":
	import timeit
	print(timeit.timeit("fib(10)", setup="from __main__ import fib"))
```

今天就先說到這邊，有關type inference其他的眉角下次有空再介紹。

其他參考連結:
[Performance tips-- Official julia documentation](http://docs.julialang.org/en/release-0.3/manual/performance-tips/)



