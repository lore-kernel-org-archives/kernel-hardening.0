From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Date: Fri, 23 Jun 2017 01:59:37 +0200
Message-ID: <3395263.N2PfeMfNmG@aspire.rjw.lan>
In-Reply-To: <CAGXu5jJWZos+uUgyc6hiHko=ei4b_6aCyZqRLDESfih1ybxR=w@mail.gmail.com>
References: <1497905801-69164-1-git-send-email-keescook@chromium.org> <CAJZ5v0hqRbsivmnG5iKMsR_ZMg+i_vxA7n-NOkuu3jh-TJ6pHw@mail.gmail.com> <CAGXu5jJWZos+uUgyc6hiHko=ei4b_6aCyZqRLDESfih1ybxR=w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: [kernel-hardening] Re: [PATCH 3/4] randstruct: Disable randomization of ACPICA structs
To: Kees Cook <keescook@chromium.org>, Lv Zheng <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Christoph Hellwig <hch@infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Robert Moore <robert.moore@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thursday, June 22, 2017 04:57:39 PM Kees Cook wrote:
> On Tue, Jun 20, 2017 at 2:34 PM, Rafael J. Wysocki <rafael@kernel.org> wrote:
> > On Tue, Jun 20, 2017 at 10:35 PM, Christoph Hellwig <hch@infradead.org> wrote:
> >> On Tue, Jun 20, 2017 at 12:25:53PM -0700, Kees Cook wrote:
> >>> Can you send the patch to https://github.com/acpica/acpica ? My change
> >>> was finally accepted, so this whole issue will go away on the next
> >>> refresh. Until then, I don't want to block the entire automatic
> >>> structure selection logic of randstruct on a three-function table. :)
> >>
> >> I do not have a github account and no such thing is required for kernel
> >> development.
> >
> > It isn't required for the ACPICA material either.
> >
> > You just need to CC the ACPICA maintainers, as per MAINTAINERS, on
> > your ACPICA patches.  They pick up stuff that looks good to them.
> >
> > And we tend to prefer routing ACPICA changes through the upstream,
> > because failing to do so usually turns out to be painful in the long
> > term.  I don't think it is unreasonable to ask for cooperation in that
> > respect.
> 
> I'd like to unblock randstruct, so what's the easiest way to move
> this? My version of changes have already landed upstream in ACPICA,
> but I don't know how frequently they get flushed back into the kernel.

Usually, when there's a new ACPICA release, but occasionally that happens
faster.

Which commit in upstream ACPICA is this?

> I can't turn on randstruct auto-selection in -next without either
> ACPICA using (or not needing) designated initializers or just
> blacklisting it in the randstruct plugin itself. I would much prefer
> the latter as the problem is solved in ACPICA upstream already but
> just isn't in the kernel yet, and I want to get testing of the
> auto-selection ASAP. Once it's in the kernel I can drop the blacklist.
> 
> Christoph: how about a middle ground where randstruct blacklists
> ACPICA in -next and if ACPICA is fixed by the time the merge window
> opens, I'll drop the blacklist. That gets the testing coverage without
> what you see as an ugly hack right now. I just really don't want to
> waste any more time on this since there are SO many other randomized
> structures I'd like to be sure are getting testing.
> 
> Alternatively, if the ACPICA folks Ack Christoph's patch, I can carry
> that in the randstruct tree for -next instead?

Maybe we can simply forward port the ACPICA commit right away.

Lv, can you take care of this, please?

Thanks,
Rafael
