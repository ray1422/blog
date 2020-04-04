---
layout: post
title: Sony Xperia XA Root實戰經驗
date: '2018-07-06T11:13:00.002-07:00'
author: Ray
image: xperia.png
tags:
- 資訊
modified_time: '2019-10-03T17:41:30.738-07:00'
thumbnail: https://4.bp.blogspot.com/-KeX6sXwSCv0/Wz-5YO73VyI/AAAAAAAACdc/7FF3g0mLfGIyer8BKERKKu7YM4WZ6aFpQCLcBGAs/s72-c/%25E6%259C%25AA%25E5%2591%25BD%25E5%2590%258D.png
blogger_id: tag:blogger.com,1999:blog-3652771586318239972.post-8952453225009351050
blogger_orig_url: https://ray1422.blogspot.com/2018/07/sony-xperia-xa-root.html
---

大家好，我是Ray  
最近換了新手機，而舊的Xperia不怎麼用了  
放著可惜，回收、轉賣也浪費  
於是，就來挑戰Root啦~  

不得不說，Sony的手機挑戰Root真的很有難度  
像是Data分區加密、recovery異常的難刷....等等的  
Ray成功Root的是單sim卡的F3115  
大家嘗試的過程中若有發生什麼問題歡迎在下方留言  

那廢話不多說 開始吧  

首先先解釋專業名詞  


*   **Bootloader解鎖** (以下簡稱BL解鎖):  
        解鎖Bootloader，想要對手機進行任何刷機的操作都必須要先解鎖BL.
*   **Root** :  
        使手機獲得Root權限。
*   **卡刷** :  
        使用SD卡，將檔案刷入手機的操作。
*   **TWRP**:  
        全名為Team Win Recovery Project，是用來進行卡刷的工具。
*   **SuperSU**:  
        用來獲取Root權限的卡刷包。
*   **ADB Tool**:  
        在電腦端偵錯/調適手機的工具。
*   **Flash Tool**:  
        用於索尼的[線刷](https://lmgtfy.com/?q=%E7%B7%9A%E5%88%B7)工具，圖示是閃電(有些同名軟體，請勿弄錯)

  

#### **第零步：下載以下工具**  
**註:以下工具連結皆為XDA網友及其他網友提供，如連接失效請自行Google.**

*   [Flash Tool](http://www.mediafire.com/download/skkyma6bmdnjm4b/flashtool-0.9.22.3-windows.exe)
*   TWRP for Xperia XA (非官方)

*   [單Sim卡 (f3111/f3113/f3115)](https://mega.nz/#!ZxBBGTbA!C2FSqJE0Xv6yQDPlmzRkmGOVxYhRMMhe3Z2TGTCvCkg)  [原文連結](https://forum.xda-developers.com/xperia-xa/development/f3111-f3113-f3115-twrp-recovery-xa-t3606488)
*   [雙Sim卡 (F3112,F3116)](https://mega.nz/#!xxZlwYLB!Df5otGqZP3IBuEcn4pHUamRh451HCFnKfbcJHP4CBTk)          [原文連結](https://forum.xda-developers.com/xperia-xa/development/f3112-f3116-twrp-recovery-xa-dual-sim-t3606232)

*   Boot.img (請進入之後，進入下方找到最新連結下載)

*   [單Sim卡 (f3111/f3113/f3115)](https://forum.xda-developers.com/xperia-xa/development/f3111-f3113-f3115-stock-kernels-built-t3573119)
*   [雙Sim卡 (F3112,F3116)](https://forum.xda-developers.com/xperia-xa/development/f3112-f3116-stock-kernels-built-sources-t3526496)

*   [SuperSu](https://androidfilehost.com/?fid=745425885120754186) (若連結失效，請自己找。Ray使用的版本是SuperSU 2.82)
*   [ADB Tool (可以自己找最新的)](https://dl.google.com/android/repository/platform-tools-latest-windows.zip)
*   [Sony Xperia XA 官方驅動](https://developer.sony.com/file/download/xperia-xa-driver/) (官方提供 最為致命)


並且準備好以下工具：  

*   USB傳輸線(請確保他不會用到一半壞掉或鬆掉，這很尷尬)
*   Windows 7以上的電腦 (XP很舊了 應該有些地方會不行，不過試試看也可以)
*   micro SD卡
*   充好電的Xperia XA (因為等等會跑很久，正常電池至少要個60%吧)


```
██╗    ██╗  █████╗  ██████╗  ███╗   ██╗ ██╗ ███╗   ██╗  ██████╗
██║    ██║ ██╔══██╗ ██╔══██╗ ████╗  ██║ ██║ ████╗  ██║ ██╔════╝
██║ █╗ ██║ ███████║ ██████╔╝ ██╔██╗ ██║ ██║ ██╔██╗ ██║ ██║  ███╗
██║███╗██║ ██╔══██║ ██╔══██╗ ██║╚██╗██║ ██║ ██║╚██╗██║ ██║   ██║  
╚███╔███╔╝ ██║  ██║ ██║  ██║ ██║ ╚████║ ██║ ██║ ╚████║ ╚██████╔╝
 ╚══╝╚══╝  ╚═╝  ╚═╝ ╚═╝  ╚═╝ ╚═╝  ╚═══╝ ╚═╝ ╚═╝  ╚═══╝  ╚═════╝
```

本站不負任何責任，繼續往下操作，你的手機會因此失去保固，並且可能會變磚塊機。

  

#### **第一步：開啟開發者模式，允許usb偵錯**

1\. 點擊\[設定\] -> \[關於手機\] -> 最下方 \[軟體版本\]，直到出現 "您以成為開發人員"

2. 點擊\[設定\] -> \[開發人員選項\] -> 開啟\[允許USB偵錯\] 以及 \[oem解鎖\]

  

#### 第二步：BL解鎖，獲得腐女封號(誤

**WARNING: 接下來就很可能會把手機搞壞了，請謹慎操作!**  
**WARNING: 此動作將會清除手機所有資料，請先備份起來!**  

1\. 解壓縮ADB Tool，將下載來的兩個.img 檔案重新命名為 recovery.img 以及 boot.img，並放入adb tool的資料夾內。  
2\. 開啟[Sony Developer](https://developer.sony.com/develop/open-devices/get-started/unlock-bootloader) 網站，在最下方裝置(device)選擇 Sony XA  
3\. 在打電話的地方輸入 \*#06# ，取得IMEI 並輸入至網頁上，並點選送出(submit)  
4\. 複製下方的解鎖代碼  

[![](https://4.bp.blogspot.com/-KeX6sXwSCv0/Wz-5YO73VyI/AAAAAAAACdc/7FF3g0mLfGIyer8BKERKKu7YM4WZ6aFpQCLcBGAs/s400/%25E6%259C%25AA%25E5%2591%25BD%25E5%2590%258D.png)](https://4.bp.blogspot.com/-KeX6sXwSCv0/Wz-5YO73VyI/AAAAAAAACdc/7FF3g0mLfGIyer8BKERKKu7YM4WZ6aFpQCLcBGAs/s1600/%25E6%259C%25AA%25E5%2591%25BD%25E5%2590%258D.png)

  

  

  

  

  

5\. 在adb tool 所在資料夾 開啟cmd (powerShell) 執行以下命令  

    ./adb reboot bootloader

  



此時，你可能需要在手機上點選允許這台電腦偵錯。並且手機應該會重新開機至黑色畫面，上方led燈應該是藍色的。  
如果無法連接 你可以試試看電腦重新開機 並且安裝上面下載的驅動(把資料夾解壓縮進C:\\windows\\system32\\)  

6\. 輸入以下指令，其中KEY是你剛剛複製的代碼(ox後面不要有空格)  


    ./fastboot oem unlock 0xKEY

  



接著你的手機應該會重新開機，並且重設所有資料。  
這次開機會特別久是正常的，請耐心等候(應該會看到Xperia Logo 而不是Sony)。  

您可以藉由以下方式確認BL解鎖成功：  

到撥號輸入 ##7378423## → 選擇 \[Service Info\] → \[Configuration\]，看看最下面一段 Rooting status。  

如果顯示為 Bootloader unlocked: Yes，表示你已經成功解鎖了。  

到此，恭喜你完成第二步驟。  

#### 第三步：刷入TWRP Recovery

此時，因為手機重設了，你要重新做一次步驟零。  
首先，安裝、開啟剛剛下載的flashTool  
這會需要一些時間，請耐心等候。  
對了，先把傳輸線移除。

  

點選工具列 有XF的圖示  
點兩下左下方的Xperia XA，點兩下你的型號，點兩下右邊的版本，在點兩下右邊的核心版本。

[![](https://2.bp.blogspot.com/-dneks8j0hrs/Wz-9dE97fJI/AAAAAAAACdo/a67kx97PAfY12ztbq5FkKVCKnrFqSSFQQCLcBGAs/s640/%25E6%259C%25AA%25E5%2591%25BD%25E5%2590%258D.png)](https://2.bp.blogspot.com/-dneks8j0hrs/Wz-9dE97fJI/AAAAAAAACdo/a67kx97PAfY12ztbq5FkKVCKnrFqSSFQQCLcBGAs/s1600/%25E6%259C%25AA%25E5%2591%25BD%25E5%2590%258D.png)

  

點選download  
這大概會有1GB多的下載，會耗費很多時間，可以先去吃早餐之類的(你大概也是深夜在做，對吧  
下載完成後，點選左上方閃點圖示 選擇 flashmode，並且照下圖操作  

[![](https://3.bp.blogspot.com/-BsCsg6pOq2o/Wz-_aUpa5mI/AAAAAAAACd0/Yx96E15Hy2A3CWQPlW7crWPV2YGW-RoUgCLcBGAs/s640/%25E6%259C%25AA%25E5%2591%25BD%25E5%2590%258D.png)](https://3.bp.blogspot.com/-BsCsg6pOq2o/Wz-_aUpa5mI/AAAAAAAACd0/Yx96E15Hy2A3CWQPlW7crWPV2YGW-RoUgCLcBGAs/s1600/%25E6%259C%25AA%25E5%2591%25BD%25E5%2590%258D.png)

移除傳輸線，並且  
長按音量減小(-) 以及電源鍵 持續約10秒 以完全關閉手機  
接著等到電腦出現動畫，按住音量減小(-) 並插入連接線至動畫消失  
如果無法成功請嘗試安裝驅動(上面有寫，ctrl + F)  
應該很快就刷入了。  

如果你的手機變磚，你也可以嘗試全部不要勾選，以還原手機(系統部分。  

接著拔掉傳輸線 開啟手機  
待開機完成後，把SuperSU ZIP資料夾放入 **SD卡**  
在adb tool 資料夾開啟cmd(powerShell)  
輸入以下指令:  

```bash
./adb reboot bootloader./fastboot flash recovery recovery.img./fastboot flash boot boot.img
```



等待刷入後(應該很快，幾秒而已)，拔除傳輸線。  
接著點音量鍵小，以及電源(同時)，並在聽到震動後立即放開。  

此時如果進入TWRP，則表示recovery刷入成功。  
若詢問密碼，請點選 "cancel"  
接著  向右滑動以允需修改  

[![](https://1.bp.blogspot.com/-eZtFeTE05ew/Wz_EVNdLnnI/AAAAAAAACeY/uXAMcMVh5PEpqsZxU7FRY9Eeof51tRwOACLcBGAs/s400/IMAG0081.jpg)](https://1.bp.blogspot.com/-eZtFeTE05ew/Wz_EVNdLnnI/AAAAAAAACeY/uXAMcMVh5PEpqsZxU7FRY9Eeof51tRwOACLcBGAs/s1600/IMAG0081.jpg)


點選 Wipe -> format Data 以格式化儲存區  

[![](https://2.bp.blogspot.com/-X0dvUudZxhY/Wz_EdZyO0SI/AAAAAAAACec/L_1-tSBFRgsqxWRN5zBrIHMi0FfRPQlagCLcBGAs/s400/IMAG0082.jpg)](https://2.bp.blogspot.com/-X0dvUudZxhY/Wz_EdZyO0SI/AAAAAAAACec/L_1-tSBFRgsqxWRN5zBrIHMi0FfRPQlagCLcBGAs/s1600/IMAG0082.jpg)  [![](https://2.bp.blogspot.com/-jz36_BOVEyo/Wz_EetoXWNI/AAAAAAAACeg/iKK9Wwquh4owk9duQmG_FcGksWiR5585gCLcBGAs/s400/IMAG0083.jpg)](https://2.bp.blogspot.com/-jz36_BOVEyo/Wz_EetoXWNI/AAAAAAAACeg/iKK9Wwquh4owk9duQmG_FcGksWiR5585gCLcBGAs/s1600/IMAG0083.jpg)  

接著按back，回到起始選單  
選擇 \[install\] \[select Storage\] \[Micro SDCard\] 點選你剛剛存入的zip檔案  
刷入成功後，點選重新開機  
重新開機會循環幾次，也會花費一些時間。  
第一次開機可能會看到什麼東西已停止，不過不用理他。  

第一次設定先別連接網路，也別登入帳號(聽說會出問題)  
進入系統後，若看到superSU 就表示大功告成啦~  

當程序要存取ROOT權限時，SuperSU會跳出彈出視窗，詢問是否給予權限  
請只給予信任的程式ROOT權限!  

個人推薦需要ROOT權限的應用有 愛字體  
索尼預設不給換字體只好來硬的了ˊˋ  
(實際效果展示)  
(這主題是自己做的，大家可以搜尋看看，很好玩)  

[![](https://1.bp.blogspot.com/-ODp22oN2vHc/Wz_Gjuq_JrI/AAAAAAAACe4/HyxLr2shHTwyP57jL77pvUZP1AnNUmiHQCLcBGAs/s320/Screenshot_20180707-034026.png)](https://1.bp.blogspot.com/-ODp22oN2vHc/Wz_Gjuq_JrI/AAAAAAAACe4/HyxLr2shHTwyP57jL77pvUZP1AnNUmiHQCLcBGAs/s1600/Screenshot_20180707-034026.png) [![](https://1.bp.blogspot.com/-S_n29mpozBk/Wz_GjzHh2uI/AAAAAAAACe8/T5xRNJz-3Vo2rDW_9MtsXgCJm5wtcewTgCLcBGAs/s320/Screenshot_20180707-034019.png)](https://1.bp.blogspot.com/-S_n29mpozBk/Wz_GjzHh2uI/AAAAAAAACe8/T5xRNJz-3Vo2rDW_9MtsXgCJm5wtcewTgCLcBGAs/s1600/Screenshot_20180707-034019.png)