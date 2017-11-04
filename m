Date: Sat, 4 Nov 2017 00:24:30 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20171104002430.GN21978@ZenIV.linux.org.uk>
References: <20171103230426.19114-1-labbott@redhat.com>
 <20171103230426.19114-2-labbott@redhat.com>
 <CAGXu5jJconGeCQbRX9XOpPo__dgDY5zdRtb5G6ce7Wih7SHyiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJconGeCQbRX9XOpPo__dgDY5zdRtb5G6ce7Wih7SHyiQ@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Subject: [kernel-hardening] Re: [RFC PATCH 2/2] x86: Allow paranoid __{get,put}_user
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 03, 2017 at 05:14:05PM -0700, Kees Cook wrote:
> > x86 turns out to be easier since the safe and unsafe paths are mostly
> > disjoint so we don't have to worry about gcc optimizing out access_ok.
> > I tweaked the Kconfig to someting a bit more generic.
> >
> > The size increase was ~8K in text with a config I tested.
> 
> Specifically, this feature would have caught the waitid() bug in 4.13
> immediately.

You mean, as soon as waitid() was given a kernel address.  At which point
you'd get a shiny way to generate a BUG(), and if something like that
happened under a mutex - it's even more fun...

> > +config PARANOID_UACCESS
> > +       bool "Use paranoid uaccess primitives"
> > +       depends on ARCH_HAS_PARANOID_UACCESS
> > +       help
> > +         Forces access_ok() checks in __get_user(), __put_user(), and other
> > +         low-level uaccess primitives which usually do not have checks. This
> > +         can limit the effect of missing access_ok() checks in higher-level
> > +         primitives, with a runtime performance overhead in some cases and a
> > +         small code size overhead.

IMO that's the wrong way to go - what we need is to reduce the amount of
__get_user()/__put_user(), rather than "instrumenting" them that way.
