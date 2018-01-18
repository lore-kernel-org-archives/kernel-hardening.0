Date: Thu, 18 Jan 2018 08:38:18 -0800
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20180118163818.GB16649@infradead.org>
References: <151586744180.5820.13215059696964205856.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151586748981.5820.14559543798744763404.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFzoAR+MYX+ub0xZ32OsT7WtD5Kru2t6LhwB1buLWPResQ@mail.gmail.com>
 <CA+55aFxsg5+u7bCHj1N8xyyVf7-RMm-5ACNp=ENNrKL78omaow@mail.gmail.com>
 <CAPcyv4hfUx8gLScuNewY3+BWi4YBS_Z9dhvYf1D+WEWDDCShXA@mail.gmail.com>
 <CA+55aFxAFG5czVmCyhYMyHmXLNJ7pcXxWzusjZvLRh_qTGHj6Q@mail.gmail.com>
 <CA+55aFxB01XEEpdPynwYmzQMfTJdJnUrN+ZLqSV_UdnKLBgAZw@mail.gmail.com>
 <1516198646.4184.13.camel@linux.intel.com>
 <CA+55aFzCgqjRR=x37fzUecK5ERMBUmBOag-EpM1zQQxFeH2+bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzCgqjRR=x37fzUecK5ERMBUmBOag-EpM1zQQxFeH2+bw@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v3 8/9] x86: use __uaccess_begin_nospec and ASM_IFENCE in
 get_user paths
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>, Eric Dumazet <edumazet@google.com>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 17, 2018 at 11:26:08AM -0800, Linus Torvalds wrote:
> But there are about ~100 set_fs() calls in generic code, and some of
> those really are pretty fundamental. Doing things like "kernel_read()"
> without set_fs() is basically impossible.

Not if we move to iov_iter or iov_iter-like behavior for all reads
and writes.  There is an issue with how vectored writes are handles
in plain read/write vs read_iter/write_iter inherited from readv/writev,
but that's nothing a flag, or a second set of methods with the
same signature.

But there are more annoying things, most notable in-kernel ioctls
calls.  We have quite a few of them, and while many are just utterly
stupid and can be replaced with direct function calls or new methods
(I've done quite a few conversions of those) some might be left.
Something like iov_iter might be the answer again.

Then we have things like probe_kernel_read/probe_kernel_write which
abuse the exception handling in get/put user.  But with a little
arch helper we don't strictly need get_fs/set_fs for that.
