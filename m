MIME-Version: 1.0
In-Reply-To: <CA+55aFzCgqjRR=x37fzUecK5ERMBUmBOag-EpM1zQQxFeH2+bw@mail.gmail.com>
References: <151586744180.5820.13215059696964205856.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151586748981.5820.14559543798744763404.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFzoAR+MYX+ub0xZ32OsT7WtD5Kru2t6LhwB1buLWPResQ@mail.gmail.com>
 <CA+55aFxsg5+u7bCHj1N8xyyVf7-RMm-5ACNp=ENNrKL78omaow@mail.gmail.com>
 <CAPcyv4hfUx8gLScuNewY3+BWi4YBS_Z9dhvYf1D+WEWDDCShXA@mail.gmail.com>
 <CA+55aFxAFG5czVmCyhYMyHmXLNJ7pcXxWzusjZvLRh_qTGHj6Q@mail.gmail.com>
 <CA+55aFxB01XEEpdPynwYmzQMfTJdJnUrN+ZLqSV_UdnKLBgAZw@mail.gmail.com>
 <1516198646.4184.13.camel@linux.intel.com> <CA+55aFzCgqjRR=x37fzUecK5ERMBUmBOag-EpM1zQQxFeH2+bw@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 17 Jan 2018 12:01:35 -0800
Message-ID: <CANn89i+JXg0YfGJeBN2wDpNqVr1g6AKQ1WbSCjdpXmSWjWcAPQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v3 8/9] x86: use __uaccess_begin_nospec and ASM_IFENCE in
 get_user paths
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 17, 2018 at 11:26 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Jan 17, 2018 at 6:17 AM, Alan Cox <alan@linux.intel.com> wrote:
>>
>> Can we kill off the remaining users of set_fs() ?
>
> I would love to, but it's not going to happen short-term. If ever.
>
> Some could be removed today: the code in arch/x86/net/bpf_jit_comp.c
> seems to be literally the ramblings of a diseased mind. There's no
> reason for the set_fs(), there's no reason for the
> flush_icache_range() (it's a no-op on x86 anyway), and the smp_wmb()
> looks bogus too.
>
> I have no idea how that braindamage happened, but I assume it got
> copied from some broken source.

At the time commit 0a14842f5a3c0e88a1e59fac5c3025db39721f74 went in,
this was the first JIT implementation for BPF, so maybe I wanted to avoid
other arches to forget to flush icache : You bet that my implementation served
as a reference for other JIT.

At that time, various calls to flush_icache_range() were definitely in arch/x86
or kernel/module.c

(I believe I must have copied the code from kernel/module.c, but that
I am not sure)

>
> But there are about ~100 set_fs() calls in generic code, and some of
> those really are pretty fundamental. Doing things like "kernel_read()"
> without set_fs() is basically impossible.
>
> We've had set_fs() since the beginning. The naming is obviously very
> historical. We have it for a very good reason, and I don't really see
> that reason going away.
>
> So realistically, we want to _minimize_ set_fs(), and we might want to
> make sure that it's done only in limited settings (it might, for
> example, be a good idea and a realistic goal to make sure that drivers
> and modules can't do it, and use proper helper functions like that
> "read_kernel()").
>
> But getting rid of the concept entirely? Doesn't seem likely.
>
>              Linus
