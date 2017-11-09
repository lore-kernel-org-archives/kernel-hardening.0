Date: Thu, 9 Nov 2017 13:11:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
Message-ID: <20171109131111.499057ab@gandalf.local.home>
In-Reply-To: <CAPDLWs-yd13yh4NKpB4msAxcG6BeXMSohfpU_Vv2RJFc5ApddA@mail.gmail.com>
References: <1510050731-32446-1-git-send-email-me@tobin.cc>
	<ec5a3690-a8c2-0329-66c0-ed7dda5db958@redhat.com>
	<CA+55aFwiaQezaPi2nzmyuFZNgR3PFcsWjjBTHJYBesKrh-Q_pQ@mail.gmail.com>
	<CA+55aFz6XYtthCgLVJY=985pedeKTwsqPLyL4VVyNpP2TjpPPg@mail.gmail.com>
	<CAPDLWs8jyL3W_sGmHtw4Uw=8U_OYfeWJd_BpBLE7zvO4c6Z_8g@mail.gmail.com>
	<CAPDLWs-yd13yh4NKpB4msAxcG6BeXMSohfpU_Vv2RJFc5ApddA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH v4] scripts: add leaking_addresses.pl
To: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Laura Abbott <labbott@redhat.com>, "Tobin C. Harding" <me@tobin.cc>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 9 Nov 2017 10:24:32 +0530
Kaiwan N Billimoria <kaiwan.billimoria@gmail.com> wrote:

> On Thu, Nov 9, 2017 at 10:13 AM, Kaiwan N Billimoria
> <kaiwan.billimoria@gmail.com> wrote:
> >> But I don't know if there is anything else than the profiling code
> >> that _really_ wants access to /proc/kallsyms in user space as a
> >> regular user.  
> >  
> 
> Front-ends to ftrace, like trace-cmd?
> [from the trace-cmd git repo (Steve Rostedt, pl stand up, pl stand up :-)
> Documentation/trace-cmd-restore.1.txt :

Yes, profiling and tracing are similar. And you need to be root to run
the recording anyway. Thus, as long as root user can read kallsyms,
trace-cmd should be fine. As trace-cmd requires root access to do any
ftrace tracing.

-- Steve
