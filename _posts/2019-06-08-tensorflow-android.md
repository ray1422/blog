---
layout: post
title: TensorFlow Android 初體驗
date: '2019-06-08T05:20:00.000-07:00'
author: Ray
tags:
- Java
- 資訊
- Android
- TensorFlow
- 機器學習
modified_time: '2019-10-03T08:21:40.805-07:00'
blogger_id: tag:blogger.com,1999:blog-3652771586318239972.post-1998659512424254993
blogger_orig_url: https://ray1422.blogspot.com/2019/06/tensorflow-android.html
---

近期由於手上項目需要，摸索了一下Android以及TensorFlow-Android  

代碼的部分跟python版本大同小異，下面附上代碼  
首現是初始化，這部分應該沒啥問題  

```java
am = assetManager;
inferenceInterface = new TensorFlowInferenceInterface(am, MODEL_FILE);
```


接下來是圖片格式，Android中圖片的格式為Bitmap，須先轉為Float Array  
這部分應該也沒啥問題，如果有需要可以包成函數  

```java
int w = bitmap.getWidth();
int h = bitmap.getHeight();
float[] floatValues = new float[w * h * 3];
int[] intValues = new int[w * h];
bitmap.getPixels(intValues, 0, bitmap.getWidth(), 0, 0, bitmap.getWidth(), bitmap.getHeight());
for (int i = 0; i < intValues.length; ++i) {
    final int val = intValues[i];
    floatValues[i * 3] = ((val >> 16) & 0xFF);
    floatValues[i * 3 + 1] = ((val >> 8) & 0xFF);
    floatValues[i * 3 + 2] = (val & 0xFF);
}
```


接下來就是處理的部份，並且把處理好的結果存到floatValues中 INPUT\_NODE是輸入的節點名稱 可以有很多輸入跟輸出 這邊建議還是另外開個Array，因為有時候處理好的圖片大小會跟原本不一致，可能導致超過大小 不過官方的demo這樣寫，所以就沒另外改了  

```java
inferenceInterface.feed(INPUT_NODE, floatValues, 1, bitmap.getHeight(), bitmap.getWidth(), 3);
inferenceInterface.run(new String[]{OUTPUT_NODE}, true);
inferenceInterface.fetch(OUTPUT_NODE, floatValues);
```

到這裡基本就處理好了，只要在把Float Array轉int Array 再轉Bitmap  

```java
for (int i = 0; i < intValues.length; ++i) {
    intValues[i] = 0xFF000000 | (((int)(floatValues[i * 3])) << 16) | (((int)(floatValues[i * 3 + 1])) << 8) | ((int)(floatValues[i * 3 + 2]));
}
Bitmap new_bitmap = Bitmap.createBitmap(bitmap.getWidth(), bitmap.getHeight(), Bitmap.Config.RGB_565);
new_bitmap.setPixels(intValues, 0, bitmap.getWidth(), 0, 0, bitmap.getWidth(), bitmap.getHeight());
```

