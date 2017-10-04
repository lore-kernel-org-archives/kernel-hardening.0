MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <1506816410-10230-1-git-send-email-me@tobin.cc>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 Oct 2017 08:41:26 -0700
Message-ID: <CA+55aFxzD=+H_M+Sg_8YRf-JYV-+-yn1c=dFhJWFzSh5yWt9Gg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter options
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Sep 30, 2017 at 5:06 PM, Tobin C. Harding <me@tobin.cc> wrote:
>   lib: vsprintf: default kptr_restrict to the maximum value

So I'm not convinced about this one.

It removes kernel pointers even for root, which is annoying for things
like perf.

And the only physical pointers we should print out during boot etc are
things we *need*.

So kptr_restrict is wrong for that, bercause either we potentially
need those values for debugging ("why does my kernel not boot"), or
they shouldn't be printed at all.

And I think _that_ is the real issue. If there are places that leak,
we should look at those, rather than just say "kptr_restrict".

                 Linus
