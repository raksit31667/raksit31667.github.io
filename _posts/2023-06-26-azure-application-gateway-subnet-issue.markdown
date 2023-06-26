---
layout: post
title: "แก้ปัญหา Azure Application Gateway อยู่ ๆ ก็เกิด 502 Bad Gateway"
date: 2023-06-26
tags: [azure, azure-application-gateway, aks]
---

เมื่ออาทิตย์ก่อนในบริษัทลูกค้าเกิดปัญหาว่า API ที่ deploy ไว้บน [Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/intro-kubernetes) มันส่ง 502 Bad Gateway กลับมาตลอด ก็มีการหาวิธีแก้แล้วก็ติดต่อหา Microsoft Support จนแก้ได้สำเร็จ เลยขอจดบันทึกไว้ดูหน่อยหากเราต้องมาเป็นคน maintain เองขึ้่นมาวันใดวันหนึ่ง

## อธิบาย Architecture ปัจจุบัน
![AKS and AGIC](/assets/2023-06-26-aks-agic.png)

<https://learn.microsoft.com/en-us/azure/architecture/example-scenario/aks-agic/aks-agic>

Architecture แต่เดิมทีนั้นก็คือ client จะส่ง request เข้ามาผ่าน [Azure Application Gateway (AGW)](https://learn.microsoft.com/en-us/azure/application-gateway/overview) ที่ผูกกับ AKS ไว้ผ่าน [Application Gateway Ingress Controller (AGIC)](https://learn.microsoft.com/en-us/azure/application-gateway/ingress-controller-overview) ทั้งหมดจะถูกตีล้อม network ไว้ใน Azure Virtual Network (VNet) ที่มี subnet แยกไว้สำหรับ AKS และ AGW เลย

- AGW ก็คือ [Layer-7 Load Balancer]({% post_url 2020-02-17-tryit-haproxy %}) ซึ่งเหมาะสำหรับ AKS เนื่องจากเราไม่รู้ว่าแต่ละ Pod มันถูก assign ด้วย IP อะไรกันแน่ เพื่อให้ client ส่ง request เข้ามาหา AGW ผ่าน internet (internet-facing) เราก็ต้องแปะ public IP ที่ host ไว้ใน Azure ด้วย เพิ่มแต่งด้วยการเอา public DNS ไปแปะเพิ่มอีกทีก็ได้เหมือนกัน โดยเราต้องเพิ่ม [role](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview) เข้าไปคือ **Reader** สำหรับอ่านข้อมูลใน resource group
    
- AGIC นั้นก็จะตรวจดู AKS ผ่าน Kubernetes API ว่ามันมีการเปลี่ยนแปลง resource configuration ไหม ถ้ามีมันก็จะทำการ update AGW เช่น มีการเพิ่ม service เข้ามาใหม่ชื่อ `foobar` พร้อมกับ configuration ว่าถ้า request เข้ามาผ่าน AGW public IP ที่มี path ขึ้นต้นด้วย `/foobar` (เราเรียก configuration นั้นว่า Ingress) แล้วให้ re-route traffic ไปหา service ภายใน AKS ได้นั่นเอง

    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
    name: foobar
    labels:
        app: foobar
    spec:
    containers:
    - image: "your.container.registry.com/foobar:latest"
        name: foobar-image
        ports:
        - containerPort: 8080
        protocol: TCP

    ---

    apiVersion: v1
    kind: Service
    metadata:
    name: foobar
    spec:
    selector:
        app: foobar
    ports:
    - protocol: TCP
        port: 80
        targetPort: 8080

    ---

    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
    name: foobar
    annotations:
        kubernetes.io/ingress.class: azure/application-gateway
    spec:
    rules:
    - http:
        paths:
        - path: /foobar/*
            backend:
            service:
                name: foobar
                port: 80
            pathType: Prefix
    ```

- หนึ่งในความสามารถของ AKS คือเราสามารถ configure access เข้าไปหา resource ต่าง ๆ ใน Azure ได้ผ่าน [role-based access control (RBAC)](https://learn.microsoft.com/en-us/azure/aks/azure-ad-rbac?tabs=portal) โดยตอนที่ AKS ถูกสร้างมันจะสร้าง Managed Identity ขึ้นมาตัวนึงที่มันผูกกับ [RoleBinding และ ClusterRoleBinding](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) ของ AKS ไว้เรียบร้อยแล้ว ทีนี้เมื่อเราเพิ่ม role เข้าไปใน [Managed Identity](https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview) ตัวนั้นผ่าน Azure มันก็จะไปเห็นผลใน AKS ด้วยเช่นกัน โดยเราต้องเพิ่ม role เข้าไปดังนี้

    - **Managed Identity Operator** สำหรัับผูก Managed Identity ของ AKS เข้ากับ Managed Identity อีกตัวนึงที่เราสร้างเอง โดยความแตกต่างคือ Managed Identity ของ AKS จะเป็น *System-assigned* เหมาะสำหรับการไปผูกกับ resource ที่ถ้าถูกลบไปแล้วตัว AKS เองก็ควรจะถูกลบด้วย (coupled) ในขณะที่ Managed Identity อีกตัวนึงที่เราสร้างเองจะเป็น *User-assgined* เหมาะสำหรับการไปผูกกับ resource อื่น ๆ ที่สามารถแยกออกจากกันได้ (decoupled) ตัวอย่างก็จะอยู่ใน bullet ถัด ๆ ไป
    - **Network Contributor** ให้ AKS สามารถเข้าถึง subnet เพื่อ [Node pool](https://learn.microsoft.com/en-us/azure/aks/use-system-pools?tabs=azure-cli) ของ AKS จะได้ใช้ IP จาก subnet นั้นไป assign เข้า container ใช้ *System-assigned* Managed Identity เนื่องจากหากขาด subnet ไป ตัว AKS จะไม่สามารถทำ networking ได้เลย
    - **AcrPull** ให้ AKS ไป pull container image จาก Azure Container Registry (ACR) ผ่าน [kubelet](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet) ที่ทำหน้าที่เป็น processor ที่ใช้ควบคุมการทำงานของ Pod
    - **Contributor** เพื่อผูก AGW เข้ากับ AKS ใช้ *User-assigned* Managed Identity เพราะถ้าขาด AGW ไป ตัว AKS ก็ยังทำงานของมันได้แค่ client จาก internet ข้างนอกจะเชื่อมเข้ามาใน AKS ไม่ได้นั่นเอง
    - **Reader** สำหรับอ่านข้อมูลใน resource group ใช้ *User-assigned* Managed Identity เพราะถ้าขาดไปตัว AKS ก็ยังทำงานของมันได้แค่ต่อกับ Azure resource อื่น ๆ ข้างนอกไม่ได้

## อยู่ดี ๆ ก็งานเข้า
เกิดปัญหาว่า API ที่ deploy ไว้บน AKS มันส่ง 502 Bad Gateway กลับมาตลอดถึงแม้ว่าตัว application จะยัง healthy ก็ตาม ระบบเกิด downtime ขึ้น พอตัวเราเองลอง deploy AKS ของตัวเองใน subscription ตัวเองก็พบว่าเกิดอาการเดียวกันเลย ณ ตอนนั้นทีมลูกค้าเดาว่างี้มันน่าจะต้องเป็นปัญหาที่ AGIC พอเข้าไป restart และ clear event ของ AGIC ก็ไม่ได้แก้ปัญหา ก็เหลืออยู่แค่อย่างเดียวคือ AGW  

พอเข้าไปดู​ AGW monitoring ก็เห็นจำนวน failed request เยอะมาก ๆ เลยต้องไปดู Activity log ซึ่งเป็นสิ่งที่ช่วยชีวิตไว้ได้จริง ๆ เพราะเราได้เห็น error แล้วว่า AGW มันพังเพราะขาด permission ตามรูปเลย

![AGW permission error](/assets/2023-06-26-agw-permission-error.png)

แสดงว่าต้นเหตุคือ AGW มันขาด permission `Microsoft.Network/virtualNetworks/subnets/join/action` ในการเข้าไปจัดการ subnet ทีนี้เราเข้าไปอ่าน [documentation](https://learn.microsoft.com/en-us/azure/application-gateway/tutorial-ingress-controller-add-on-new#deploy-an-aks-cluster-with-the-add-on-enabled) ของ Microsoft ก็พบว่า

> If the virtual network Application Gateway is deployed into doesn't reside in the same resource group as the AKS nodes, please ensure the identity used by AGIC has the Microsoft.Network/virtualNetworks/subnets/join/action permission delegated to the subnet Application Gateway is deployed into. If a custom role is not defined with this permission, you may use the built-in Network Contributor role, which contains the Microsoft.Network/virtualNetworks/subnets/join/action permission.

ซึ่งก็เข้าเงื่อนไขของเราพอดีเนื่องจาก VNet ของ AGW ไม่ได้อยู่ใน resource group เดียวกันกับ Node ของ AKS

## วิธีแก้
ก็ตาม documentation ไปเลยคือเราก็ไปเพิ่ม role **Network Contributor** ขึ้นมาเพื่อเชื่อม subnet เข้ากับ AGW ผ่าน *User-assigned* Managed Identity **ของ AGW เอง** เนื่องจาก AGIC ใช้ identity ตัวนี้ในการ manage subnet นั่นเอง ตัวอย่าง code ข้างล่างคือระบบของเราใช้ Terraform เป็น Infrastructure-as-a-Code เลยมี code ตัวอย่างให้ดู

```hcl
resource "azurerm_role_assignment" "aks_agic_network_contributor" {
  scope                = azurerm_subnet.application_gateway_subnet.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
}
```

หลังจากเพิ่ม role assignment เข้าไปแล้วพบว่าตอนนี้ Activity log ไม่มี error แล้ว นอกจากนั้น API กลับมา response เป็น 2xx แล้วตามรูป

![AGW monitoring](/assets/2023-06-26-agw-monitoring.png)

หลังจากแก้ปัญหาไปผู้คนก็สงสัยกันว่าทำไมแต่ก่อนไม่เห็นต้องเพิ่ม role นี้เลยมันก็ใช้ได้นิ จนทีหลังมาพบว่า Microsoft เพิ่งทำการ update สด ๆ ร้อน ๆ เข้าไปอ่านใน [GitHub discussion ใน commit ของ documentation](https://github.com/MicrosoftDocs/azure-docs/commit/9f78373307d571b5b17f185176db18af1411c2ad) ได้

## ถอดบทเรียน
จากปัญหาที่เกิดขึ้น เราได้เรียนรู้สิ่งต่าง ๆ ต่อไปนี้
- ระบบ Kubernetes cluster ตามที่ได้กล่าวไว้ในส่วนของหัวข้อ Architecture
- ควรหมั่น monitor Activity log และ [Advisor](https://learn.microsoft.com/en-us/azure/advisor/advisor-overview) ใน Azure portal  หรือใช้ [Azure Service Health](https://learn.microsoft.com/en-gb/azure/service-health/overview) นอกจากจะเป็นเบาะแสที่ดีในการค้นหาต้นเหตุแล้ว ยังเอาไว้เรียนรู้ทำตาม best practice ของ Azure ได้อีกด้วย
- ควรหมั่นติดตามการ update ของ Microsoft ผ่านช่องทาง email notification และ toast ใน Azure portal (เพิ่งรู้ว่ากรณีนี้ทาง Microsoft เค้าส่ง email ไปหา subscription owner แล้วด้วย)