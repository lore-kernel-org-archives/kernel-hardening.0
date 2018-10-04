MIME-Version: 1.0
References: <20180926203446.2004-1-casey.schaufler@intel.com>
 <20180926203446.2004-3-casey.schaufler@intel.com> <CAG48ez3_XJYCURiCurDeCousGguGUdPego30j5+UF8FebWxUtA@mail.gmail.com>
 <99FC4B6EFCEFD44486C35F4C281DC673214625EA@ORSMSX107.amr.corp.intel.com>
 <CAG48ez1+9Bfadu4y4TzPYJfFpLk+N8w7GdCE+xwNCM5TfQ8W8Q@mail.gmail.com> <nycvar.YFH.7.76.1810040942110.14430@cbobk.fhfr.pm>
In-Reply-To: <nycvar.YFH.7.76.1810040942110.14430@cbobk.fhfr.pm>
From: Jann Horn <jannh@google.com>
Date: Thu, 4 Oct 2018 13:36:50 +0200
Message-ID: <CAG48ez1OiAvqqtLXpBjxz-=9X+YdtR9iF7fA_pXhu2GfBt5osw@mail.gmail.com>
Subject: Re: [PATCH v5 2/5] Smack: Prepare for PTRACE_MODE_SCHED
Content-Type: text/plain; charset="UTF-8"
To: Jiri Kosina <jikos@kernel.org>, Casey Schaufler <casey.schaufler@intel.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, selinux@tycho.nsa.gov, Dave Hansen <dave.hansen@intel.com>, deneen.t.dock@intel.com, kristen@linux.intel.com, Arjan van de Ven <arjan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 4, 2018 at 9:47 AM Jiri Kosina <jikos@kernel.org> wrote:
> On Thu, 27 Sep 2018, Jann Horn wrote:
> > > Yes. Since the PTRACE_MODE_NOAUDIT was in PTRACE_MODE_IBPB in Jiri's
> > > previous patch set and not in PTRACE_MODE_SCHED in this one I assumed
> > > that there was a good reason for it.
> >
> > Jiri, was there a good reason for it, and if so, what was it?
>
> [ FWIW PTRACE_MODE_NOAUDIT being in PTRACE_MODE_IBPB goes back to original
>   Tim's pre-CRD patchset ]
>
> Well, we can't really call out into audit from scheduler code, and the
> previous versions of the patchsets didn't have PTRACE_MODE_SCHED, so it
> had to be included in PTRACE_MODE_IBPB in order to make sure we're not
> calling into audit from context switch code.
>
> Or did I misunderstand the question?

If I understand Casey correctly, he is saying that your patch
(https://lore.kernel.org/lkml/nycvar.YFH.7.76.1809251437340.15880@cbobk.fhfr.pm/)
doesn't include PTRACE_MODE_NOAUDIT for IBPB, but the previous v6 of
your patch (https://lore.kernel.org/lkml/nycvar.YFH.7.76.1809121105330.15880@cbobk.fhfr.pm/)
did include it, and therefore Casey thinks that there is a specific
reason why you removed PTRACE_MODE_NOAUDIT, and therefore Casey is
adding special-case logic for PTRACE_MODE_SCHED to Smack when simply
using PTRACE_MODE_NOAUDIT would also work.

I think that Casey should change ptrace_may_access_sched() to use
"mode | PTRACE_MODE_SCHED | PTRACE_MODE_NOAUDIT".
