---
 layout: post
 title: 給資工系學弟妹的建議
 date: '2023-05-03T01:43:24+08:00'
 author: Ray
 tags:
 modified_time: '2023-05-03T01:43:24+08:00'
---
一些雖然不是必要，但會幫助你過得更順利的建議。
## 專案資料夾
不少朋友總是每個作業散落在電腦C槽，甚至桌面上。
我想應該不是少數人。將每個作業，或是專案，放在資料夾。這樣更好管理。更何況有些程式作業需要 Makefile，如果散落在各地，專案會非常難管理，也很難繳交。


```
C:/workspace
    + programming/
        + assignment_1_something/
            + bin/
            - Makefile
            - main.c
            - test.c
            - utils.c
    + oop/
        + assignment_3_something/
        ...
```

雖然實在是難以理解有人不懂，但是實在時常看到有人全部丟在一起。

## 保持 Coding Style
保持一致的 coding style 是很重要的。
通常我會尊重 formatter, 他怎麼排版我就怎麼排。我會在 vscode 安裝對應的 formatter 插件，然後時常按排版的快速鍵。當然你要什麼 editor 取決於你，我也會用 vim 寫程式，按下 `gg=G` 也可以自動處理 indent (縮排)。

不只是你要右括還是下括，變數命名規則、專案裡的風格，保持整個專案一致。以下是錯誤的範例：
```c
struct Foo {int *a; int *b};
int getA() {}

int get_b() {}
```

或是錯誤處理

```c
// get_a:
//  param obj: non-null pointer to Foo
//  param ptr: non-null ptr to stores returned value
//  return: non-zero value for errors, ...
int get_a(struct Foo &obj, int *ptr) {
    if (obj.a == NULL) {
        return 1;
    }
    *ptr = *obj.a;
    return 0;
}
```
具體回傳什麼數值？是 0 表示失敗還是成功？儘量在專案上維持一致。

## 文件
這裡會說文件，不只是註解。像是上面 `get_a` 清楚的寫了每個參數要做什麼。當然這個函數非常簡單，`obj` 可能就不用寫是什麼，可能提醒下 non-null 就好。但是像是 return 就宜寫清楚。

## Makefile
Makefile 除了作業要求，更多時候是幫助自己。即使你不會寫花俏的、自動依賴偵測的 Makefile，單純的 `make` 肯定要比每次都手動打編譯指令來的簡單，也不容易忘記重新編譯。

## CLI
使用 CLI 是**必要**的。如果你到現在不熟悉 CLI 操作、不知道什麼是 PATH，麻煩找點時間學。

## 使用 sanitizer
寫 C/C++ 時常碰到未定義行為、記憶體等問題。使用 Unix-like 作業系統時可以打開 `-fsanitize=undefined -fsanitize=address -fsanitize=leak` 的編譯參數。Windows 可以使用 WSL。vscode 有很方便的套件可以連線到 WSL。建議如果寫的是 C/C++ 儘量就用 WSL。Linux 開發要比 Windows 來的友善太多。
以上大概是近些時間看到的比較多問題，希望對大家有幫助。
