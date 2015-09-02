# Symbol型別在DataFrame的角色

前一篇我們提到了DataFrame是用Symbol這個型別的儲存Index資訊。這一篇就要來解釋為什麼要這樣做:

julia程式的每一行指令(Expression)都是由兩個部份組成，head和args，它的定義是這樣的:

```
type Expr
  head::Symbol
  args::Array{Any,1}
end
```

head用來指定這個expression所要做的動作，而args是個次expression，對編譯器設計有了解的讀者應該會覺得似曾相識。我們直接來看一個例子:

```
julia> demoex=:(a+b*c+1)
:(a + b * c + 1)
```
我們先用:(a+b*c+1)建了一個Expr型別的物件demoex，接著就來看demoex的head和args分別是什麼:


```
julia> demoex.head
:call

julia> demoex.args
4-element Array{Any,1}:
  :+      
  :a      
  :(b * c)
 1        
```

demoex的head是:call，用來執行這個a+b*c+1的運算，而args則由幾個Symbol和Expr型別的元素所組成:在這四個元素中，+和a是Symbol，(b*c)則是另一個Expr。

也就是說，Symbol這個型別是用來構成julia程式語言的基本單位。

julia提供了於eval()函式來執行自訂的Expr物件，舉個非常簡單的例子像這樣:

```
julia> ex=:(a+b)
:(a + b)

julia> a=2
2

julia> b=1
1

julia> eval(ex)
3
```

eval()函式的功能和python裡的eval()非常類似。但還是有一點點不同，python的eval()函式是傳入一個String物件作為引數，以上面的例子來說，python會寫成

```
eval("(a+b)")
```
但是在julia裡，eval()的引數就只能是Expr或是Symbol型別的變數實體。這個設計的好處是讓程式碼本身和語言解析器(parser)及程式碼產生器(code generation)等編譯器工具可以更緊密地結合在一起，讓julia擁有相當特出的metaprogramming的功能。

我們可以從另外一個例子來感受一下來這件事，同時，我們也會由這個例子來把主題慢慢拉回DataFrame架構的解析。

julia的函式也有optional argument的設計，像這樣

```
function f(;kwargs...)

   .....
end

f(a=1,b=2)

```

f裡的分號;是用來告訴編譯器接下來的"kwargs..."是若干組"引數名稱=引數值"的組合。接著我們來看"引數名稱"這個實體是屬於什麼型別:

```
function f(; kwargs...)

	for (r,v) in kwargs

		println(typeof(r))

	end

end


f(a=1,b=2)
```
傳回的結果為:

```
Symbol

Symbol

```

而DataFrame選用Symbol作為欄位名稱型別的理由就是可以運用這個特性DataFrame的建構式可以很簡潔，像這樣:

```
julia> df=DataFrame(C1=1:3,C2=4:6)
3x2 DataFrame
| Row | C1 | C2 |
|-----|----|----|
| 1   | 1  | 4  |
| 2   | 2  | 5  |
| 3   | 3  | 6  |
```

C1和C2是欄位的名稱，而1:3和4:6則分別是C1和C2所代表的資料。因為C1和C2都是Symbol型別，所以就可以不用經過型別轉換直接放到Index裡頭。也因為這樣，所以讀取C1欄位的資料時，要用df[:C1]而不是df["C1"]。

```
julia> df["C1"]
WARNING: indexing DataFrames with strings is deprecated; use symbols instead
 in getindex at /.julia/v0.3/DataFrames/src/deprecated.jl:180
3-element DataArray{Int64,1}:
 1
 2
 3

julia> df[:C1]
3-element DataArray{Int64,1}:
 1
 2
 3
```
在這個例子上，雖然df["C1"]還可以運作，但是會收到DataFrame的警告，建議的使用者用Symbol而不是String在呼叫欄位資料，以免日後版本不相容。

DataFrame架構就先介紹到這邊，希望有興趣使用DataFrame來分析資料的讀者能有所幫助。





