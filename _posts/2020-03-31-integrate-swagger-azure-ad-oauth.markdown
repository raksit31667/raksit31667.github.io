---
layout: post
title:  "ลองเชื่อม Swagger UI กับ Azure Active Directory OAuth"
date:   2020-03-31
tags: [swagger, azure, security, oauth, spring]
---
ช่วงที่ผ่านมาเขียน blog เกี่ยวกับ security เลยนึกขึ้นได้ว่าเรามี API documentation ผ่าน Swagger ด้วย ก็เลยจะมาลอง integrate กับ Azure AD OAuth ดูหน่อย

### ตัวอย่างนี้จะใช้ API ที่พัฒนาบน Java Spring
ที่มีระบบ authentication / authorization ด้วย OAuth2 ถ้า API ของเรายังไม่มี แนะนำให้ไปดูตามตัวอย่างใน [OWASP API Security Part 1]({% post_url 2020-03-18-owasp-api-security-part-1 %}) กันก่อน
<script src="https://gist.github.com/raksit31667/d1d266bf42651706b59a816d420ff6fd.js"></script>

### เริ่มจากลง Dependencies กันก่อน
มี 2 ตัวคือ OAuth2 ซึ่งเกี่ยวกับ security โดยตรง (น่าจะมีกันอยู่แล้ว) และ Springfox framework สำหรับ generate Swagger UI จาก Spring annotations
<script src="https://gist.github.com/raksit31667/c51b9a97ca486b712e239051e8e91f04.js"></script>

### จากนั้นให้เราสร้าง class ชื่อ SwaggerConfiguration ขึ้นมา
ซึ่งโดยปกติถ้า API เรามี Swagger อยู่แล้ว เราจะต้องมี configuration class ในการสร้าง Docket (เป็น interface หลักในการ configuration ของ Springfox)
<script src="https://gist.github.com/raksit31667/9799ccbcadef9239f3369f20bccadf6f.js"></script>

### เปิด Authorization ใน Swagger ด้วยการเพิ่ม SecurityScheme
<script src="https://gist.github.com/raksit31667/7b189ed9ac78e504962fc01c1396d15f.js"></script>

จากนั้นรัน application แล้วก็เข้า Swagger ที่ `http://localhost:8080/swagger-ui.html` click **Authorize** จะได้หน้าตาประมาณนี้
![Swagger UI 1](/assets/2020-03-31-swagger-ui-1.png)

### Configure Azure AD เพื่อทำ redirect URLs
ในการ integrate กับ Azure AD เราต้องไป configure ใน **App Registration --> Authentication** ตามนี้
![Azure AD Authentication Web Settings](/assets/2020-03-31-azure-ad-authentication-web-settings.png)
**คำอธิบาย**
- เพิ่ม url ของ Springfox สำหรับการ redirect ใน browser หลังจากทำ authentication สำเร็จ (**https://your-service-host-name.com/webjars/springfox-swagger-ui/oauth2-redirect.html**)
- ติ๊กตรง **ID tokens** ใน **Implicit grant** เพราะว่า Azure จะให้ token ของ User identity ที่ click **Authorize** จาก Swagger UI ไม่เกี่ยวกับ Access tokens ที่ client ใช้ในการ access Resource Server ของเรา 
- ดังนั้นเราต้องไป grant user คนนั้นให้มี permission ในการ access ด้วย โดยไปที่ **Enterprise applications --> your-application-name --> Users and groups** (ทำตาม [documentation](https://docs.microsoft.com/en-us/azure/active-directory/manage-apps/assign-user-or-group-access-portal) นี้เลยครับ)
- อย่าลืม configure `oauth2AllowImplicitFlow` ใน **App Registration -> Manifest** ให้เป็น `true` ด้วยนะครับ (ดูตาม [documentation](https://docs.microsoft.com/en-us/azure/active-directory/develop/reference-app-manifest#oauth2allowimplicitflow-attribute) นี้เลย)

### Configure Azure AD information ใน API ของเรา
เราต้องการ 2 อย่างคือ resource id (ดูได้จาก application ของ API) และ tenant id
<script src="https://gist.github.com/raksit31667/762fa54605a0892cad57d449e2a748b1.js"></script>

### กลับมา Configure SecurityScheme กันต่อ
เพิ่ม implicit grant type และ scope สำหรับการทำ authorization
<script src="https://gist.github.com/raksit31667/6a9965811ee5cec066d1b3457efa9158.js"></script>

พอกลับไปที่ Swagger UI จะได้หน้าตาประมาณนี้
![Swagger UI 2](/assets/2020-03-31-swagger-ui-2.png)

### ต่อด้วยการ Configure SecurityContext
เพื่อบอก Swagger ให้ใช้ authorization จาก scope resource id ของเราในทุกๆ endpoint ของ API เรา
<script src="https://gist.github.com/raksit31667/fcf113aee17a8c201b9cb317e30f9823.js"></script>

### ปิดท้ายด้วยการ Default ค่า resource id ใน Swagger UI
จะได้ไม่ต้องมาพิมพ์ clientId เอง เลยทำการสร้าง Bean ของ SecurityConfiguration ใน Swagger จากนัั้นก็ใส่ค่า clientId ให้เป็น resourceId
<script src="https://gist.github.com/raksit31667/f8442c8fb470f2fc5d94f3aede7b2725.js"></script>

จะได้หน้าตาประมาณนี้
![Swagger UI 3](/assets/2020-03-31-swagger-ui-3.png)

พอกด Authorize ตัว Azure AD ก็จะ authorize และ redirect มาที่ Swagger UI ทีนี้เราก็สามารถ access resource ได้ด้วย id token
 ![Swagger UI 4](/assets/2020-03-31-swagger-ui-4.png)

 > ไปดูตัวอย่างโค้ด [https://github.com/raksit31667/example-spring-order](https://github.com/raksit31667/example-spring-order)






