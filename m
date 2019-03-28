MIME-Version: 1.0
References: <20190327145331.215360-1-joel@joelfernandes.org> <CAGXu5j+nhsL_s36R0k5APUfP6cNiH-BGEJu6mV6UcsP0i3gtyA@mail.gmail.com>
In-Reply-To: <CAGXu5j+nhsL_s36R0k5APUfP6cNiH-BGEJu6mV6UcsP0i3gtyA@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 28 Mar 2019 01:59:45 +0100
Message-ID: <CAG48ez1vZ5cngEKVtWTL9rz_K8K25b1sMKYrNs+jn4Va3KYucw@mail.gmail.com>
Subject: Re: [PATCH] Convert struct pid count to refcount_t
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>, LKML <linux-kernel@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, Oleg Nesterov <oleg@redhat.com>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 28, 2019 at 1:06 AM Kees Cook <keescook@chromium.org> wrote:
> On Wed, Mar 27, 2019 at 7:53 AM Joel Fernandes (Google)
> <joel@joelfernandes.org> wrote:
> >
> > struct pid's count is an atomic_t field used as a refcount. Use
> > refcount_t for it which is basically atomic_t but does additional
> > checking to prevent use-after-free bugs. No change in behavior if
> > CONFIG_REFCOUNT_FULL=n.
> >
> > Cc: keescook@chromium.org
> > Cc: kernel-team@android.com
> > Cc: kernel-hardening@lists.openwall.com
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > [...]
> > diff --git a/kernel/pid.c b/kernel/pid.c
> > index 20881598bdfa..2095c7da644d 100644
> > --- a/kernel/pid.c
> > +++ b/kernel/pid.c
> > @@ -37,7 +37,7 @@
> >  #include <linux/init_task.h>
> >  #include <linux/syscalls.h>
> >  #include <linux/proc_ns.h>
> > -#include <linux/proc_fs.h>
> > +#include <linux/refcount.h>
> >  #include <linux/sched/task.h>
> >  #include <linux/idr.h>
> >
> > @@ -106,8 +106,8 @@ void put_pid(struct pid *pid)
> >                 return;
> >
> >         ns = pid->numbers[pid->level].ns;
> > -       if ((atomic_read(&pid->count) == 1) ||
> > -            atomic_dec_and_test(&pid->count)) {
> > +       if ((refcount_read(&pid->count) == 1) ||
> > +            refcount_dec_and_test(&pid->count)) {
>
> Why is this (and the original code) safe in the face of a race against
> get_pid()? i.e. shouldn't this only use refcount_dec_and_test()? I
> don't see this code pattern anywhere else in the kernel.

Semantically, it doesn't make a difference whether you do this or
leave out the "refcount_read(&pid->count) == 1". If you read a 1 from
refcount_read(), then you have the only reference to "struct pid", and
therefore you want to free it. If you don't get a 1, you have to
atomically drop a reference, which, if someone else is concurrently
also dropping a reference, may leave you with the last reference (in
the case where refcount_dec_and_test() returns true), in which case
you still have to take care of freeing it.

My guess is that the goal of this is to make the "drop last reference"
case a little bit faster by avoiding the cacheline dirtying and the
atomic op, at the expense of an extra memory op and branch every time
we drop a non-final reference. But that's a pretty low-level
optimization, and forking by itself isn't exactly fast... I think the
clean thing to do would be to either move this detail into the
refcount implementation (if it turns out to actually be valuable in at
least a microbenchmark), or just get rid of it. Given the overhead of
fork()/clone(), I would be surprised if you could actually measure
this effect here.

Eric, can you remember the rationale for doing it that way in commit
92476d7fc0326a409ab1d3864a04093a6be9aca7? Am I guessing correctly?
