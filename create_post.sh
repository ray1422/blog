#!/bin/bash

read -p "請輸入標題： " title
read -p "請輸入標籤： " tags_raw
datetime_str=$(date --iso-8601=second)
tags=""
for tag in $tags_raw
do
    tags="$tags - $tag\n"
done

output="
---\n
layout: post\n
title: ${title}\n
date: '${datetime_str}'\n
author: Ray\n
tags:\n
${tags}
modified_time: '${datetime_str}'\n
---\n"
date_str=$(date +%F)
read -p "請輸入檔名(不用副檔名)： ${date_str}-" filename
echo -e $output > "_posts/${date_str}-${filename}.md"
echo "完成！"
vim "_posts/${date_str}-${filename}.md"


