Date: Tue, 17 Apr 2018 22:20:18 +0200
From: Solar Designer <solar@openwall.com>
Subject: Re: mmap flags
Message-ID: <20180417202018.GA11018@openwall.com>
References: <20180417193145.GA10528@openwall.com> <CAG48ez2UjVxD_ZryiFRVTQir58ZNXsDjGPU3cTk5fugN+shzXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez2UjVxD_ZryiFRVTQir58ZNXsDjGPU3cTk5fugN+shzXw@mail.gmail.com>
To: Jann Horn <jannh@google.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 17, 2018 at 09:37:43PM +0200, Jann Horn wrote:
> On Tue, Apr 17, 2018 at 9:31 PM, Solar Designer <solar@openwall.com> wrote:
> > I'd like to have two new security-related mmap() flags on Linux:
> >
> > 1. MAP_NOCORE - same as FreeBSD already has, "Region is not included in
> > a core file." per their man page.  We can now do similar by writing a
> > bitmask into /proc/<pid>/coredump_filter, but it's cumbersome (not
> > something a library would be OK doing because of its one security
> > sensitive and/or very large mapping needing this), low granularity (not
> > per mapping), and non-portable (MAP_NOCORE would be portable at least
> > between Linux and FreeBSD).
> 
> Linux already has madvise(addr, len, MADV_DONTDUMP):
> http://man7.org/linux/man-pages/man2/madvise.2.html

Oh, missed it.  Thanks!

Maybe introduce MAP_NOCORE as well, for easier use and for compatibility
with FreeBSD?  Should be trivial with MADV_DONTDUMP already in there.

> > 2. MAP_ZEROIZE (or whatever we call it) - zeroize the pages on unmap
> > (but not necessarily before the munmap() syscall returns), including on
> > [abnormal] process exit

Maybe MAP_WIPEONUNMAP and MADV_WIPEONUNMAP, for similarity with the
existing MADV_WIPEONFORK?

Alexander
