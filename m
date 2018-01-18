Date: Thu, 18 Jan 2018 18:12:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20180118181218.GB13338@ZenIV.linux.org.uk>
References: <151586748981.5820.14559543798744763404.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFzoAR+MYX+ub0xZ32OsT7WtD5Kru2t6LhwB1buLWPResQ@mail.gmail.com>
 <CA+55aFxsg5+u7bCHj1N8xyyVf7-RMm-5ACNp=ENNrKL78omaow@mail.gmail.com>
 <CAPcyv4hfUx8gLScuNewY3+BWi4YBS_Z9dhvYf1D+WEWDDCShXA@mail.gmail.com>
 <CA+55aFxAFG5czVmCyhYMyHmXLNJ7pcXxWzusjZvLRh_qTGHj6Q@mail.gmail.com>
 <CA+55aFxB01XEEpdPynwYmzQMfTJdJnUrN+ZLqSV_UdnKLBgAZw@mail.gmail.com>
 <1516198646.4184.13.camel@linux.intel.com>
 <CA+55aFzCgqjRR=x37fzUecK5ERMBUmBOag-EpM1zQQxFeH2+bw@mail.gmail.com>
 <20180118163818.GB16649@infradead.org>
 <CA+55aFxw2CtC_28-7Renuzxfu0zegfCHv+QX-ng4NxUrBRhyXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxw2CtC_28-7Renuzxfu0zegfCHv+QX-ng4NxUrBRhyXA@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Subject: [kernel-hardening] Re: [PATCH v3 8/9] x86: use __uaccess_begin_nospec and ASM_IFENCE in
 get_user paths
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@linux.intel.com>, Eric Dumazet <edumazet@google.com>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 18, 2018 at 08:49:31AM -0800, Linus Torvalds wrote:
> On Thu, Jan 18, 2018 at 8:38 AM, Christoph Hellwig <hch@infradead.org> wrote:
> >
> > > But there are about ~100 set_fs() calls in generic code, and some of
> > > those really are pretty fundamental. Doing things like "kernel_read()"
> > > without set_fs() is basically impossible.
> >
> > Not if we move to iov_iter or iov_iter-like behavior for all reads
> > and writes.
> 
> Not going to happen. Really. We have how many tens of thousands of
> drivers again, all doing "copy_to_user()".

The real PITA is not even that (we could provide helpers making
conversion from ->read() to ->read_iter() easy for char devices,
etc.).  It's the semantics of readv(2).  Consider e.g. readv()
from /dev/rtc, with iovec array consisting of 10 segments, each
int-sized.  Right now we'll get rtc_dev_read() called in a loop,
once for each segment.  Single read() into 40-byte buffer will
fill one long and bugger off.  Converting it to ->read_iter()
will mean more than just "use copy_to_iter() instead of put_user()" -
that would be trivial.  But to preserve the current behaviour
we would need something like
	total = 0;
	while (iov_iter_count(to)) {
		count = iov_iter_single_seg_count(to);
		/* current body of rtc_dev_read(), with
		 * put_user() replaced with copy_to_iter()
		 */
		....
		if (res < 0) {
			if (!total)
				total = res;
			break;
		}
		total += res;
		if (res != count)
			break;
	}
	return total;
in that thing.  And similar boilerplates would be needed in
a whole lot of drivers.  Sure, they are individually trivial,
but they would add up to shitloads of code to get wrong.

These are basically all ->read() instances that ignore *ppos
and, unlike pipes, do not attempt to fill as much of the
buffer as possible.  We do have quite a few of such.

Some ->read() instances can be easily converted to ->read_iter()
and will, in fact, be better off that way.  We had patches of
that sort and I'm certain that we still have such places left.
Ditto for ->write() and ->write_iter().  But those are not
even close to being the majority.  Sorry.

We could, in principle, do something like

dev_rtc_read_iter(iocb, to)
{
	return loop_read_iter(iocb, to, modified_dev_rtc_read);
}
with modified_dev_rtc_read() being the result of minimal
conversion (put_user() and copy_to_user() replaced with used
of copy_to_iter()).  It would be less boilerplate that way,
but I really don't see big benefits from doing that.

On the write side the things are just as unpleasant - we have
a lot of ->write() instances that parse the beginning of the
buffer, ignore the rest and report that everything got written.
writev() on those will parse each iovec segment, ignoring the
junk in the end of each.  Again, that loop needs to go somewhere.
And we do have a bunch of "parse the buffer and do some action
once" ->write() instances - in char devices, debugfs, etc.
