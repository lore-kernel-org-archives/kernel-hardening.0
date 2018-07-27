MIME-Version: 1.0
References: <20180725202238.165314-1-salyzyn@android.com> <20180725210717.3b807191@vmware.local.home>
 <11437c3e-5131-7190-c496-7b51eb7fcc2a@android.com> <20180726153153.GA8327@kroah.com>
 <CAKwvOdk9s+=kUwcPGQzZNxR7eOGAiiasAyWhZxgKom4_6h+oxA@mail.gmail.com>
 <20180726181558.25a5c3b8@gandalf.local.home> <753E9YR1QhdsPhsFoYuXCwfUzfyntDrc_A93hMUkktMi7lbh3KUZMcbfqKVWUfi15zYhuiDFant-ROa4QNV5shx74ff4hGngq2BOJDv-hq4=@protonmail.ch>
In-Reply-To: <753E9YR1QhdsPhsFoYuXCwfUzfyntDrc_A93hMUkktMi7lbh3KUZMcbfqKVWUfi15zYhuiDFant-ROa4QNV5shx74ff4hGngq2BOJDv-hq4=@protonmail.ch>
From: Jann Horn <jannh@google.com>
Date: Fri, 27 Jul 2018 15:40:32 +0200
Message-ID: <CAG48ez1U=5nTOrnOqwMuXhdER-7XxJUYLcyYNuczwasQLQ0gXA@mail.gmail.com>
Subject: Re: [PATCH] tracing: do not leak kernel addresses
Content-Type: text/plain; charset="UTF-8"
To: Golden_Miller83@protonmail.ch
Cc: Steven Rostedt <rostedt@goodmis.org>, Nick Desaulniers <ndesaulniers@google.com>, Greg KH <greg@kroah.com>, Kees Cook <keescook@google.com>, salyzyn@android.com, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, kernel-team@android.com, stable@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jul 27, 2018 at 2:07 PM Jordan Glover
<Golden_Miller83@protonmail.ch> wrote:
>
> On July 27, 2018 12:15 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > On Thu, 26 Jul 2018 09:52:11 -0700
> > Nick Desaulniers ndesaulniers@google.com wrote:
> >
> > > See the section "Kernel addresses" in
> > > Documentation/security/self-protection. IIRC, the issue is that a
> > > process may have CAP_SYSLOG but not necessarily CAP_SYS_ADMIN (so it
> > > can read dmesg, but not necessarily issue a sysctl to change
> > > kptr_restrict), get compromised and used to leak kernel addresses,
> > > which can then be used to defeat KASLR.
> >
> > But the code doesn't go to dmesg. It's only available
> > via /sys/kernel/debug/tracing/printk_formats which is only available
> > via root. Nobody else has access to that directory.
> >
> > -- Steve
>
> I think the point was that when we take capabilities into account the root
> privileges aren't unequivocal anymore. The 'root' owned process with only
> 'CAP_SYSLOG' shouldn't have access to /sys/kernel/debug/tracing/printk_formats

Then they shouldn't have access to debugfs at all, right?
