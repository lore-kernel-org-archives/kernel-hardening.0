Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 20 Nov 2015 14:16:33 -0500
From: Rich Felker <dalias@libc.org>
Message-ID: <20151120191632.GX3818@brightrain.aerifal.cx>
References: <564EF64F.1060903@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <564EF64F.1060903@redhat.com>
Sender: Rich Felker <dalias@aerifal.cx>
Subject: Re: [kernel-hardening] System call interface changes
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 20, 2015 at 11:30:39AM +0100, Florian Weimer wrote:
> Not sure if this in scope for this list.  If not, please say so.
> 
> Currently, the system call interface to user space expects the system
> call number in a register (on i386 and x86_64, and probably most other
> architectures).  This means that once you have a system call instruction
> in the process image, it can be theoretically used to run *any* system
> call, including ones that are not actually referenced in the binary.  As
> a result, you need seccomp or a Linux security module to interdict
> certain system calls.
> 
> This would have to be an opt-in feature, obviously, and applications
> would have to opt in explicitly via some ELF flag (similar to what we
> did for non-executable stacks).

I don't think that's necessary. The application (or for typical
dynamic linking, just the build of libc.so) would just need to refrain
from using the parameterized syscall so that the old opcode would not
appear in its executable mappings.

> Do you think it would be feasible to encode the system call number in
> the instruction stream instead, next to the instruction?  I think this

This was done on ARM in the old pre-EABI ABI, and it turned out to be
a bad design, at least from standpoints other than security. Reading
the syscall number out of the instruction stream was more expensive,
incompatible with syscall() (which ended up requiring a special
SYS_syscall that needed messy argument conventions), and incompatible
with reasonable userspace coding of syscalls using inline functions
rather than macros, where you would have to rely on constant
propagation optimizations to be able to satisfy asm constraints. See
how we're currently doing syscall asm for mips in musl:

http://git.musl-libc.org/cgit/musl/tree/arch/mips/syscall_arch.h

The "ir" constraint allows the compiler to use an immediate if
constant propagation succeeds, but also allows the syscall number in a
register if it doesn't.

I think your idea is also problematic for syscall restart when the
kernel needs to arrange for a special restartblock to be used rather
than the original syscall, since the kernel would have no way of
storing that state (or if there were a way to store that, userspace
could exploit it to make its own restartblocks for the sake of
executing arbitrary syscalls).

Rich
