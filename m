MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAFUG7CcQoJZ9SyGnD61xjkc6nCQhbgnqBJ0k-PkQxE9iTo2+SA@mail.gmail.com>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
 <CA+55aFxzD=+H_M+Sg_8YRf-JYV-+-yn1c=dFhJWFzSh5yWt9Gg@mail.gmail.com> <CAFUG7CcQoJZ9SyGnD61xjkc6nCQhbgnqBJ0k-PkQxE9iTo2+SA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 Oct 2017 09:29:16 -0700
Message-ID: <CA+55aFwmVdeLFs1-HJGXeOBz5WgJinCDNAu7mcr+fJhjQp+mEg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter options
To: Boris Lukashev <blukashev@sempervictus.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 4, 2017 at 9:22 AM, Boris Lukashev
<blukashev@sempervictus.com> wrote:
>
> When adding modules from outside the mainline tree (zfs, aufs, scst,
> etc), we would not be able to audit the source, and risk leaking
> sensitive pointers from those components if we dont filter them out
> this way or in a similar programmatic manner.

I call *COMPLETE* bullshit on that argument.

Non-mainlined source code is insecure, and printing some random
address is the *least* of the problems in it.

And the way to make it secure has absolutely nothing to do with printk strings.

Ask somebody about Android camera drivers some day.

Go away. Don't use this specious idiotic argument, all it does is to
make all your other arguments look stupid.

That said, they didn't need much help: ttalking about FDA and medical
equipment as an argument for some particular default value is another
sign that your arguments are UTTER SHIT.

If this is seriously the quality of excuses for this patch-series, I
never ever want to see those patches again.

                Linus
