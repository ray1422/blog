---
 layout: post
 title: 優化網頁滾動效能
 date: '2021-02-10T14:10:12+08:00'
 author: Ray
 tags:
 - 網頁
 - CSS
 modified_time: '2021-02-10T14:10:12+08:00'
---

在網頁捲動時，若有明顯卡頓，可能是因為元素重繪所造成的。首先利用 Chrome 的開發工具確認捲動時重繪的元素：

1. 打開 DevTools

2. 按 `ctrl` + `shift` + `p`

3. 輸入 `flash` 並且選取顯示

   ![image-20210210141439522]({{site.baseurl}}/img/chrome_dev_flash_paint.png)

4. 滾動網頁，尋找刷新的區塊

   ![image-20210210141439522]({{site.baseurl}}/img/web_flashing_block.jpg)

這樣就找到捲動時會重繪的區塊。對他們加上以下 CSS

```css
THE_ELEMENT {
    transform: translate3d(0,0,0);
    -webkit-transform: translate3d(0,0,0);
    will-change: transform;
}
```

再次檢查是否會重繪，理論上效能就會提昇了。

[ref](https://medium.com/@kulor/one-small-css-hack-to-improve-scrolling-performance-c5238029e518)