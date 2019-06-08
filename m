Date: Fri, 7 Jun 2019 21:32:00 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: Get involved
Message-ID: <201906072117.A1C045C@keescook>
References: <CABgxDo+x3r=8HFxyM89HAc_FdY6+kBpJR5RpAgpOYsu0xZtshQ@mail.gmail.com>
 <CABgxDoJ-ue6HKyBR_q8cmbOp8DFnZDVf7zbxv8_wmHh7uis_vw@mail.gmail.com>
 <CAOfkYf4OxG-vkCOoWvmGxyRg3UVFcGszkdStKSoXf5qqyF_RQA@mail.gmail.com>
 <CABgxDoLe3fXNLob3pnj7Nn2v54Htqr+cg5gRRQPxFK7HPX85=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgxDoLe3fXNLob3pnj7Nn2v54Htqr+cg5gRRQPxFK7HPX85=Q@mail.gmail.com>
To: Romain Perier <romain.perier@gmail.com>
Cc: Shyam Saini <mayhs11saini@gmail.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 07, 2019 at 08:16:42PM +0200, Romain Perier wrote:
> Hi,

Hi! Sorry for the late reply: I've been travelling this week. :P

> Okay, np. I will select another one then :) (hehe that's the game ;) )
> 
> @Kees: do you have something in mind (as a new task) ?

Shyam, you'd also started FIELD_SIZEOF refactoring, but never sent a v2
patch if I was following correctly? Is there one or the other of these
tasks you'd like help with?  https://patchwork.kernel.org/patch/10900187/

Romain, what do you think about reviewing NLA code? I'd mentioned a
third task here:
https://www.openwall.com/lists/kernel-hardening/2019/04/17/8

Quoting...


- audit and fix all misuse of NLA_STRING

This is a following up on noticing the misuse of NLA_STRING (no NUL
terminator), getting used with regular string functions (that expect a
NUL termination):
https://lore.kernel.org/lkml/1519329289.2637.12.camel@sipsolutions.net/T/#u

It'd be nice if someone could inspect all the NLA_STRING
representations and find if there are any other problems like this
(and see if there was a good way to systemically fix the problem).



For yet another idea would be to get syzkaller[1] set up and enable
integer overflow detection (by adding "-fsanitize=signed-integer-overflow"
to KBUILD_CFLAGS) and start finding and fixes cases like this[2].

Thanks and let me know what you think!

-Kees

[1] https://github.com/google/syzkaller/blob/master/docs/linux/setup.md
[2] https://lore.kernel.org/lkml/20180824215439.GA46785@beast/


-- 
Kees Cook
