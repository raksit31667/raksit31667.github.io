---
layout: post
title:  "แก้ไข Git author ของทุก commit ใน repository ด้วย filter-repo"
date:   2023-09-17
tags: [git]
---

เป็นบางครั้งที่เราจะลืม[ตั้งค่า Git author]({% post_url 2023-01-23-manage-multiple-git-config %}) จนทำให้เราเผลอ push code ขึ้นไปโดยที่ author ผิด (ซึ่งเหตุการณ์นี้จะไม่เกิดขึ้นถ้าองค์กรตั้ง [domain whitelist](https://gitlab.com/gitlab-org/gitlab/-/issues/7297) ไว้) ถ้าเราอยากจะแก้มันก็แค่ rebase เข้าไปเปลี่ยน author ดูง่าย แต่มันไม่ง่ายถ้าเรารู้ตัวอีกทีก็มี commit ที่ author ผิดขึ้นไปเป็นหลายสิบอันแล้ว เข้าไปแก้ก็ดูเสียเวลาเหลือเกิน ในบทความนี้เราจะนำ [git-filter-repo](https://github.com/newren/git-filter-repo) ซึ่ง[ได้รับการแนะนำโดยทีมพัฒนา Git เลย](https://git-scm.com/docs/git-filter-branch#_warning)

```shell
$ git log

commit ...
Author: Correct Name <new@email.com>
Date:   ...

    existing-commit-1

commit ...
Author: Correct Name <new@email.com>
Date:   ...

    existing-commit-2
```

## เริ่มจากการติดตั้งกันก่อน
1. เราใช้ macOS ก็สามารถติดตั้งผ่าน Homebrew ได้เลย

    ```shell
    $ brew install git-filter-repo
    ```

2. สร้าง file ขึ้นมาชื่อ `mailmap` (ไม่ต้องใส่ extension อะไรทั้งนั้น) จากนั้นให้เราใส่ข้อมูล email เก่าและใหม่ลงไปตาม format ดังนี้

    ```text
    Correct Name <new@email.com> <old@email.com>
    ```

3. จากนั้นเข้าไปที่ repository ของเราและให้ run คำสั่ง `git filter-repo` เพื่อทำการแก้ author ให้ถูกต้อง

    ```shell
    $ git filter-repo --mailmap <path/to/your/mailmap>
    ```

4. ทีนี้เรา run คำสั่ง `git log` ขึ้นมาดูจะพบว่า author ของเราเปลี่ยนไปเป็นของใหม่แล้ว

    ```shell
    $ git log

    commit ...
    Author: Correct Name <new@email.com>
    Date:   ...

        existing-commit-1

    commit ...
    Author: Correct Name <new@email.com>
    Date:   ...

        existing-commit-2
    ```

5. ตัว `git-filter-repo` จะทำการลบ remote address เดิมทิ้งเนื่องจากให้เราคิดอีกรอบว่าจะใช้ address เดิมไหมเพราะเวลาเรา push เข้า repository เดิมมันจะต้อง **force** เพราะเป็นการแก้ไข history ทำให้มีโอกาสที่จะไปกระทบกับคนอื่นที่ใช้ repository ด้วย ดังนั้นถ้าเราคิดจะใช้จริง ๆ ก็ให้เพิ่ม remote address ลงไป

    ```shell
    $ git remote add origin <your-remote-address.git>
    ```

6. ทำการ push code ขึ้นถ้าเป็น repository เดิมก็ใส่ `--force` ลงไป

    ```shell
    git push -f origin <your-branch-name>
    ```

> ก็เป็นวิธีที่แก้ไขปัญหาหลังจากที่มันเกิดไปแล้ว แต่ทางที่ดีกว่าคืออย่าลืมตั้งค่า Git ให้เสร็จก่อนเริ่มทำการพัฒนานะครับ (เขียนไว้เตือนตัวเองด้วย ฮ่า ๆๆ)

## References
[How to Change the Author of All Commits in a Git Repository](https://www.codeconcisely.com/posts/change-author-data-for-all-existing-commits/)