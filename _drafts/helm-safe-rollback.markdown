---
layout: post
title: "Rollback Kubernetes resources อย่างปลอดภัยบน Helm อย่างไร"
date: 2023-06-29
tags: [kubernetes, helm, azure-devops]
---

เมื่อเดือนก่อนเกิดปัญหาตอน deploy application ขึ้น Kubernetes ผ่าน [Helm](https://helm.sh/) เมื่อ deploy ไม่สำเร็จแล้วไม่ได้ผลตามที่คาด จึงต้องแก้ปัญหากันไป เลยจดบันทึกไว้ว่าทำยังไง

## ปัญหาที่เกิดขึ้น
เนื่องจากเราใช้ Helm ซึ่งเป็น package manager สำหรับ Kubernetes จาก chart ของ application ที่เตรียมไว้แล้ว คำสั่งที่ใช้ก็จะมีหน้าตาประมาณนี้

```shell
helm upgrade --install --wait --debug --atomic \
  --namespace "$KUBERNETES_NAMESPACE" \
  --values "/path/to/helm/values.yaml" \
  "$HELM_RELEASE_NAME" \
  "path/to/helm/chart/directory"
```

- `upgrade --install` คือถ้าใน Kubernetes namespace ที่เอาไป deploy ไม่เคยมี release นี้มาก่อนก็จะทำการติดตั้งให้ใหม่ แต่ถ้ามีอยู่แล้วก็จะทำการ upgrade
- `--wait` ตัว process ที่ run คำสั่ง Helm จะรอให้ release นั้นจบไม่ว่าจะสำเร็จหรือไม่ก็ตาม แล้วค่อย exit ไป
- `--atomic` ถ้าการ release ไม่สำเร็จก็จะทำการ rollback ย้อนกลับไปหา release ล่าสุดที่สำเร็จ

เรา run คำสั่งนี้บน CI/CD pipeline agent ปัญหาก็คือเราไม่สามารถควบคุม agent ได้ 100% ทำให้บางครั้งมันก็หยุดทำงานหรือมีคนไปกด cancel pipeline ระหว่าง deploy พอดี ทำให้เกิดการหยุดกลางคัน ส่งผลให้การ release ค้างอยู่ในสถานะพวก `pending-install` หรือ `pending-upgrade` (กำลัง release อยู่นะ) เมื่อมีการ release ครั้งถัดไปก็จะเกิด error เพราะ Helm นึกว่าการ release ยังไม่จบนั่นเอง

## วิธีแก้
วิธีที่เราใช้คือทำยังไงให้ process ที่ run คำสั่ง Helm ยังคงทำงานต่อก่อนที่ agent จะหยุด run ซึ่งเราไปพบว่าต้องใช้คำสั่ง `exec` ซึ่งจะ run คำสั่งออกจาก process เดิมแยกออกมาใหม่

```shell
exec

Replace the current process with another process.
More information: <https://linuxcommand.org/lc3_man_pages/exech.html>.

- Replace with the specified command using the current environment variables:
    exec command -with -flags

- Replace with the specified command, clearing environment variables:
    exec -c command -with -flags

- Replace with the specified command and login using the default shell:
    exec -l command -with -flags

- Replace with the specified command and change the process name:
    exec -a process_name command -with -flags
```

จาก script ข้างล่างจะพบว่าปัจจุบัน Shell process ที่ run `zsh` อยู่ใน process ID `10010` เมื่อ run คำสั่ง `exec sleep 60` แล้วตัว process ID `10010` จะเปลี่ยนเป็น `sleep 60` แทน หลัังจาก sleep ไปครบ 60 วินาทีแล้ว Shell ตัวเดิมที่ run `zsh` จะถูก terminate ออกไป

```shell
# Current shell
$ echo $$
10010

$ ps
PID TTY           TIME CMD
10010 ttys008    0:00.39 /opt/homebrew/bin/zsh -il

$ exec sleep 60

# New Shell
$ ps
PID TTY           TIME CMD
10010 ttys008    0:00.42 sleep 60
12423 ttys009    0:00.18 /opt/homebrew/bin/zsh -il
```

ต่อมาคือมาดูว่ามันมีขั้นตอนยังไงที่จะหยุด run agent โดยเราเดาว่า CI/CD pipeline จะส่ง [signal](https://bash.cyberciti.biz/guide/Shell_signal_values) เข้ามา เราเลยใช้คำสั่ง `trap` เพื่อดูว่ามันส่ง signal อะไรเข้ามาตรงไหน

```shell
trap

Automatically execute commands after receiving signals by processes or the operating system.
Can be used to perform cleanups for interruptions by the user or other actions.
More information: <https://manned.org/trap>.

- List available signals to set traps for:
    trap -l

- List active traps for the current shell:
    trap -p

- Set a trap to execute commands when one or more signals are detected:
    trap 'echo "Caught signal SIGHUP"' SIGHUP

- Remove active traps:
    trap - SIGHUP SIGINT
```

จาการที่เราใช้คำสั่ง `trap` เพื่อดักตามข้างล่าง เราพบว่าตัว signal จะส่ง `SIGTERM` เข้ามาใน process ของ Shell ชั้นบนสุดเลย เมื่อ agent หยุดทำงานหรือมีคนกด cancel pipeline เราก็จะเห็น log นี้ขึ้นมานั่นเอง ทำให้เราสามารถตรวจสอบสาเหตุที่เกิดขึ้นได้ง่ายขึ้น

```shell
$ trap 'echo "Caught signal SIGTERM"' SIGTERM
```

> เมื่อรวมกันแล้วเราก็จะสามารถแก้ปัญหานี้ได้ เราได้เรียนรู้การทำงานของ Shell เพิ่มอีกด้วย
