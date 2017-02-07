MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1702072344520.8117@nanos>
References: <CAJwLwmYQt2ae_Y-TDXhPGsX5im29ATwwKmg3FtUC=6HjrzH4HA@mail.gmail.com>
 <CAGXu5j+qgNMP1jt1-cssuY5qNkSPDde5MzH9YQUcuLepbHX0jg@mail.gmail.com> <alpine.DEB.2.20.1702072344520.8117@nanos>
From: Jessica Frazelle <me@jessfraz.com>
Date: Tue, 7 Feb 2017 14:56:53 -0800
Message-ID: <CAEk6tEyzgCV5YWppu5OwxjFz6royvXmJM-Qs_mKTUSsqeR7wZw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: /proc/timer_list leaks the real pids of the associated processes
To: Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@google.com>
Cc: Xing Gao <xgao01@email.wm.edu>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>

So I used to use this "feature" as a hack to see if something was
running in a k8s cluster or not because fluentd gives a lot of things
away. Runc basically decided to mask this file so it stopped happening
though. But I think namespace aware is the right decision.


On Tue, Feb 7, 2017 at 2:48 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Fri, 3 Feb 2017, Kees Cook wrote:
>
> > On Fri, Feb 3, 2017 at 2:29 PM, Xing Gao <xgao01@email.wm.edu> wrote:
> > > Dear Thomas and Kees,
> > >
> > > I posted a bug report on bugzilla, and John asked me to send it the lkml.
> > >
> > > Here is the link, https://bugzilla.kernel.org/show_bug.cgi?id=193921
> > >
> > > Please cc to me when you reply this email.
> > >
> > > And please check the information below.
> > >
> > > The pseudo file /proc/timer_list leaks the real pids of the associated
> > > processes.
> > >
> > > The function print_timer(kernel/time/timer_list.c) displays
> > > timer->start_pid, which is set inside the function
> > > __timer_stats_timer_set_start_info (kernel/time/timer.c). This is the real
> > > pid, rather than the pid in the pid namespace. If the user within a
> > > container retrieves the content of /proc/timer_list, this file will leak the
> > > real pid of the associated process.
> >
> > I feel like this has been pointed out before, but I can't find the
> > email about it. Regardless, yeah, this looks true:
> >
> >         SEQ_printf(m, ", %s/%d", tmp, timer->start_pid);
> >
> >  #11: <0000000000000000>, hrtimer_wakeup, S:01, do_nanosleep, cron/2570
> >
> > Seems like this should be made namespace aware... (and why is this
> > file needed at all? Seems like it should live in debugfs not proc).
>
> I'm fine with that.
>
> The TIMER_STATS stuff should go away completely. If people are interested
> in that information they can use the tracer which gives way better
> data than that file.
>
> Thanks,
>
>         tglx
> .
