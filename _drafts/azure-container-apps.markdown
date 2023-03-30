---
layout: post
title: "สวัสดี Azure Container Apps"
date: 2023-03-30
tags: [azure, container, azure-container-apps]
---

ช่วงนี้ใน project จะเริ่มทำการพัฒนา CI/CD pipeline สำหรับ developer ทั้งองค์กรเพื่อ deploy application ขึ้น cloud อย่าง [Microsoft Azure](https://azure.microsoft.com/en-us) หนึ่งในจุดหมายของการ deploy คือ [Azure Container Apps (ACA)](https://learn.microsoft.com/en-us/azure/container-apps/overview) เลยมาจดบันทึกแบบสรุปไว้สำหรับการแบ่งปันประสบการณ์ต่อไป

## Azure Container Apps คืออะไร
ในการพัฒนา software ปัจจุบัน การ deploy application ส่วนใหญ่ก็มักจะอยู่ในลักษณะของ container เพื่อลดค่าใช้จ่ายและความซับซ้อนในการติดตั้ง dependencies ให้พร้อมสำหรับการ deploy เช่น ติดตั้ง operating system เนื่องจาก container จะมีเพียงแค่ dependencies ที่จำเป็นต่อการ run application เท่านั้น  

ทีนี้บน cloud provider ก็จะมี service เพื่อรองรับการ deploy container ขึ้นแตกต่างกันไป ในส่วนของ Azure นั้นก็จะมีหลายอันเลย หนึ่งในนั้นคือ **ACA** นั่นเอง 

ACA จะอยู่ตรงกลาง ๆ ในด้านของความซับซ้อนที่ต่ำลงมาเพราะ Microsoft จัดการเรื่องความซับซ้อนในการดูแล Kubernetes cluster แต่แลกมากับ feature ที่จำกัดตาม technology ที่มาทดแทน Kubernetes ซึ่งได้แก่

- [Dapr](https://dapr.io/) เป็น API ที่ติดตั้งในรูปแบบของ sidecar pattern ที่ช่วยลดความซับซ้อนในการพัฒนา feature ต่าง ๆ ตามแนวคิดของ distributed architecture เช่น state management, configuration and secret management, publish & subscribe (pub/sub), event notification (bindings), service-to-service communication

![Dapr components](/assets/2023-03-30-azure-container-apps-dapr-components.jpeg)

<https://azure.github.io/aca-dotnet-workshop/aca/00-workshop-intro/3-dapr-integration/>

- [KEDA](https://keda.sh/) เป็น platform ที่ช่วย scale application ตามจำนวนของ event ที่เกิดขึ้นตามแนวคิดของ event-driven architecture
- [Envoy](https://www.envoyproxy.io/) เป็น HTTP proxy ช่วยทำเรื่อง ingress, DNS, traffic routing และ TLS termination

เมื่อเทียบกับ service คล้าย ๆ กัน (จะขอตัดพวก third party อย่าง [Azure Red Hat Openshift](https://azure.microsoft.com/en-us/products/openshift) หรือ [Azure Spring Apps](https://azure.microsoft.com/en-au/products/spring-apps/) ออกไปเพื่อให้เห็นภาพมากขึ้น) ก็จะมีข้อดี-ข้อเสียต่างกันไปตามนี้

![Azure computing choices](/assets/2023-03-30-azure-computing-choices.png)

<https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/compute-decision-tree>

| สิ่งที่ต้องพิจารณา / Service         | Azure Kubernetes Service (AKS)                            | Azure Container Apps (ACA)                                          | Azure Container Instances (ACI)                             | Azure App Service                                                                              |
|--------------------------------|-----------------------------------------------------------|---------------------------------------------------------------------|-------------------------------------------------------------|------------------------------------------------------------------------------------------------|
| ความซับซ้อน                      | สูง ต้องอาศัยความรู้ในการดูแล Kubernetes cluster                | ปานกลาง ไม่ต้องมีความรู้เรื่อง Kubernetes แต่อาจจะต้องมีความรู้ใน tech ที่มาทดแทน | ต่ำ ไม่ต้องมีความรู้เรื่อง Kubernetes และ technology ที่เกี่ยวข้อง       | ปานกลาง ไม่ต้องมีความรู้เรื่อง Kubernetes แต่อาจจะต้องมีความรู้ใน Azure service ที่เกี่ยวข้องกับ web application |
| การ scale                      | สูง (ขึ้นอยู่กับ resource limit ที่กำหนดไว้)                       | ปานกลาง (ขึ้นอยู่กับ resource limit ที่กำหนดไว้)                            | ต่ำ ถ้าอยากจะ scale มา n instances จะต้องสร้าง ACI ใหม่เอง n ครั้ง | ปานกลาง (ขึ้นอยู่กับ resource limit ที่กำหนดไว้)                                                       |
| ความอิสระในการเพิ่ม feature ต่าง ๆ | สูง สามารถใช้ Kubernetes custom resource หรือ operator ได้หมด | ปานกลาง จำกัดอยู่แค่ tech ที่มาทดแทน Kubernetes                           | ต่ำ load balancing กับ certificates ก็ไม่มีให้                    | ปานกลาง จำกัดอยู่แค่ web, API เพราะมันถูกสร้างมาให้ใช้แค่นั้น                                              |
| ค่าใช้จ่าย                        | ปานกลาง-สูง (หากต้องการใช้ในระดับ production grade)           | ต่ำ-ปานกลาง (ขึ้นอยู่กับ resource limit ที่กำหนดไว้)                         | ต่ำมาก-ต่ำ (ขึ้นอยู่กับ resource limit ที่กำหนดไว้)                   | ต่ำ-ปานกลาง (ขึ้นอยู่กับ resource limit ที่กำหนดไว้)                                                    |

ในส่วนของการออกแบบ CI/CD pipeline ก็จะต้องออกแบบให้รองรับ use case ที่ขึ้นอยู่กับแต่ละ service โดยที่คนนำ CI/CD pipeline ไปใช้จะต้องไม่ปวดหัวกับความซับซ้อนใน technology ที่กล่าวมาข้างต้น

## ขั้นตอนการ deploy ล่ะทำยังไง
ในส่วนของการ deploy container ขึ้น ACA นอกจากตัว app ก็จะมีส่วนประกอบสำคัญดังนี้

- **Environments**: เป็นสิ่งที่รวมกลุ่มของ ACA app ที่เกี่ยวข้องกันไว้ด้วยกัน ใช้สำหรับทำ service-to-service communication ภายใน environment กันเองได้หากมี [Azure Virtual Network (VNet)](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview) นอกจากนั้นยังเอาไว้เก็บ log เพื่อส่งต่อให้ [Azure Log Analytics Workspace](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview)
- **Log Analytics Workspace**: ทำการเก็บ log ที่ส่งมาจาก ACA environment ใช้ Kusto Query Language (KQL) ในการค้นหา log
- **Dapr components**: สำหรับระบุ configuration เพื่อใช้งาน feature ต่าง ๆ ใน Dapr

เราสามารถเลือกการ deploy ได้ 2 รุปแบบ (revision) ได้แก่

- **Single**: เมื่อมีการ deploy version ใหม่ขึ้นมา ก็จะเก็บไว้ทั้ง version เก่าและใหม่ จากนั้น ACA จะทำการ deactivate version เก่าทิ้งให้โดยอัตโนมัติ ถ้าอยากได้ zero-downtime deployment จะต้องมี ingress เพื่อให้ traffic เข้า version เก่าจนกว่า version ใหม่จะ deploy เสร็จ
- **Multiple**: เมื่อมีการ deploy version ใหม่ขึ้นมา ก็จะเก็บไว้ทั้ง version เก่าและใหม่ แต่จะไม่ deactivate version เก่าทิ้งจนกว่าเราจะตั้งค่า version ใหม่ว่าเป็น `latestRevision` เอง จุดประสงค์เพื่อเอาไว้ทำ [blue-green deployment](https://en.wikipedia.org/wiki/Blue-green_deployment) หรือ [A/B testing](https://en.wikipedia.org/wiki/A/B_testing)

![ACA lifecycle update](/assets/2023-03-30-azure-container-apps-lifecycle-update.png)

![ACA lifecycle deactivate](/assets/2023-03-30-azure-container-apps-lifecycle-deactivate.png)

<https://learn.microsoft.com/en-us/azure/container-apps/application-lifecycle-management>

วิธีการ deploy เลือกได้หลายแบบ เช่น [Azure portal](https://azure.microsoft.com/en-us/get-started/azure-portal), command line, Infrastrutuce-as-a-Code (IaC) ถ้าพูดถึงในส่วนของการออกแบบ CI/CD pipeline ก็จะเลือกเป็น IaC เพื่อเก็บ version control ผ่าน Git และลดงาน manual (ClickOps) ลงไป ทีนี้ IaC ของ Azure ก็มีหลากหลายตัวให้เลือก โดย 2 ตัวหลัก ๆ ที่เลือกนำมาพิจารณาคือ [Azure Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview#:~:text=Bicep%20is%20a%20domain%2Dspecific,to%20repeatedly%20deploy%20your%20infrastructure.) และ [Terraform](https://www.terraform.io/) นอกจาก[ความแตกต่างที่ได้อธิบายไว้ใน documentation นี้แล้ว](https://learn.microsoft.com/en-us/azure/developer/terraform/comparing-terraform-and-bicep?tabs=comparing-bicep-terraform-integration-features) ยังมีสิ่งที่ต้องพิจารณาเพิ่ม เช่น ความซับซ้อนในการสร้าง ACA เนื่องจากใน Terraform ขณะที่เขียนบทความนี้ ตัว [Azure resource management (ARM) provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) ยังไม่รองรับ ACA เต็มรูปแบบ เช่น [Dapr binding configuration](https://docs.dapr.io/operations/components/setup-bindings/) เป็นต้น จีงต้องหันไปใช้ [Azure API (AZAPI) provider](https://registry.terraform.io/providers/azure/azapi/latest/docs) เพียงแค่ส่วนนั้นแทน (จริง ๆ แล้วเราสามารถใช้ AZAPI provider แทน ARM provider ได้หมดทุก resource เลยนะ แต่มันจะซับซ้อนดูแลยากกว่า)

## Dependencies ของ ACA
ในการใช้งาน ACA ในระดับ production grade นั้น มีเพียงแค่ app คงไม่เพียงพอ เนื่องจาก Dapr มี feature มากมายที่มี integration กับ Azure service อื่น ๆ เช่น

- [Azure Storage account](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-overview) สำหรับทำ state management
- [Azure KeyVault](https://learn.microsoft.com/en-us/azure/key-vault/general/basic-concepts#:~:text=Azure%20Key%20Vault%20is%20a,security%20module(HSM)%20pools.) สำหรับทำ secret management
- [Azure Virtual Network (VNet)](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-**overview**) สำหรับทำ networking
- [Azure AppInsight](https://learn.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview) และ [Azure Monitor](https://learn.microsoft.com/en-us/azure/azure-monitor/overview) สำหรับทำ telemetry และ monitoring

จากนั้นพิจารณา use case ต่าง ๆ เหล่านี้เพื่อต่อยอดการพัฒนาปรับปรุงชิ้นงานให้ดีขึ้น ๆ ไป
