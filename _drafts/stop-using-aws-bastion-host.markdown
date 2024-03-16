---
layout: post
title: "มีวิธีในการต่อ database แบบ secure โดยไม่ต้องใช้ Bastion host แล้ว"
date: 2024-03-16
tags: [productivity, macos]
---

(https://blog.thoughtworks.net/jithin-paul/eic-endpoint-connect-to-private-aws-ec2-instance-without-public-ip), but there is a means of connecting to EC2 instances in private subnets without requiring public IP addresses. As long as the machine can accept a TCP connection, you're golden.

And the best thing: There is no additional cost attached outside of traffic.

What you're looking for is called EC2 Instance Connect Endpoint. Only ports 22 and 3389 are supported, but of course you can use additional ssh tunnels for port forwarding. You chuck one of these into your private subnet and tunnel through it.

Unfortunately, EC2 Instance Connect Endpoint doesn't support connections to an instance using IPv6 addresses. But given the upside of not having to mess with a bastion host, this should be fine.

```sh
ssh -i my-key-pair.pem ec2-user@i-0123456789example \
    -o ProxyCommand='aws ec2-instance-connect open-tunnel --instance-id i-0123456789example'
```

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/connect-using-eice.html

That's it. You don't even have to remember that, you can just chuck it all into your ssh config.

For windows, you just forward the RDP port and then connect to `localhost:<local port>`

```sh
aws ec2-instance-connect open-tunnel \
    --instance-id i-0123456789example \
    --remote-port 3389 \
    --local-port any-port
```

https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/connect-using-eice.html#eic-connect-using-rdp

There's also AWS SSM Fleet Manager to gain access to your EC2 instances which don't need public IPs or a Bastion.

It does require the SSM Agent which most images support.  SSM Agent also can help with patching the OS too. It's a case of finding the right tool for your use case. I've not used the EC2 Instance Connect Endpoint but it looks pretty good