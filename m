Date: Fri, 27 Jul 2018 09:47:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing: do not leak kernel addresses
Message-ID: <20180727094730.3a448629@gandalf.local.home>
In-Reply-To: <CAG48ez1U=5nTOrnOqwMuXhdER-7XxJUYLcyYNuczwasQLQ0gXA@mail.gmail.com>
References: <20180725202238.165314-1-salyzyn@android.com>
	<20180725210717.3b807191@vmware.local.home>
	<11437c3e-5131-7190-c496-7b51eb7fcc2a@android.com>
	<20180726153153.GA8327@kroah.com>
	<CAKwvOdk9s+=kUwcPGQzZNxR7eOGAiiasAyWhZxgKom4_6h+oxA@mail.gmail.com>
	<20180726181558.25a5c3b8@gandalf.local.home>
	<753E9YR1QhdsPhsFoYuXCwfUzfyntDrc_A93hMUkktMi7lbh3KUZMcbfqKVWUfi15zYhuiDFant-ROa4QNV5shx74ff4hGngq2BOJDv-hq4=@protonmail.ch>
	<CAG48ez1U=5nTOrnOqwMuXhdER-7XxJUYLcyYNuczwasQLQ0gXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Jann Horn <jannh@google.com>
Cc: Golden_Miller83@protonmail.ch, Nick Desaulniers <ndesaulniers@google.com>, Greg KH <greg@kroah.com>, Kees Cook <keescook@google.com>, salyzyn@android.com, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, kernel-team@android.com, stable@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 27 Jul 2018 15:40:32 +0200
Jann Horn <jannh@google.com> wrote:

> > > But the code doesn't go to dmesg. It's only available
> > > via /sys/kernel/debug/tracing/printk_formats which is only available
> > > via root. Nobody else has access to that directory.
> > >
> > > -- Steve  
> >
> > I think the point was that when we take capabilities into account the root
> > privileges aren't unequivocal anymore. The 'root' owned process with only
> > 'CAP_SYSLOG' shouldn't have access to /sys/kernel/debug/tracing/printk_formats  
> 
> Then they shouldn't have access to debugfs at all, right?

That's what I'm thinking.

-- Steve
