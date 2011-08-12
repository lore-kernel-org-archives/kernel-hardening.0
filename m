Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 12 Aug 2011 14:58:24 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110812105824.GA7141@openwall.com>
References: <20110812102954.GA3496@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110812102954.GA3496@albatros>
Subject: Re: [kernel-hardening] [RFC] x86, mm: start mmap allocation for libs from low addresses
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Fri, Aug 12, 2011 at 02:29:54PM +0400, Vasiliy Kulikov wrote:
> This patch changes mmap base address allocator logic to incline to
> allocate addresses from the first 16 Mbs of address space.  These
> addresses start from zero byte (0x00AABBCC).  Using such addresses
> breaks ret2libc exploits abusing string buffer overflows.  As library
> addresses contain zero byte, addresses of library functions may not
> present in the string, which is used to overflow the buffer.  As a
> result, it makes it impossible to change the return address on the stack
> to the address of some library function (e.g. system(3)).

JFYI, this statement is too strong.  It is usually possible to pass such
addresses because the string does terminate with a NUL and this NUL gets
written.  C string based overflows where the terminating NUL is somehow
not written are uncommon (in fact, I don't recall any).  However,
requiring NUL as the most significant byte of a 32-bit address achieves
two things:

1. The overflow length has to be inferred/guessed exactly, because only
one NUL may be written.  Simply using a repeated pattern (with function
address and arguments) no longer works.

2. Passing function arguments in the straightforward manner no longer
works, because copying stops after the NUL.  The attacker's best bet may
be to find an entry point not at function boundary that sets registers
and then proceeds with or branches to the desired library code.  The
easiest way to set registers and branch would be a function epilogue -
pop/pop/.../ret - but then there's the difficulty in passing the address
to ret to (we have just one NUL and we've already used it to get to this
code).  Similarly, even via such pop's we can't pass an argument that
contains a NUL in it - e.g., the address of "/bin/sh" in libc (it
contains a NUL most significant byte too) or a zero value for root's
uid.  A possible bypass is via multiple overflows - if the overflow may
be triggered more than once before the vulnerable function returns, then
multiple NULs may be written, exactly one per overflow.  But this is
hopefully relatively rare.

Overall, this does make exploits harder and less reliable, just not in
the exact sense of making it impossible to point the return address at
libc.

Alexander
