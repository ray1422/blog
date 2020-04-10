---
layout: post
title: TensorFlow 多卡訓練
date: '2020-04-11T03:15:58+08:00'
author: Ray
image: 'taiwnia_2.jpg'
tags:
- 資訊
- TensorFlow
- 機器學習
---

~~哪個男孩不想要有自己的超級電腦呢(x)~~

最近經手的項目越來越大，煉丹(X)訓練(O)的時間也是越拉越長。
為了節約訓練時間，使用多顯卡以加快訊練速度是必不可少的。
下面是經過統整後的一些要點。
  

## 使用`tf.data.Dataset` 代替自己寫Generator
自己寫的Generator 受到Python的全局解釋器鎖 (Global Interpreter Lock, GIL)的限制，效能十分低落。  
然而`TFRecord`太麻煩了，目前推薦使用[官網的教學](https://www.tensorflow.org/tutorials/load_data/images)方式，將圖片的路徑儲存為dataset，並在map方法中開啟圖片（與預處理一起進行），貌似可以有效的提昇運行速度。

## 代碼範例

`train.py`
```python
BATCH_SIZE = 64
strategy = tf.distribute.MirroredStrategy()
n_gpu = strategy.num_replicas_in_sync
BATCH_SIZE *= n_gpu

with strategy.scope():
    model = models.get_model(n_class=18)
    model.compile(optimizer='adam', loss="categorical_crossentropy")
 
@timer  # @timer 是自己寫的裝飾器，用來計時的，不重要。
def train():
    train_dataset, n_td = get_dataset(dir_name="./dataset/train", batch_size=BATCH_SIZE)
    valid_dataset, n_vd = get_dataset(dir_name="./dataset/valid", batch_size=BATCH_SIZE)

    model.fit(train_dataset,
              epochs=10,
              validation_data=valid_dataset,
              steps_per_epoch=n_td,
              validation_steps=n_vd)

with strategy.scope():
   train()

```  
`dataset.py` （基本上跟官網的一致，直接看官方教學即可。）
```python
import glob
import os
import pathlib

import numpy as np
import tensorflow as tf

AUTOTUNE = tf.data.experimental.AUTOTUNE


def get_onehots(length):
    embeddings = np.zeros((length, length), dtype=np.int32)
    for i in range(length):
        embeddings[i][i] = 1

    return embeddings


def get_dataset(dir_name, batch_size=64):
    @tf.function
    def open_image(path):
        image = tf.io.read_file(path)
        image = tf.image.decode_jpeg(image, channels=3)
        image = tf.image.resize(image, [224, 224])
        image /= 255.0  # normalize to [0,1] range
        return image

    all_image_paths = list(glob.glob(f'{dir_name}/*/*.*g'))
    label_names = sorted(os.path.basename(item) for item in glob.glob(f"{dir_name}/*") if os.path.isdir(item))
    label_to_index = dict((name, index) for index, name in enumerate(label_names))
    idx_to_onehot = get_onehots(len(label_names))
    all_image_labels = [idx_to_onehot[label_to_index[pathlib.Path(path).parent.name]] for path in all_image_paths]

    path_ds = tf.data.Dataset.from_tensor_slices(all_image_paths)
    image_ds = path_ds.map(open_image, num_parallel_calls=AUTOTUNE)
    label_ds = tf.data.Dataset.from_tensor_slices(tf.cast(all_image_labels, tf.int64))
    image_label_ds = tf.data.Dataset.zip((image_ds, label_ds))
    image_label_ds = image_label_ds.shuffle(len(all_image_paths)).repeat().batch(batch_size=batch_size)
    return image_label_ds.prefetch(AUTOTUNE), tf.math.ceil(len(all_image_paths) / batch_size).numpy()

```

## 注意事項
在使用多顯卡訓練時，batch size 要乘以顯卡數量，這樣整個batch會被均攤到每張顯卡。
例如顯卡數量8，batch size = 8 * 32
這樣每張顯卡都會被分到batch size = 32


## 實驗
### 測試環境
 - [TAIWANIA 2](https://www.nchc.org.tw/Page?itemid=2&mid=4#TAIWANIA%202)
 - GPU: Tesla V100 x8
 - cpu: 每張顯示卡對4核心
 - Dataset: EFIGI Dataset
 - 任務：VGG Image Classification

所有檔案均每次從硬碟讀取，沒有快取。
第一個epoch因為要初始化一些東西，所以比較慢是正常的。

### 實驗1：單顯卡，不同batch size
由於不同張顯卡的 batch size 是不同的，因此先排除batch size對效能的影響。

- batch size = 64
  - 每個epoch耗費17秒，總共193秒
```
GPUs: 1
Train for 50.0 steps, validate for 6.0 steps
Epoch 1/10
50/50 [==============================] - 40s 798ms/step
Epoch 2/10
50/50 [==============================] - 17s 339ms/step
...
"train" took 193.9154613018036 seconds.
```
- batch size = 128
  - 每個epoch耗費16秒，總共186秒
```
GPUs: 1
Train for 25.0 steps, validate for 3.0 steps
Epoch 1/10
25/25 [==============================] - 38s    2s/step
Epoch 2/10
25/25 [==============================] - 16s 658ms/step
"train" took 186.43455386161804 seconds.
```
不難發現，單純加大batch size對於整體的影響並不大。


### 實驗2：多顯卡訓練
- GPUs: 2
  - 每個epoch耗費11秒，總共129秒
  - 相較單顯卡提昇1.45倍。
```
GPUs: 2
Train for 25.0 steps, validate for 3.0 steps
Epoch 1/10
25/25 [==============================] - 27s    1s/step
Epoch 2/10
25/25 [==============================] - 11s 458ms/step
...
"train" took 129.5954978466034 seconds.
```
- GPUs: 4
  - 每個epoch耗費5秒，總共69秒
  - 相較單顯卡提昇2.7倍，相較雙顯卡提昇1.86倍
```
GPUs: 4
Train for 13.0 steps, validate for 2.0 steps
Epoch 1/10
13/13 [==============================] - 24s    2s/step
Epoch 2/10
13/13 [==============================] -  5s 380ms/step
...
"train" took 69.54226183891296 seconds.
```

- GPUs: 8
  - 每個epoch耗費6秒，總共102秒
  - 沒有提昇反而變慢
```
GPUs: 8
Train for 7.0 steps, validate for 1.0 steps
Epoch 1/10
7/7 [==============================] - 37s 5s/step - loss: 154.3344 - val_loss: 3.1926
Epoch 2/10
7/7 [==============================] - 7s 945ms/step - loss: 7.4059 - val_loss: 3.2977
...
"train" took 102.41243410110474 seconds.
```

## 結論
在上面的實驗中，4 GPUs 有最好的效能。至於為什麼使用8張顯示卡沒有更快，可能是因為碰到硬碟瓶頸了，不但沒辦法更快，反而還要處理多張顯示卡得開銷。但也可能是資料集太小，導致提昇不明顯。

