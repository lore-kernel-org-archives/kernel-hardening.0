Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 21 Feb 2012 21:42:45 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20120221174245.GA23759@openwall.com>
References: <20120210020658.GA17709@dztty> <20120210143616.GA6100@albatros> <20120221145653.GA22597@openwall.com> <20120221162558.GA12919@dztty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120221162558.GA12919@dztty>
Subject: Re: [kernel-hardening] procfs: infoleaks and DAC permissions
To: kernel-hardening@lists.openwall.com
Cc: Brad Spengler <spender@grsecurity.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 21, 2012 at 05:25:58PM +0100, Djalal Harouni wrote:
> On Tue, Feb 21, 2012 at 06:56:53PM +0400, Solar Designer wrote:
> > On Fri, Feb 10, 2012 at 06:36:17PM +0400, Vasiliy Kulikov wrote:
> > > [1] http://grsecurity.net/~spender/dev_patches/distros_should_sponsor_me_for_doing_their_jobs.patch
> > 
> > In order to provide its security, this relies on atomic64_t actually
> > being 64-bit and on atomic64_inc_return() returning a 64-bit value - but
> > one or both of these requirements appear to be violated for some archs.
> > 
> > In fact, per a quick grep it appears that atomic64_inc_return() exists
> > for a subset of the archs only.
> There is the GENERIC_ATOMIC64 config option that can be used to support
> atomic64_t.

Oh, I thought I could have missed something like this.  I now see that
this option is actually being forced for proper archs, such as 32-bit
PowerPC.  That's good news.

	select GENERIC_ATOMIC64 if PPC32

> I want to add that atomic64_t is already used in other places:
> xfs log functions, perf counters, netfilter conntrack modules...
> 
> That generic solution is already using raw spinlocks, but with a static
> hashed array, which is perhaps not perfect for a machine with a lot of
> CPUs ?

This is what the comment in lib/atomic64.c says, but perhaps machines
with a large number of CPUs actually have native 64-bit atomics.  For
example, if we consider PowerPC, the large machines are surely 64-bit.

OK, it looks like Brad's approach may be used as-is.

Alexander
