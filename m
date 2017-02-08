Date: Wed, 8 Feb 2017 11:24:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <CALAqxLW6FowGNWgtnSh6S9B4S_C=GW29mq7uLvk=_KMceOfHSw@mail.gmail.com>
Message-ID: <alpine.DEB.2.20.1702081122190.3536@nanos>
References: <20170207234031.GA27933@beast> <CALAqxLW6FowGNWgtnSh6S9B4S_C=GW29mq7uLvk=_KMceOfHSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH] time: Remove CONFIG_TIMER_STATS
To: John Stultz <john.stultz@linaro.org>
Cc: Kees Cook <keescook@chromium.org>, Xing Gao <xgao01@email.wm.edu>, Jessica Frazelle <me@jessfraz.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Jonathan Corbet <corbet@lwn.net>, Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, Petr Mladek <pmladek@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Nicolas Iooss <nicolas.iooss_linux@m4x.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Richard Cochran <richardcochran@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Michal Marek <mmarek@suse.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, Olof Johansson <olof@lixom.net>, Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 7 Feb 2017, John Stultz wrote:
> On Tue, Feb 7, 2017 at 3:40 PM, Kees Cook <keescook@chromium.org> wrote:
> > Currently CONFIG_TIMER_STATS exposes process information across namespaces:
> >
> > kernel/time/timer_list.c print_timer():
> >
> >         SEQ_printf(m, ", %s/%d", tmp, timer->start_pid);
> >
> > /proc/timer_list:
> >
> >  #11: <0000000000000000>, hrtimer_wakeup, S:01, do_nanosleep, cron/2570
> >
> > Given that the tracer can give the same information, this patch entirely
> > removes CONFIG_TIMER_STATS.
> >
> > Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> I don't have an issue with this, but I worry this would break some
> tooling out there. Should it be marked as deprecated first?
> 
> Or maybe just pulling the band-aid off is the best way?

I think we should just kill it.

No tools can really rely on the behaviour of that file because it depends
on CONFIG_TIMER_STATS and the information available there is just a random
snapshot of queued timers at a given point of time, which is in no way
usefull.

Thanks,

	tglx
