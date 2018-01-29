Date: Mon, 29 Jan 2018 06:22:25 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20180129062225.GA29051@ZenIV.linux.org.uk>
References: <cover.1517164461.git.luto@kernel.org>
 <4dd5a4d0f6b694f17eaf64c80c36a2560993b9ea.1517164461.git.luto@kernel.org>
 <CA+55aFxbE6p+3kMumsTfh_E=fR=bteKi4d6WLGaFeBP8JBv_eg@mail.gmail.com>
 <20180128202128.GI13338@ZenIV.linux.org.uk>
 <CA+55aFzScvPkO0JN_OReKMoyRC5KRbn_8bmWKkxVdi9m_X+cgQ@mail.gmail.com>
 <20180128225031.GJ13338@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180128225031.GJ13338@ZenIV.linux.org.uk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Subject: [kernel-hardening] Re: [PATCH 3/3] syscalls: Add a bit of documentation to
 __SYSCALL_DEFINE
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jan 28, 2018 at 10:50:31PM +0000, Al Viro wrote:
> On Sun, Jan 28, 2018 at 12:42:24PM -0800, Linus Torvalds wrote:
> 
> > The 64-bit argument for 32-bit case would end up having to have a few
> > more of those architecture-specific oddities. So not just
> > "argument1(ptregs)", but "argument2_32_64(ptregs)" or something that
> > says "get me argument 2, when the first argument is 32-bit and I want
> > a 64-bit one".
> 
> Yeah, but...  You either get to give SYSCALL_DEFINE more than just
> the number of arguments (SYSCALL_DEFINE_WDDW) or you need to go
> for rather grotty macros to pick that information.  That's pretty
> much what I'd tried; it hadn't been fun at all...

FWIW, going through the notes from back then (with some personal
comments censored - parts of that were definitely in the actionable
territory):

------

* s390 aside, the headache comes from combination of calling conventions
for 64bit arguments on 32bit and [speculation regarding libc maintainers
qualities]

* All architectures in question[1] treat syscall arguments as either
32bit (arith types <= 32bit, pointers) or 64bit.  Prototypical case
is f(int a1, int a2, ....); let L1, L2, ... be the sequence of locations
used to pass them (might be GPR, might be stack locations).  Anything
that doesn't involve long long uses the same sequence; in theory, we could
have different sets of registers for e.g. pointers and integers, but nothing
we care about seems to be doing that.

* wrt 64bit ints there are two variants: one is to simply treat them as pair
of 32bit ones (i.e. take the next two elements of the sequence), another is
to skip an element and then use the next two.  Some architectures always
go for the first variant; x86, s390 and, surprisingly, sparc are that way.
arm, mips, parisc, ppc and tile go for the second variant when odd number
of 32bit values had been passed so far.

* argument passing for syscalls is something almost, but not entirely different.
First of all, we don't want to pass them on stack (no surprise); mips o32
ABI is trouble in that respect, everything else manages to use registers
(so do other mips ABI variants).  Next, we are generally limited to 6 words.
No worries, right?  We don't have syscalls with more than 6 arguments, and
ones with 64bit args still fit into 32*6 bits.  Too fucking bad - akpm has
introduced int sys_fadvise64(int fd, loff_t offset, size_t len, int advice)
and then topped it with
long sys_fadvise64_64(int fd, loff_t offset, loff_t len, int advice)
Note that this sucker already has 32*6 bits total *AND* 64bit argument in odd
position.  arm, mips and ppc folks were not amused (IIRC, rmk got downright
sarcastic at the time; not quite Patrician-level, what with the lack of
resources, but...)
That had been compounded by sync_file_range(2), with identical braind^WAPI.
The latter got a saner variant (sync_file_range2(2)) and newer architectures
should take that.  fadvise64_64(2) has not.  BTW, that had been a headache
for other 32bit architectures as well - at least c6x and metag are in the
same boat.  Different solutions with that one - some split those 64bit into
32bit on C level and repackage them into 64bit in stubs, some reorder the
arguments so that 64bit ones are at good offsets.

* for syscalls like pread64/pwrite64, the situation is less dire.  Some still
pass the misaligned 64bit arg as a pair of C-level 32bit ones, some accept
the padding.

* to make things even more interesting, libc (all of them) pass a bunch of
64bit args as explicit pairs.  Which creates no end of amusing situations -
will this argument of this syscall end up with LSB first?  Last?  According
to endianness?  Opposite?  Different rules for different architectures?
Onna stick.  Inna bun.  And that's cuttin' me own throat... [speculations
regarding various habits of libc maintainers]

* it might be possible to teach COMPAT_SYSCALL_DEFINE to insert padding and
combine the halves.  Cost: collecting the information about the number of
words passed so far; messy, but maybe I'm missing some clever solution.
However, that doesn't do a damn thing for libc-inflicted idiocies, so it
might or might not be worth it.  In some cases the mapping from what
libc is feeding to the kernel to actual long long passed from the glue
into C side of things is just too fucking irregular[2].

------

[1] i.e. 32bit side of biarch ones; I was interested in COMPAT_SYSCALL_DEFINE
back then.
[2] looking at that now, parisc has fanotify_mark() passing halves of 64bit
arg in the order opposite to that for truncate64().  On the same parisc.
>From the same libc.  And then there's lookup_dcookie(), which might or
might not be correct there.
