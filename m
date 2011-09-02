Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 2 Sep 2011 22:29:29 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110902182929.GA23848@openwall.com>
References: <20110812102954.GA3496@albatros> <20110812105824.GA7141@openwall.com> <20110825171934.GA3044@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825171934.GA3044@albatros>
Subject: Re: [kernel-hardening] [RFC] x86, mm: start mmap allocation for libs from low addresses
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

Some nitpicking on the patch description:

On Thu, Aug 25, 2011 at 09:19:34PM +0400, Vasiliy Kulikov wrote:
> This patch changes mmap base address allocator logic to incline to
> allocate addresses for executable pages from the first 16 Mbs of address

s/Mbs/MiB/ (or just MB, whereas Mb is sometimes used to denote megabits)

> space.  These addresses start from zero byte (0x00AABBCC).  Using such
> addresses breaks ret2libc exploits abusing string buffer overflows (or
> does it much harder).

s,does it much harder,makes such attacks harder and/or less reliable,

> As x86 architecture is little-endian, this zero byte is the last byte of
> the address.  So it's possible to e.g. overwrite a return address on the
> stack with the mailformed address.  However, now it's impossible to

s/mailformed/malformed/

> additionally overwrite function arguments, which are located after the
> function address on the stack.  The attacker's best bet may be to find
> an entry point not at function boundary that sets registers and then
> proceeds with or branches to the desired library code.  The easiest way
> to set registers and branch would be a function epilogue -
> pop/pop/.../ret - but then there's the difficulty in passing the address
> to ret to (we have just one NUL and we've already used it to get to this
> code).  Similarly, even via such pop's we can't pass an argument that
> contains a NUL in it - e.g., the address of "/bin/sh" in libc (it
> contains a NUL most significant byte too) or a zero value for root's
> uid.

The above was partially flawed logic on my part - as written above
(without further detail), the pop/pop/.../ret thing doesn't apply
because those pop's would read stack right after the just-used return
address - that is, the same stack locations that we presumably could not
write to in order to pass the arguments in a more straightforward
fashion.  So this trick would be of no help, and thus its other
limitations would be of no relevance.

However, in practice similar approaches involving function epilogues
could be of relevance.  For example, a certain build of glibc has this
instruction sequence:

mov    0xfffffff0(%ebp),%eax
lea    0xfffffff4(%ebp),%esp
pop    %ebx
pop    %esi
pop    %edi
pop    %ebp
ret

So the reads may actually be from different stack locations - perhaps on
the calling function's stack frame (since our vulnerable function likely
similarly restored %ebp prior to returning).

In practice, an exploit could try to pass these values via inputs other
than the string used to cause the overflow, if such user inputs are
available in a given program and attack vector.  These other inputs may
or may not make it difficult to pass NULs, and the number of NULs that
may be passed will vary.

Trying to explain it in detail is beyond scope of the patch description,
and we might get it partially wrong again.

I propose that we keep this portion almost as-is:

> additionally overwrite function arguments, which are located after the
> function address on the stack.  The attacker's best bet may be to find
> an entry point not at function boundary that sets registers and then
> proceeds with or branches to the desired library code.  The easiest way

with only one change - s/overwrite/provide/

However, we just end the sentence here:

"to set registers and branch would be a function epilogue."

Instead of this piece:

> pop/pop/.../ret - but then there's the difficulty in passing the address
> to ret to (we have just one NUL and we've already used it to get to this
> code).  Similarly, even via such pop's we can't pass an argument that
> contains a NUL in it - e.g., the address of "/bin/sh" in libc (it
> contains a NUL most significant byte too) or a zero value for root's
> uid.

We may write:

"Then it may be similarly difficult to reliably pass register values and
a further address to branch to, because the desired values for these
will also tend to contain NULs - e.g., the address of "/bin/sh" in libc
or a zero value for root's uid."

> A possible bypass is via multiple overflows - if the overflow may
> be triggered more than once before the vulnerable function returns, then
> multiple NULs may be written, exactly one per overflow.  But this is
> hopefully relatively rare.

This is OK to keep.

> To fully utilize the protection, the executable image should be
> randomized (sysctl kernel.randomize_va_space > 0 and the executable is
> compiled as PIE) and the sum of libraries sizes plus executable size
> shouldn't exceed 16 Mb.

Same comment re: "Mb".

> In this case the only pages out of
> ASCII-protected range are VDSO and vsyscall.  However, they don't
> provide enough material for obtaining arbitrary code execution and are
> not dangerous without using other executable pages.

I did not research this.  Perhaps you're right.

I think there are also cases when those pages are not present - e.g.,
they don't appear to be present for 32-bit processes on Owl now, both
with 32-bit and 64-bit kernels (Owl default builds).

> The logic is applied to x86 32 bit tasks, both for 32 bit kernels and
> for 32 bit tasks running on 64 bit kernels.  64 bit tasks already have
> zero bytes in addresses of library functions.  Other architectures
> (non-x86) may reuse the logic too.

OK.

> Without the patch:
> 
> $ ldd /bin/ls
> 	linux-gate.so.1 =>  (0xf779c000)
>         librt.so.1 => /lib/librt.so.1 (0xb7fcf000)
>         libtermcap.so.2 => /lib/libtermcap.so.2 (0xb7fca000)
>         libc.so.6 => /lib/libc.so.6 (0xb7eae000)
>         libpthread.so.0 => /lib/libpthread.so.0 (0xb7e5b000)
>         /lib/ld-linux.so.2 (0xb7fe6000)
> 
> With the patch:
> 
> $ ldd /bin/ls
> 	linux-gate.so.1 =>  (0xf772a000)
> 	librt.so.1 => /lib/librt.so.1 (0x0004a000)
> 	libtermcap.so.2 => /lib/libtermcap.so.2 (0x0005e000)
> 	libc.so.6 => /lib/libc.so.6 (0x00062000)
> 	libpthread.so.0 => /lib/libpthread.so.0 (0x00183000)
> 	/lib/ld-linux.so.2 (0x00121000)

Yes, we're getting output similar to the latter on Owl for i686 now
(32-bit RHEL5'ish kernel), but without linux-gate.  Ditto for -ow
patches for older kernels.

> If CONFIG_VM86=y, the first megabyte is excluded from the potential
> range for mmap allocations as it might be used by vm86 code.  If
> CONFIG_VM86=n, the allocation begins from the mmap_min_addr.  Regardless
> of CONFIG_VM86 the base address is randomized with the same entropy size
> as mm->mmap_base.

OK.  Shouldn't CONFIG_VM86 be a sysctl, though?

Does the kernel have CONFIG_VM86 already?  I thought were merely
discussed it, but you never submitted it to LKML?  If/when CONFIG_VM86
or an equivalent sysctl is added, it should also control the vm86(2) and
vm86old(2) syscalls.

> If 16 Mbs are over, we fallback to the old allocation algorithm.
> But, hopefully, programs which need such protection (network daemons,
> programs working with untrusted data, etc.) are small enough to utilize
> the protection.

OK.  Same comment about "Mbs".

> The same logic was used in -ow patch for 2.0-2.4 kernels and in
> exec-shield for 2.6.x kernels.  Code parts were taken from exec-shield
> from RHEL6.
> 
> v2 - Added comments, adjusted patch description.
>    - s/arch_get_unmapped_exec_area/get_unmapped_exec_area/
>    - Don't reserve first Mb if CONFIG_VM86=n.

s/first Mb/first 1 MiB + 64 KiB/

> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> --
>  arch/x86/mm/mmap.c       |   20 +++++++++++
>  include/linux/mm_types.h |    4 ++
>  include/linux/sched.h    |    3 ++
>  mm/mmap.c                |   82 +++++++++++++++++++++++++++++++++++++++++++---
>  4 files changed, 104 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
> index 1dab519..4e7a783 100644
> --- a/arch/x86/mm/mmap.c
> +++ b/arch/x86/mm/mmap.c
> @@ -118,6 +118,22 @@ static unsigned long mmap_legacy_base(void)
>  		return TASK_UNMAPPED_BASE + mmap_rnd();
>  }
>  
> +#ifdef CONFIG_VM86
> +/*
> + * Don't touch any memory that can be used by vm86 apps.
> + * Reserve the first Mb + 64 kb of guard pages.
> + */
> +#define ASCII_ARMOR_MIN_ADDR (0x00100000 + 0x00010000)

The extra 64 KiB are not "guard pages".  The rationale is that these
are addresses available from VM86 mode, as well as from real mode with
line A20 enabled on 286+ machines (dosemu may run DOS drivers and
programs from that era).  This was a way to get slightly more of usable
memory under DOS - IIRC, I had something like 900+ KB total DOS memory,
736 KB free after full bootup on a 386 (with proper drivers and
configuration tweaks).  Not everyone was happy with a mere 640 KB, of
which only 550 KB or so would be free after DOS bootup.

http://en.wikipedia.org/wiki/Real_mode#Addressing_capacity

"So, the actual amount of memory addressable by the 80286 and later x86
CPUs in real mode is 1 MiB + 64 KiB - 16 B = 1114096 B."

Alexander
