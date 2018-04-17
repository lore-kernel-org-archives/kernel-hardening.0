MIME-Version: 1.0
In-Reply-To: <20180417193145.GA10528@openwall.com>
References: <20180417193145.GA10528@openwall.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 17 Apr 2018 21:37:43 +0200
Message-ID: <CAG48ez2UjVxD_ZryiFRVTQir58ZNXsDjGPU3cTk5fugN+shzXw@mail.gmail.com>
Subject: Re: mmap flags
Content-Type: text/plain; charset="UTF-8"
To: Solar Designer <solar@openwall.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 17, 2018 at 9:31 PM, Solar Designer <solar@openwall.com> wrote:
> Hi,
>
> I'd like to have two new security-related mmap() flags on Linux:
>
> 1. MAP_NOCORE - same as FreeBSD already has, "Region is not included in
> a core file." per their man page.  We can now do similar by writing a
> bitmask into /proc/<pid>/coredump_filter, but it's cumbersome (not
> something a library would be OK doing because of its one security
> sensitive and/or very large mapping needing this), low granularity (not
> per mapping), and non-portable (MAP_NOCORE would be portable at least
> between Linux and FreeBSD).

Linux already has madvise(addr, len, MADV_DONTDUMP):
http://man7.org/linux/man-pages/man2/madvise.2.html

> 2. MAP_ZEROIZE (or whatever we call it) - zeroize the pages on unmap
> (but not necessarily before the munmap() syscall returns), including on
> [abnormal] process exit, which is good for security (if the data is
> sensitive) and also for performance (the program doesn't have to do the
> zeroization on its own and either wait for it to complete or spawn a
> thread, but instead can trivially defer this work to be done by the
> kernel a bit later; also, a subsequent mmap() with MAP_POPULATE, or
> corresponding memory accesses if without MAP_POPULATE, can complete
> quicker due to the lazily-zeroized pages).
>
> I'd use both for yescrypt.  In fact, I learned of FreeBSD's MAP_NOCORE
> from scrypt, so indeed yescrypt already uses it where available, too.
>
> I'd also like SHM_* equivalents of these.  And a SHM_POPULATE too, but
> that's purely for performance (not security), so is off-topic here.
> I'd use those for yescrypt ROMs.
>
> Perhaps the zeroization can build upon a common framework also
> supporting a sysctl where it's forced on all (or only ever writable?)
> mappings of all processes, without them requesting it explicitly.  It's
> just set the flag on all mappings (few systems will) vs. only on some
> (few libraries and programs will, but hopefully those where it's needed
> the most).  This would reduce total complexity of the implementation.
>
> Not hardening of the kernel (in fact, there's a risk we'd introduce bugs
> at first), but helping harden the userland.
>
> I'm just posting this in case anyone capable has time and willingness
> to work on this.
>
> Alexander
