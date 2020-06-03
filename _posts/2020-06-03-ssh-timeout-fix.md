---
 layout: post
 title: 解決ssh超時自動斷開
 date: '2020-06-03T17:57:18+08:00'
 author: Ray
 tags:
 - linux
 - ssh
 modified_time: '2020-06-03T17:57:18+08:00'
 ---
更改ssh配置文件 `/etc/ssh/sshd_config`
```config
ClientAliveInterval 60
```
這樣每過60秒伺服器就會發送請求，檢查客戶端是否存。
預設是0 就是不檢查

[ref](https://www.cnblogs.com/longshiyVip/p/4774177.html)

