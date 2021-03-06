# julia有可能是科學運算的未來嗎?

這篇來稍微總結一下julia。

julia應該是繼Fortran之後第一個完全以科學計算為目的而設計語言。長久以來，腳本式語言如(R/C/C++)有效率不彰的問題，而中階語言C/C++/Fortran寫起來又太過於費時。通常的解決方案是把需要大量記憶體存取以及大量迴圈的程序包裝起來，然後讓這些腳本式語言來呼叫這些函式。然而，如果我們只是要prototype的話，這麼做實在是大炮打鳥，但是用高階語言prototype的話，又要付出很多運算資源。以我們之前介紹2048的AI為例，它用類似蒙地卡羅做大量的隨機模擬，然後找出最好的一步。如果完全用python來prototype的話，每一步大概只能跑10個迴圈就已經等很久了，但是要把它用C/C++改寫又很費時(不過是個玩具，實在不想在上面花那麼多時間)。julia就提供了一個很美好的折衷，和python相比，相同的時間和計算資源，它可以跑100個迴圈甚至更多。

我們也花了許多篇幅在討論julia的語言架構以及特性。它的速度並非來自編譯器的優化code generation，它來自語言本身的設計。我認為julia的語言架構和C非常接近，不管是型別和function overload的設計，除去type inference的話，幾乎可以對譯到C語言。這個設計讓julia可以有效借助目前C/C++的編譯器優化技術，產生出高效的程式碼。

既然是以科學計算為目的而設計的語言，除了速度之外，julia也提供了許多重要的功能，像是平行計算、效能測試，單元測試、meta-programming，也提供了很方便的C/C++/Fortran的串接功能。雖然沒有內建處理表格資料的功能，但是有套件DataFrame可以填補這方面的不足，而DataFrame套件目前的功能和穩定性也都不斷在擴充。

雖然julia語言本身相當優越，而且它的確也填補了目前科學運算語言市場上的真空。然後，套件和維護的人力不足是它的致命傷。從TIOBE index過往的歷史來看，一個程式語言能不能流行，語言的設計不是最大的決定因素。最大的決定因素是這個語言背後有沒有商業公司在撐腰。C#當年出道的時候微軟正是如日中天，正式版都還沒出，C#的書就已經舖滿書店了。近期的例子是Apple的swift的學習熱潮。另外一個決定性的因素是這個語言寫成的程式能不能帶來很高的產值。目前網頁開發和WebApp是顯學中的顯學，所以PHP、JavaScript、Ruby、Python可以累積相當大量的使用者，形成質量俱優的社群來維護這些語言的套件以及相關文件。

julia本身仍缺乏這方面資源的挹注，短期內要全面取代python/R/Matlab的機會並不太高，然而，這並不表示它會一直低調下去。高速運算以及可以快速開發的特性讓julia會成為資料科學家的強力武器之一，使得一些大公司已經開始慢慢採用這個語言作為資料分析之用。julia的DataFrame的其中一位主開發者就是facebook的工程師。當資料科學的從業人數和產值可以和網頁開發相提並論的時候，應該也就是julia大紅大紫的時候。

目前的套件支援不足是julia的缺點之一，因此我認為最適合julia的位置應該是python和C/Fortran的中間地帶。以往用python太過耗時的code可以慢慢用julia一點一點地取代。因此julia目前的方向應該是強化其他語言的串接，讓julia可以很容易接上其他語言的套件，而別的語言也可以很容易接上julia來使用julia做複雜度較高的運算。目前julia和python的雙向串接還有待加強，文件也不夠完整，因此只有一小部份人在使用這些功能。

因為我目前工作的地方沒有買matlab，所以我目前仍然是以python為主，畢竟以目前的狀況來說，用python的產出還是最高的。但是如果julia和python的雙向連結可以加強的話，其實我很願意把一部份python code用julia改寫，來得到更好的效能。

總之，如果你對不同的程式語言有興趣，或是需要大量的科學計算的話，julia是一個相當值得學習的語言，也許你還用不到，但是我相信它的語言設計和架構一定可以給你很大啟發，至少對我來說是這樣。



