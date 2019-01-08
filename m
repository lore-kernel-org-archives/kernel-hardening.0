MIME-Version: 1.0
References: <20190102093137.17136-1-yanaijie@huawei.com> <CAG48ez3_oMX7Nzjaa4=QzipQ7i-BOOVojY5WVBNOBw0RZeik=g@mail.gmail.com>
In-Reply-To: <CAG48ez3_oMX7Nzjaa4=QzipQ7i-BOOVojY5WVBNOBw0RZeik=g@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 8 Jan 2019 15:54:05 -0800
Message-ID: <CAGXu5jLGbAr9JLo=FtvSSF+EdTcj1J04PUUi65tY97zpdUAkRQ@mail.gmail.com>
Subject: Re: [PATCH] usercopy: skip the check if not a real usercopy
Content-Type: text/plain; charset="UTF-8"
To: Jann Horn <jannh@google.com>
Cc: Jason Yan <yanaijie@huawei.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, zhaohongjiang@huawei.com, miaoxie@huawei.com, Li Bin <huawei.libin@huawei.com>, Wei Yongjun <weiyongjun1@huawei.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 3, 2019 at 1:36 AM Jann Horn <jannh@google.com> wrote:
>
> On Wed, Jan 2, 2019 at 12:10 PM Jason Yan <yanaijie@huawei.com> wrote:
> > Some kernel codes use copy_to/from_user to copy data between kernel
> > buffers by calling set_fs(KERNEL_DS). Hardened usercopy will check these
> > objects and sometimes soft lockup may happen as follows:
> >
> > [   96.314420] watchdog: BUG: soft lockup - CPU#4 stuck for 22s! [sh:356]
> > ......
> > [   96.674904] Call Trace:
> > [   96.684489]  __check_object_size+0x1f1/0x460
> > [   96.691669]  __probe_kernel_write+0x195/0x390
> > [   96.696821]  ftrace_write+0x67/0xa0
>
> I think it makes sense to focus on the __probe_kernel_write(), not the
> KERNEL_DS.
>
> >
> > It's unnecessary to check these objects for copying between kernel buffers.
> > So skip all hardened usercopy tests.
> >
> > Signed-off-by: Jason Yan <yanaijie@huawei.com>
> > CC: Li Bin <huawei.libin@huawei.com>
> > CC: Wei Yongjun <weiyongjun1@huawei.com>
> > ---
> >  mm/usercopy.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/mm/usercopy.c b/mm/usercopy.c
> > index 852eb4e53f06..8a0a1854f564 100644
> > --- a/mm/usercopy.c
> > +++ b/mm/usercopy.c
> > @@ -23,6 +23,7 @@
> >  #include <linux/atomic.h>
> >  #include <linux/jump_label.h>
> >  #include <asm/sections.h>
> > +#include <linux/uaccess.h>
> >
> >  /*
> >   * Checks if a given pointer and length is contained by the current
> > @@ -255,6 +256,10 @@ void __check_object_size(const void *ptr, unsigned long n, bool to_user)
> >         if (static_branch_unlikely(&bypass_usercopy_checks))
> >                 return;
> >
> > +       /* Skip all tests if it is not a real usercopy. */
> > +       if (uaccess_kernel())
> > +               return;
> > +
> >         /* Skip all tests if size is zero. */
> >         if (!n)
> >                 return;
>
> As an alternative, maybe it would make sense to only do this when the
> access is coming through __probe_kernel_read() and
> __probe_kernel_write()? These functions are specifically for accessing
> arbitrary kernel memory, including via things like kcore and kgdb; so
> I don't think usercopy restrictions make sense for them. I'm actually
> surprised that people haven't complained about this earlier.
>
> I had to do something similar for my "complain on kernel pagefault in
> usercopy code" series, by adding the per-task number
> "kernel_uaccess_faults_ok" and incrementing/decrementing it in
> __probe_kernel_{read,write}; see commit
> 9da3f2b74054406f87dff7101a569217ffceb29b.

I would think we'd still want to be performing bounds-checking even in
the kernel-to-kernel case. It seems like there is some other issue
here? Why would the check stall?

Can you find out from your build what your top-of-dump line this
resolves to? (My various kernel version builds don't share the same
function size, so this doesn't resolve for me...)

$ ./scripts/faddr2line vmlinux __check_object_size+0x1f1/0x460

Maybe it's getting stuck in loop doing stack frame walking? I'd expect
that to show up in the backtrace though (since it's noinline).

-- 
Kees Cook
