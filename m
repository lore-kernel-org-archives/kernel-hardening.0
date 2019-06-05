MIME-Version: 1.0
References: <20190601222738.6856-1-joel@joelfernandes.org> <20190601222738.6856-5-joel@joelfernandes.org>
 <20190605012429.wmlvlgn4mb4jkvua@ca-dmjordan1.us.oracle.com>
In-Reply-To: <20190605012429.wmlvlgn4mb4jkvua@ca-dmjordan1.us.oracle.com>
From: Joel Fernandes <joel@joelfernandes.org>
Date: Wed, 5 Jun 2019 09:04:44 -0400
Message-ID: <CAEXW_YTsT5BY5Qbc6Jju2XmbHSQFELrGM9UaPPXY-ETmJaBrsA@mail.gmail.com>
Subject: Re: [RFC 4/6] workqueue: Convert for_each_wq to use built-in list check
Content-Type: text/plain; charset="UTF-8"
To: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Josh Triplett <josh@joshtriplett.org>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Lai Jiangshan <jiangshanlai@gmail.com>, Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org, Linux PM <linux-pm@vger.kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Neil Brown <neilb@suse.com>, netdev <netdev@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, "Paul E. McKenney" <paulmck@linux.ibm.com>, Pavel Machek <pavel@ucw.cz>, Peter Zilstra <peterz@infradead.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, rcu <rcu@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 4, 2019 at 9:25 PM Daniel Jordan <daniel.m.jordan@oracle.com> wrote:
>
> On Sat, Jun 01, 2019 at 06:27:36PM -0400, Joel Fernandes (Google) wrote:
> > list_for_each_entry_rcu now has support to check for RCU reader sections
> > as well as lock. Just use the support in it, instead of explictly
> > checking in the caller.
> >
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > ---
> >  kernel/workqueue.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> > index 9657315405de..91ed7aca16e5 100644
> > --- a/kernel/workqueue.c
> > +++ b/kernel/workqueue.c
> > @@ -424,9 +424,8 @@ static void workqueue_sysfs_unregister(struct workqueue_struct *wq);
> >   * ignored.
> >   */
> >  #define for_each_pwq(pwq, wq)                                                \
> > -     list_for_each_entry_rcu((pwq), &(wq)->pwqs, pwqs_node)          \
> > -             if (({ assert_rcu_or_wq_mutex(wq); false; })) { }       \
> > -             else
> > +     list_for_each_entry_rcu((pwq), &(wq)->pwqs, pwqs_node,          \
> > +                              lock_is_held(&(wq->mutex).dep_map))
> >
>
> I think the definition of assert_rcu_or_wq_mutex can also be deleted.

Sure, will do. Thank you.
