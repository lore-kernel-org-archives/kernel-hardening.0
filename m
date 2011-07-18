Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 18 Jul 2011 23:48:03 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110718194803.GA5337@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] GNU_STACK policy problem
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

I've written kernel part of PT_GNU_STACK NX enforcement for binaries and
trampolines emulation (the latter is taken from PaX as-is).  It Just
Works for both 32 and 64 bits.

But there is a major problem - it also needs support from libc to handle
DSO's GNU_STACK.  As for now, GNU_STACK of the binary is handled by the
kernel and GNU_STACK of the DSO is handled by glibc.  So, if there is
some DSO with GNU_STACK=X, which is loaded for an executable with
GNU_STACK=NX, the stack will be made =X by glibc in the runtime.  This
case is fully handled by the userspace, there is nothing kernel can
enforce.

(Unless hook mprotect and identify it is related to the stack, which is
ugly.  Btw, stacks for all threads should be altered in multi-threaded
app.).

As I've implemented it as sysctl kernel.execstack_mode, there is a
possibility to patch libc to look at this sysctl while loading a DSO (1).
However, it will not work if either procfs is not mounted (it is fully
legitimate case for simple DSO loading, e.g. for early boot tasks) or
the task is chrooted into a very restricted tree (or /proc is restricted
by some LSM).

I don't see a simple generic way to handle it as the kernel has 2
policies for GNU_STACK - if it is X and if it is completely missing.
So, libc should handle these 2 situations of DSO's according to the
kernel policy.  Some fs-free way to pass these 2 bits from kernel to
userspace is needed.

One solution I see is somehow passing this information (GNU_STACK
handling policy for 2 cases) at the task creation time.  Something like
VDSO symbol (2) or auxv entry (3).  VDSO case is complicated as IIRC now
it is global to the kernel and is not per pid namespace (I recall a
problem in OpenVZ kernel when kernel version symbol was globally removed
to fool some pid namespaces expecting new kernel).  auxv is complicated
as it is ELF ABI changing :-(

Fundamentally different way (4) - in the kernel implement trampolines
emulation only.  The policy of handling GNU_STACK is fully userspace
thing.  Store the variable in some /etc/ config file (any existing
file?).  As libc already relies on /etc/ld.so* files presence, it
shouldn't be a problem (unlike procfs).  But given we're trying to
harden mainline kernel/libc, the glibc maintainer, Ulrich Drepper,
should accept this change.  It is very unlikely, given he "supports
glibc only for the mainline kernel" and, AFAIU, he is fully satisfied
with current GNU_STACK situation.

Fallback "solution" - "recommend" distros to force GNU_STACK=NX for all
binaries and libraries via execstack(1) and implement trampolines
emulation in the kernel (with sysctl) (5).  This is bad in sense there is
*some* way to execute code on the stack (however, I might overestimate
the significance as the code is very restricted and can be executed by
ret2libc anyway).  Or "enhance" GNU_STACK to have additional value (6) -
whether trampolines should be emulated or not (this will be set by
execstack).  It might not be accepted by glibc as it is a gcc-specific
hack.

I'm not sure what to do in this situation - all solutions above are far
from ideal.  I'd be glad to hear any comments.

Thanks,

-- 
Vasiliy
