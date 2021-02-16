---
 layout: post
 title: Linux 下 Chrome 使用深色模式
 date: '2021-02-16T13:29:38+08:00'
 author: Ray
 tags:
 - Linux
 modified\_time: '2021-02-16T13:29:38+08:00'
---

## 基本操作及原理

原理是在chrome開啟時加上參數，所以啟動參數如下：
```bash
google-chrome-stable --force-dark-mode --enable-fearures=WebUIDarkMode
```
但是每次開啟時都要打很麻煩

所以就使用以下指令自動處理

指令內容就是簡單的改掉 `/usr/share/applications/google-chrome.desktop`

```bash
sudo sed -i 's/Exec=\/usr\/bin\/google-chrome-stable/Exec=\/usr\/bin\/google-chrome-stable\ --force-dark-mode\ --enable-features=WebUIDarkMode/' /usr/share/applications/google-chrome.desktop
```

## 讓他更完整一點

利用 Arch Linux 的 Hooks 在套件安裝後自動執行

加入以下檔案 `/etc/pacman.d/hooks/chrome.hook`

```ini
[Trigger]
Operation = Install
Type = Path
Target = /usr/share/applications/google-chrome.desktop

[Trigger]
Operation = Upgrade
Type = Path
Target = /usr/share/applications/google-chrome.desktop

[Trigger]
Operation = Install
Type = Package
Target = google-chrome

[Trigger]
Operation = Upgrade
Type = Package
Target = google-chrome

[Action]
Description = Enable dark theme for google chrome.
When = PostTransaction
Exec = /bin/sh -c "sed -i 's/Exec=\/usr\/bin\/google-chrome-stable/Exec=\/usr\/bin\/google-chrome-stable\ --force-dark-mode\ --enable-features=WebUIDarkMode/' /usr/share/applications/google-chrome.desktop"
```
