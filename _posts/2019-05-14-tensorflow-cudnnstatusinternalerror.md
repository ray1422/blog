---
layout: post
title: "[TensorFlow] 解決CUDA內部錯誤"
date: '2019-05-14T08:45:00.002-07:00'
author: Ray
tags:
- 資訊
modified_time: '2019-10-03T08:21:40.844-07:00'
blogger_id: tag:blogger.com,1999:blog-3652771586318239972.post-7962034384516717223
blogger_orig_url: https://ray1422.blogspot.com/2019/05/tensorflow-cudnnstatusinternalerror.html
---

前些時間跑TensorFlow代碼的時候出現CUDNN_STATUS_INTERNAL_ERROR錯誤
據說會有此錯誤是因為顯存分配問題所導致的BUG，加上以下代碼即可：

```python
config = tf.ConfigProto()
config.gpu_options.allow_growth = True
sess = tf.Session(graph=graph, config=config)
```