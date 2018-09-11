MIME-Version: 1.0
References: <20180910191002.350195-1-kristen@linux.intel.com>
 <CAG48ez0Skq5SgVXh6SEYq1Jn=_yUvEeuJYNViEora5S2cXLtng@mail.gmail.com> <1536681497.3382.4.camel@linux.intel.com>
In-Reply-To: <1536681497.3382.4.camel@linux.intel.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 11 Sep 2018 18:12:43 +0200
Message-ID: <CAG48ez10bCZ6r7YDDtBPw87rJDSiVohmYk1SLbiA_0KDbi4hog@mail.gmail.com>
Subject: Re: [RFC PATCH] x86: entry: flush the cache if syscall error
Content-Type: text/plain; charset="UTF-8"
To: kristen@linux.intel.com
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Sep 11, 2018 at 5:58 PM Kristen C Accardi
<kristen@linux.intel.com> wrote:
> On Mon, 2018-09-10 at 22:32 +0200, Jann Horn wrote:
> > On Mon, Sep 10, 2018 at 9:14 PM Kristen Carlson Accardi
> > <kristen@linux.intel.com> wrote:
> > > This patch aims to make it harder to perform cache timing attacks
> > > on data
> > > left behind by system calls. If we have an error returned from a
> > > syscall,
> > > flush the L1 cache.
[...]
> > > +config SYSCALL_FLUSH
> > > +       bool "Clear L1 Cache on syscall errors"
> > > +       default y
> > > +       help
> > > +         Select to allow the L1 cache to be cleared upon return of
> > > +         an error code from a syscall. This will reduce the
> > > likelyhood of
> > > +         speculative execution style attacks on syscalls.
> >
> > s/L1/L1D/ ?
>
> I can change this - the documentation for this msr mentioned that on
> some processors the icache might be impacted as well - think that's
> worth mentioning?

Ah, whoops, I didn't realize that it isn't as clear-cut as "just flush
L1D". I should've looked for the documentation first... nevermind, I
guess. I don't want to turn this into a documentation bikeshed.
