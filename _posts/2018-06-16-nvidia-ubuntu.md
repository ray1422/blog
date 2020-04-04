---
layout: post
title: 解決Nvidia 顯卡ubuntu / Arch Linux 在筆電上畫面撕裂
date: '2018-06-16T13:04:00.000-07:00'
author: Ray
tags:
- nvidia
- linux
- 資訊
- 網路
modified_time: '2019-10-03T08:21:40.815-07:00'
blogger_id: tag:blogger.com,1999:blog-3652771586318239972.post-3142179953327829163
blogger_orig_url: https://ray1422.blogspot.com/2018/06/nvidia-ubuntu.html
---

在使用帶有Nvidia 顯示卡的筆電時，常常會發生畫面撕裂的情形。這裡提供了一些方法來解決。




首先，編輯 /etc/modprobe.d/nvidia-graphics-drivers.conf

```bash
sudo vim /etc/modprobe.d/nvidia-graphics-drivers.conf
```
並且在最後面加入以下內容：
```bash
options nvidia_drm modeset=2
```
最後 在終端機輸入
```bash
# for Ubuntu
sudo update-initramfs -u 

# for Arch Linux
sudo mkinitcpio -p linux
```
並且重新啟動電腦。  
這時候，如果還可以登入桌面，就代表你成功了！！



部份內容參考自 https://ywnz.com/linuxjc/2009.html