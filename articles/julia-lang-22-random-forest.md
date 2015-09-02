# Random Forest Classification

上一篇完成了資料的整理。今天就來試一下用random forest來做預測。

在julia(17)這篇文章我們也是用這個演算法來做字母辨識，之前的code幾乎可以拿過來用。但還是需要稍微調整一下。

首先是轉換資料的型態。Decision Tree這個package並沒有完全支援DataFrame，所以我們必須要把DataFrame和DataArray這兩個型別轉回julia的基本Array型別。作法也很簡單，只要用array()就可以了:

```
xTrain=newdata      # newdata 是已經整理好的資料
yTrain=df[:Survived] # 生還結果df[:Survived]是training label

#把資料轉為一般的Array

xTrain=array(xTrain)
yTrain=array(yTrain)
```

使用random forest包含了兩個步驟，第一步是用build_forest()以及training data建立模型

```
model = build_forest(yTrain, xTrain, 5, 20, 1.0)
```

接下來用apply_forest()來預測test data的結果:

```
predTest = apply_forest(model, xTest)
```

因為目前我們還沒有test data，所以我們要直接用cross validation來看這個模型的預測結果。DecisionTree package提供了一個可以直接結合random forest和cross validation的函式nfoldCV_forest()


```
accuracy = nfoldCV_forest(yTrain, xTrain, 5, 20, 4, 0.7)
```

得到的結果如下。

```
Fold 1
Classes:  {0,1}
Matrix:   
[125 12
 23 62]
Accuracy: 0.8423423423423423
Kappa:    0.6579804560260585

Fold 2
Classes:  {0,1}
Matrix:   
[134 11
 26 51]
Accuracy: 0.8333333333333334
Kappa:    0.6145471609572971

Fold 3
Classes:  {0,1}
Matrix:   
[121 19
 26 56]
Accuracy: 0.7972972972972973
Kappa:    0.5570630486831604

Fold 4
Classes:  {0,1}
Matrix:   
[110 15
 26 71]
Accuracy: 0.8153153153153153
Kappa:    0.6198312588756161

Mean Accuracy: 0.822072072072072
```

結果並不差，大約都在80%上下。下一步就是把test data set也做一樣的資料處理，然後就上傳到kaggle的server上評分。

