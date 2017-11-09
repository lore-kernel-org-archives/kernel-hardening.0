MIME-Version: 1.0
In-Reply-To: <CAPDLWs8jyL3W_sGmHtw4Uw=8U_OYfeWJd_BpBLE7zvO4c6Z_8g@mail.gmail.com>
References: <1510050731-32446-1-git-send-email-me@tobin.cc>
 <ec5a3690-a8c2-0329-66c0-ed7dda5db958@redhat.com> <CA+55aFwiaQezaPi2nzmyuFZNgR3PFcsWjjBTHJYBesKrh-Q_pQ@mail.gmail.com>
 <CA+55aFz6XYtthCgLVJY=985pedeKTwsqPLyL4VVyNpP2TjpPPg@mail.gmail.com> <CAPDLWs8jyL3W_sGmHtw4Uw=8U_OYfeWJd_BpBLE7zvO4c6Z_8g@mail.gmail.com>
From: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
Date: Thu, 9 Nov 2017 10:24:32 +0530
Message-ID: <CAPDLWs-yd13yh4NKpB4msAxcG6BeXMSohfpU_Vv2RJFc5ApddA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH v4] scripts: add leaking_addresses.pl
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Laura Abbott <labbott@redhat.com>, "Tobin C. Harding" <me@tobin.cc>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 9, 2017 at 10:13 AM, Kaiwan N Billimoria
<kaiwan.billimoria@gmail.com> wrote:
>> But I don't know if there is anything else than the profiling code
>> that _really_ wants access to /proc/kallsyms in user space as a
>> regular user.
>

Front-ends to ftrace, like trace-cmd?
[from the trace-cmd git repo (Steve Rostedt, pl stand up, pl stand up :-)
Documentation/trace-cmd-restore.1.txt :
...
*-k* kallsyms::
    Used with *-c*, it overrides where to read the kallsyms file from.
    By default, /proc/kallsyms is used. *-k* will override the file to
    read the kallsyms from. This can be useful if the trace.dat file
    to create is from another machine. Just copy the /proc/kallsyms
    file locally, and use *-k* to point to that file.
...
]

> Am unsure about this, but kprobes? (/jprobes/kretprobes), and by
> extension, wrappers over this infra (like SystemTap)?
> I (hazily) recollect a script I once wrote (years back though) that
> collects kernel virtual addresses off of kallsyms for the purpose of
> passing them to a 'helper' kernel module that uses kprobes. I realize
> that 'modern' kprobes exposes APIs that just require the symbolic name
> & that they're anyway at kernel privilege... but the point is, a
> usermode script was picking up and passing the kernel addresses.
>
> Also, what about kernel addresses exposed via System.map?
> Oh, just checked, it's root rw only.. pl ignore.
