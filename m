Date: Thu, 9 Feb 2017 14:41:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20170208203027.r6v4apovtyi6nuu3@codemonkey.org.uk>
Message-ID: <alpine.DEB.2.20.1702091415140.3604@nanos>
References: <20170208192659.GA32582@beast> <CA+55aFzz25AxbG7vJNNKAOEpAJFYnd=D0wJrL-tEN-SREk6kSQ@mail.gmail.com> <20170208203027.r6v4apovtyi6nuu3@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v2] time: Remove CONFIG_TIMER_STATS
To: Dave Jones <davej@codemonkey.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Xing Gao <xgao01@email.wm.edu>, Jessica Frazelle <me@jessfraz.com>, John Stultz <john.stultz@linaro.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Jonathan Corbet <corbet@lwn.net>, Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, Petr Mladek <pmladek@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nicolas Iooss <nicolas.iooss_linux@m4x.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Richard Cochran <richardcochran@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Michal Marek <mmarek@suse.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, Olof Johansson <olof@lixom.net>, Shuah Khan <shuah@kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Arjan van de Ven <arjan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 8 Feb 2017, Dave Jones wrote:

> On Wed, Feb 08, 2017 at 11:54:30AM -0800, Linus Torvalds wrote:
>  > On Wed, Feb 8, 2017 at 11:26 AM, Kees Cook <keescook@chromium.org> wrote:
>  > >
>  > > Given that the tracer can give the same information, this patch entirely
>  > > removes CONFIG_TIMER_STATS.
>  > >
>  > > Suggested-by: Thomas Gleixner <tglx@linutronix.de>
>  > > Signed-off-by: Kees Cook <keescook@chromium.org>
>  > > Acked-by: John Stultz <john.stultz@linaro.org>
>  > 
>  > Looks good to me. Let's wait for the 4.11 merge window though. I'm
>  > assuming I'll get this through the tip timer tree..
> 
> >From a quick look at the source, powertop uses this file, and appears to
> handle it gracefully if it fails to open, but it will lose functionality
> to determine if a timer is deferred.

The lookup happens when evaluating a timer_expire_entry tracing event.

With current kernels the same information can be retrieved from the
timer_start tracing event (flags field). And that's way more sensible than
scanning timer_stats because when the trace is evaluated there is no
guarantee at all that the timer is still queued and exposed there. That
should be trivial to fix in powertop.

Thanks,

	tglx
