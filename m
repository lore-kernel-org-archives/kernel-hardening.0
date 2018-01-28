Date: Sun, 28 Jan 2018 20:21:28 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20180128202128.GI13338@ZenIV.linux.org.uk>
References: <cover.1517164461.git.luto@kernel.org>
 <4dd5a4d0f6b694f17eaf64c80c36a2560993b9ea.1517164461.git.luto@kernel.org>
 <CA+55aFxbE6p+3kMumsTfh_E=fR=bteKi4d6WLGaFeBP8JBv_eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxbE6p+3kMumsTfh_E=fR=bteKi4d6WLGaFeBP8JBv_eg@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Subject: [kernel-hardening] Re: [PATCH 3/3] syscalls: Add a bit of documentation to
 __SYSCALL_DEFINE
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jan 28, 2018 at 11:15:15AM -0800, Linus Torvalds wrote:
> Is that "long long" part of the example on purpose? Because that's
> likely the only really nasty part about any ptregs wrapper: some
> arguments aren't _one_ register, they are two. And "long long" is the
> simplest example, even though in practice the type is most often
> "loff_t".
> 
> You won't see this on 64-bit architectures, but it's visible on 32-bit ones.
> 
> We may have to do wrappers for those, and error out for 'long long'.
> We already do that for some cases, for compat system calls. See for
> example
> 
> COMPAT_SYSCALL_DEFINE5(preadv, compat_ulong_t, fd,
>                 const struct compat_iovec __user *,vec,
>                 compat_ulong_t, vlen, u32, pos_low, u32, pos_high)
> {
>         loff_t pos = ((loff_t)pos_high << 32) | pos_low;
> 
>         return do_compat_preadv64(fd, vec, vlen, pos, 0);
> }
> 
> where we have the issue of a 64-bit value being split over two
> registers even on 64-bit, due to it being a compat interface for 32
> bit.
> 
> But if we pick up the values by hand from ptregs in a wrapper, we'll
> have this issue even for native calls on 32-bit.

... and have more of that logics arch-dependent than one might expect;
it's *not* just "split each 64bit argument into a pair of 32bit ones,
combine in the body".  I tried to do something to reduce the amount of
remaining wrappers several years ago.  Trying to automate that gets
very ugly very fast - there are architectures like mips where you get
alignment requirements ($6/$7 can hold that, $5/$6 can't), creating
padding arguments, etc.

FWIW, that affects
	lookup_dcookie() (64,32,32)
	truncate64(), ftruncate64() (32,64)
	fadvise64_64(), sync_file_range() (32,64,64,32)
	readahead() (32,64,32)
	fadvise64() (32,64,32,32)
	fallocate(), sync_file_range2() (32,32,64,64)
	fanotify_mark() (32,32,64,32,32)
	pread64(), pwrite64() (32,32,32,64)

Giving each of those a compat wrapper of its own is already annoying
(looking at that again, we should at least unify pread64() and pwrite64()
compat wrappers - grep for sys_pread64 and you'll see), but giving
each an explicit wrapper for native ones?  Ouch.
