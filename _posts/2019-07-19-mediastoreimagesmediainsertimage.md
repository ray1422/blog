---
layout: post
title: MediaStore.Images.Media.insertImage 的巨坑
date: '2019-07-19T16:57:00.002-07:00'
author: Ray
tags:
- 資訊
- Android
modified_time: '2019-11-05T05:59:03.861-08:00'
blogger_id: tag:blogger.com,1999:blog-3652771586318239972.post-6616169166238180073
blogger_orig_url: https://ray1422.blogspot.com/2019/07/mediastoreimagesmediainsertimage.html
---

如題
原始的分享功能會自動壓縮圖片50%，所以要自己寫個，避免被降低畫質。


```java
package club.chisc.fantasticfilterandroid;

import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.ContentValues;
import android.graphics.Bitmap;
import android.net.Uri;
import android.provider.MediaStore;
import android.util.Log;

import java.io.OutputStream;

import static android.provider.MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
import static androidx.constraintlayout.widget.Constraints.TAG;

public class HDMediaStore {
    public static String insertImage(ContentResolver cr, Bitmap source,
                                     String title, String description) {
        ContentValues values = new ContentValues();
        values.put(MediaStore.Images.Media.TITLE, title);
        values.put(MediaStore.Images.Media.DESCRIPTION, description);
        values.put(MediaStore.Images.Media.MIME_TYPE, "image/png");

        Uri url = null;
        String stringUrl = null;    /* value to be returned */

        try {
            url = cr.insert(EXTERNAL_CONTENT_URI, values);

            if (source != null) {
                OutputStream imageOut = cr.openOutputStream(url);
                try {
                    source.compress(Bitmap.CompressFormat.PNG, 100, imageOut);
                } finally {
                    imageOut.close();
                }

                long id = ContentUris.parseId(url);
                // Wait until MINI_KIND thumbnail is generated.
            } else {
                Log.e(TAG, "Failed to create thumbnail, removing original");
                cr.delete(url, null, null);
                url = null;
            }
        } catch (Exception e) {
            Log.e(TAG, "Failed to insert image", e);
            if (url != null) {
                cr.delete(url, null, null);
                url = null;
            }
        }

        if (url != null) {
            stringUrl = url.toString();
        }

        return stringUrl;
    }

}
```

