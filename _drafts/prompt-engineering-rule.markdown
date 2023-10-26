---
layout: post
title: "บันทึกกฎในการเขียน prompt ที่ดีและง่ายและน่าทำตาม"
date: 2023-10-26
tags: [generative-ai, prompt-engineering, technique]
---

ที่บริษัทมีการแบ่งปันความรู้เกี่ยวกับ [ChatGPT](https://chat.openai.com/) ซึ่งกำลังเป็นกระแสอยู่ในหลายวงการรวมถึงการพัฒนา software ด้วยเนื่องจากมันเข้ามาช่วยทุ่นแรงในงานส่วนต่าง ๆ ได้ อาทิเช่น

- [ช่วยเขียน code แนะนำวิธีแก้ปัญหา]({% post_url 2023-10-22-github-copilot-tips-and-tricks %})
- ช่วย prioritize feature
- ช่วยระบุ dependencies และ risk ที่อาจจะเกิดขึ้นได้
- ช่วยเขียนเอกสาร
- ช่วย brainstorm idea ในการทำ product

แต่ว่าไม่ใช่ทุกครั้งที่เราจะใส่ prompt เข้าไปแล้วได้ผลลัพธ์ตามที่เราต้องการเพราะว่ายิ่งเราให้ input (prompt) เจาะจงได้มากเท่าไร ChatGPT ก็จะทำงานได้ดีมากขึ้นเท่านั้น  

ใน community ก็มีการ share technique มากมาย อันที่ดัง ๆ เลยก็คืออับดุลของ 9arm ซึ่งต่อมา ChatGPT ก็ได้ออก patch มาแก้ไขไปแล้ว ฮ่า ๆๆ

<iframe width="560" height="315" src="https://www.youtube.com/embed/R6IbwLAwAWU?si=gltg9AMCary1zL8f" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

บทความนี้ก็เลยจะมาบอกว่ามันมีอีก technique นึงที่น่าสนใจคือ **P.I.A.D.O** ของคุณ [Zichuan Xiong](https://www.thoughtworks.com/en-th/profiles/z/zichuan-xiong) ซึ่งเป็นวิธีการเขียน prompt โดยมีโครงสร้างเป็นดังนี้

- **Purpose**: ระบุจุดประสงค์และ context ของสิ่งที่เราอยากให้ ChatGPT ทำ
- **Input**: ใส่ input ที่มี format แบบเดียวกัน
- **Action**: กำหนดสิ่งที่เราอยากให้ ChatGPT ทำแบบชัดเจน
- **Details**: เพิ่ม details ของสิ่งที่เราอยากให้ ChatGPT ทำ
- **Output**: กำหนด output รวมถึง format ของผลลัพธ์

## ตัวอย่าง prompt ที่ใช้ P.I.A.D.O

1. เริ่มจาก **Propose** ก่อน
    > I am applying DDD for an eCommerce platform design, I am trying to understand how I can select a particular BoundedContext breakdown from Aggregates, here is what I have:

2. ตามด้วย **Input** ที่มี format เป็นการจัดกลุ่ม

    > BoundedContext 1: SalesManagement Aggregates: Product, Customer, Order
    > BoundedContext 2: FulfillmentManagement Aggregates: Inventory, Payment

3. กำหนด **Action**
    > Now I want you to describe me detailed rationale you use to choose this option.]

4. ใส่ **Details** เข้าไปเพิ่มเติมว่าอยากให้อธิบายยังไง
    > I want you to describe it from four aspects:
    > Shared functionality
    > Cross-cutting concerns
    > Aggregation of data
    > Team organization

5. ปิดท้ายด้วย **Output** ในรูปแบบที่เราต้องการ
    > The output format is
    > Aspect 1
    > Key Assumption: We choose this option if this happens in term of aspect 1

สุดท้ายแล้วลงเอยด้วยผลลัพธ์แบบพอใช้ได้เลย

> Aspect 1: Shared Functionality
> Key Assumption: We choose this option if there is significant shared functionality or code that is common between the SalesManagement and FulfillmentManagement BoundedContexts.

> If you notice that the SalesManagement and FulfillmentManagement BoundedContexts have a substantial amount of shared functionality, such as common business logic, services, or processes, it might make sense to create a single, unified BoundedContext. This could streamline development and maintenance, reduce redundancy, and promote code reusability.

> Aspect 2: Cross-cutting Concerns
> Key Assumption: We choose this option if there are critical cross-cutting concerns that span both SalesManagement and FulfillmentManagement BoundedContexts.

> If there are important cross-cutting concerns like security, authentication, or auditing that affect both BoundedContexts, it might be more efficient to have a unified BoundedContext. This can help ensure a consistent and coherent approach to these concerns across the entire system, simplifying compliance and maintenance.

> Aspect 3: Aggregation of Data
> Key Assumption: We choose this option if there is a strong need for shared data access and consistency across the SalesManagement and FulfillmentManagement BoundedContexts.

> If the SalesManagement and FulfillmentManagement BoundedContexts require access to the same data or need strong data consistency, it may be beneficial to merge them into a single BoundedContext. This can simplify data management, transactions, and queries, reducing the need for complex data synchronization mechanisms between BoundedContexts.

> Aspect 4: Team Organization
> Key Assumption: We choose this option if the organization's teams are structured in a way that supports cross-functional teams working on a single BoundedContext or if there is a need for specialized teams for Sales and Fulfillment.

> Consider the team structure and expertise within your organization. If you have cross-functional teams that can efficiently manage a combined Sales and Fulfillment BoundedContext, it may make sense to go with a single BoundedContext. Conversely, if specialized teams are required for each aspect, maintaining separate BoundedContexts might be more appropriate.

> Ultimately, the choice between a unified or separate BoundedContexts should align with your specific business requirements, development capabilities, and team organization. It's essential to carefully evaluate these four aspects to make an informed decision that best suits your eCommerce platform design.

ลองนำไปปรับใช้กันดูครับ ก็น่าจะช่วยให้การทำ [prompt engineering](https://en.wikipedia.org/wiki/Prompt_engineering) มีประสิทธิภาพมากขึ้นแลกกับว่าต้องออกแรงเพิ่มในการเขียน prompt ที่เจาะจงขึ้นมา
