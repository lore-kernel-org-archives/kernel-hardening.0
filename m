MIME-Version: 1.0
References: <20180725202238.165314-1-salyzyn@android.com> <20180725210717.3b807191@vmware.local.home>
 <11437c3e-5131-7190-c496-7b51eb7fcc2a@android.com> <20180726153153.GA8327@kroah.com>
 <CAKwvOdk9s+=kUwcPGQzZNxR7eOGAiiasAyWhZxgKom4_6h+oxA@mail.gmail.com>
 <20180726181558.25a5c3b8@gandalf.local.home> <753E9YR1QhdsPhsFoYuXCwfUzfyntDrc_A93hMUkktMi7lbh3KUZMcbfqKVWUfi15zYhuiDFant-ROa4QNV5shx74ff4hGngq2BOJDv-hq4=@protonmail.ch>
 <CAG48ez1U=5nTOrnOqwMuXhdER-7XxJUYLcyYNuczwasQLQ0gXA@mail.gmail.com> <20180727094730.3a448629@gandalf.local.home>
In-Reply-To: <20180727094730.3a448629@gandalf.local.home>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Fri, 27 Jul 2018 11:13:51 -0700
Message-ID: <CAKwvOdmg4DSSwy9YBccYWzc+6ZU2yKSSFmfnj72wqbYDJU0gzw@mail.gmail.com>
Subject: Re: [PATCH] tracing: do not leak kernel addresses
Content-Type: text/plain; charset="UTF-8"
To: rostedt@goodmis.org
Cc: Jann Horn <jannh@google.com>, Golden_Miller83@protonmail.ch, greg@kroah.com, Kees Cook <keescook@google.com>, salyzyn@android.com, LKML <linux-kernel@vger.kernel.org>, mingo@redhat.com, kernel-team@android.com, stable@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jul 27, 2018 at 6:47 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 27 Jul 2018 15:40:32 +0200
> Jann Horn <jannh@google.com> wrote:
>
> > > > But the code doesn't go to dmesg. It's only available
> > > > via /sys/kernel/debug/tracing/printk_formats which is only available
> > > > via root. Nobody else has access to that directory.

Oh, sorry, you're right. We're not printing an address to dmesg, but
to a sysfs node.  If you must have CAP_SYS_ADMIN to read this dir,
then printk's %pK wont save you, because then you can modify
kptr_restrict with sysctl.

> > > I think the point was that when we take capabilities into account the root
> > > privileges aren't unequivocal anymore. The 'root' owned process with only
> > > 'CAP_SYSLOG' shouldn't have access to /sys/kernel/debug/tracing/printk_formats
> >
> > Then they shouldn't have access to debugfs at all, right?
>
> That's what I'm thinking.

I found the internal bug report (reported Jan '17, you'll have to
forgive me if my memory of the issue is hazy, or if the fix used at
the time wasn't perfect), which was reported against the Nexus 6.
>From the report, it was possible to `cat
/sys/kernel/debug/tracing/printk_formats` without being root, which I
can't do on my workstations much more modern kernel (Nexus 6 was
3.10).  So I guess the question is what governs access to files below
/sys/kernel/debug, and why was it missing from those kernels?  I
assume some check was added, but either not backported to 3.10 stable
(or more likely not pulled in to Nexus 6's kernel through stable;
Android is now in a much better place for that kind of issue).

--
Thanks,
~Nick Desaulniers
