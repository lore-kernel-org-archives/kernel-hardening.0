Date: Wed, 14 Jun 2017 14:36:56 +0200
From: Solar Designer <solar@openwall.com>
Message-ID: <20170614123656.GA18554@openwall.com>
References: <20170608034349.31876-1-matt@nmatt.com> <20170608034349.31876-2-matt@nmatt.com> <CAGXu5jLsrTZV_xDR_MPZdkT44P1MpbDiF3Kk2HNWBXKsdY+fzg@mail.gmail.com> <94ba5ebb-952b-2037-799e-07306629a6f9@nmatt.com> <20170613212704.GA16726@openwall.com> <25278a42-736e-0d3b-8c0a-7b2b05ed7d28@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25278a42-736e-0d3b-8c0a-7b2b05ed7d28@digikod.net>
Subject: Re: [kernel-hardening] Re: [PATCH v2 1/1] Add Trusted Path Execution as a stackable LSM
To: Micka??l Sala??n <mic@digikod.net>
Cc: Matt Brown <matt@nmatt.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 14, 2017 at 01:53:56AM +0200, Micka??l Sala??n wrote:
> On 13/06/2017 23:27, Solar Designer wrote:
> > Interpreters are only a tip of the iceberg.
> > 
> > With TPE, every program invocation becomes similar to a SUID/SGID one as
> > it relates to TPE's newly introduced security barrier.  However, the
> > dynamic linker and libc have no idea of this, and will happily grant
> > arbitrary code execution in context of those programs via LD_PRELOAD and
> > such.  Even if this is somehow dealt with (how would you do that in the
> > kernel alone? filter typical env var names? it quickly becomes way too
> > hackish and blacklistish, thus imperfect), then there's still:
> 
> What about using the AT_SECURE auxv (cf. security_bprm_secureexec)?

You're right, I was wrong.  For kernel/ld.so/libc communication, this
case is no different from fscaps.  So no need for hacks and blacklists,
and AT_SECURE will work just as well (or as poorly, if a userspace
component on a given system does the old-fashioned euid and egid check
only, like some third-party libraries do before trusting env vars).
So it's not a TPE-specific issue, and the TPE patch or module may take
care of it as you suggest.

So this is something Matt will want to implement.  I see that Alan also
brought up the LD_PRELOAD argument, and this would address it.

> > I think many, and maybe most, binaries on a system will contain buffer
> > overflows and such that also allow for arbitrary code execution.  Those
> 
> Enforcing W^X (cf. tpe.memory xattr) mitigate this threat.

Mitigates yes, eliminates no.

> > programs were not written as carefully as SUID/SGID ones are supposed to
> > be.  They don't treat their input and environment as untrusted.
> 
> Sure, but perfect is the enemy of good. Having a kernel enforcing TPE is
> a good argument to convince userland to be hardened against untrusted
> input. ;) For example, thanks to PaX, the Gentoo Hardened community
> patched a lot of userland programs to make them compatible with PIE and
> other security features.

If TPE results in some programs becoming more robust (have we seen it
happening because of TPE specifically? I think not), that would be a
good thing on its own.  However, I doubt that non-trivial Linux
distros/installs will ever have a shortage of TPE bypasses.

> > The real big issue is that TPE
> > is either inherently fairly easily bypassable (and should be documented
> > as such) via many of the installed programs (by far not just explicit
> > interpreters, but also any programs containing "weird machines", which
> > is probably most non-trivial programs out there, and some trivial ones),
> > or it relies on all programs in the trusted paths being written as if
> > they were SUID/SGID (unrealistic for non-trivial systems).
> 
> Right, this is the most complex part, but we should start somewhere. :)
> This kind of machine can not be constrain by the kernel, only by the
> programs themselves. We need them to honor the AT_SECURE.

For many libraries, yes, we need them to honor AT_SECURE, although the
current way to achieve that appears to be to have glibc export its
__libc_enable_secure and to have it tested by other libraries like
OpenSSL's.  That's what we did in Owl years ago.  Another way would be
for Linux libc's to provide OpenBSD's issetugid(), like musl already
does.  This would make some portable projects like OpenSSL pick it up.

As to all programs honoring AT_SECURE, I think that's too much to ask,
and is unreasonable.

Alexander
