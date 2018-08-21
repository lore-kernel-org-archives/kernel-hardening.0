MIME-Version: 1.0
References: <20180817221624.10232-1-casey.schaufler@intel.com>
 <20180817221624.10232-3-casey.schaufler@intel.com> <CAG48ez23G+wcnkCMNZV_mxYMS=h+pZkpx1451Wz5GB9_tcDv3Q@mail.gmail.com>
 <99FC4B6EFCEFD44486C35F4C281DC6732143F769@ORSMSX107.amr.corp.intel.com>
In-Reply-To: <99FC4B6EFCEFD44486C35F4C281DC6732143F769@ORSMSX107.amr.corp.intel.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 21 Aug 2018 12:20:21 +0200
Message-ID: <CAG48ez1LHOHvB4ud+8asOjKARVLQJGV4ocdKVDJtvTXTfeMa9w@mail.gmail.com>
Subject: Re: [PATCH RFC v2 2/5] X86: Support LSM determination of side-channel vulnerability
Content-Type: text/plain; charset="UTF-8"
To: Casey Schaufler <casey.schaufler@intel.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, selinux@tycho.nsa.gov, Dave Hansen <dave.hansen@intel.com>, deneen.t.dock@intel.com, kristen@linux.intel.com, Arjan van de Ven <arjan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 20, 2018 at 4:45 PM Schaufler, Casey
<casey.schaufler@intel.com> wrote:
>
> > -----Original Message-----
> > From: Jann Horn [mailto:jannh@google.com]
> > Sent: Friday, August 17, 2018 4:55 PM
> > To: Schaufler, Casey <casey.schaufler@intel.com>
> > Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>; kernel list
> > <linux-kernel@vger.kernel.org>; linux-security-module <linux-security-
> > module@vger.kernel.org>; selinux@tycho.nsa.gov; Hansen, Dave
> > <dave.hansen@intel.com>; Dock, Deneen T <deneen.t.dock@intel.com>;
> > kristen@linux.intel.com; Arjan van de Ven <arjan@linux.intel.com>
> > Subject: Re: [PATCH RFC v2 2/5] X86: Support LSM determination of side-
> > channel vulnerability
> >
> > On Sat, Aug 18, 2018 at 12:17 AM Casey Schaufler
> > <casey.schaufler@intel.com> wrote:
> > >
> > > From: Casey Schaufler <cschaufler@localhost.localdomain>
> > >
> > > When switching between tasks it may be necessary
> > > to set an indirect branch prediction barrier if the
> > > tasks are potentially vulnerable to side-channel
> > > attacks. This adds a call to security_task_safe_sidechannel
> > > so that security modules can weigh in on the decision.
> > >
> > > Signed-off-by: Casey Schaufler <casey.schaufler@intel.com>
> > > ---
> > >  arch/x86/mm/tlb.c | 12 ++++++++----
> > >  1 file changed, 8 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
> > > index 6eb1f34c3c85..8714d4af06aa 100644
> > > --- a/arch/x86/mm/tlb.c
> > > +++ b/arch/x86/mm/tlb.c
> > > @@ -7,6 +7,7 @@
> > >  #include <linux/export.h>
> > >  #include <linux/cpu.h>
> > >  #include <linux/debugfs.h>
> > > +#include <linux/security.h>
> > >
> > >  #include <asm/tlbflush.h>
> > >  #include <asm/mmu_context.h>
> > > @@ -270,11 +271,14 @@ void switch_mm_irqs_off(struct mm_struct *prev,
> > struct mm_struct *next,
> > >                  * threads. It will also not flush if we switch to idle
> > >                  * thread and back to the same process. It will flush if we
> > >                  * switch to a different non-dumpable process.
> > > +                * If a security module thinks that the transition
> > > +                * is unsafe do the flush.
> > >                  */
> > > -               if (tsk && tsk->mm &&
> > > -                   tsk->mm->context.ctx_id != last_ctx_id &&
> > > -                   get_dumpable(tsk->mm) != SUID_DUMP_USER)
> > > -                       indirect_branch_prediction_barrier();
> > > +               if (tsk && tsk->mm && tsk->mm->context.ctx_id != last_ctx_id) {
> > > +                       if (get_dumpable(tsk->mm) != SUID_DUMP_USER ||
> > > +                           security_task_safe_sidechannel(tsk) != 0)
> > > +                               indirect_branch_prediction_barrier();
> > > +               }
> >
> > When you posted v1 of this series, I asked:
> >
> > | Does this enforce transitivity? What happens if we first switch from
> > | an attacker task to a task without ->mm, and immediately afterwards
> > | from the task without ->mm to a victim task? In that case, whether a
> > | flush happens between the attacker task and the victim task depends on
> > | whether the LSM thinks that the mm-less task should have access to the
> > | victim task, right?
> >
> > Have you addressed that? I don't see it...
>
> Nope. That's going to require maintaining state about all the
> tasks in the chain that might still have cache involvement.
>
>         A -> B -> C -> D

Really?

>From what I can tell, it'd be enough to:

 - ensure that the LSM-based access checks behave approximately transitively
   (which I think they already do, mostly)
 - keep a copy of the metadata of the last non-kernel task on the CPU

> If B and C don't do anything cacheworthy D could conceivably attack A.
> The amount of state required to detect this case would be prohibitive.
> I think that if you're sufficiently concerned about this case you should just
> go ahead and set the barrier. I'm willing to learn something that says I'm
> wrong.

That means that an attacker who can e.g. get a CPU to first switch
from an attacker task to a softirqd (e.g. for network packet
processing or whatever), then switch from the softirqd to a root-owned
victim task would be able to bypass the check, right? That doesn't
sound like a very complicated attack...

I very much dislike the idea of adding a mitigation with a known
bypass technique to the kernel.
