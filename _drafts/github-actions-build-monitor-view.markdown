---
layout: post
title: "แนะนำเครื่องมือที่ใช้สร้าง dashboard view สำหรับ GitHub Actions"
date: 2024-05-12
tags: [github-actions, cicd, tools]
---

อาทิตย์ที่ผ่านมาไปสอนเรื่องเกี่ยวกับ software engineering โดยกิจกรรมจะมีทั้ง lecture และ workshop โดยอย่างหลังจะให้ project ผู้เรียนใช้งาน [GitHub Actions](https://github.com/features/actions) สำหรับการ run test, build และ deploy ขึ้น environment โดยอัตโนมัติ ปัญหาคือ GitHub Actions ตัวมันเองไม่มี dashboard ที่แสดงผลว่า status มันไปถึงไหนแล้วแบบสวยงามอย่าง [Jenkins](https://www.jenkins.io/)

![Jenkins Build Monitor View](/assets/2024-05-12-jenkins-build-monitor-view.png)

เผอิญไปเจอเครื่องมือมา 2 อันที่ได้ลองใช้ไปนิดหน่อย

## Gitboard.io
[Gitboard.io](https://gitboard.io/) เป็นเครื่องมือที่เอาไว้ดู status ที่รองรับทั้ง GitHub Actions และ [Bitbucket CI](https://bitbucket.org/product/features/pipelines) ใช้งานง่ายและ update status แบบ near real-time

![Gitboard.io](/assets/2024-05-12-gitboard-io.webp)
<https://medium.hexlabs.io/monitor-your-ci-builds-in-real-time-8f07248ceb86>

ข้อจำกัดคือตอนที่ reload dashboard ขึ้นมาเราจะไม่เห็นรายละเอียดทันที เราต้องกด expand ออกมาทุกครั้ง และใน free version ไม่สามารถ share board ให้คนอื่นได้

## Octolense
[Octolense](https://octolense.com/) เป็นเครื่องมือที่จุดประสงค์หลักคือทำมาเพื่อ track การใช้งานและค่าใช้จ่ายของ GitHub Actions โดยเฉพาะ (เผื่อใครไม่รู้ว่า GitHub Actions มันมี free quota ต่อเดือนอยู่) แต่เราสามารถใช้ในการดู run ล่าสุดของแต่ละ repository ได้ซึ่งนั่นก็คือสิ่งที่เราต้องการแหละ  

![Octolense](/assets/2024-05-12-octolense.webp)

ปล. ต้องเสียตังค์ถ้าจะใช้กับ organization โชคดีที่ตอนนี้ Octolense อยู่ในช่วง **public beta** ก็เลยยังใช้งานฟรี ดังนั้นใครจะต้องใช้แล้วรีบใช้ก่อนที่จะหมดเขตครับ

> เครื่องมือทั้ง 2 อันที่เอามาให้ลองในบทความนี้เป็น [GitHub Apps](https://docs.github.com/en/apps/creating-github-apps/about-creating-github-apps/about-creating-github-apps) ทั้งหมดครับ ดังนั้นการติดตั้งก็สามารถทผ่าน GitHub ได้เลย 
