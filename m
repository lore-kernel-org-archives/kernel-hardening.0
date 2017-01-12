Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
From: park jinbum <jinb.park7@gmail.com>
Date: Fri, 13 Jan 2017 00:06:31 +0900
Message-ID: <CAErMHp-W=zcX-D10dbhzRG41-mjfVcKb2_+p4dxdXsnfizZuag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Introduction
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hello All,

I'd like to contribute to kernel self protection project.
I've experienced ARM kernel, security solution on production.
(kernel memory protection, contents protection, ...)

I'm interested in following topics.
- Move kernel stack to vmap area (done on x86, other archs still need it)
- KASLR for ARM
- protect ARM vector table as fixed-location kernel target
- expand use of __ro_after_init, especially in arch/arm64

I'm still a kernel newbie,  so they can be too much for me.
If there is something easier and smaller to do, that is good for me.
