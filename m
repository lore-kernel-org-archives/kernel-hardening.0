Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <3694.1466127526@turing-police.cc.vt.edu>
References: <1465420302-23754-1-git-send-email-keescook@chromium.org>
 <9020.1466040627@turing-police.cc.vt.edu> <CAGXu5jKcLHy3t0C7RyX8xXYowhYuh0rO+WPxWQFKuSn9LN6sjA@mail.gmail.com>
 <16741.1466120212@turing-police.cc.vt.edu> <3694.1466127526@turing-police.cc.vt.edu>
From: Kees Cook <keescook@chromium.org>
Date: Sat, 18 Jun 2016 12:30:31 -0700
Message-ID: <CAGXu5jLX5aAm=m0Smyec4xxTJxsJN-nzDk0GQ22jiXmYDK4rkw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC][PATCH v2 0/4] mm: Hardened usercopy
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey.schaufler@intel.com>, Rik van Riel <riel@redhat.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 16, 2016 at 6:38 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Thu, 16 Jun 2016 19:36:52 -0400, Valdis.Kletnieks@vt.edu said:
>
>> stuff is working.  I may whomp on it with trinity for a while, see if
>> anything falls out...
>
> Woo hoo! Bagged one! :)  (Haven't figured out yet if actual bug, or missing
> annotation)
>
> [ 4033.178386] NET: Registered protocol family 21
> [ 4033.226806] NET: Registered protocol family 38
> [ 4033.256276] Guest personality initialized and is inactive
> [ 4033.256797] VMCI host device registered (name=vmci, major=10, minor=53)
> [ 4033.256801] Initialized host personality
> [ 4033.266376] NET: Registered protocol family 40
> [ 4033.365982] NET: Registered protocol family 24
> [ 4033.413031] irda_setsockopt: not allowed to set MAXSDUSIZE for this socket type!
> [ 4033.531569] sock: process `trinity-main' is using obsolete setsockopt SO_BSDCOMPAT
> [ 4033.834839] irda_setsockopt: not allowed to set MAXSDUSIZE for this socket type!
> [ 4034.444515] irda_setsockopt: not allowed to set MAXSDUSIZE for this socket type!
> [ 4034.569913] sctp: [Deprecated]: trinity-main (pid 19154) Use of int in max_burst socket option deprecated.
> [ 4034.569913] Use struct sctp_assoc_value instead
> [ 4034.728723] usercopy: kernel memory overwrite attempt detected to ffff8801ecef4700 (SCTP) (4 bytes)
> [ 4034.728730] CPU: 3 PID: 19154 Comm: trinity-main Tainted: G           OE   4.7.0-rc3-next-20160614-dirty #302
> [ 4034.728732] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A17 08/19/2015
> [ 4034.728734]  0000000000000000 0000000063913a95 ffff8801f8b33da8 ffffffffb269f61a
> [ 4034.728740]  ffff8801ecef4700 0000000063913a95 0000000000000004 0000000000000000
> [ 4034.728744]  ffff8801f8b33df8 ffffffffb2367b30 0000000000000004 ffffea0006bd4580
> [ 4034.728748] Call Trace:
> [ 4034.728754]  [<ffffffffb269f61a>] dump_stack+0x7b/0xd1
> [ 4034.728758]  [<ffffffffb2367b30>] __check_object_size+0x70/0x3d4
> [ 4034.728761]  [<ffffffffb2eae5e4>] sctp_setsockopt.part.9+0x684/0x1e70
> [ 4034.728764]  [<ffffffffb236f002>] ? __vfs_write+0x22/0x2e0
> [ 4034.728767]  [<ffffffffb2eafe3e>] sctp_setsockopt+0x6e/0xe0
> [ 4034.728770]  [<ffffffffb2bd1d0a>] sock_common_setsockopt+0x3a/0xc0
> [ 4034.728772]  [<ffffffffb2bcfb99>] SyS_setsockopt+0x89/0x120
> [ 4034.728775]  [<ffffffffb30896e5>] entry_SYSCALL_64_fastpath+0x18/0xa8
> [ 4034.728779]  [<ffffffffb2143e3f>] ? trace_hardirqs_off_caller+0x1f/0xf0

Cool, interesting. I don't see anything obvious in grsecurity's
patches that covers this, so either I'm missing something else, or
this bug exists there too. (Though not a lot of people use SCTP,
though.)

> Do we have a good place to collect these, or should I just post them here
> as I find stuff?

For now, let's just collect them on the list, and any patches that
might solve them. I'm hoping to add the copy_*_user_n() API to help
with these.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
