Reply-To: kernel-hardening@lists.openwall.com
From: zerons <zeronsaxm@gmail.com>
Message-ID: <bf475a29-58cc-7b87-0821-9d23f01851b3@gmail.com>
Date: Sat, 19 Nov 2016 19:50:16 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] get NULL pointer dereferences or #GP fault to infomation leakage
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

I wonder if this could be an issue.

Test on Ubuntu 16.04 with linux kernel 4.4.x, x86_64.

When a NULL-pointer-deref or a #GP fault
(e.g: access to 0xdead0000-xxxxxxxx) happens in kernel space,
it seems that the kernel would kill the current process, then
output the Oops message or "general protection fault" message.

So we can get these messages via `dmesg` or reading the /var/log/...

I think this may be a way to bypass the KASLR, could it be?
