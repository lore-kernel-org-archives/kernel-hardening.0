MIME-Version: 1.0
In-Reply-To: <20171109131111.499057ab@gandalf.local.home>
References: <1510050731-32446-1-git-send-email-me@tobin.cc>
 <ec5a3690-a8c2-0329-66c0-ed7dda5db958@redhat.com> <CA+55aFwiaQezaPi2nzmyuFZNgR3PFcsWjjBTHJYBesKrh-Q_pQ@mail.gmail.com>
 <CA+55aFz6XYtthCgLVJY=985pedeKTwsqPLyL4VVyNpP2TjpPPg@mail.gmail.com>
 <CAPDLWs8jyL3W_sGmHtw4Uw=8U_OYfeWJd_BpBLE7zvO4c6Z_8g@mail.gmail.com>
 <CAPDLWs-yd13yh4NKpB4msAxcG6BeXMSohfpU_Vv2RJFc5ApddA@mail.gmail.com> <20171109131111.499057ab@gandalf.local.home>
From: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
Date: Fri, 10 Nov 2017 08:33:14 +0530
Message-ID: <CAPDLWs_hRzejj3yBYxp-wQ93b4VMVkV3LfcH4FJgTLpFwKn+ew@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH v4] scripts: add leaking_addresses.pl
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Laura Abbott <labbott@redhat.com>, "Tobin C. Harding" <me@tobin.cc>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

>
> Yes, profiling and tracing are similar. And you need to be root to run
> the recording anyway. Thus, as long as root user can read kallsyms,
> trace-cmd should be fine. As trace-cmd requires root access to do any
> ftrace tracing.
>
> -- Steve
Got it, thanks..
