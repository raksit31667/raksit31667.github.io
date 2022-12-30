---
layout: post
title:  "สรุปสิ่งที่น่าสนใจจาก session Accessibility APIs in Android"
date:   2022-12-21
tags: [accessibility, android]
---

- More padding
- Don't use only colors as means of communication
- Label images
- Provide users a way to add the content description for user-generated contents
- Skip unnecessary elements for screen reader to navigate faster
- Let accessibility services knows an action can be performed
- Android accessibility services: TalkBack, BrailleBack, VoiceAccess
- Merge views to make screen reader navigate with fewer taps (recommend to use for Lists)
- Tell the screen reader about state changed by interaction (e.g. turn up volume 80%, play-pause)
- Don't use constant timeouts, use recommended timeout from Accessibility manager
- Don't reinvent the wheel (e.g. make custom UI element)
- Don't abuse accessibility announcements (e.g. override notify when user receives a new email but got them constantly)
- Use accessibility scanner to check for best practices
- Accessibility is an user experience so you have to test it manually by yourself to know it's a good experience
