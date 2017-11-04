Date: Sat, 4 Nov 2017 01:58:05 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20171104015805.o6kkoydzn7kfhiav@salmiak>
References: <20171103230426.19114-1-labbott@redhat.com>
 <20171103230426.19114-2-labbott@redhat.com>
 <CAGXu5jJconGeCQbRX9XOpPo__dgDY5zdRtb5G6ce7Wih7SHyiQ@mail.gmail.com>
 <20171104002430.GN21978@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171104002430.GN21978@ZenIV.linux.org.uk>
Subject: [kernel-hardening] Re: [RFC PATCH 2/2] x86: Allow paranoid __{get,put}_user
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Nov 04, 2017 at 12:24:30AM +0000, Al Viro wrote:
> On Fri, Nov 03, 2017 at 05:14:05PM -0700, Kees Cook wrote:
> > > x86 turns out to be easier since the safe and unsafe paths are mostly
> > > disjoint so we don't have to worry about gcc optimizing out access_ok.
> > > I tweaked the Kconfig to someting a bit more generic.
> > >
> > > The size increase was ~8K in text with a config I tested.
> > 
> > Specifically, this feature would have caught the waitid() bug in 4.13
> > immediately.
> 
> You mean, as soon as waitid() was given a kernel address.  At which point
> you'd get a shiny way to generate a BUG(), and if something like that
> happened under a mutex - it's even more fun...

FWIW, on the arm64 version I'd used BUG() since my initial focus was fuzzing.

We can make this safe for hardening by returning -EFAULT instead.

> > > +config PARANOID_UACCESS
> > > +       bool "Use paranoid uaccess primitives"
> > > +       depends on ARCH_HAS_PARANOID_UACCESS
> > > +       help
> > > +         Forces access_ok() checks in __get_user(), __put_user(), and other
> > > +         low-level uaccess primitives which usually do not have checks. This
> > > +         can limit the effect of missing access_ok() checks in higher-level
> > > +         primitives, with a runtime performance overhead in some cases and a
> > > +         small code size overhead.
> 
> IMO that's the wrong way to go - what we need is to reduce the amount of
> __get_user()/__put_user(), rather than "instrumenting" them that way.

Certainly that's where we want to get to.

However, in the mean time, I'd argue that there's little downside to providing
the option to check the nominally unchecked primitives, provided this is
optional.

In investigating this for arm/arm64, I found at least one other bug. I would
not be surprised to find that I had missed others, nor would I be surprised to
find that new bugs get introduced in future.

Thanks,
Mark.
