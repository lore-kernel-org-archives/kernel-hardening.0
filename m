MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20180118163818.GB16649@infradead.org>
References: <151586744180.5820.13215059696964205856.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151586748981.5820.14559543798744763404.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFzoAR+MYX+ub0xZ32OsT7WtD5Kru2t6LhwB1buLWPResQ@mail.gmail.com>
 <CA+55aFxsg5+u7bCHj1N8xyyVf7-RMm-5ACNp=ENNrKL78omaow@mail.gmail.com>
 <CAPcyv4hfUx8gLScuNewY3+BWi4YBS_Z9dhvYf1D+WEWDDCShXA@mail.gmail.com>
 <CA+55aFxAFG5czVmCyhYMyHmXLNJ7pcXxWzusjZvLRh_qTGHj6Q@mail.gmail.com>
 <CA+55aFxB01XEEpdPynwYmzQMfTJdJnUrN+ZLqSV_UdnKLBgAZw@mail.gmail.com>
 <1516198646.4184.13.camel@linux.intel.com> <CA+55aFzCgqjRR=x37fzUecK5ERMBUmBOag-EpM1zQQxFeH2+bw@mail.gmail.com>
 <20180118163818.GB16649@infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Jan 2018 08:49:31 -0800
Message-ID: <CA+55aFxw2CtC_28-7Renuzxfu0zegfCHv+QX-ng4NxUrBRhyXA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v3 8/9] x86: use __uaccess_begin_nospec and ASM_IFENCE in
 get_user paths
To: Christoph Hellwig <hch@infradead.org>
Cc: Alan Cox <alan@linux.intel.com>, Eric Dumazet <edumazet@google.com>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 18, 2018 at 8:38 AM, Christoph Hellwig <hch@infradead.org> wrote:
>
> > But there are about ~100 set_fs() calls in generic code, and some of
> > those really are pretty fundamental. Doing things like "kernel_read()"
> > without set_fs() is basically impossible.
>
> Not if we move to iov_iter or iov_iter-like behavior for all reads
> and writes.

Not going to happen. Really. We have how many tens of thousands of
drivers again, all doing "copy_to_user()".

And the fact is, set_fs() really isn't even a problem for this. Never
really has been.   From a security standpoint, it would actually be
*much* worse if we made those ten thousand places do "if (kernel_flag)
memcpy() else copy_to_user()".

We've had some issues with set_fs() being abused in interesting ways.
But "kernel_read()" and friends is not it.

               Linus
