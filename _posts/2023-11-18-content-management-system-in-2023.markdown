---
layout: post
title: "แนวทางการเลือก technology สำหรับ Content Management System ในปี 2023"
date: 2023-11-17
tags: [content-management-system, platform]
---

เมื่อช่วงที่ผ่านมาได้มีโอกาสไปทำ project ที่เกี่ยวกับสังคมปัจจุบันในไทยมา หนึ่งในงานคือการเปลี่ยนโฉม website จากของเก่าเป็นของใหม่ ซึ่งพอเข้าไปดู technology เบื้องหลังแล้วพบว่ามันคือ [Content Management System (CMS)](https://en.wikipedia.org/wiki/Content_management_system) โดยที่เราไม่เคยมีประสบการณ์ใช้งานหรือพัฒนาตรงมาก่อนหน้านี้ (รู้จักแค่ว่า CMS == WordPress ฮ่า ๆๆ) จึงเป็นโอกาสที่ดีที่เราได้ค้นคว้าและเรียนรู้เกี่ยวกับ CMS และเป็นโอกาสที่ดีกว่าที่ได้มาเขียน blog นี้ไว้แบ่งปันให้เพื่อน ๆ ที่เข้ามาอ่านกัน

## CMS คืออะไร
CMS คือระบบที่ถูกออกแบบมาเพื่อช่วยในการสร้างและจัดการเนื้อหา (content) เช่น blog, post, forum บน website โดยเฉพาะ โดยมากจะมีส่วนประกอบด้วยกัน 5 ส่วน

1. **Editor Interface**: ให้คนสร้าง content บน website ด้วยตนเอง โดยมักจะมีการจัดรูปแบบของ content มาให้สำหรับเริ่มต้นได้ง่ายอยู่แล้วอย่างเช่น หัวข้อ เนื้อหา tag เป็นต้น
2. **Database**: เก็บข้อมูลเนื้อหาทั้งหมดเพื่อการจัดการและเรียกใช้ข้อมูลต่าง ๆ ใน website
3. **Themes/Templates**: สำหรับการตกแต่ง user interface ของ website
4. **User Management**: จัดการสิทธิ์และการเข้าถึงข้อมูลต่าง ๆ ของ user
5. **Plugins/Extensions**: ส่วนเสริมที่เพิ่มความสามารถของ CMS ในด้านต่าง ๆ เช่น security, migration, third-party เป็นต้น มีทั้งแบบฟรีและเสียตังค์

![Elementor](/assets/2023-11-18-elementor.avif)
<https://elementor.com/features/page-builder/>

### ข้อดี-ข้อเสียของการใช้ CMS
- **ไม่ต้องมีความรู้ technical ในการทำ website มาก**: ลดการปวดหัวไม่ต้องเขียน code ลงทุกรายละเอียดเองเหมือนกับทำ website เอง เช่น HTML, CSS, JavaScript
- **แก้ไขเนื้อหาที่ง่าย**: เป็นธรรมชาติของ CMS ที่จะออกแบบให้เรา focus ที่การดูแล content
- **การ scale ทำได้จำกัด**: การปรับเปลี่ยนหรือเพิ่มเติม feature ในภายหลังก็ทำได้ในระดับนึง (ถ้ารองรับด้วย plugins/extensions ของ CMS นั้น ๆ) แต่ถ้า feature มันซับซ้อนมาก ๆ ก็ต้องการการเขียน code อยู่ดี
- **ยังต้องการความรู้ technical สำหรับการ maintain**: หากเราอยากให้ website เป็น production-grade ก็ต้องคำนึงเรื่อง security, deployment, version control, database อยู่ดี

มีหลาย CMS platform ที่น่าสนใจและได้รับความนิยม เช่น [WordPress](https://wordpress.com/), [Joomla](https://www.joomla.org/), [Drupal](https://www.drupal.org/), [Magento](https://business.adobe.com/products/magento/magento-commerce.html), [Wix](https://www.wix.com/) เป็นต้น บางตัวออกมาแบบสำหรับ use case เฉพาะ เช่น ทำระบบ e-commerce ก็จะเพิ่มส่วนที่เชื่อมกับการจ่ายเงิน, ดูแล order, track-and-trace เป็นต้น

![Choosing CMS](/assets/2023-11-18-choosing-cms.png)
<https://www.thoughtworks.com/insights/blog/how-perfect-your-cms-implementation>

## Technology สำหรับ CMS
อย่างที่บอกไปในหัวข้อที่แล้วว่าการพัฒนา CMS เป็น production-grade ก็ต้องการความรู้ technical สำหรับ maintain ด้วย technology ต่าง ๆ ที่ขึ้นอยู่กับยี่ห้อ CMS ที่ใช้ แต่ส่วนใหญ่แล้วจะหนีไม่พ้นกลุ่มพวกนี้

- **Programming language**: PHP, Python โดยที่อันแรกมักจะเป็นหนึ่งในภาษาที่ระบบโดนโจมตีด้าน security บ่อยที่สุด
- **Database**: MySQL, PostgreSQL, SQLite
- **Frontend development**: HTML, CSS, JavaScript
- **Server**: Apache, NGINX โดยที่อันแรกมักจะเป็นหนึ่งในภาษาที่ระบบโดนโจมตีด้าน security บ่อยที่สุด
- **Web Framework**: Laravel, Django
- **Version Control**: Git
- **Security**: SSL/TLS

สืบเนื่องจากปัญหาที่ว่า themes/template และ user interface ของ CMS นั้นจะผูกติดกับระบบหลังบ้านของ CMS ลึกไปจนถึง database ด้วย ทำให้ไม่สามารถรับการ scale ของ feature ได้ทัน เลยทำให้เกิดแนวคิดของ [Headless CMS](https://en.wikipedia.org/wiki/Headless_content_management_system) ขึ้นเพื่อลดการยึดติดด้าน user interface ของ CMS ในขณะที่ยังคงความสะดวกสบายในการแก้ไข content ซึ่งเป็นจุดเด่นของ CMS อยู่

![Headless CMS](/assets/2023-11-18-headless-cms.png)
<https://strapi.io/what-is-headless-cms>

- **Decoupled Structure**: แยกการจัดการเนื้อหา และ user interface ออกจากกัน ส่งผลให้ frontend และ backend สามารถทำงานและ scale แยกกันอย่างอิสระ เพียงแค่ frontend ใช้ API จาก backend เพื่อดึงข้อมูลโดยที่ API schema และ definition จะถูกจัดการด้วยตัว CMS บางส่วน
- **Flexible and Scalable**: สามารถ scale ไปใช้งานสำหรับ ๆ หลาย frontend และหลาย platform พร้อม ๆ กัน

มีหลาย Headless CMS platform ที่น่าสนใจและมีคนใช้งานเพิ่มมากขึ้นเรื่อย ๆ เช่น [Contentful](https://www.contentful.com/), [Strapi](https://strapi.io/) เป็นต้น  

เพื่อให้เข้าใจได้ง่าย ๆ ก็เลยสรุปความแตกต่างระหว่าง Headless CMS และ Traditional CMS ออกมาไว้เป็นตารางเปรียบเทียบดังนี้

| CMS                   | Traditional CMS                                          | Headless CMS                                      |
|-----------------------|----------------------------------------------------------|---------------------------------------------------|
| การพัฒนาและการปรับเปลี่ยน | การพัฒนาและการปรับเปลี่ยนทั้ง frontend และ backend ต้องทำพร้อมกัน | สามารถพัฒนา frontend และ backend โดยอิสระจากระบบหลัก |
| Flexibility           | ต่ำกว่า เพราะผูกติดกับยี่ห้อ CMS และ plugins/extensions          | มากกว่า                                            |
| Scalability           | ต้อง scale ทั้งระบบ ค่าใช้จ่ายสูง                               | สามารถ scale ได้แยกกันระหว่าง frontend และ backend   |
| Template              | มี template engine และ theme                              | ไม่มี ต้องลงมือเขียน code เอง                          |
| ค่าใช้จ่ายในการดูแลรักษา   | ต่ำกว่า เนื่องจากดูแลแค่ CMS ที่เป็น monolith และ database        | สูงกว่ามาก เนื่องจากต้องดูแลทั้ง frontend และ backend     |

> น่าจะเห็นภาพกันแล้วว่า CMS นั้นเป็น technology ที่ยังมีการใช้งานอยู่เพื่อลดแรงและค่าใช้จ่ายในการสร้าง content และดูแลรักษาในบางส่วน (ขึ้นอยู่กับยี่ห้อ CMS) แต่ก็แลกมากับข้อจำกัดในการ scale ของ feature ดังนั้นก่อนนำ CMS ไปใช้ควรศึกษาหาความรู้ว่า use case ของเรานั้นมันรองรับด้วย CMS มากขนาดไหน