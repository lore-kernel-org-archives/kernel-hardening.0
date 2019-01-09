MIME-Version: 1.0
References: <20190102093137.17136-1-yanaijie@huawei.com> <CAG48ez3_oMX7Nzjaa4=QzipQ7i-BOOVojY5WVBNOBw0RZeik=g@mail.gmail.com>
 <CAGXu5jLGbAr9JLo=FtvSSF+EdTcj1J04PUUi65tY97zpdUAkRQ@mail.gmail.com> <5C355BD6.2010608@huawei.com>
In-Reply-To: <5C355BD6.2010608@huawei.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 9 Jan 2019 14:59:46 -0800
Message-ID: <CAGXu5jKsj+_O-NAATco6Ln6DLdcA+BC8_zd9DVfLNRa3jL+E=w@mail.gmail.com>
Subject: Re: [PATCH] usercopy: skip the check if not a real usercopy
Content-Type: text/plain; charset="UTF-8"
To: Jason Yan <yanaijie@huawei.com>
Cc: Jann Horn <jannh@google.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, zhaohongjiang@huawei.com, miaoxie@huawei.com, Li Bin <huawei.libin@huawei.com>, Wei Yongjun <weiyongjun1@huawei.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 8, 2019 at 6:26 PM Jason Yan <yanaijie@huawei.com> wrote:
> It's very easy to reproduce in qemu using my config with v4.20. Please
> refer to the attachment.
>
> I did some debug and found that check_object_size() did not stuck but
> check_object_size() sometimes takes more than 30 milliseconds, and
> ftrace will call __probe_kernel_write() thousands of times, which makes
> the whole process stuck for more than 20 seconds.

30ms is still WAY too long. :)

> [yanaijie@138 linux]$ ./scripts/faddr2line vmlinux
> __check_object_size+0x5/0x460
> __check_object_size+0x5/0x460:
> __check_object_size at mm/usercopy.c:254
> [yanaijie@138 linux]$

For me, that's the entry to __check_object_size (the line with "{").
Is that what you see too?

Perhaps this is poor interaction with tracing? Does marking
__check_object_size with "notrace" help?

-- 
Kees Cook
