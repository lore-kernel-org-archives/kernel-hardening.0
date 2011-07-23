Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 23 Jul 2011 19:37:51 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110723153751.GB11156@openwall.com>
References: <20110718194803.GA5337@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110718194803.GA5337@albatros>
Subject: Re: [kernel-hardening] GNU_STACK policy problem
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Mon, Jul 18, 2011 at 11:48:03PM +0400, Vasiliy Kulikov wrote:
> I've written kernel part of PT_GNU_STACK NX enforcement for binaries and
> trampolines emulation (the latter is taken from PaX as-is).  It Just
> Works for both 32 and 64 bits.

Sounds great.

> But there is a major problem - it also needs support from libc to handle
> DSO's GNU_STACK.  As for now, GNU_STACK of the binary is handled by the
> kernel and GNU_STACK of the DSO is handled by glibc.  So, if there is
> some DSO with GNU_STACK=X, which is loaded for an executable with
> GNU_STACK=NX, the stack will be made =X by glibc in the runtime.  This
> case is fully handled by the userspace, there is nothing kernel can
> enforce.

Oops.  To me, this makes mprotect() restrictions significantly more
important.  Systems that want to enforce non-executable stack will just
enable those, even though this affects more than just the stack...

One nasty thing is that we'd be relying on glibc ignoring failure of
mprotect(), or we'd have not to indicate the failure, which would also
be nasty.

> One solution I see is somehow passing this information (GNU_STACK
> handling policy for 2 cases) at the task creation time.  Something like
> VDSO symbol (2) or auxv entry (3).  VDSO case is complicated as IIRC now
> it is global to the kernel and is not per pid namespace (I recall a
> problem in OpenVZ kernel when kernel version symbol was globally removed
> to fool some pid namespaces expecting new kernel).  auxv is complicated
> as it is ELF ABI changing :-(

I like the auxv approach.

I don't know who is the central authority to allocate new AT_* values or
AT_FLAGS bits (perhaps for Linux only) - do you?  My guess is that if we
get a couple of extra AT_FLAGS bits accepted into mainline kernels, that
will be it.

For others reading this, here's some info on auxv:

http://articles.manugarg.com/aboutelfauxiliaryvectors.html

> Fundamentally different way (4) - in the kernel implement trampolines
> emulation only.  The policy of handling GNU_STACK is fully userspace
> thing.  Store the variable in some /etc/ config file (any existing
> file?).  As libc already relies on /etc/ld.so* files presence, it
> shouldn't be a problem (unlike procfs).  But given we're trying to
> harden mainline kernel/libc, the glibc maintainer, Ulrich Drepper,
> should accept this change.  It is very unlikely, given he "supports
> glibc only for the mainline kernel" and, AFAIU, he is fully satisfied
> with current GNU_STACK situation.

This is similar to the auxv thing above in terms of glibc needing
changes, although if we get auxv accepted into mainline kernels first,
then this will be an argument for Ulrich to add the support in glibc.

For the filename, I was thinking of adding /etc/libc.conf, which would
contain other settings as well (unrelated to GNU_STACK).  The drawback
is that we'd be (very slightly) slowing down program startup.

> Fallback "solution" - "recommend" distros to force GNU_STACK=NX for all
> binaries and libraries via execstack(1) and implement trampolines
> emulation in the kernel (with sysctl) (5).  This is bad in sense there is
> *some* way to execute code on the stack (however, I might overestimate
> the significance as the code is very restricted and can be executed by
> ret2libc anyway).  Or "enhance" GNU_STACK to have additional value (6) -
> whether trampolines should be emulated or not (this will be set by
> execstack).  It might not be accepted by glibc as it is a gcc-specific
> hack.

I think this is bad primarily in another way, which you did not mention:
it only applies to distro-provided binaries and libraries.  As soon as a
user of such distro installs a third-party package, that program is left
unprotected.

> I'm not sure what to do in this situation - all solutions above are far
> from ideal.  I'd be glad to hear any comments.

I vote for AT_FLAGS.

Thanks,
 
Alexander
