---
 layout: post
 title: 解決終端機打字 Lag
 date: '2021-02-18T17:02:23+08:00'
 author: Ray
 tags:
 - Linux
 modified_time: '2021-02-18T17:02:23+08:00'
---
問題是由於 frame buffer compression 所導致

將 `i915.enable_fbc=0` 加入內核參數即可禁用之。

[ref](https://wiki.archLinux.org/index.php/Intel_graphics_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#Disabling_frame_buffer_compression)


