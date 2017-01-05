Reply-To: kernel-hardening@lists.openwall.com
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Thu, 5 Jan 2017 09:56:19 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C380E4@IRSMSX102.ger.corp.intel.com>
References: <1482994571-18687-1-git-send-email-elena.reshetova@intel.com>
 <1482994571-18687-9-git-send-email-elena.reshetova@intel.com>
 <20170105022535.GA20972@linaro.org>
In-Reply-To: <20170105022535.GA20972@linaro.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: RE: [kernel-hardening] [RFC PATCH 08/19] kernel, mm: convert from
 atomic_t to refcount_t
To: AKASHI Takahiro <takahiro.akashi@linaro.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: "keescook@chromium.org" <keescook@chromium.org>, "arnd@arndb.de" <arnd@arndb.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, "peterz@infradead.org" <peterz@infradead.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "dwindsor@gmail.com" <dwindsor@gmail.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "ishkamiel@gmail.com" <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

> On Thu, Dec 29, 2016 at 08:56:00AM +0200, Elena Reshetova wrote:
> > refcount_t type and corresponding API should be
> > used instead of atomic_t when the variable is used as
> > a reference counter. Convert the cases found.
> >
> > Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> > Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
> > ---
> >  arch/alpha/kernel/smp.c                 |  6 ++---
> >  arch/arc/kernel/smp.c                   |  2 +-
> >  arch/arc/mm/tlb.c                       |  2 +-
> >  arch/arm/kernel/smp.c                   |  2 +-
> >  arch/blackfin/mach-common/smp.c         |  4 +--
> >  arch/frv/mm/mmu-context.c               |  2 +-
> >  arch/ia64/include/asm/tlbflush.h        |  2 +-
> >  arch/ia64/kernel/smp.c                  |  2 +-
> >  arch/ia64/sn/kernel/sn2/sn2_smp.c       |  4 +--
> >  arch/metag/kernel/smp.c                 |  2 +-
> >  arch/mips/kernel/process.c              |  2 +-
> >  arch/mips/kernel/smp.c                  |  6 ++---
> >  arch/parisc/include/asm/mmu_context.h   |  2 +-
> >  arch/powerpc/mm/hugetlbpage.c           |  2 +-
> >  arch/powerpc/mm/icswx.c                 |  4 +--
> >  arch/s390/include/asm/debug.h           |  3 ++-
> >  arch/s390/kernel/debug.c                |  6 ++---
> >  arch/sh/kernel/smp.c                    |  8 +++---
> >  arch/sparc/kernel/mdesc.c               | 17 ++++++------
> >  arch/sparc/kernel/smp_64.c              |  6 ++---
> >  arch/sparc/mm/srmmu.c                   |  2 +-
> >  arch/um/kernel/tlb.c                    |  2 +-
> >  arch/x86/include/asm/amd_nb.h           |  3 ++-
> >  arch/x86/kernel/cpu/common.c            |  4 +--
> >  arch/x86/kernel/cpu/mcheck/mce_amd.c    |  6 ++---
> >  arch/x86/kernel/tboot.c                 |  4 +--
> >  arch/xtensa/kernel/smp.c                |  2 +-
> >  drivers/firmware/efi/arm-runtime.c      |  4 +--
> >  drivers/gpu/drm/i915/i915_gem_userptr.c |  4 +--
> >  drivers/iommu/intel-svm.c               |  2 +-
> >  fs/coredump.c                           |  2 +-
> >  fs/exec.c                               |  4 +--
> >  fs/proc/base.c                          | 10 +++----
> >  fs/proc/task_mmu.c                      |  4 +--
> >  fs/proc/task_nommu.c                    |  2 +-
> >  fs/userfaultfd.c                        |  2 +-
> >  include/linux/backing-dev-defs.h        |  3 ++-
> >  include/linux/backing-dev.h             |  4 +--
> >  include/linux/cgroup-defs.h             |  3 ++-
> >  include/linux/cgroup.h                  |  7 ++---
> >  include/linux/cred.h                    | 13 +++++-----
> >  include/linux/init_task.h               |  7 ++---
> >  include/linux/kvm_host.h                |  3 ++-
> >  include/linux/mm_types.h                |  5 ++--
> >  include/linux/nsproxy.h                 |  6 ++---
> >  include/linux/perf_event.h              |  3 ++-
> >  include/linux/rmap.h                    |  7 ++---
> >  include/linux/sched.h                   | 25 +++++++++---------
> >  kernel/audit_tree.c                     | 10 +++----
> >  kernel/audit_watch.c                    |  8 +++---
> >  kernel/cgroup.c                         | 23 ++++++++++-------
> >  kernel/cred.c                           | 46 ++++++++++++++++---------=
--------
> >  kernel/events/core.c                    | 16 ++++++------
> >  kernel/events/internal.h                |  5 ++--
> >  kernel/events/ring_buffer.c             |  8 +++---
> >  kernel/events/uprobes.c                 | 13 +++++-----
> >  kernel/exit.c                           |  4 +--
> >  kernel/fork.c                           | 40 ++++++++++++++-----------=
---
> >  kernel/futex.c                          | 17 ++++++------
> >  kernel/groups.c                         |  2 +-
> >  kernel/kcov.c                           |  9 ++++---
> >  kernel/nsproxy.c                        |  6 ++---
> >  kernel/sched/core.c                     |  7 ++---
> >  kernel/sched/fair.c                     |  8 +++---
> >  kernel/user.c                           |  8 +++---
> >  lib/is_single_threaded.c                |  2 +-
> >  mm/backing-dev.c                        | 11 ++++----
> >  mm/debug.c                              |  2 +-
> >  mm/huge_memory.c                        | 16 +++++++-----
> >  mm/init-mm.c                            |  4 +--
> >  mm/khugepaged.c                         |  4 +--
> >  mm/kmemleak.c                           | 16 ++++++------
> >  mm/ksm.c                                |  4 +--
> >  mm/memory.c                             |  2 +-
> >  mm/mmu_context.c                        |  2 +-
> >  mm/mmu_notifier.c                       | 12 ++++-----
> >  mm/mprotect.c                           |  2 +-
> >  mm/oom_kill.c                           |  6 ++---
> >  mm/rmap.c                               | 14 +++++-----
> >  mm/swapfile.c                           | 14 +++++-----
> >  mm/vmacache.c                           |  2 +-
> >  mm/zpool.c                              |  4 +--
> >  net/sunrpc/auth_null.c                  |  2 +-
> >  virt/kvm/async_pf.c                     |  2 +-
> >  virt/kvm/kvm_main.c                     | 10 +++----
> >  85 files changed, 307 insertions(+), 281 deletions(-)
> >
> > diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
> > index 46bf263..cc5aa0a 100644
> > --- a/arch/alpha/kernel/smp.c
> > +++ b/arch/alpha/kernel/smp.c
> > @@ -653,7 +653,7 @@ flush_tlb_mm(struct mm_struct *mm)
> >
> >  	if (mm =3D=3D current->active_mm) {
> >  		flush_tlb_current(mm);
> > -		if (atomic_read(&mm->mm_users) <=3D 1) {
> > +		if (refcount_read(&mm->mm_users) <=3D 1) {
> >  			int cpu, this_cpu =3D
> smp_processor_id();
> >  			for (cpu =3D 0; cpu < NR_CPUS; cpu++) {
> >  				if (!cpu_online(cpu) ||
> cpu =3D=3D this_cpu)
> > @@ -702,7 +702,7 @@ flush_tlb_page(struct vm_area_struct *vma, unsigned
> long addr)
> >
> >  	if (mm =3D=3D current->active_mm) {
> >  		flush_tlb_current_page(mm, vma, addr);
> > -		if (atomic_read(&mm->mm_users) <=3D 1) {
> > +		if (refcount_read(&mm->mm_users) <=3D 1) {
> >  			int cpu, this_cpu =3D
> smp_processor_id();
> >  			for (cpu =3D 0; cpu < NR_CPUS; cpu++) {
> >  				if (!cpu_online(cpu) ||
> cpu =3D=3D this_cpu)
> > @@ -758,7 +758,7 @@ flush_icache_user_range(struct vm_area_struct *vma,
> struct page *page,
> >
> >  	if (mm =3D=3D current->active_mm) {
> >  		__load_new_mm_context(mm);
> > -		if (atomic_read(&mm->mm_users) <=3D 1) {
> > +		if (refcount_read(&mm->mm_users) <=3D 1) {
> >  			int cpu, this_cpu =3D
> smp_processor_id();
> >  			for (cpu =3D 0; cpu < NR_CPUS; cpu++) {
> >  				if (!cpu_online(cpu) ||
> cpu =3D=3D this_cpu)
> > diff --git a/arch/arc/kernel/smp.c b/arch/arc/kernel/smp.c
> > index 88674d9..8e22594 100644
> > --- a/arch/arc/kernel/smp.c
> > +++ b/arch/arc/kernel/smp.c
> > @@ -124,7 +124,7 @@ void start_kernel_secondary(void)
> >  	/* MMU, Caches, Vector Table, Interrupts etc */
> >  	setup_processor();
> >
> > -	atomic_inc(&mm->mm_users);
> > +	refcount_inc(&mm->mm_users);
> >  	atomic_inc(&mm->mm_count);
> >  	current->active_mm =3D mm;
> >  	cpumask_set_cpu(cpu, mm_cpumask(mm));
> > diff --git a/arch/arc/mm/tlb.c b/arch/arc/mm/tlb.c
> > index bdb295e..6dbdfe7 100644
> > --- a/arch/arc/mm/tlb.c
> > +++ b/arch/arc/mm/tlb.c
> > @@ -297,7 +297,7 @@ noinline void local_flush_tlb_mm(struct mm_struct
> *mm)
> >  	 * Only for fork( ) do we need to move parent to a new MMU ctxt,
> >  	 * all other cases are NOPs, hence this check.
> >  	 */
> > -	if (atomic_read(&mm->mm_users) =3D=3D 0)
> > +	if (refcount_read(&mm->mm_users) =3D=3D 0)
> >  		return;
> >
> >  	/*
> > diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> > index 7dd14e8..1d59aca 100644
> > --- a/arch/arm/kernel/smp.c
> > +++ b/arch/arm/kernel/smp.c
> > @@ -371,7 +371,7 @@ asmlinkage void secondary_start_kernel(void)
> >  	 * reference and switch to it.
> >  	 */
> >  	cpu =3D smp_processor_id();
> > -	atomic_inc(&mm->mm_count);
> > +	refcount_inc(&mm->mm_count);
> >  	current->active_mm =3D mm;
> >  	cpumask_set_cpu(cpu, mm_cpumask(mm));
> >
>=20
> If this is the case, arm64 has almost the same code.

Thank you! I haven't tried to build on arm64 this yet (as well as on other =
arches). I am pretty sure there are more cases on other arches that are mis=
sed.
That's why I was hoping that we can run this series to the automatic build =
infra.=20

@Kees, how did you do it before for previous patches? Who should be contact=
ed to get a build-test on all arches?

Best Regards,
Elena


>=20
> -Takahiro AKASHI
>=20
> > diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-
> common/smp.c
> > index 23c4ef5..d90422d 100644
> > --- a/arch/blackfin/mach-common/smp.c
> > +++ b/arch/blackfin/mach-common/smp.c
> > @@ -307,7 +307,7 @@ void secondary_start_kernel(void)
> >  	local_irq_disable();
> >
> >  	/* Attach the new idle task to the global mm. */
> > -	atomic_inc(&mm->mm_users);
> > +	refcount_inc(&mm->mm_users);
> >  	atomic_inc(&mm->mm_count);
> >  	current->active_mm =3D mm;
> >
> > @@ -422,7 +422,7 @@ void cpu_die(void)
> >  {
> >  	(void)cpu_report_death();
> >
> > -	atomic_dec(&init_mm.mm_users);
> > +	refcount_dec(&init_mm.mm_users);
> >  	atomic_dec(&init_mm.mm_count);
> >
> >  	local_irq_disable();
> > diff --git a/arch/frv/mm/mmu-context.c b/arch/frv/mm/mmu-context.c
> > index 81757d5..128cfd6 100644
> > --- a/arch/frv/mm/mmu-context.c
> > +++ b/arch/frv/mm/mmu-context.c
> > @@ -188,7 +188,7 @@ int cxn_pin_by_pid(pid_t pid)
> >  		task_lock(tsk);
> >  		if (tsk->mm) {
> >  			mm =3D tsk->mm;
> > -			atomic_inc(&mm->mm_users);
> > +			refcount_inc(&mm->mm_users);
> >  			ret =3D 0;
> >  		}
> >  		task_unlock(tsk);
> > diff --git a/arch/ia64/include/asm/tlbflush.h b/arch/ia64/include/asm/t=
lbflush.h
> > index 3be25df..650708a 100644
> > --- a/arch/ia64/include/asm/tlbflush.h
> > +++ b/arch/ia64/include/asm/tlbflush.h
> > @@ -56,7 +56,7 @@ flush_tlb_mm (struct mm_struct *mm)
> >  	set_bit(mm->context, ia64_ctx.flushmap);
> >  	mm->context =3D 0;
> >
> > -	if (atomic_read(&mm->mm_users) =3D=3D 0)
> > +	if (refcount_read(&mm->mm_users) =3D=3D 0)
> >  		return;		/* happens as a result
> of exit_mmap() */
> >
> >  #ifdef CONFIG_SMP
> > diff --git a/arch/ia64/kernel/smp.c b/arch/ia64/kernel/smp.c
> > index 7f706d4..dd7b680 100644
> > --- a/arch/ia64/kernel/smp.c
> > +++ b/arch/ia64/kernel/smp.c
> > @@ -295,7 +295,7 @@ smp_flush_tlb_mm (struct mm_struct *mm)
> >  	cpumask_var_t cpus;
> >  	preempt_disable();
> >  	/* this happens for the common case of a single-threaded fork():  */
> > -	if (likely(mm =3D=3D current->active_mm && atomic_read(&mm-
> >mm_users) =3D=3D 1))
> > +	if (likely(mm =3D=3D current->active_mm && refcount_read(&mm-
> >mm_users) =3D=3D 1))
> >  	{
> >  		local_finish_flush_tlb_mm(mm);
> >  		preempt_enable();
> > diff --git a/arch/ia64/sn/kernel/sn2/sn2_smp.c
> b/arch/ia64/sn/kernel/sn2/sn2_smp.c
> > index c98dc96..1c801b3 100644
> > --- a/arch/ia64/sn/kernel/sn2/sn2_smp.c
> > +++ b/arch/ia64/sn/kernel/sn2/sn2_smp.c
> > @@ -122,7 +122,7 @@ void sn_migrate(struct task_struct *task)
> >  void sn_tlb_migrate_finish(struct mm_struct *mm)
> >  {
> >  	/* flush_tlb_mm is inefficient if more than 1 users of mm */
> > -	if (mm =3D=3D current->mm && mm && atomic_read(&mm->mm_users)
> =3D=3D 1)
> > +	if (mm =3D=3D current->mm && mm && refcount_read(&mm-
> >mm_users) =3D=3D 1)
> >  		flush_tlb_mm(mm);
> >  }
> >
> > @@ -204,7 +204,7 @@ sn2_global_tlb_purge(struct mm_struct *mm, unsigned
> long start,
> >  		return;
> >  	}
> >
> > -	if (atomic_read(&mm->mm_users) =3D=3D 1 && mymm) {
> > +	if (refcount_read(&mm->mm_users) =3D=3D 1 && mymm) {
> >  		flush_tlb_mm(mm);
> >  		__this_cpu_inc(ptcstats.change_rid);
> >  		preempt_enable();
> > diff --git a/arch/metag/kernel/smp.c b/arch/metag/kernel/smp.c
> > index bad1323..5a9835b 100644
> > --- a/arch/metag/kernel/smp.c
> > +++ b/arch/metag/kernel/smp.c
> > @@ -344,7 +344,7 @@ asmlinkage void secondary_start_kernel(void)
> >  	 * All kernel threads share the same mm context; grab a
> >  	 * reference and switch to it.
> >  	 */
> > -	atomic_inc(&mm->mm_users);
> > +	refcount_inc(&mm->mm_users);
> >  	atomic_inc(&mm->mm_count);
> >  	current->active_mm =3D mm;
> >  	cpumask_set_cpu(cpu, mm_cpumask(mm));
> > diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
> > index 9514e5f..64baeb8 100644
> > --- a/arch/mips/kernel/process.c
> > +++ b/arch/mips/kernel/process.c
> > @@ -642,7 +642,7 @@ int mips_set_process_fp_mode(struct task_struct *ta=
sk,
> unsigned int value)
> >  		/* No need to send an IPI for the local CPU */
> >  		max_users =3D (task->mm =3D=3D current->mm) ? 1 : 0;
> >
> > -		if (atomic_read(&current->mm->mm_users) >
> max_users)
> > +		if (refcount_read(&current->mm->mm_users) >
> max_users)
> >
> 	smp_call_function(prepare_for_fp_mode_switch,
> >  					  (void
> *)current->mm, 1);
> >  	}
> > diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
> > index 7ebb191..9017ff3 100644
> > --- a/arch/mips/kernel/smp.c
> > +++ b/arch/mips/kernel/smp.c
> > @@ -510,7 +510,7 @@ void flush_tlb_mm(struct mm_struct *mm)
> >  {
> >  	preempt_disable();
> >
> > -	if ((atomic_read(&mm->mm_users) !=3D 1) || (current->mm !=3D mm)) {
> > +	if ((refcount_read(&mm->mm_users) !=3D 1) || (current->mm !=3D mm))
> {
> >  		smp_on_other_tlbs(flush_tlb_mm_ipi, mm);
> >  	} else {
> >  		unsigned int cpu;
> > @@ -543,7 +543,7 @@ void flush_tlb_range(struct vm_area_struct *vma,
> unsigned long start, unsigned l
> >  	struct mm_struct *mm =3D vma->vm_mm;
> >
> >  	preempt_disable();
> > -	if ((atomic_read(&mm->mm_users) !=3D 1) || (current->mm !=3D mm)) {
> > +	if ((refcount_read(&mm->mm_users) !=3D 1) || (current->mm !=3D mm))
> {
> >  		struct flush_tlb_data fd =3D {
> >  			.vma =3D vma,
> >  			.addr1 =3D start,
> > @@ -597,7 +597,7 @@ static void flush_tlb_page_ipi(void *info)
> >  void flush_tlb_page(struct vm_area_struct *vma, unsigned long page)
> >  {
> >  	preempt_disable();
> > -	if ((atomic_read(&vma->vm_mm->mm_users) !=3D 1) || (current-
> >mm !=3D vma->vm_mm)) {
> > +	if ((refcount_read(&vma->vm_mm->mm_users) !=3D 1) || (current-
> >mm !=3D vma->vm_mm)) {
> >  		struct flush_tlb_data fd =3D {
> >  			.vma =3D vma,
> >  			.addr1 =3D page,
> > diff --git a/arch/parisc/include/asm/mmu_context.h
> b/arch/parisc/include/asm/mmu_context.h
> > index 59be257..e64f398 100644
> > --- a/arch/parisc/include/asm/mmu_context.h
> > +++ b/arch/parisc/include/asm/mmu_context.h
> > @@ -21,7 +21,7 @@ extern void free_sid(unsigned long);
> >  static inline int
> >  init_new_context(struct task_struct *tsk, struct mm_struct *mm)
> >  {
> > -	BUG_ON(atomic_read(&mm->mm_users) !=3D 1);
> > +	BUG_ON(refcount_read(&mm->mm_users) !=3D 1);
> >
> >  	mm->context =3D alloc_sid();
> >  	return 0;
> > diff --git a/arch/powerpc/mm/hugetlbpage.c
> b/arch/powerpc/mm/hugetlbpage.c
> > index 289df38..f3db57b 100644
> > --- a/arch/powerpc/mm/hugetlbpage.c
> > +++ b/arch/powerpc/mm/hugetlbpage.c
> > @@ -403,7 +403,7 @@ static void hugepd_free(struct mmu_gather *tlb, voi=
d
> *hugepte)
> >
> >  	batchp =3D &get_cpu_var(hugepd_freelist_cur);
> >
> > -	if (atomic_read(&tlb->mm->mm_users) < 2 ||
> > +	if (refcount_read(&tlb->mm->mm_users) < 2 ||
> >  	    cpumask_equal(mm_cpumask(tlb->mm),
> >  			  cpumask_of(smp_processor_id()))) {
> >  		kmem_cache_free(hugepte_cache, hugepte);
> > diff --git a/arch/powerpc/mm/icswx.c b/arch/powerpc/mm/icswx.c
> > index 915412e..2406ff8 100644
> > --- a/arch/powerpc/mm/icswx.c
> > +++ b/arch/powerpc/mm/icswx.c
> > @@ -110,7 +110,7 @@ int use_cop(unsigned long acop, struct mm_struct *m=
m)
> >  	 * running. We need to send an IPI to force them to pick up any
> >  	 * change in PID and ACOP.
> >  	 */
> > -	if (atomic_read(&mm->mm_users) > 1)
> > +	if (refcount_read(&mm->mm_users) > 1)
> >  		smp_call_function(sync_cop, mm, 1);
> >
> >  out:
> > @@ -150,7 +150,7 @@ void drop_cop(unsigned long acop, struct mm_struct
> *mm)
> >  	 * running. We need to send an IPI to force them to pick up any
> >  	 * change in PID and ACOP.
> >  	 */
> > -	if (atomic_read(&mm->mm_users) > 1)
> > +	if (refcount_read(&mm->mm_users) > 1)
> >  		smp_call_function(sync_cop, mm, 1);
> >
> >  	if (free_pid !=3D COP_PID_NONE)
> > diff --git a/arch/s390/include/asm/debug.h b/arch/s390/include/asm/debu=
g.h
> > index 0206c80..df7b54e 100644
> > --- a/arch/s390/include/asm/debug.h
> > +++ b/arch/s390/include/asm/debug.h
> > @@ -10,6 +10,7 @@
> >  #include <linux/spinlock.h>
> >  #include <linux/kernel.h>
> >  #include <linux/time.h>
> > +#include <linux/refcount.h>
> >  #include <uapi/asm/debug.h>
> >
> >  #define DEBUG_MAX_LEVEL            6  /* debug levels range from 0 to =
6 */
> > @@ -31,7 +32,7 @@ struct debug_view;
> >  typedef struct debug_info {
> >  	struct debug_info* next;
> >  	struct debug_info* prev;
> > -	atomic_t ref_count;
> > +	refcount_t ref_count;
> >  	spinlock_t lock;
> >  	int level;
> >  	int nr_areas;
> > diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
> > index aa12de7..b4c1d2a 100644
> > --- a/arch/s390/kernel/debug.c
> > +++ b/arch/s390/kernel/debug.c
> > @@ -277,7 +277,7 @@ debug_info_alloc(const char *name, int
> pages_per_area, int nr_areas,
> >  	memset(rc->views, 0, DEBUG_MAX_VIEWS * sizeof(struct
> debug_view *));
> >  	memset(rc->debugfs_entries, 0 ,DEBUG_MAX_VIEWS *
> >  		sizeof(struct dentry*));
> > -	atomic_set(&(rc->ref_count), 0);
> > +	refcount_set(&(rc->ref_count), 0);
> >
> >  	return rc;
> >
> > @@ -416,7 +416,7 @@ static void
> >  debug_info_get(debug_info_t * db_info)
> >  {
> >  	if (db_info)
> > -		atomic_inc(&db_info->ref_count);
> > +		refcount_inc(&db_info->ref_count);
> >  }
> >
> >  /*
> > @@ -431,7 +431,7 @@ debug_info_put(debug_info_t *db_info)
> >
> >  	if (!db_info)
> >  		return;
> > -	if (atomic_dec_and_test(&db_info->ref_count)) {
> > +	if (refcount_dec_and_test(&db_info->ref_count)) {
> >  		for (i =3D 0; i < DEBUG_MAX_VIEWS; i++) {
> >  			if (!db_info->views[i])
> >  				continue;
> > diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
> > index 38e7860..f0aabeb 100644
> > --- a/arch/sh/kernel/smp.c
> > +++ b/arch/sh/kernel/smp.c
> > @@ -179,7 +179,7 @@ asmlinkage void start_secondary(void)
> >
> >  	enable_mmu();
> >  	atomic_inc(&mm->mm_count);
> > -	atomic_inc(&mm->mm_users);
> > +	refcount_inc(&mm->mm_users);
> >  	current->active_mm =3D mm;
> >  #ifdef CONFIG_MMU
> >  	enter_lazy_tlb(mm, current);
> > @@ -363,7 +363,7 @@ void flush_tlb_mm(struct mm_struct *mm)
> >  {
> >  	preempt_disable();
> >
> > -	if ((atomic_read(&mm->mm_users) !=3D 1) || (current->mm !=3D mm)) {
> > +	if ((refcount_read(&mm->mm_users) !=3D 1) || (current->mm !=3D mm))
> {
> >  		smp_call_function(flush_tlb_mm_ipi, (void *)mm, 1);
> >  	} else {
> >  		int i;
> > @@ -395,7 +395,7 @@ void flush_tlb_range(struct vm_area_struct *vma,
> >  	struct mm_struct *mm =3D vma->vm_mm;
> >
> >  	preempt_disable();
> > -	if ((atomic_read(&mm->mm_users) !=3D 1) || (current->mm !=3D mm)) {
> > +	if ((refcount_read(&mm->mm_users) !=3D 1) || (current->mm !=3D mm))
> {
> >  		struct flush_tlb_data fd;
> >
> >  		fd.vma =3D vma;
> > @@ -438,7 +438,7 @@ static void flush_tlb_page_ipi(void *info)
> >  void flush_tlb_page(struct vm_area_struct *vma, unsigned long page)
> >  {
> >  	preempt_disable();
> > -	if ((atomic_read(&vma->vm_mm->mm_users) !=3D 1) ||
> > +	if ((refcount_read(&vma->vm_mm->mm_users) !=3D 1) ||
> >  	    (current->mm !=3D vma->vm_mm)) {
> >  		struct flush_tlb_data fd;
> >
> > diff --git a/arch/sparc/kernel/mdesc.c b/arch/sparc/kernel/mdesc.c
> > index 8a6982d..111e3ce 100644
> > --- a/arch/sparc/kernel/mdesc.c
> > +++ b/arch/sparc/kernel/mdesc.c
> > @@ -12,6 +12,7 @@
> >  #include <linux/miscdevice.h>
> >  #include <linux/bootmem.h>
> >  #include <linux/export.h>
> > +#include <linux/refcount.h>
> >
> >  #include <asm/cpudata.h>
> >  #include <asm/hypervisor.h>
> > @@ -70,7 +71,7 @@ struct mdesc_handle {
> >  	struct list_head	list;
> >  	struct mdesc_mem_ops	*mops;
> >  	void			*self_base;
> > -	atomic_t		refcnt;
> > +	refcount_t		refcnt;
> >  	unsigned int		handle_size;
> >  	struct mdesc_hdr	mdesc;
> >  };
> > @@ -84,7 +85,7 @@ static void mdesc_handle_init(struct mdesc_handle *hp=
,
> >  	memset(hp, 0, handle_size);
> >  	INIT_LIST_HEAD(&hp->list);
> >  	hp->self_base =3D base;
> > -	atomic_set(&hp->refcnt, 1);
> > +	refcount_set(&hp->refcnt, 1);
> >  	hp->handle_size =3D handle_size;
> >  }
> >
> > @@ -114,7 +115,7 @@ static void __init mdesc_memblock_free(struct
> mdesc_handle *hp)
> >  	unsigned int alloc_size;
> >  	unsigned long start;
> >
> > -	BUG_ON(atomic_read(&hp->refcnt) !=3D 0);
> > +	BUG_ON(refcount_read(&hp->refcnt) !=3D 0);
> >  	BUG_ON(!list_empty(&hp->list));
> >
> >  	alloc_size =3D PAGE_ALIGN(hp->handle_size);
> > @@ -154,7 +155,7 @@ static struct mdesc_handle *mdesc_kmalloc(unsigned =
int
> mdesc_size)
> >
> >  static void mdesc_kfree(struct mdesc_handle *hp)
> >  {
> > -	BUG_ON(atomic_read(&hp->refcnt) !=3D 0);
> > +	BUG_ON(refcount_read(&hp->refcnt) !=3D 0);
> >  	BUG_ON(!list_empty(&hp->list));
> >
> >  	kfree(hp->self_base);
> > @@ -193,7 +194,7 @@ struct mdesc_handle *mdesc_grab(void)
> >  	spin_lock_irqsave(&mdesc_lock, flags);
> >  	hp =3D cur_mdesc;
> >  	if (hp)
> > -		atomic_inc(&hp->refcnt);
> > +		refcount_inc(&hp->refcnt);
> >  	spin_unlock_irqrestore(&mdesc_lock, flags);
> >
> >  	return hp;
> > @@ -205,7 +206,7 @@ void mdesc_release(struct mdesc_handle *hp)
> >  	unsigned long flags;
> >
> >  	spin_lock_irqsave(&mdesc_lock, flags);
> > -	if (atomic_dec_and_test(&hp->refcnt)) {
> > +	if (refcount_dec_and_test(&hp->refcnt)) {
> >  		list_del_init(&hp->list);
> >  		hp->mops->free(hp);
> >  	}
> > @@ -344,7 +345,7 @@ void mdesc_update(void)
> >  	if (status !=3D HV_EOK || real_len > len) {
> >  		printk(KERN_ERR "MD: mdesc reread fails with
> %lu\n",
> >  		       status);
> > -		atomic_dec(&hp->refcnt);
> > +		refcount_dec(&hp->refcnt);
> >  		mdesc_free(hp);
> >  		goto out;
> >  	}
> > @@ -357,7 +358,7 @@ void mdesc_update(void)
> >  	mdesc_notify_clients(orig_hp, hp);
> >
> >  	spin_lock_irqsave(&mdesc_lock, flags);
> > -	if (atomic_dec_and_test(&orig_hp->refcnt))
> > +	if (refcount_dec_and_test(&orig_hp->refcnt))
> >  		mdesc_free(orig_hp);
> >  	else
> >  		list_add(&orig_hp->list, &mdesc_zombie_list);
> > diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
> > index 8182f7c..582a085 100644
> > --- a/arch/sparc/kernel/smp_64.c
> > +++ b/arch/sparc/kernel/smp_64.c
> > @@ -1063,7 +1063,7 @@ void smp_flush_tlb_mm(struct mm_struct *mm)
> >  	u32 ctx =3D CTX_HWBITS(mm->context);
> >  	int cpu =3D get_cpu();
> >
> > -	if (atomic_read(&mm->mm_users) =3D=3D 1) {
> > +	if (refcount_read(&mm->mm_users) =3D=3D 1) {
> >  		cpumask_copy(mm_cpumask(mm),
> cpumask_of(cpu));
> >  		goto local_flush_and_out;
> >  	}
> > @@ -1101,7 +1101,7 @@ void smp_flush_tlb_pending(struct mm_struct *mm,
> unsigned long nr, unsigned long
> >  	info.nr =3D nr;
> >  	info.vaddrs =3D vaddrs;
> >
> > -	if (mm =3D=3D current->mm && atomic_read(&mm->mm_users) =3D=3D 1)
> > +	if (mm =3D=3D current->mm && refcount_read(&mm->mm_users) =3D=3D 1)
> >  		cpumask_copy(mm_cpumask(mm),
> cpumask_of(cpu));
> >  	else
> >  		smp_call_function_many(mm_cpumask(mm),
> tlb_pending_func,
> > @@ -1117,7 +1117,7 @@ void smp_flush_tlb_page(struct mm_struct *mm,
> unsigned long vaddr)
> >  	unsigned long context =3D CTX_HWBITS(mm->context);
> >  	int cpu =3D get_cpu();
> >
> > -	if (mm =3D=3D current->mm && atomic_read(&mm->mm_users) =3D=3D 1)
> > +	if (mm =3D=3D current->mm && refcount_read(&mm->mm_users) =3D=3D 1)
> >  		cpumask_copy(mm_cpumask(mm),
> cpumask_of(cpu));
> >  	else
> >  		smp_cross_call_masked(&xcall_flush_tlb_page,
> > diff --git a/arch/sparc/mm/srmmu.c b/arch/sparc/mm/srmmu.c
> > index c7f2a52..17941a8 100644
> > --- a/arch/sparc/mm/srmmu.c
> > +++ b/arch/sparc/mm/srmmu.c
> > @@ -1662,7 +1662,7 @@ static void smp_flush_tlb_mm(struct mm_struct *mm=
)
> >  		cpumask_clear_cpu(smp_processor_id(),
> &cpu_mask);
> >  		if (!cpumask_empty(&cpu_mask)) {
> >  			xc1((smpfunc_t) local_ops->tlb_mm,
> (unsigned long) mm);
> > -			if (atomic_read(&mm->mm_users) =3D=3D
> 1 && current->active_mm =3D=3D mm)
> > +			if (refcount_read(&mm->mm_users)
> =3D=3D 1 && current->active_mm =3D=3D mm)
> >
> 	cpumask_copy(mm_cpumask(mm),
> >
> cpumask_of(smp_processor_id()));
> >  		}
> > diff --git a/arch/um/kernel/tlb.c b/arch/um/kernel/tlb.c
> > index 3777b82..1da0463 100644
> > --- a/arch/um/kernel/tlb.c
> > +++ b/arch/um/kernel/tlb.c
> > @@ -530,7 +530,7 @@ void flush_tlb_mm_range(struct mm_struct *mm,
> unsigned long start,
> >  	 * Don't bother flushing if this address space is about to be
> >  	 * destroyed.
> >  	 */
> > -	if (atomic_read(&mm->mm_users) =3D=3D 0)
> > +	if (refcount_read(&mm->mm_users) =3D=3D 0)
> >  		return;
> >
> >  	fix_range(mm, start, end, 0);
> > diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_n=
b.h
> > index 00c88a0..da181ad 100644
> > --- a/arch/x86/include/asm/amd_nb.h
> > +++ b/arch/x86/include/asm/amd_nb.h
> > @@ -3,6 +3,7 @@
> >
> >  #include <linux/ioport.h>
> >  #include <linux/pci.h>
> > +#include <linux/refcount.h>
> >
> >  struct amd_nb_bus_dev_range {
> >  	u8 bus;
> > @@ -55,7 +56,7 @@ struct threshold_bank {
> >  	struct threshold_block	*blocks;
> >
> >  	/* initialized to the number of CPUs on the node sharing this bank
> */
> > -	atomic_t		cpus;
> > +	refcount_t		cpus;
> >  };
> >
> >  struct amd_northbridge {
> > diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.=
c
> > index 1f6b50a..b92d07a 100644
> > --- a/arch/x86/kernel/cpu/common.c
> > +++ b/arch/x86/kernel/cpu/common.c
> > @@ -1490,7 +1490,7 @@ void cpu_init(void)
> >  	for (i =3D 0; i <=3D IO_BITMAP_LONGS; i++)
> >  		t->io_bitmap[i] =3D ~0UL;
> >
> > -	atomic_inc(&init_mm.mm_count);
> > +	refcount_inc(&init_mm.mm_count);
> >  	me->active_mm =3D &init_mm;
> >  	BUG_ON(me->mm);
> >  	enter_lazy_tlb(&init_mm, me);
> > @@ -1541,7 +1541,7 @@ void cpu_init(void)
> >  	/*
> >  	 * Set up and load the per-CPU TSS and LDT
> >  	 */
> > -	atomic_inc(&init_mm.mm_count);
> > +	refcount_inc(&init_mm.mm_count);
> >  	curr->active_mm =3D &init_mm;
> >  	BUG_ON(curr->mm);
> >  	enter_lazy_tlb(&init_mm, curr);
> > diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c
> b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> > index ffacfdc..61a7a76 100644
> > --- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
> > +++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
> > @@ -1194,7 +1194,7 @@ static int threshold_create_bank(unsigned int cpu=
,
> unsigned int bank)
> >  				goto out;
> >
> >  			per_cpu(threshold_banks, cpu)[bank]
> =3D b;
> > -			atomic_inc(&b->cpus);
> > +			refcount_inc(&b->cpus);
> >
> >  			err =3D __threshold_add_blocks(b);
> >
> > @@ -1217,7 +1217,7 @@ static int threshold_create_bank(unsigned int cpu=
,
> unsigned int bank)
> >  	per_cpu(threshold_banks, cpu)[bank] =3D b;
> >
> >  	if (is_shared_bank(bank)) {
> > -		atomic_set(&b->cpus, 1);
> > +		refcount_set(&b->cpus, 1);
> >
> >  		/* nb is already initialized, see above */
> >  		if (nb) {
> > @@ -1281,7 +1281,7 @@ static void threshold_remove_bank(unsigned int cp=
u,
> int bank)
> >  		goto free_out;
> >
> >  	if (is_shared_bank(bank)) {
> > -		if (!atomic_dec_and_test(&b->cpus)) {
> > +		if (!refcount_dec_and_test(&b->cpus)) {
> >  			__threshold_remove_blocks(b);
> >  			per_cpu(threshold_banks, cpu)[bank]
> =3D NULL;
> >  			return;
> > diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
> > index 8402907..eb4b2bd 100644
> > --- a/arch/x86/kernel/tboot.c
> > +++ b/arch/x86/kernel/tboot.c
> > @@ -102,8 +102,8 @@ static pgd_t *tboot_pg_dir;
> >  static struct mm_struct tboot_mm =3D {
> >  	.mm_rb          =3D RB_ROOT,
> >  	.pgd            =3D swapper_pg_dir,
> > -	.mm_users       =3D ATOMIC_INIT(2),
> > -	.mm_count       =3D ATOMIC_INIT(1),
> > +	.mm_users       =3D REFCOUNT_INIT(2),
> > +	.mm_count       =3D REFCOUNT_INIT(1),
> >  	.mmap_sem       =3D __RWSEM_INITIALIZER(init_mm.mmap_sem),
> >  	.page_table_lock =3D
> __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),
> >  	.mmlist         =3D LIST_HEAD_INIT(init_mm.mmlist),
> > diff --git a/arch/xtensa/kernel/smp.c b/arch/xtensa/kernel/smp.c
> > index fc4ad21..4e9ec31 100644
> > --- a/arch/xtensa/kernel/smp.c
> > +++ b/arch/xtensa/kernel/smp.c
> > @@ -135,7 +135,7 @@ void secondary_start_kernel(void)
> >
> >  	/* All kernel threads share the same mm context. */
> >
> > -	atomic_inc(&mm->mm_users);
> > +	refcount_inc(&mm->mm_users);
> >  	atomic_inc(&mm->mm_count);
> >  	current->active_mm =3D mm;
> >  	cpumask_set_cpu(cpu, mm_cpumask(mm));
> > diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/=
arm-
> runtime.c
> > index 349dc3e..f0571f2 100644
> > --- a/drivers/firmware/efi/arm-runtime.c
> > +++ b/drivers/firmware/efi/arm-runtime.c
> > @@ -32,8 +32,8 @@ extern u64 efi_system_table;
> >
> >  static struct mm_struct efi_mm =3D {
> >  	.mm_rb			=3D RB_ROOT,
> > -	.mm_users		=3D ATOMIC_INIT(2),
> > -	.mm_count		=3D ATOMIC_INIT(1),
> > +	.mm_users		=3D REFCOUNT_INIT(2),
> > +	.mm_count		=3D REFCOUNT_INIT(1),
> >  	.mmap_sem		=3D
> __RWSEM_INITIALIZER(efi_mm.mmap_sem),
> >  	.page_table_lock	=3D
> __SPIN_LOCK_UNLOCKED(efi_mm.page_table_lock),
> >  	.mmlist			=3D
> LIST_HEAD_INIT(efi_mm.mmlist),
> > diff --git a/drivers/gpu/drm/i915/i915_gem_userptr.c
> b/drivers/gpu/drm/i915/i915_gem_userptr.c
> > index d068af2..430eeba 100644
> > --- a/drivers/gpu/drm/i915/i915_gem_userptr.c
> > +++ b/drivers/gpu/drm/i915/i915_gem_userptr.c
> > @@ -334,7 +334,7 @@ i915_gem_userptr_init__mm_struct(struct
> drm_i915_gem_object *obj)
> >  		mm->i915 =3D to_i915(obj->base.dev);
> >
> >  		mm->mm =3D current->mm;
> > -		atomic_inc(&current->mm->mm_count);
> > +		refcount_inc(&current->mm->mm_count);
> >
> >  		mm->mn =3D NULL;
> >
> > @@ -507,7 +507,7 @@ __i915_gem_userptr_get_pages_worker(struct
> work_struct *_work)
> >  			flags |=3D FOLL_WRITE;
> >
> >  		ret =3D -EFAULT;
> > -		if (atomic_inc_not_zero(&mm->mm_users)) {
> > +		if (refcount_inc_not_zero(&mm->mm_users)) {
> >  			down_read(&mm->mmap_sem);
> >  			while (pinned < npages) {
> >  				ret =3D
> get_user_pages_remote
> > diff --git a/drivers/iommu/intel-svm.c b/drivers/iommu/intel-svm.c
> > index cb72e00..d46eb3b 100644
> > --- a/drivers/iommu/intel-svm.c
> > +++ b/drivers/iommu/intel-svm.c
> > @@ -579,7 +579,7 @@ static irqreturn_t prq_event_thread(int irq, void *=
d)
> >  		if (!svm->mm)
> >  			goto bad_req;
> >  		/* If the mm is already defunct, don't handle faults.
> */
> > -		if (!atomic_inc_not_zero(&svm->mm->mm_users))
> > +		if (!refcount_inc_not_zero(&svm->mm->mm_users))
> >  			goto bad_req;
> >  		down_read(&svm->mm->mmap_sem);
> >  		vma =3D find_extend_vma(svm->mm, address);
> > diff --git a/fs/coredump.c b/fs/coredump.c
> > index eb9c92c..5d3f725 100644
> > --- a/fs/coredump.c
> > +++ b/fs/coredump.c
> > @@ -347,7 +347,7 @@ static int zap_threads(struct task_struct *tsk, str=
uct
> mm_struct *mm,
> >  		return nr;
> >
> >  	tsk->flags |=3D PF_DUMPCORE;
> > -	if (atomic_read(&mm->mm_users) =3D=3D nr + 1)
> > +	if (refcount_read(&mm->mm_users) =3D=3D nr + 1)
> >  		goto done;
> >  	/*
> >  	 * We should find and kill all tasks which use this mm, and we should
> > diff --git a/fs/exec.c b/fs/exec.c
> > index eadbf50..d463f17 100644
> > --- a/fs/exec.c
> > +++ b/fs/exec.c
> > @@ -1174,7 +1174,7 @@ static int de_thread(struct task_struct *tsk)
> >  	flush_itimer_signals();
> >  #endif
> >
> > -	if (atomic_read(&oldsighand->count) !=3D 1) {
> > +	if (refcount_read(&oldsighand->count) !=3D 1) {
> >  		struct sighand_struct *newsighand;
> >  		/*
> >  		 * This ->sighand is shared with the CLONE_SIGHAND
> > @@ -1184,7 +1184,7 @@ static int de_thread(struct task_struct *tsk)
> >  		if (!newsighand)
> >  			return -ENOMEM;
> >
> > -		atomic_set(&newsighand->count, 1);
> > +		refcount_set(&newsighand->count, 1);
> >  		memcpy(newsighand->action, oldsighand->action,
> >  		       sizeof(newsighand->action));
> >
> > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > index 5ea8363..ef0b7ae 100644
> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -798,7 +798,7 @@ struct mm_struct *proc_mem_open(struct inode *inode=
,
> unsigned int mode)
> >
> >  		if (!IS_ERR_OR_NULL(mm)) {
> >  			/* ensure this mm_struct can't be
> freed */
> > -			atomic_inc(&mm->mm_count);
> > +			refcount_inc(&mm->mm_count);
> >  			/* but do not pin its memory */
> >  			mmput(mm);
> >  		}
> > @@ -845,7 +845,7 @@ static ssize_t mem_rw(struct file *file, char __use=
r *buf,
> >  		return -ENOMEM;
> >
> >  	copied =3D 0;
> > -	if (!atomic_inc_not_zero(&mm->mm_users))
> > +	if (!refcount_inc_not_zero(&mm->mm_users))
> >  		goto free;
> >
> >  	/* Maybe we should limit FOLL_FORCE to actual ptrace users? */
> > @@ -953,7 +953,7 @@ static ssize_t environ_read(struct file *file, char=
 __user
> *buf,
> >  		return -ENOMEM;
> >
> >  	ret =3D 0;
> > -	if (!atomic_inc_not_zero(&mm->mm_users))
> > +	if (!refcount_inc_not_zero(&mm->mm_users))
> >  		goto free;
> >
> >  	down_read(&mm->mmap_sem);
> > @@ -1094,9 +1094,9 @@ static int __set_oom_adj(struct file *file, int o=
om_adj,
> bool legacy)
> >  		struct task_struct *p =3D find_lock_task_mm(task);
> >
> >  		if (p) {
> > -			if (atomic_read(&p->mm->mm_users)
> > 1) {
> > +			if (refcount_read(&p->mm-
> >mm_users) > 1) {
> >  				mm =3D p->mm;
> > -				atomic_inc(&mm-
> >mm_count);
> > +				refcount_inc(&mm-
> >mm_count);
> >  			}
> >  			task_unlock(p);
> >  		}
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index 958f325..cc65008 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -167,7 +167,7 @@ static void *m_start(struct seq_file *m, loff_t *pp=
os)
> >  		return ERR_PTR(-ESRCH);
> >
> >  	mm =3D priv->mm;
> > -	if (!mm || !atomic_inc_not_zero(&mm->mm_users))
> > +	if (!mm || !refcount_inc_not_zero(&mm->mm_users))
> >  		return NULL;
> >
> >  	down_read(&mm->mmap_sem);
> > @@ -1352,7 +1352,7 @@ static ssize_t pagemap_read(struct file *file, ch=
ar
> __user *buf,
> >  	unsigned long end_vaddr;
> >  	int ret =3D 0, copied =3D 0;
> >
> > -	if (!mm || !atomic_inc_not_zero(&mm->mm_users))
> > +	if (!mm || !refcount_inc_not_zero(&mm->mm_users))
> >  		goto out;
> >
> >  	ret =3D -EINVAL;
> > diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
> > index 3717562..bf0b163 100644
> > --- a/fs/proc/task_nommu.c
> > +++ b/fs/proc/task_nommu.c
> > @@ -219,7 +219,7 @@ static void *m_start(struct seq_file *m, loff_t *po=
s)
> >  		return ERR_PTR(-ESRCH);
> >
> >  	mm =3D priv->mm;
> > -	if (!mm || !atomic_inc_not_zero(&mm->mm_users))
> > +	if (!mm || !refcount_inc_not_zero(&mm->mm_users))
> >  		return NULL;
> >
> >  	down_read(&mm->mmap_sem);
> > diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> > index d96e2f3..a866d9a 100644
> > --- a/fs/userfaultfd.c
> > +++ b/fs/userfaultfd.c
> > @@ -1306,7 +1306,7 @@ static struct file *userfaultfd_file_create(int f=
lags)
> >  	ctx->released =3D false;
> >  	ctx->mm =3D current->mm;
> >  	/* prevent the mm struct to be freed */
> > -	atomic_inc(&ctx->mm->mm_count);
> > +	refcount_inc(&ctx->mm->mm_count);
> >
> >  	file =3D anon_inode_getfile("[userfaultfd]", &userfaultfd_fops, ctx,
> >  				  O_RDWR | (flags &
> UFFD_SHARED_FCNTL_FLAGS));
> > diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-d=
ev-defs.h
> > index e850e76..a123fe7 100644
> > --- a/include/linux/backing-dev-defs.h
> > +++ b/include/linux/backing-dev-defs.h
> > @@ -4,6 +4,7 @@
> >  #include <linux/list.h>
> >  #include <linux/radix-tree.h>
> >  #include <linux/rbtree.h>
> > +#include <linux/refcount.h>
> >  #include <linux/spinlock.h>
> >  #include <linux/percpu_counter.h>
> >  #include <linux/percpu-refcount.h>
> > @@ -50,7 +51,7 @@ enum wb_stat_item {
> >   */
> >  struct bdi_writeback_congested {
> >  	unsigned long state;		/*
> WB_[a]sync_congested flags */
> > -	atomic_t refcnt;		/* nr of attached wb's
> and blkg */
> > +	refcount_t refcnt;		/* nr of attached wb's
> and blkg */
> >
> >  #ifdef CONFIG_CGROUP_WRITEBACK
> >  	struct backing_dev_info *bdi;	/* the associated bdi */
> > diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> > index 43b93a9..0c9f5ed 100644
> > --- a/include/linux/backing-dev.h
> > +++ b/include/linux/backing-dev.h
> > @@ -422,13 +422,13 @@ static inline bool inode_cgwb_enabled(struct inod=
e
> *inode)
> >  static inline struct bdi_writeback_congested *
> >  wb_congested_get_create(struct backing_dev_info *bdi, int blkcg_id, gf=
p_t gfp)
> >  {
> > -	atomic_inc(&bdi->wb_congested->refcnt);
> > +	refcount_inc(&bdi->wb_congested->refcnt);
> >  	return bdi->wb_congested;
> >  }
> >
> >  static inline void wb_congested_put(struct bdi_writeback_congested
> *congested)
> >  {
> > -	if (atomic_dec_and_test(&congested->refcnt))
> > +	if (refcount_dec_and_test(&congested->refcnt))
> >  		kfree(congested);
> >  }
> >
> > diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
> > index 861b467..3556adb 100644
> > --- a/include/linux/cgroup-defs.h
> > +++ b/include/linux/cgroup-defs.h
> > @@ -13,6 +13,7 @@
> >  #include <linux/wait.h>
> >  #include <linux/mutex.h>
> >  #include <linux/rcupdate.h>
> > +#include <linux/refcount.h>
> >  #include <linux/percpu-refcount.h>
> >  #include <linux/percpu-rwsem.h>
> >  #include <linux/workqueue.h>
> > @@ -149,7 +150,7 @@ struct cgroup_subsys_state {
> >   */
> >  struct css_set {
> >  	/* Reference count */
> > -	atomic_t refcount;
> > +	refcount_t refcount;
> >
> >  	/*
> >  	 * List running through all cgroup groups in the same hash
> > diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> > index c83c23f..9b0d3f4 100644
> > --- a/include/linux/cgroup.h
> > +++ b/include/linux/cgroup.h
> > @@ -22,6 +22,7 @@
> >  #include <linux/ns_common.h>
> >  #include <linux/nsproxy.h>
> >  #include <linux/user_namespace.h>
> > +#include <linux/refcount.h>
> >
> >  #include <linux/cgroup-defs.h>
> >
> > @@ -640,7 +641,7 @@ static inline void cgroup_sk_free(struct
> sock_cgroup_data *skcd) {}
> >  #endif	/* CONFIG_CGROUP_DATA */
> >
> >  struct cgroup_namespace {
> > -	atomic_t		count;
> > +	refcount_t		count;
> >  	struct ns_common	ns;
> >  	struct user_namespace	*user_ns;
> >  	struct ucounts		*ucounts;
> > @@ -675,12 +676,12 @@ copy_cgroup_ns(unsigned long flags, struct
> user_namespace *user_ns,
> >  static inline void get_cgroup_ns(struct cgroup_namespace *ns)
> >  {
> >  	if (ns)
> > -		atomic_inc(&ns->count);
> > +		refcount_inc(&ns->count);
> >  }
> >
> >  static inline void put_cgroup_ns(struct cgroup_namespace *ns)
> >  {
> > -	if (ns && atomic_dec_and_test(&ns->count))
> > +	if (ns && refcount_dec_and_test(&ns->count))
> >  		free_cgroup_ns(ns);
> >  }
> >
> > diff --git a/include/linux/cred.h b/include/linux/cred.h
> > index f0e70a1..25fdc87 100644
> > --- a/include/linux/cred.h
> > +++ b/include/linux/cred.h
> > @@ -17,6 +17,7 @@
> >  #include <linux/key.h>
> >  #include <linux/selinux.h>
> >  #include <linux/atomic.h>
> > +#include <linux/refcount.h>
> >  #include <linux/uidgid.h>
> >
> >  struct user_struct;
> > @@ -27,7 +28,7 @@ struct inode;
> >   * COW Supplementary groups list
> >   */
> >  struct group_info {
> > -	atomic_t	usage;
> > +	refcount_t	usage;
> >  	int		ngroups;
> >  	kgid_t		gid[0];
> >  };
> > @@ -43,7 +44,7 @@ struct group_info {
> >   */
> >  static inline struct group_info *get_group_info(struct group_info *gi)
> >  {
> > -	atomic_inc(&gi->usage);
> > +	refcount_inc(&gi->usage);
> >  	return gi;
> >  }
> >
> > @@ -53,7 +54,7 @@ static inline struct group_info *get_group_info(struc=
t
> group_info *gi)
> >   */
> >  #define put_group_info(group_info)			\
> >  do {
> 		\
> > -	if (atomic_dec_and_test(&(group_info)->usage))	\
> > +	if (refcount_dec_and_test(&(group_info)->usage))	\
> >  		groups_free(group_info);		\
> >  } while (0)
> >
> > @@ -107,7 +108,7 @@ extern bool may_setgroups(void);
> >   * same context as task->real_cred.
> >   */
> >  struct cred {
> > -	atomic_t	usage;
> > +	refcount_t	usage;
> >  #ifdef CONFIG_DEBUG_CREDENTIALS
> >  	atomic_t	subscribers;	/* number of processes subscribed */
> >  	void		*put_addr;
> > @@ -220,7 +221,7 @@ static inline bool cap_ambient_invariant_ok(const s=
truct
> cred *cred)
> >   */
> >  static inline struct cred *get_new_cred(struct cred *cred)
> >  {
> > -	atomic_inc(&cred->usage);
> > +	refcount_inc(&cred->usage);
> >  	return cred;
> >  }
> >
> > @@ -260,7 +261,7 @@ static inline void put_cred(const struct cred *_cre=
d)
> >  	struct cred *cred =3D (struct cred *) _cred;
> >
> >  	validate_creds(cred);
> > -	if (atomic_dec_and_test(&(cred)->usage))
> > +	if (refcount_dec_and_test(&(cred)->usage))
> >  		__put_cred(cred);
> >  }
> >
> > diff --git a/include/linux/init_task.h b/include/linux/init_task.h
> > index 325f649..9b84ce6 100644
> > --- a/include/linux/init_task.h
> > +++ b/include/linux/init_task.h
> > @@ -12,6 +12,7 @@
> >  #include <linux/securebits.h>
> >  #include <linux/seqlock.h>
> >  #include <linux/rbtree.h>
> > +#include <linux/refcount.h>
> >  #include <net/net_namespace.h>
> >  #include <linux/sched/rt.h>
> >
> > @@ -65,7 +66,7 @@ extern struct fs_struct init_fs;
> >  extern struct nsproxy init_nsproxy;
> >
> >  #define INIT_SIGHAND(sighand) {
> 			\
> > -	.count		=3D ATOMIC_INIT(1),
> 			\
> > +	.count		=3D REFCOUNT_INIT(1),
> 			\
> >  	.action		=3D { { { .sa_handler =3D SIG_DFL, } }, },
> 		\
> >  	.siglock	=3D __SPIN_LOCK_UNLOCKED(sighand.siglock),
> 	\
> >  	.signalfd_wqh	=3D
> __WAIT_QUEUE_HEAD_INITIALIZER(sighand.signalfd_wqh),	\
> > @@ -188,7 +189,7 @@ extern struct task_group root_task_group;
> >  #ifdef CONFIG_THREAD_INFO_IN_TASK
> >  # define INIT_TASK_TI(tsk)			\
> >  	.thread_info =3D INIT_THREAD_INFO(tsk),	\
> > -	.stack_refcount =3D ATOMIC_INIT(1),
> > +	.stack_refcount =3D REFCOUNT_INIT(1),
> >  #else
> >  # define INIT_TASK_TI(tsk)
> >  #endif
> > @@ -202,7 +203,7 @@ extern struct task_group root_task_group;
> >  	INIT_TASK_TI(tsk)
> 			\
> >  	.state		=3D 0,
> 				\
> >  	.stack		=3D init_stack,
> 			\
> > -	.usage		=3D ATOMIC_INIT(2),
> 			\
> > +	.usage		=3D REFCOUNT_INIT(2),
> 			\
> >  	.flags		=3D PF_KTHREAD,
> 				\
> >  	.prio		=3D MAX_PRIO-20,
> 				\
> >  	.static_prio	=3D MAX_PRIO-20,
> 			\
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 1c5190d..865ec17 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -26,6 +26,7 @@
> >  #include <linux/context_tracking.h>
> >  #include <linux/irqbypass.h>
> >  #include <linux/swait.h>
> > +#include <linux/refcount.h>
> >  #include <asm/signal.h>
> >
> >  #include <linux/kvm.h>
> > @@ -403,7 +404,7 @@ struct kvm {
> >  #endif
> >  	struct kvm_vm_stat stat;
> >  	struct kvm_arch arch;
> > -	atomic_t users_count;
> > +	refcount_t users_count;
> >  #ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
> >  	struct kvm_coalesced_mmio_ring *coalesced_mmio_ring;
> >  	spinlock_t ring_lock;
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index 808751d..f4b048f 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -7,6 +7,7 @@
> >  #include <linux/list.h>
> >  #include <linux/spinlock.h>
> >  #include <linux/rbtree.h>
> > +#include <linux/refcount.h>
> >  #include <linux/rwsem.h>
> >  #include <linux/completion.h>
> >  #include <linux/cpumask.h>
> > @@ -407,8 +408,8 @@ struct mm_struct {
> >  	unsigned long task_size;		/* size of task vm
> space */
> >  	unsigned long highest_vm_end;		/*
> highest vma end address */
> >  	pgd_t * pgd;
> > -	atomic_t mm_users;			/* How
> many users with user space? */
> > -	atomic_t mm_count;			/* How
> many references to "struct mm_struct" (users count as 1) */
> > +	refcount_t mm_users;			/* How
> many users with user space? */
> > +	refcount_t mm_count;			/* How
> many references to "struct mm_struct" (users count as 1) */
> >  	atomic_long_t nr_ptes;			/* PTE
> page table pages */
> >  #if CONFIG_PGTABLE_LEVELS > 2
> >  	atomic_long_t nr_pmds;			/* PMD
> page table pages */
> > diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
> > index ac0d65b..f862ba8 100644
> > --- a/include/linux/nsproxy.h
> > +++ b/include/linux/nsproxy.h
> > @@ -28,7 +28,7 @@ struct fs_struct;
> >   * nsproxy is copied.
> >   */
> >  struct nsproxy {
> > -	atomic_t count;
> > +	refcount_t count;
> >  	struct uts_namespace *uts_ns;
> >  	struct ipc_namespace *ipc_ns;
> >  	struct mnt_namespace *mnt_ns;
> > @@ -74,14 +74,14 @@ int __init nsproxy_cache_init(void);
> >
> >  static inline void put_nsproxy(struct nsproxy *ns)
> >  {
> > -	if (atomic_dec_and_test(&ns->count)) {
> > +	if (refcount_dec_and_test(&ns->count)) {
> >  		free_nsproxy(ns);
> >  	}
> >  }
> >
> >  static inline void get_nsproxy(struct nsproxy *ns)
> >  {
> > -	atomic_inc(&ns->count);
> > +	refcount_inc(&ns->count);
> >  }
> >
> >  #endif
> > diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> > index 4741ecd..321a332 100644
> > --- a/include/linux/perf_event.h
> > +++ b/include/linux/perf_event.h
> > @@ -54,6 +54,7 @@ struct perf_guest_info_callbacks {
> >  #include <linux/perf_regs.h>
> >  #include <linux/workqueue.h>
> >  #include <linux/cgroup.h>
> > +#include <linux/refcount.h>
> >  #include <asm/local.h>
> >
> >  struct perf_callchain_entry {
> > @@ -741,7 +742,7 @@ struct perf_event_context {
> >  	int				nr_stat;
> >  	int				nr_freq;
> >  	int
> 	rotate_disable;
> > -	atomic_t			refcount;
> > +	refcount_t			refcount;
> >  	struct task_struct		*task;
> >
> >  	/*
> > diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> > index 15321fb..8c8f896 100644
> > --- a/include/linux/rmap.h
> > +++ b/include/linux/rmap.h
> > @@ -9,6 +9,7 @@
> >  #include <linux/mm.h>
> >  #include <linux/rwsem.h>
> >  #include <linux/memcontrol.h>
> > +#include <linux/refcount.h>
> >
> >  /*
> >   * The anon_vma heads a list of private "related" vmas, to scan if
> > @@ -34,7 +35,7 @@ struct anon_vma {
> >  	 * the reference is responsible for clearing up the
> >  	 * anon_vma if they are the last user on release
> >  	 */
> > -	atomic_t refcount;
> > +	refcount_t refcount;
> >
> >  	/*
> >  	 * Count of child anon_vmas and VMAs which points to this
> anon_vma.
> > @@ -101,14 +102,14 @@ enum ttu_flags {
> >  #ifdef CONFIG_MMU
> >  static inline void get_anon_vma(struct anon_vma *anon_vma)
> >  {
> > -	atomic_inc(&anon_vma->refcount);
> > +	refcount_inc(&anon_vma->refcount);
> >  }
> >
> >  void __put_anon_vma(struct anon_vma *anon_vma);
> >
> >  static inline void put_anon_vma(struct anon_vma *anon_vma)
> >  {
> > -	if (atomic_dec_and_test(&anon_vma->refcount))
> > +	if (refcount_dec_and_test(&anon_vma->refcount))
> >  		__put_anon_vma(anon_vma);
> >  }
> >
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 4d19052..4d7bd87 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -43,6 +43,7 @@ struct sched_param {
> >  #include <linux/seccomp.h>
> >  #include <linux/rcupdate.h>
> >  #include <linux/rculist.h>
> > +#include <linux/refcount.h>
> >  #include <linux/rtmutex.h>
> >
> >  #include <linux/time.h>
> > @@ -555,7 +556,7 @@ static inline int get_dumpable(struct mm_struct *mm=
)
> >  #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK |
> MMF_DUMP_FILTER_MASK)
> >
> >  struct sighand_struct {
> > -	atomic_t		count;
> > +	refcount_t		count;
> >  	struct k_sigaction	action[_NSIG];
> >  	spinlock_t		siglock;
> >  	wait_queue_head_t	signalfd_wqh;
> > @@ -695,7 +696,7 @@ struct autogroup;
> >   * the locking of signal_struct.
> >   */
> >  struct signal_struct {
> > -	atomic_t		sigcnt;
> > +	refcount_t		sigcnt;
> >  	atomic_t		live;
> >  	int			nr_threads;
> >  	struct list_head	thread_head;
> > @@ -865,7 +866,7 @@ static inline int signal_group_exit(const struct
> signal_struct *sig)
> >   * Some day this will be a full-fledged user tracking system..
> >   */
> >  struct user_struct {
> > -	atomic_t __count;	/* reference count */
> > +	refcount_t __count;	/* reference count */
> >  	atomic_t processes;	/* How many processes does this
> user have? */
> >  	atomic_t sigpending;	/* How many pending signals does
> this user have? */
> >  #ifdef CONFIG_INOTIFY_USER
> > @@ -1508,7 +1509,7 @@ struct task_struct {
> >  #endif
> >  	volatile long state;	/* -1 unrunnable, 0 runnable, >0
> stopped */
> >  	void *stack;
> > -	atomic_t usage;
> > +	refcount_t usage;
> >  	unsigned int flags;	/* per process flags, defined below */
> >  	unsigned int ptrace;
> >
> > @@ -1986,7 +1987,7 @@ struct task_struct {
> >  #endif
> >  #ifdef CONFIG_THREAD_INFO_IN_TASK
> >  	/* A live task holds one reference. */
> > -	atomic_t stack_refcount;
> > +	refcount_t stack_refcount;
> >  #endif
> >  /* CPU-specific state of this task */
> >  	struct thread_struct thread;
> > @@ -2237,13 +2238,13 @@ static inline int is_global_init(struct task_st=
ruct *tsk)
> >  extern struct pid *cad_pid;
> >
> >  extern void free_task(struct task_struct *tsk);
> > -#define get_task_struct(tsk) do { atomic_inc(&(tsk)->usage); } while(0=
)
> > +#define get_task_struct(tsk) do { refcount_inc(&(tsk)->usage); } while=
(0)
> >
> >  extern void __put_task_struct(struct task_struct *t);
> >
> >  static inline void put_task_struct(struct task_struct *t)
> >  {
> > -	if (atomic_dec_and_test(&t->usage))
> > +	if (refcount_dec_and_test(&t->usage))
> >  		__put_task_struct(t);
> >  }
> >
> > @@ -2703,7 +2704,7 @@ extern struct task_struct *find_task_by_pid_ns(pi=
d_t
> nr,
> >  extern struct user_struct * alloc_uid(kuid_t);
> >  static inline struct user_struct *get_uid(struct user_struct *u)
> >  {
> > -	atomic_inc(&u->__count);
> > +	refcount_inc(&u->__count);
> >  	return u;
> >  }
> >  extern void free_uid(struct user_struct *);
> > @@ -2918,7 +2919,7 @@ extern struct mm_struct * mm_alloc(void);
> >  extern void __mmdrop(struct mm_struct *);
> >  static inline void mmdrop(struct mm_struct *mm)
> >  {
> > -	if (unlikely(atomic_dec_and_test(&mm->mm_count)))
> > +	if (unlikely(refcount_dec_and_test(&mm->mm_count)))
> >  		__mmdrop(mm);
> >  }
> >
> > @@ -2930,7 +2931,7 @@ static inline void mmdrop_async_fn(struct
> work_struct *work)
> >
> >  static inline void mmdrop_async(struct mm_struct *mm)
> >  {
> > -	if (unlikely(atomic_dec_and_test(&mm->mm_count))) {
> > +	if (unlikely(refcount_dec_and_test(&mm->mm_count))) {
> >  		INIT_WORK(&mm->async_put_work,
> mmdrop_async_fn);
> >  		schedule_work(&mm->async_put_work);
> >  	}
> > @@ -2938,7 +2939,7 @@ static inline void mmdrop_async(struct mm_struct
> *mm)
> >
> >  static inline bool mmget_not_zero(struct mm_struct *mm)
> >  {
> > -	return atomic_inc_not_zero(&mm->mm_users);
> > +	return refcount_inc_not_zero(&mm->mm_users);
> >  }
> >
> >  /* mmput gets rid of the mappings and all user-space */
> > @@ -3223,7 +3224,7 @@ static inline unsigned long *end_of_stack(struct
> task_struct *p)
> >  #ifdef CONFIG_THREAD_INFO_IN_TASK
> >  static inline void *try_get_task_stack(struct task_struct *tsk)
> >  {
> > -	return atomic_inc_not_zero(&tsk->stack_refcount) ?
> > +	return refcount_inc_not_zero(&tsk->stack_refcount) ?
> >  		task_stack_page(tsk) : NULL;
> >  }
> >
> > diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
> > index 8b1dde9..8a7533b 100644
> > --- a/kernel/audit_tree.c
> > +++ b/kernel/audit_tree.c
> > @@ -9,7 +9,7 @@ struct audit_tree;
> >  struct audit_chunk;
> >
> >  struct audit_tree {
> > -	atomic_t count;
> > +	refcount_t count;
> >  	int goner;
> >  	struct audit_chunk *root;
> >  	struct list_head chunks;
> > @@ -77,7 +77,7 @@ static struct audit_tree *alloc_tree(const char *s)
> >
> >  	tree =3D kmalloc(sizeof(struct audit_tree) + strlen(s) + 1,
> GFP_KERNEL);
> >  	if (tree) {
> > -		atomic_set(&tree->count, 1);
> > +		refcount_set(&tree->count, 1);
> >  		tree->goner =3D 0;
> >  		INIT_LIST_HEAD(&tree->chunks);
> >  		INIT_LIST_HEAD(&tree->rules);
> > @@ -91,12 +91,12 @@ static struct audit_tree *alloc_tree(const char *s)
> >
> >  static inline void get_tree(struct audit_tree *tree)
> >  {
> > -	atomic_inc(&tree->count);
> > +	refcount_inc(&tree->count);
> >  }
> >
> >  static inline void put_tree(struct audit_tree *tree)
> >  {
> > -	if (atomic_dec_and_test(&tree->count))
> > +	if (refcount_dec_and_test(&tree->count))
> >  		kfree_rcu(tree, head);
> >  }
> >
> > @@ -963,7 +963,7 @@ static void audit_tree_freeing_mark(struct
> fsnotify_mark *entry, struct fsnotify
> >  	 * We are guaranteed to have at least one reference to the mark
> from
> >  	 * either the inode or the caller of fsnotify_destroy_mark().
> >  	 */
> > -	BUG_ON(atomic_read(&entry->refcnt) < 1);
> > +	BUG_ON(refcount_read(&entry->refcnt) < 1);
> >  }
> >
> >  static const struct fsnotify_ops audit_tree_ops =3D {
> > diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
> > index f79e465..8ca9e6c 100644
> > --- a/kernel/audit_watch.c
> > +++ b/kernel/audit_watch.c
> > @@ -46,7 +46,7 @@
> >   */
> >
> >  struct audit_watch {
> > -	atomic_t		count;	/* reference count */
> > +	refcount_t		count;	/* reference count */
> >  	dev_t			dev;	/*
> associated superblock device */
> >  	char			*path;	/*
> insertion path */
> >  	unsigned long		ino;	/* associated inode
> number */
> > @@ -111,12 +111,12 @@ static inline struct audit_parent
> *audit_find_parent(struct inode *inode)
> >
> >  void audit_get_watch(struct audit_watch *watch)
> >  {
> > -	atomic_inc(&watch->count);
> > +	refcount_inc(&watch->count);
> >  }
> >
> >  void audit_put_watch(struct audit_watch *watch)
> >  {
> > -	if (atomic_dec_and_test(&watch->count)) {
> > +	if (refcount_dec_and_test(&watch->count)) {
> >  		WARN_ON(watch->parent);
> >  		WARN_ON(!list_empty(&watch->rules));
> >  		kfree(watch->path);
> > @@ -178,7 +178,7 @@ static struct audit_watch *audit_init_watch(char *p=
ath)
> >  		return ERR_PTR(-ENOMEM);
> >
> >  	INIT_LIST_HEAD(&watch->rules);
> > -	atomic_set(&watch->count, 1);
> > +	refcount_set(&watch->count, 1);
> >  	watch->path =3D path;
> >  	watch->dev =3D AUDIT_DEV_UNSET;
> >  	watch->ino =3D AUDIT_INO_UNSET;
> > diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> > index 2ee9ec3..bfed258 100644
> > --- a/kernel/cgroup.c
> > +++ b/kernel/cgroup.c
> > @@ -223,7 +223,7 @@ static u16 have_free_callback __read_mostly;
> >
> >  /* cgroup namespace for init task */
> >  struct cgroup_namespace init_cgroup_ns =3D {
> > -	.count		=3D { .counter =3D 2, },
> > +	.count		=3D REFCOUNT_INIT(2),
> >  	.user_ns	=3D &init_user_ns,
> >  	.ns.ops		=3D &cgroupns_operations,
> >  	.ns.inum	=3D PROC_CGROUP_INIT_INO,
> > @@ -646,7 +646,7 @@ struct cgrp_cset_link {
> >   * haven't been created.
> >   */
> >  struct css_set init_css_set =3D {
> > -	.refcount		=3D ATOMIC_INIT(1),
> > +	.refcount		=3D REFCOUNT_INIT(1),
> >  	.cgrp_links		=3D
> LIST_HEAD_INIT(init_css_set.cgrp_links),
> >  	.tasks			=3D
> LIST_HEAD_INIT(init_css_set.tasks),
> >  	.mg_tasks		=3D
> LIST_HEAD_INIT(init_css_set.mg_tasks),
> > @@ -816,7 +816,7 @@ static void put_css_set_locked(struct css_set *cset=
)
> >
> >  	lockdep_assert_held(&css_set_lock);
> >
> > -	if (!atomic_dec_and_test(&cset->refcount))
> > +	if (!refcount_dec_and_test(&cset->refcount))
> >  		return;
> >
> >  	/* This css_set is dead. unlink it and release cgroup and css refs */
> > @@ -847,10 +847,13 @@ static void put_css_set(struct css_set *cset)
> >  	 * can see it. Similar to atomic_dec_and_lock(), but for an
> >  	 * rwlock
> >  	 */
> > -	if (atomic_add_unless(&cset->refcount, -1, 1))
> > +	spin_lock_irqsave(&css_set_lock, flags);
> > +	if (refcount_read(&cset->refcount) !=3D 1) {
> > +		WARN_ON(refcount_dec_and_test(&cset-
> >refcount));
> > +		spin_unlock_irqrestore(&css_set_lock, flags);
> >  		return;
> > +	}
> >
> > -	spin_lock_irqsave(&css_set_lock, flags);
> >  	put_css_set_locked(cset);
> >  	spin_unlock_irqrestore(&css_set_lock, flags);
> >  }
> > @@ -860,7 +863,7 @@ static void put_css_set(struct css_set *cset)
> >   */
> >  static inline void get_css_set(struct css_set *cset)
> >  {
> > -	atomic_inc(&cset->refcount);
> > +	refcount_inc(&cset->refcount);
> >  }
> >
> >  /**
> > @@ -1094,7 +1097,7 @@ static struct css_set *find_css_set(struct css_se=
t
> *old_cset,
> >  		return NULL;
> >  	}
> >
> > -	atomic_set(&cset->refcount, 1);
> > +	refcount_set(&cset->refcount, 1);
> >  	INIT_LIST_HEAD(&cset->cgrp_links);
> >  	INIT_LIST_HEAD(&cset->tasks);
> >  	INIT_LIST_HEAD(&cset->mg_tasks);
> > @@ -3940,7 +3943,7 @@ static int cgroup_task_count(const struct cgroup
> *cgrp)
> >
> >  	spin_lock_irq(&css_set_lock);
> >  	list_for_each_entry(link, &cgrp->cset_links, cset_link)
> > -		count +=3D atomic_read(&link->cset->refcount);
> > +		count +=3D refcount_read(&link->cset->refcount);
> >  	spin_unlock_irq(&css_set_lock);
> >  	return count;
> >  }
> > @@ -6377,7 +6380,7 @@ static struct cgroup_namespace
> *alloc_cgroup_ns(void)
> >  		kfree(new_ns);
> >  		return ERR_PTR(ret);
> >  	}
> > -	atomic_set(&new_ns->count, 1);
> > +	refcount_set(&new_ns->count, 1);
> >  	new_ns->ns.ops =3D &cgroupns_operations;
> >  	return new_ns;
> >  }
> > @@ -6548,7 +6551,7 @@ static u64 current_css_set_refcount_read(struct
> cgroup_subsys_state *css,
> >  	u64 count;
> >
> >  	rcu_read_lock();
> > -	count =3D atomic_read(&task_css_set(current)->refcount);
> > +	count =3D refcount_read(&task_css_set(current)->refcount);
> >  	rcu_read_unlock();
> >  	return count;
> >  }
> > diff --git a/kernel/cred.c b/kernel/cred.c
> > index 5f264fb..31ebce0 100644
> > --- a/kernel/cred.c
> > +++ b/kernel/cred.c
> > @@ -35,13 +35,13 @@ do {
>=20
> 	\
> >  static struct kmem_cache *cred_jar;
> >
> >  /* init to 2 - one for init_task, one to ensure it is never freed */
> > -struct group_info init_groups =3D { .usage =3D ATOMIC_INIT(2) };
> > +struct group_info init_groups =3D { .usage =3D REFCOUNT_INIT(2) };
> >
> >  /*
> >   * The initial credentials for the initial task
> >   */
> >  struct cred init_cred =3D {
> > -	.usage			=3D ATOMIC_INIT(4),
> > +	.usage			=3D REFCOUNT_INIT(4),
> >  #ifdef CONFIG_DEBUG_CREDENTIALS
> >  	.subscribers		=3D ATOMIC_INIT(2),
> >  	.magic			=3D CRED_MAGIC,
> > @@ -100,17 +100,17 @@ static void put_cred_rcu(struct rcu_head *rcu)
> >
> >  #ifdef CONFIG_DEBUG_CREDENTIALS
> >  	if (cred->magic !=3D CRED_MAGIC_DEAD ||
> > -	    atomic_read(&cred->usage) !=3D 0 ||
> > +	    refcount_read(&cred->usage) !=3D 0 ||
> >  	    read_cred_subscribers(cred) !=3D 0)
> >  		panic("CRED: put_cred_rcu() sees %p with"
> >  		      " mag %x, put %p, usage %d, subscr %d\n",
> >  		      cred, cred->magic, cred->put_addr,
> > -		      atomic_read(&cred->usage),
> > +		      refcount_read(&cred->usage),
> >  		      read_cred_subscribers(cred));
> >  #else
> > -	if (atomic_read(&cred->usage) !=3D 0)
> > +	if (refcount_read(&cred->usage) !=3D 0)
> >  		panic("CRED: put_cred_rcu() sees %p with usage
> %d\n",
> > -		      cred, atomic_read(&cred->usage));
> > +		      cred, refcount_read(&cred->usage));
> >  #endif
> >
> >  	security_cred_free(cred);
> > @@ -134,10 +134,10 @@ static void put_cred_rcu(struct rcu_head *rcu)
> >  void __put_cred(struct cred *cred)
> >  {
> >  	kdebug("__put_cred(%p{%d,%d})", cred,
> > -	       atomic_read(&cred->usage),
> > +	       refcount_read(&cred->usage),
> >  	       read_cred_subscribers(cred));
> >
> > -	BUG_ON(atomic_read(&cred->usage) !=3D 0);
> > +	BUG_ON(refcount_read(&cred->usage) !=3D 0);
> >  #ifdef CONFIG_DEBUG_CREDENTIALS
> >  	BUG_ON(read_cred_subscribers(cred) !=3D 0);
> >  	cred->magic =3D CRED_MAGIC_DEAD;
> > @@ -158,7 +158,7 @@ void exit_creds(struct task_struct *tsk)
> >  	struct cred *cred;
> >
> >  	kdebug("exit_creds(%u,%p,%p,{%d,%d})", tsk->pid, tsk->real_cred,
> tsk->cred,
> > -	       atomic_read(&tsk->cred->usage),
> > +	       refcount_read(&tsk->cred->usage),
> >  	       read_cred_subscribers(tsk->cred));
> >
> >  	cred =3D (struct cred *) tsk->real_cred;
> > @@ -193,7 +193,7 @@ const struct cred *get_task_cred(struct task_struct
> *task)
> >  	do {
> >  		cred =3D __task_cred((task));
> >  		BUG_ON(!cred);
> > -	} while (!atomic_inc_not_zero(&((struct cred *)cred)->usage));
> > +	} while (!refcount_inc_not_zero(&((struct cred *)cred)->usage));
> >
> >  	rcu_read_unlock();
> >  	return cred;
> > @@ -211,7 +211,7 @@ struct cred *cred_alloc_blank(void)
> >  	if (!new)
> >  		return NULL;
> >
> > -	atomic_set(&new->usage, 1);
> > +	refcount_set(&new->usage, 1);
> >  #ifdef CONFIG_DEBUG_CREDENTIALS
> >  	new->magic =3D CRED_MAGIC;
> >  #endif
> > @@ -257,7 +257,7 @@ struct cred *prepare_creds(void)
> >  	old =3D task->cred;
> >  	memcpy(new, old, sizeof(struct cred));
> >
> > -	atomic_set(&new->usage, 1);
> > +	refcount_set(&new->usage, 1);
> >  	set_cred_subscribers(new, 0);
> >  	get_group_info(new->group_info);
> >  	get_uid(new->user);
> > @@ -334,7 +334,7 @@ int copy_creds(struct task_struct *p, unsigned long
> clone_flags)
> >  		get_cred(p->cred);
> >  		alter_cred_subscribers(p->cred, 2);
> >  		kdebug("share_creds(%p{%d,%d})",
> > -		       p->cred, atomic_read(&p->cred->usage),
> > +		       p->cred, refcount_read(&p->cred->usage),
> >  		       read_cred_subscribers(p->cred));
> >  		atomic_inc(&p->cred->user->processes);
> >  		return 0;
> > @@ -425,7 +425,7 @@ int commit_creds(struct cred *new)
> >  	const struct cred *old =3D task->real_cred;
> >
> >  	kdebug("commit_creds(%p{%d,%d})", new,
> > -	       atomic_read(&new->usage),
> > +	       refcount_read(&new->usage),
> >  	       read_cred_subscribers(new));
> >
> >  	BUG_ON(task->cred !=3D old);
> > @@ -434,7 +434,7 @@ int commit_creds(struct cred *new)
> >  	validate_creds(old);
> >  	validate_creds(new);
> >  #endif
> > -	BUG_ON(atomic_read(&new->usage) < 1);
> > +	BUG_ON(refcount_read(&new->usage) < 1);
> >
> >  	get_cred(new); /* we will require a ref for the subj creds too */
> >
> > @@ -499,13 +499,13 @@ EXPORT_SYMBOL(commit_creds);
> >  void abort_creds(struct cred *new)
> >  {
> >  	kdebug("abort_creds(%p{%d,%d})", new,
> > -	       atomic_read(&new->usage),
> > +	       refcount_read(&new->usage),
> >  	       read_cred_subscribers(new));
> >
> >  #ifdef CONFIG_DEBUG_CREDENTIALS
> >  	BUG_ON(read_cred_subscribers(new) !=3D 0);
> >  #endif
> > -	BUG_ON(atomic_read(&new->usage) < 1);
> > +	BUG_ON(refcount_read(&new->usage) < 1);
> >  	put_cred(new);
> >  }
> >  EXPORT_SYMBOL(abort_creds);
> > @@ -522,7 +522,7 @@ const struct cred *override_creds(const struct cred
> *new)
> >  	const struct cred *old =3D current->cred;
> >
> >  	kdebug("override_creds(%p{%d,%d})", new,
> > -	       atomic_read(&new->usage),
> > +	       refcount_read(&new->usage),
> >  	       read_cred_subscribers(new));
> >
> >  	validate_creds(old);
> > @@ -533,7 +533,7 @@ const struct cred *override_creds(const struct cred
> *new)
> >  	alter_cred_subscribers(old, -1);
> >
> >  	kdebug("override_creds() =3D %p{%d,%d}", old,
> > -	       atomic_read(&old->usage),
> > +	       refcount_read(&old->usage),
> >  	       read_cred_subscribers(old));
> >  	return old;
> >  }
> > @@ -551,7 +551,7 @@ void revert_creds(const struct cred *old)
> >  	const struct cred *override =3D current->cred;
> >
> >  	kdebug("revert_creds(%p{%d,%d})", old,
> > -	       atomic_read(&old->usage),
> > +	       refcount_read(&old->usage),
> >  	       read_cred_subscribers(old));
> >
> >  	validate_creds(old);
> > @@ -610,7 +610,7 @@ struct cred *prepare_kernel_cred(struct task_struct
> *daemon)
> >  	validate_creds(old);
> >
> >  	*new =3D *old;
> > -	atomic_set(&new->usage, 1);
> > +	refcount_set(&new->usage, 1);
> >  	set_cred_subscribers(new, 0);
> >  	get_uid(new->user);
> >  	get_user_ns(new->user_ns);
> > @@ -734,7 +734,7 @@ static void dump_invalid_creds(const struct cred *c=
red,
> const char *label,
> >  	printk(KERN_ERR "CRED: ->magic=3D%x, put_addr=3D%p\n",
> >  	       cred->magic, cred->put_addr);
> >  	printk(KERN_ERR "CRED: ->usage=3D%d, subscr=3D%d\n",
> > -	       atomic_read(&cred->usage),
> > +	       refcount_read(&cred->usage),
> >  	       read_cred_subscribers(cred));
> >  	printk(KERN_ERR "CRED: ->*uid =3D { %d,%d,%d,%d }\n",
> >  		from_kuid_munged(&init_user_ns, cred->uid),
> > @@ -808,7 +808,7 @@ void validate_creds_for_do_exit(struct task_struct =
*tsk)
> >  {
> >  	kdebug("validate_creds_for_do_exit(%p,%p{%d,%d})",
> >  	       tsk->real_cred, tsk->cred,
> > -	       atomic_read(&tsk->cred->usage),
> > +	       refcount_read(&tsk->cred->usage),
> >  	       read_cred_subscribers(tsk->cred));
> >
> >  	__validate_process_creds(tsk, __FILE__, __LINE__);
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index ab15509..8c03c27 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -1117,7 +1117,7 @@ static void perf_event_ctx_deactivate(struct
> perf_event_context *ctx)
> >
> >  static void get_ctx(struct perf_event_context *ctx)
> >  {
> > -	WARN_ON(!atomic_inc_not_zero(&ctx->refcount));
> > +	WARN_ON(!refcount_inc_not_zero(&ctx->refcount));
> >  }
> >
> >  static void free_ctx(struct rcu_head *head)
> > @@ -1131,7 +1131,7 @@ static void free_ctx(struct rcu_head *head)
> >
> >  static void put_ctx(struct perf_event_context *ctx)
> >  {
> > -	if (atomic_dec_and_test(&ctx->refcount)) {
> > +	if (refcount_dec_and_test(&ctx->refcount)) {
> >  		if (ctx->parent_ctx)
> >  			put_ctx(ctx->parent_ctx);
> >  		if (ctx->task && ctx->task !=3D TASK_TOMBSTONE)
> > @@ -1209,7 +1209,7 @@ perf_event_ctx_lock_nested(struct perf_event
> *event, int nesting)
> >  again:
> >  	rcu_read_lock();
> >  	ctx =3D ACCESS_ONCE(event->ctx);
> > -	if (!atomic_inc_not_zero(&ctx->refcount)) {
> > +	if (!refcount_inc_not_zero(&ctx->refcount)) {
> >  		rcu_read_unlock();
> >  		goto again;
> >  	}
> > @@ -1337,7 +1337,7 @@ perf_lock_task_context(struct task_struct *task, =
int
> ctxn, unsigned long *flags)
> >  		}
> >
> >  		if (ctx->task =3D=3D TASK_TOMBSTONE ||
> > -		    !atomic_inc_not_zero(&ctx->refcount)) {
> > +		    !refcount_inc_not_zero(&ctx->refcount)) {
> >  			raw_spin_unlock(&ctx->lock);
> >  			ctx =3D NULL;
> >  		} else {
> > @@ -3639,7 +3639,7 @@ static void __perf_event_init_context(struct
> perf_event_context *ctx)
> >  	INIT_LIST_HEAD(&ctx->pinned_groups);
> >  	INIT_LIST_HEAD(&ctx->flexible_groups);
> >  	INIT_LIST_HEAD(&ctx->event_list);
> > -	atomic_set(&ctx->refcount, 1);
> > +	refcount_set(&ctx->refcount, 1);
> >  }
> >
> >  static struct perf_event_context *
> > @@ -4934,7 +4934,7 @@ struct ring_buffer *ring_buffer_get(struct perf_e=
vent
> *event)
> >  	rcu_read_lock();
> >  	rb =3D rcu_dereference(event->rb);
> >  	if (rb) {
> > -		if (!atomic_inc_not_zero(&rb->refcount))
> > +		if (!refcount_inc_not_zero(&rb->refcount))
> >  			rb =3D NULL;
> >  	}
> >  	rcu_read_unlock();
> > @@ -4944,7 +4944,7 @@ struct ring_buffer *ring_buffer_get(struct perf_e=
vent
> *event)
> >
> >  void ring_buffer_put(struct ring_buffer *rb)
> >  {
> > -	if (!atomic_dec_and_test(&rb->refcount))
> > +	if (!refcount_dec_and_test(&rb->refcount))
> >  		return;
> >
> >  	WARN_ON_ONCE(!list_empty(&rb->event_list));
> > @@ -5009,7 +5009,7 @@ static void perf_mmap_close(struct vm_area_struct
> *vma)
> >
> >  		/* this has to be the last one */
> >  		rb_free_aux(rb);
> > -		WARN_ON_ONCE(atomic_read(&rb-
> >aux_refcount));
> > +		WARN_ON_ONCE(refcount_read(&rb-
> >aux_refcount));
> >
> >  		mutex_unlock(&event->mmap_mutex);
> >  	}
> > diff --git a/kernel/events/internal.h b/kernel/events/internal.h
> > index 486fd78..b36d917 100644
> > --- a/kernel/events/internal.h
> > +++ b/kernel/events/internal.h
> > @@ -2,6 +2,7 @@
> >  #define _KERNEL_EVENTS_INTERNAL_H
> >
> >  #include <linux/hardirq.h>
> > +#include <linux/refcount.h>
> >  #include <linux/uaccess.h>
> >
> >  /* Buffer handling */
> > @@ -9,7 +10,7 @@
> >  #define RING_BUFFER_WRITABLE		0x01
> >
> >  struct ring_buffer {
> > -	atomic_t			refcount;
> > +	refcount_t			refcount;
> >  	struct rcu_head
> 	rcu_head;
> >  #ifdef CONFIG_PERF_USE_VMALLOC
> >  	struct work_struct		work;
> > @@ -47,7 +48,7 @@ struct ring_buffer {
> >  	atomic_t			aux_mmap_count;
> >  	unsigned long			aux_mmap_locked;
> >  	void
> 	(*free_aux)(void *);
> > -	atomic_t			aux_refcount;
> > +	refcount_t			aux_refcount;
> >  	void
> 	**aux_pages;
> >  	void
> 	*aux_priv;
> >
> > diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
> > index 257fa46..c501d4e 100644
> > --- a/kernel/events/ring_buffer.c
> > +++ b/kernel/events/ring_buffer.c
> > @@ -284,7 +284,7 @@ ring_buffer_init(struct ring_buffer *rb, long water=
mark,
> int flags)
> >  	else
> >  		rb->overwrite =3D 1;
> >
> > -	atomic_set(&rb->refcount, 1);
> > +	refcount_set(&rb->refcount, 1);
> >
> >  	INIT_LIST_HEAD(&rb->event_list);
> >  	spin_lock_init(&rb->event_lock);
> > @@ -344,7 +344,7 @@ void *perf_aux_output_begin(struct perf_output_hand=
le
> *handle,
> >  	if (!atomic_read(&rb->aux_mmap_count))
> >  		goto err;
> >
> > -	if (!atomic_inc_not_zero(&rb->aux_refcount))
> > +	if (!refcount_inc_not_zero(&rb->aux_refcount))
> >  		goto err;
> >
> >  	/*
> > @@ -636,7 +636,7 @@ int rb_alloc_aux(struct ring_buffer *rb, struct per=
f_event
> *event,
> >  	 * we keep a refcount here to make sure either of the two can
> >  	 * reference them safely.
> >  	 */
> > -	atomic_set(&rb->aux_refcount, 1);
> > +	refcount_set(&rb->aux_refcount, 1);
> >
> >  	rb->aux_overwrite =3D overwrite;
> >  	rb->aux_watermark =3D watermark;
> > @@ -655,7 +655,7 @@ int rb_alloc_aux(struct ring_buffer *rb, struct per=
f_event
> *event,
> >
> >  void rb_free_aux(struct ring_buffer *rb)
> >  {
> > -	if (atomic_dec_and_test(&rb->aux_refcount))
> > +	if (refcount_dec_and_test(&rb->aux_refcount))
> >  		__rb_free_aux(rb);
> >  }
> >
> > diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> > index 215871b..afbb09f 100644
> > --- a/kernel/events/uprobes.c
> > +++ b/kernel/events/uprobes.c
> > @@ -37,6 +37,7 @@
> >  #include <linux/percpu-rwsem.h>
> >  #include <linux/task_work.h>
> >  #include <linux/shmem_fs.h>
> > +#include <linux/refcount.h>
> >
> >  #include <linux/uprobes.h>
> >
> > @@ -64,7 +65,7 @@ static struct percpu_rw_semaphore dup_mmap_sem;
> >
> >  struct uprobe {
> >  	struct rb_node		rb_node;	/* node in the rb tree
> */
> > -	atomic_t		ref;
> > +	refcount_t		ref;
> >  	struct rw_semaphore	register_rwsem;
> >  	struct rw_semaphore	consumer_rwsem;
> >  	struct list_head	pending_list;
> > @@ -363,13 +364,13 @@ set_orig_insn(struct arch_uprobe *auprobe, struct
> mm_struct *mm, unsigned long v
> >
> >  static struct uprobe *get_uprobe(struct uprobe *uprobe)
> >  {
> > -	atomic_inc(&uprobe->ref);
> > +	refcount_inc(&uprobe->ref);
> >  	return uprobe;
> >  }
> >
> >  static void put_uprobe(struct uprobe *uprobe)
> >  {
> > -	if (atomic_dec_and_test(&uprobe->ref))
> > +	if (refcount_dec_and_test(&uprobe->ref))
> >  		kfree(uprobe);
> >  }
> >
> > @@ -451,7 +452,7 @@ static struct uprobe *__insert_uprobe(struct uprobe
> *uprobe)
> >  	rb_link_node(&uprobe->rb_node, parent, p);
> >  	rb_insert_color(&uprobe->rb_node, &uprobes_tree);
> >  	/* get access + creation ref */
> > -	atomic_set(&uprobe->ref, 2);
> > +	refcount_set(&uprobe->ref, 2);
> >
> >  	return u;
> >  }
> > @@ -741,7 +742,7 @@ build_map_info(struct address_space *mapping, loff_=
t
> offset, bool is_register)
> >  			continue;
> >  		}
> >
> > -		if (!atomic_inc_not_zero(&vma->vm_mm-
> >mm_users))
> > +		if (!refcount_inc_not_zero(&vma->vm_mm-
> >mm_users))
> >  			continue;
> >
> >  		info =3D prev;
> > @@ -1115,7 +1116,7 @@ void uprobe_munmap(struct vm_area_struct *vma,
> unsigned long start, unsigned lon
> >  	if (no_uprobe_events() || !valid_vma(vma, false))
> >  		return;
> >
> > -	if (!atomic_read(&vma->vm_mm->mm_users)) /* called by mmput()
> ? */
> > +	if (!refcount_read(&vma->vm_mm->mm_users)) /* called by
> mmput() ? */
> >  		return;
> >
> >  	if (!test_bit(MMF_HAS_UPROBES, &vma->vm_mm->flags) ||
> > diff --git a/kernel/exit.c b/kernel/exit.c
> > index aacff8e..9a646e8 100644
> > --- a/kernel/exit.c
> > +++ b/kernel/exit.c
> > @@ -396,7 +396,7 @@ void mm_update_next_owner(struct mm_struct *mm)
> >  	 * candidates.  Do not leave the mm pointing to a possibly
> >  	 * freed task structure.
> >  	 */
> > -	if (atomic_read(&mm->mm_users) <=3D 1) {
> > +	if (refcount_read(&mm->mm_users) <=3D 1) {
> >  		mm->owner =3D NULL;
> >  		return;
> >  	}
> > @@ -509,7 +509,7 @@ static void exit_mm(struct task_struct *tsk)
> >  		__set_task_state(tsk, TASK_RUNNING);
> >  		down_read(&mm->mmap_sem);
> >  	}
> > -	atomic_inc(&mm->mm_count);
> > +	refcount_inc(&mm->mm_count);
> >  	BUG_ON(mm !=3D tsk->active_mm);
> >  	/* more a memory barrier than a real lock */
> >  	task_lock(tsk);
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index 869b8cc..3e001e2 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -330,7 +330,7 @@ static void release_task_stack(struct task_struct *=
tsk)
> >  #ifdef CONFIG_THREAD_INFO_IN_TASK
> >  void put_task_stack(struct task_struct *tsk)
> >  {
> > -	if (atomic_dec_and_test(&tsk->stack_refcount))
> > +	if (refcount_dec_and_test(&tsk->stack_refcount))
> >  		release_task_stack(tsk);
> >  }
> >  #endif
> > @@ -348,7 +348,7 @@ void free_task(struct task_struct *tsk)
> >  	 * If the task had a separate stack allocation, it should be gone
> >  	 * by now.
> >  	 */
> > -	WARN_ON_ONCE(atomic_read(&tsk->stack_refcount) !=3D 0);
> > +	WARN_ON_ONCE(refcount_read(&tsk->stack_refcount) !=3D 0);
> >  #endif
> >  	rt_mutex_debug_task_free(tsk);
> >  	ftrace_graph_exit_task(tsk);
> > @@ -375,14 +375,14 @@ static inline void free_signal_struct(struct
> signal_struct *sig)
> >
> >  static inline void put_signal_struct(struct signal_struct *sig)
> >  {
> > -	if (atomic_dec_and_test(&sig->sigcnt))
> > +	if (refcount_dec_and_test(&sig->sigcnt))
> >  		free_signal_struct(sig);
> >  }
> >
> >  void __put_task_struct(struct task_struct *tsk)
> >  {
> >  	WARN_ON(!tsk->exit_state);
> > -	WARN_ON(atomic_read(&tsk->usage));
> > +	WARN_ON(refcount_read(&tsk->usage));
> >  	WARN_ON(tsk =3D=3D current);
> >
> >  	cgroup_free(tsk);
> > @@ -501,7 +501,7 @@ static struct task_struct *dup_task_struct(struct
> task_struct *orig, int node)
> >  	tsk->stack_vm_area =3D stack_vm_area;
> >  #endif
> >  #ifdef CONFIG_THREAD_INFO_IN_TASK
> > -	atomic_set(&tsk->stack_refcount, 1);
> > +	refcount_set(&tsk->stack_refcount, 1);
> >  #endif
> >
> >  	if (err)
> > @@ -530,7 +530,7 @@ static struct task_struct *dup_task_struct(struct
> task_struct *orig, int node)
> >  	 * One for us, one for whoever does the "release_task()" (usually
> >  	 * parent)
> >  	 */
> > -	atomic_set(&tsk->usage, 2);
> > +	refcount_set(&tsk->usage, 2);
> >  #ifdef CONFIG_BLK_DEV_IO_TRACE
> >  	tsk->btrace_seq =3D 0;
> >  #endif
> > @@ -753,8 +753,8 @@ static struct mm_struct *mm_init(struct mm_struct
> *mm, struct task_struct *p,
> >  	mm->mmap =3D NULL;
> >  	mm->mm_rb =3D RB_ROOT;
> >  	mm->vmacache_seqnum =3D 0;
> > -	atomic_set(&mm->mm_users, 1);
> > -	atomic_set(&mm->mm_count, 1);
> > +	refcount_set(&mm->mm_users, 1);
> > +	refcount_set(&mm->mm_count, 1);
> >  	init_rwsem(&mm->mmap_sem);
> >  	INIT_LIST_HEAD(&mm->mmlist);
> >  	mm->core_state =3D NULL;
> > @@ -856,7 +856,7 @@ EXPORT_SYMBOL_GPL(__mmdrop);
> >
> >  static inline void __mmput(struct mm_struct *mm)
> >  {
> > -	VM_BUG_ON(atomic_read(&mm->mm_users));
> > +	VM_BUG_ON(refcount_read(&mm->mm_users));
> >
> >  	uprobe_clear_state(mm);
> >  	exit_aio(mm);
> > @@ -883,7 +883,7 @@ void mmput(struct mm_struct *mm)
> >  {
> >  	might_sleep();
> >
> > -	if (atomic_dec_and_test(&mm->mm_users))
> > +	if (refcount_dec_and_test(&mm->mm_users))
> >  		__mmput(mm);
> >  }
> >  EXPORT_SYMBOL_GPL(mmput);
> > @@ -897,7 +897,7 @@ static void mmput_async_fn(struct work_struct *work=
)
> >
> >  void mmput_async(struct mm_struct *mm)
> >  {
> > -	if (atomic_dec_and_test(&mm->mm_users)) {
> > +	if (refcount_dec_and_test(&mm->mm_users)) {
> >  		INIT_WORK(&mm->async_put_work,
> mmput_async_fn);
> >  		schedule_work(&mm->async_put_work);
> >  	}
> > @@ -994,7 +994,7 @@ struct mm_struct *get_task_mm(struct task_struct
> *task)
> >  		if (task->flags & PF_KTHREAD)
> >  			mm =3D NULL;
> >  		else
> > -			atomic_inc(&mm->mm_users);
> > +			refcount_inc(&mm->mm_users);
> >  	}
> >  	task_unlock(task);
> >  	return mm;
> > @@ -1096,7 +1096,7 @@ void mm_release(struct task_struct *tsk, struct
> mm_struct *mm)
> >  	 */
> >  	if (tsk->clear_child_tid) {
> >  		if (!(tsk->signal->flags &
> SIGNAL_GROUP_COREDUMP) &&
> > -		    atomic_read(&mm->mm_users) > 1) {
> > +		    refcount_read(&mm->mm_users) > 1) {
> >  			/*
> >  			 * We don't check the error code - if
> userspace has
> >  			 * not set up a proper pointer then
> tough luck.
> > @@ -1182,7 +1182,7 @@ static int copy_mm(unsigned long clone_flags, str=
uct
> task_struct *tsk)
> >  	vmacache_flush(tsk);
> >
> >  	if (clone_flags & CLONE_VM) {
> > -		atomic_inc(&oldmm->mm_users);
> > +		refcount_inc(&oldmm->mm_users);
> >  		mm =3D oldmm;
> >  		goto good_mm;
> >  	}
> > @@ -1279,7 +1279,7 @@ static int copy_sighand(unsigned long clone_flags=
,
> struct task_struct *tsk)
> >  	struct sighand_struct *sig;
> >
> >  	if (clone_flags & CLONE_SIGHAND) {
> > -		atomic_inc(&current->sighand->count);
> > +		refcount_inc(&current->sighand->count);
> >  		return 0;
> >  	}
> >  	sig =3D kmem_cache_alloc(sighand_cachep, GFP_KERNEL);
> > @@ -1287,14 +1287,14 @@ static int copy_sighand(unsigned long clone_fla=
gs,
> struct task_struct *tsk)
> >  	if (!sig)
> >  		return -ENOMEM;
> >
> > -	atomic_set(&sig->count, 1);
> > +	refcount_set(&sig->count, 1);
> >  	memcpy(sig->action, current->sighand->action, sizeof(sig->action));
> >  	return 0;
> >  }
> >
> >  void __cleanup_sighand(struct sighand_struct *sighand)
> >  {
> > -	if (atomic_dec_and_test(&sighand->count)) {
> > +	if (refcount_dec_and_test(&sighand->count)) {
> >  		signalfd_cleanup(sighand);
> >  		/*
> >  		 * sighand_cachep is SLAB_DESTROY_BY_RCU so we
> can free it
> > @@ -1337,7 +1337,7 @@ static int copy_signal(unsigned long clone_flags,
> struct task_struct *tsk)
> >
> >  	sig->nr_threads =3D 1;
> >  	atomic_set(&sig->live, 1);
> > -	atomic_set(&sig->sigcnt, 1);
> > +	refcount_set(&sig->sigcnt, 1);
> >
> >  	/* list_add(thread_node, thread_head) without INIT_LIST_HEAD()
> */
> >  	sig->thread_head =3D (struct list_head)LIST_HEAD_INIT(tsk-
> >thread_node);
> > @@ -1808,7 +1808,7 @@ static __latent_entropy struct task_struct
> *copy_process(
> >  		} else {
> >  			current->signal->nr_threads++;
> >  			atomic_inc(&current->signal->live);
> > -			atomic_inc(&current->signal->sigcnt);
> > +			refcount_inc(&current->signal-
> >sigcnt);
> >  			list_add_tail_rcu(&p->thread_group,
> >  					  &p-
> >group_leader->thread_group);
> >  			list_add_tail_rcu(&p->thread_node,
> > @@ -2120,7 +2120,7 @@ static int check_unshare_flags(unsigned long
> unshare_flags)
> >  			return -EINVAL;
> >  	}
> >  	if (unshare_flags & (CLONE_SIGHAND | CLONE_VM)) {
> > -		if (atomic_read(&current->sighand->count) > 1)
> > +		if (refcount_read(&current->sighand->count) > 1)
> >  			return -EINVAL;
> >  	}
> >  	if (unshare_flags & CLONE_VM) {
> > diff --git a/kernel/futex.c b/kernel/futex.c
> > index 9246d9f..e794c0b 100644
> > --- a/kernel/futex.c
> > +++ b/kernel/futex.c
> > @@ -65,6 +65,7 @@
> >  #include <linux/freezer.h>
> >  #include <linux/bootmem.h>
> >  #include <linux/fault-inject.h>
> > +#include <linux/refcount.h>
> >
> >  #include <asm/futex.h>
> >
> > @@ -207,7 +208,7 @@ struct futex_pi_state {
> >  	struct rt_mutex pi_mutex;
> >
> >  	struct task_struct *owner;
> > -	atomic_t refcount;
> > +	refcount_t refcount;
> >
> >  	union futex_key key;
> >  };
> > @@ -338,7 +339,7 @@ static inline bool should_fail_futex(bool fshared)
> >
> >  static inline void futex_get_mm(union futex_key *key)
> >  {
> > -	atomic_inc(&key->private.mm->mm_count);
> > +	refcount_inc(&key->private.mm->mm_count);
> >  	/*
> >  	 * Ensure futex_get_mm() implies a full barrier such that
> >  	 * get_futex_key() implies a full barrier. This is relied upon
> > @@ -792,7 +793,7 @@ static int refill_pi_state_cache(void)
> >  	INIT_LIST_HEAD(&pi_state->list);
> >  	/* pi_mutex gets initialized later */
> >  	pi_state->owner =3D NULL;
> > -	atomic_set(&pi_state->refcount, 1);
> > +	refcount_set(&pi_state->refcount, 1);
> >  	pi_state->key =3D FUTEX_KEY_INIT;
> >
> >  	current->pi_state_cache =3D pi_state;
> > @@ -821,7 +822,7 @@ static void put_pi_state(struct futex_pi_state *pi_=
state)
> >  	if (!pi_state)
> >  		return;
> >
> > -	if (!atomic_dec_and_test(&pi_state->refcount))
> > +	if (!refcount_dec_and_test(&pi_state->refcount))
> >  		return;
> >
> >  	/*
> > @@ -845,7 +846,7 @@ static void put_pi_state(struct futex_pi_state *pi_=
state)
> >  		 * refcount is at 0 - put it back to 1.
> >  		 */
> >  		pi_state->owner =3D NULL;
> > -		atomic_set(&pi_state->refcount, 1);
> > +		refcount_set(&pi_state->refcount, 1);
> >  		current->pi_state_cache =3D pi_state;
> >  	}
> >  }
> > @@ -989,7 +990,7 @@ static int attach_to_pi_state(u32 uval, struct
> futex_pi_state *pi_state,
> >  	if (unlikely(!pi_state))
> >  		return -EINVAL;
> >
> > -	WARN_ON(!atomic_read(&pi_state->refcount));
> > +	WARN_ON(!refcount_read(&pi_state->refcount));
> >
> >  	/*
> >  	 * Handle the owner died case:
> > @@ -1040,7 +1041,7 @@ static int attach_to_pi_state(u32 uval, struct
> futex_pi_state *pi_state,
> >  	if (pid !=3D task_pid_vnr(pi_state->owner))
> >  		return -EINVAL;
> >  out_state:
> > -	atomic_inc(&pi_state->refcount);
> > +	refcount_inc(&pi_state->refcount);
> >  	*ps =3D pi_state;
> >  	return 0;
> >  }
> > @@ -1907,7 +1908,7 @@ static int futex_requeue(u32 __user *uaddr1,
> unsigned int flags,
> >  			 * refcount on the pi_state and store
> the pointer in
> >  			 * the futex_q object of the waiter.
> >  			 */
> > -			atomic_inc(&pi_state->refcount);
> > +			refcount_inc(&pi_state->refcount);
> >  			this->pi_state =3D pi_state;
> >  			ret =3D
> rt_mutex_start_proxy_lock(&pi_state->pi_mutex,
> >
> 		this->rt_waiter,
> > diff --git a/kernel/groups.c b/kernel/groups.c
> > index 2fcadd6..89ad6c6 100644
> > --- a/kernel/groups.c
> > +++ b/kernel/groups.c
> > @@ -22,7 +22,7 @@ struct group_info *groups_alloc(int gidsetsize)
> >  	if (!gi)
> >  		return NULL;
> >
> > -	atomic_set(&gi->usage, 1);
> > +	refcount_set(&gi->usage, 1);
> >  	gi->ngroups =3D gidsetsize;
> >  	return gi;
> >  }
> > diff --git a/kernel/kcov.c b/kernel/kcov.c
> > index 85e5546..b8506c3 100644
> > --- a/kernel/kcov.c
> > +++ b/kernel/kcov.c
> > @@ -19,6 +19,7 @@
> >  #include <linux/debugfs.h>
> >  #include <linux/uaccess.h>
> >  #include <linux/kcov.h>
> > +#include <linux/refcount.h>
> >  #include <asm/setup.h>
> >
> >  /*
> > @@ -35,7 +36,7 @@ struct kcov {
> >  	 *  - opened file descriptor
> >  	 *  - task with enabled coverage (we can't unwire it from another
> task)
> >  	 */
> > -	atomic_t		refcount;
> > +	refcount_t		refcount;
> >  	/* The lock protects mode, size, area and t. */
> >  	spinlock_t		lock;
> >  	enum kcov_mode		mode;
> > @@ -101,12 +102,12 @@ EXPORT_SYMBOL(__sanitizer_cov_trace_pc);
> >
> >  static void kcov_get(struct kcov *kcov)
> >  {
> > -	atomic_inc(&kcov->refcount);
> > +	refcount_inc(&kcov->refcount);
> >  }
> >
> >  static void kcov_put(struct kcov *kcov)
> >  {
> > -	if (atomic_dec_and_test(&kcov->refcount)) {
> > +	if (refcount_dec_and_test(&kcov->refcount)) {
> >  		vfree(kcov->area);
> >  		kfree(kcov);
> >  	}
> > @@ -182,7 +183,7 @@ static int kcov_open(struct inode *inode, struct fi=
le
> *filep)
> >  	kcov =3D kzalloc(sizeof(*kcov), GFP_KERNEL);
> >  	if (!kcov)
> >  		return -ENOMEM;
> > -	atomic_set(&kcov->refcount, 1);
> > +	refcount_set(&kcov->refcount, 1);
> >  	spin_lock_init(&kcov->lock);
> >  	filep->private_data =3D kcov;
> >  	return nonseekable_open(inode, filep);
> > diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> > index 782102e..435a0f9 100644
> > --- a/kernel/nsproxy.c
> > +++ b/kernel/nsproxy.c
> > @@ -30,7 +30,7 @@
> >  static struct kmem_cache *nsproxy_cachep;
> >
> >  struct nsproxy init_nsproxy =3D {
> > -	.count			=3D ATOMIC_INIT(1),
> > +	.count			=3D REFCOUNT_INIT(1),
> >  	.uts_ns			=3D &init_uts_ns,
> >  #if defined(CONFIG_POSIX_MQUEUE) || defined(CONFIG_SYSVIPC)
> >  	.ipc_ns			=3D &init_ipc_ns,
> > @@ -51,7 +51,7 @@ static inline struct nsproxy *create_nsproxy(void)
> >
> >  	nsproxy =3D kmem_cache_alloc(nsproxy_cachep, GFP_KERNEL);
> >  	if (nsproxy)
> > -		atomic_set(&nsproxy->count, 1);
> > +		refcount_set(&nsproxy->count, 1);
> >  	return nsproxy;
> >  }
> >
> > @@ -224,7 +224,7 @@ void switch_task_namespaces(struct task_struct *p,
> struct nsproxy *new)
> >  	p->nsproxy =3D new;
> >  	task_unlock(p);
> >
> > -	if (ns && atomic_dec_and_test(&ns->count))
> > +	if (ns && refcount_dec_and_test(&ns->count))
> >  		free_nsproxy(ns);
> >  }
> >
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index 966556e..f60da66 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -2231,7 +2231,7 @@ static void __sched_fork(unsigned long clone_flag=
s,
> struct task_struct *p)
> >  #endif
> >
> >  #ifdef CONFIG_NUMA_BALANCING
> > -	if (p->mm && atomic_read(&p->mm->mm_users) =3D=3D 1) {
> > +	if (p->mm && refcount_read(&p->mm->mm_users) =3D=3D 1) {
> >  		p->mm->numa_next_scan =3D jiffies +
> msecs_to_jiffies(sysctl_numa_balancing_scan_delay);
> >  		p->mm->numa_scan_seq =3D 0;
> >  	}
> > @@ -2878,7 +2878,7 @@ context_switch(struct rq *rq, struct task_struct =
*prev,
> >
> >  	if (!mm) {
> >  		next->active_mm =3D oldmm;
> > -		atomic_inc(&oldmm->mm_count);
> > +		refcount_inc(&oldmm->mm_count);
> >  		enter_lazy_tlb(oldmm, next);
> >  	} else
> >  		switch_mm_irqs_off(oldmm, mm, next);
> > @@ -6177,6 +6177,7 @@ build_overlap_sched_groups(struct sched_domain
> *sd, int cpu)
> >  		cpumask_or(covered, covered, sg_span);
> >
> >  		sg->sgc =3D *per_cpu_ptr(sdd->sgc, i);
> > +
> >  		if (atomic_inc_return(&sg->sgc->ref) =3D=3D 1)
> >  			build_group_mask(sd, sg);
> >
> > @@ -7686,7 +7687,7 @@ void __init sched_init(void)
> >  	/*
> >  	 * The boot idle thread does lazy MMU switching as well:
> >  	 */
> > -	atomic_inc(&init_mm.mm_count);
> > +	refcount_inc(&init_mm.mm_count);
> >  	enter_lazy_tlb(&init_mm, current);
> >
> >  	/*
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 6559d19..8622d15 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -1133,7 +1133,7 @@ static void account_numa_dequeue(struct rq *rq,
> struct task_struct *p)
> >  }
> >
> >  struct numa_group {
> > -	atomic_t refcount;
> > +	refcount_t refcount;
> >
> >  	spinlock_t lock; /* nr_tasks, tasks */
> >  	int nr_tasks;
> > @@ -2181,12 +2181,12 @@ static void task_numa_placement(struct task_str=
uct
> *p)
> >
> >  static inline int get_numa_group(struct numa_group *grp)
> >  {
> > -	return atomic_inc_not_zero(&grp->refcount);
> > +	return refcount_inc_not_zero(&grp->refcount);
> >  }
> >
> >  static inline void put_numa_group(struct numa_group *grp)
> >  {
> > -	if (atomic_dec_and_test(&grp->refcount))
> > +	if (refcount_dec_and_test(&grp->refcount))
> >  		kfree_rcu(grp, rcu);
> >  }
> >
> > @@ -2207,7 +2207,7 @@ static void task_numa_group(struct task_struct *p=
, int
> cpupid, int flags,
> >  		if (!grp)
> >  			return;
> >
> > -		atomic_set(&grp->refcount, 1);
> > +		refcount_set(&grp->refcount, 1);
> >  		grp->active_nodes =3D 1;
> >  		grp->max_faults_cpu =3D 0;
> >  		spin_lock_init(&grp->lock);
> > diff --git a/kernel/user.c b/kernel/user.c
> > index b069ccb..d9dff8e 100644
> > --- a/kernel/user.c
> > +++ b/kernel/user.c
> > @@ -89,7 +89,7 @@ static DEFINE_SPINLOCK(uidhash_lock);
> >
> >  /* root_user.__count is 1, for init task cred */
> >  struct user_struct root_user =3D {
> > -	.__count	=3D ATOMIC_INIT(1),
> > +	.__count	=3D REFCOUNT_INIT(1),
> >  	.processes	=3D ATOMIC_INIT(1),
> >  	.sigpending	=3D ATOMIC_INIT(0),
> >  	.locked_shm     =3D 0,
> > @@ -115,7 +115,7 @@ static struct user_struct *uid_hash_find(kuid_t uid=
, struct
> hlist_head *hashent)
> >
> >  	hlist_for_each_entry(user, hashent, uidhash_node) {
> >  		if (uid_eq(user->uid, uid)) {
> > -			atomic_inc(&user->__count);
> > +			refcount_inc(&user->__count);
> >  			return user;
> >  		}
> >  	}
> > @@ -162,7 +162,7 @@ void free_uid(struct user_struct *up)
> >  		return;
> >
> >  	local_irq_save(flags);
> > -	if (atomic_dec_and_lock(&up->__count, &uidhash_lock))
> > +	if (refcount_dec_and_lock(&up->__count, &uidhash_lock))
> >  		free_user(up, flags);
> >  	else
> >  		local_irq_restore(flags);
> > @@ -183,7 +183,7 @@ struct user_struct *alloc_uid(kuid_t uid)
> >  			goto out_unlock;
> >
> >  		new->uid =3D uid;
> > -		atomic_set(&new->__count, 1);
> > +		refcount_set(&new->__count, 1);
> >
> >  		/*
> >  		 * Before adding this, check whether we raced
> > diff --git a/lib/is_single_threaded.c b/lib/is_single_threaded.c
> > index 391fd23..295ddcf 100644
> > --- a/lib/is_single_threaded.c
> > +++ b/lib/is_single_threaded.c
> > @@ -25,7 +25,7 @@ bool current_is_single_threaded(void)
> >  	if (atomic_read(&task->signal->live) !=3D 1)
> >  		return false;
> >
> > -	if (atomic_read(&mm->mm_users) =3D=3D 1)
> > +	if (refcount_read(&mm->mm_users) =3D=3D 1)
> >  		return true;
> >
> >  	ret =3D false;
> > diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> > index 3bfed5ab..103875d 100644
> > --- a/mm/backing-dev.c
> > +++ b/mm/backing-dev.c
> > @@ -416,8 +416,10 @@ wb_congested_get_create(struct backing_dev_info
> *bdi, int blkcg_id, gfp_t gfp)
> >  			node =3D &parent->rb_left;
> >  		else if (congested->blkcg_id > blkcg_id)
> >  			node =3D &parent->rb_right;
> > -		else
> > -			goto found;
> > +		else {
> > +			refcount_inc(&congested->refcnt);
> > + 			goto found;
> > +		}
> >  	}
> >
> >  	if (new_congested) {
> > @@ -436,13 +438,12 @@ wb_congested_get_create(struct backing_dev_info
> *bdi, int blkcg_id, gfp_t gfp)
> >  	if (!new_congested)
> >  		return NULL;
> >
> > -	atomic_set(&new_congested->refcnt, 0);
> > +	refcount_set(&new_congested->refcnt, 1);
> >  	new_congested->bdi =3D bdi;
> >  	new_congested->blkcg_id =3D blkcg_id;
> >  	goto retry;
> >
> >  found:
> > -	atomic_inc(&congested->refcnt);
> >  	spin_unlock_irqrestore(&cgwb_lock, flags);
> >  	kfree(new_congested);
> >  	return congested;
> > @@ -459,7 +460,7 @@ void wb_congested_put(struct bdi_writeback_congeste=
d
> *congested)
> >  	unsigned long flags;
> >
> >  	local_irq_save(flags);
> > -	if (!atomic_dec_and_lock(&congested->refcnt, &cgwb_lock)) {
> > +	if (!refcount_dec_and_lock(&congested->refcnt, &cgwb_lock)) {
> >  		local_irq_restore(flags);
> >  		return;
> >  	}
> > diff --git a/mm/debug.c b/mm/debug.c
> > index db1cd26..0866505 100644
> > --- a/mm/debug.c
> > +++ b/mm/debug.c
> > @@ -134,7 +134,7 @@ void dump_mm(const struct mm_struct *mm)
> >  		mm->get_unmapped_area,
> >  #endif
> >  		mm->mmap_base, mm->mmap_legacy_base, mm-
> >highest_vm_end,
> > -		mm->pgd, atomic_read(&mm->mm_users),
> > +		mm->pgd, refcount_read(&mm->mm_users),
> >  		atomic_read(&mm->mm_count),
> >  		atomic_long_read((atomic_long_t *)&mm-
> >nr_ptes),
> >  		mm_nr_pmds((struct mm_struct *)mm),
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 10eedbf..5048e8f 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -30,6 +30,7 @@
> >  #include <linux/userfaultfd_k.h>
> >  #include <linux/page_idle.h>
> >  #include <linux/shmem_fs.h>
> > +#include <linux/refcount.h>
> >
> >  #include <asm/tlb.h>
> >  #include <asm/pgalloc.h>
> > @@ -56,14 +57,14 @@ unsigned long transparent_hugepage_flags
> __read_mostly =3D
> >
> >  static struct shrinker deferred_split_shrinker;
> >
> > -static atomic_t huge_zero_refcount;
> > +static refcount_t huge_zero_refcount;
> >  struct page *huge_zero_page __read_mostly;
> >
> >  static struct page *get_huge_zero_page(void)
> >  {
> >  	struct page *zero_page;
> >  retry:
> > -	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
> > +	if (likely(refcount_inc_not_zero(&huge_zero_refcount)))
> >  		return READ_ONCE(huge_zero_page);
> >
> >  	zero_page =3D alloc_pages((GFP_TRANSHUGE | __GFP_ZERO) &
> ~__GFP_MOVABLE,
> > @@ -81,7 +82,7 @@ static struct page *get_huge_zero_page(void)
> >  	}
> >
> >  	/* We take additional reference here. It will be put back by shrinker
> */
> > -	atomic_set(&huge_zero_refcount, 2);
> > +	refcount_set(&huge_zero_refcount, 2);
> >  	preempt_enable();
> >  	return READ_ONCE(huge_zero_page);
> >  }
> > @@ -92,7 +93,7 @@ static void put_huge_zero_page(void)
> >  	 * Counter should never go to zero here. Only shrinker can put
> >  	 * last reference.
> >  	 */
> > -	BUG_ON(atomic_dec_and_test(&huge_zero_refcount));
> > +	BUG_ON(refcount_dec_and_test(&huge_zero_refcount));
> >  }
> >
> >  struct page *mm_get_huge_zero_page(struct mm_struct *mm)
> > @@ -119,13 +120,16 @@ static unsigned long
> shrink_huge_zero_page_count(struct shrinker *shrink,
> >  					struct
> shrink_control *sc)
> >  {
> >  	/* we can free zero page only if last reference remains */
> > -	return atomic_read(&huge_zero_refcount) =3D=3D 1 ? HPAGE_PMD_NR
> : 0;
> > +	return refcount_read(&huge_zero_refcount) =3D=3D 1 ?
> HPAGE_PMD_NR : 0;
> >  }
> >
> >  static unsigned long shrink_huge_zero_page_scan(struct shrinker *shrin=
k,
> >  				       struct
> shrink_control *sc)
> >  {
> > -	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) =3D=3D 1) {
> > +	/* the below is probably not fully safe */
> > +	/* do we need to take a lock? */
> > +	if (refcount_read(&huge_zero_refcount) =3D=3D 1) {
> > +		refcount_set(&huge_zero_refcount, 0);
> >  		struct page *zero_page =3D xchg(&huge_zero_page,
> NULL);
> >  		BUG_ON(zero_page =3D=3D NULL);
> >  		__free_pages(zero_page,
> compound_order(zero_page));
> > diff --git a/mm/init-mm.c b/mm/init-mm.c
> > index 975e49f..8de5267 100644
> > --- a/mm/init-mm.c
> > +++ b/mm/init-mm.c
> > @@ -17,8 +17,8 @@
> >  struct mm_struct init_mm =3D {
> >  	.mm_rb		=3D RB_ROOT,
> >  	.pgd		=3D swapper_pg_dir,
> > -	.mm_users	=3D ATOMIC_INIT(2),
> > -	.mm_count	=3D ATOMIC_INIT(1),
> > +	.mm_users	=3D REFCOUNT_INIT(2),
> > +	.mm_count	=3D REFCOUNT_INIT(1),
> >  	.mmap_sem	=3D __RWSEM_INITIALIZER(init_mm.mmap_sem),
> >  	.page_table_lock =3D
> __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),
> >  	.mmlist		=3D LIST_HEAD_INIT(init_mm.mmlist),
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index e32389a..85f584a 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -391,7 +391,7 @@ static void insert_to_mm_slots_hash(struct mm_struc=
t
> *mm,
> >
> >  static inline int khugepaged_test_exit(struct mm_struct *mm)
> >  {
> > -	return atomic_read(&mm->mm_users) =3D=3D 0;
> > +	return refcount_read(&mm->mm_users) =3D=3D 0;
> >  }
> >
> >  int __khugepaged_enter(struct mm_struct *mm)
> > @@ -420,7 +420,7 @@ int __khugepaged_enter(struct mm_struct *mm)
> >  	list_add_tail(&mm_slot->mm_node,
> &khugepaged_scan.mm_head);
> >  	spin_unlock(&khugepaged_mm_lock);
> >
> > -	atomic_inc(&mm->mm_count);
> > +	refcount_inc(&mm->mm_count);
> >  	if (wakeup)
> >  		wake_up_interruptible(&khugepaged_wait);
> >
> > diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> > index da34369..2e1167b 100644
> > --- a/mm/kmemleak.c
> > +++ b/mm/kmemleak.c
> > @@ -105,7 +105,7 @@
> >
> >  #include <asm/sections.h>
> >  #include <asm/processor.h>
> > -#include <linux/atomic.h>
> > +#include <linux/refcount.h>
> >
> >  #include <linux/kasan.h>
> >  #include <linux/kmemcheck.h>
> > @@ -154,7 +154,7 @@ struct kmemleak_object {
> >  	struct rb_node rb_node;
> >  	struct rcu_head rcu;		/* object_list lockless
> traversal */
> >  	/* object usage count; object freed when use_count =3D=3D 0 */
> > -	atomic_t use_count;
> > +	refcount_t use_count;
> >  	unsigned long pointer;
> >  	size_t size;
> >  	/* minimum number of a pointers found before it is considered leak
> */
> > @@ -434,7 +434,7 @@ static struct kmemleak_object *lookup_object(unsign=
ed
> long ptr, int alias)
> >   */
> >  static int get_object(struct kmemleak_object *object)
> >  {
> > -	return atomic_inc_not_zero(&object->use_count);
> > +	return refcount_inc_not_zero(&object->use_count);
> >  }
> >
> >  /*
> > @@ -467,7 +467,7 @@ static void free_object_rcu(struct rcu_head *rcu)
> >   */
> >  static void put_object(struct kmemleak_object *object)
> >  {
> > -	if (!atomic_dec_and_test(&object->use_count))
> > +	if (!refcount_dec_and_test(&object->use_count))
> >  		return;
> >
> >  	/* should only get here after delete_object was called */
> > @@ -556,7 +556,7 @@ static struct kmemleak_object *create_object(unsign=
ed
> long ptr, size_t size,
> >  	INIT_LIST_HEAD(&object->gray_list);
> >  	INIT_HLIST_HEAD(&object->area_list);
> >  	spin_lock_init(&object->lock);
> > -	atomic_set(&object->use_count, 1);
> > +	refcount_set(&object->use_count, 1);
> >  	object->flags =3D OBJECT_ALLOCATED;
> >  	object->pointer =3D ptr;
> >  	object->size =3D size;
> > @@ -629,7 +629,7 @@ static void __delete_object(struct kmemleak_object
> *object)
> >  	unsigned long flags;
> >
> >  	WARN_ON(!(object->flags & OBJECT_ALLOCATED));
> > -	WARN_ON(atomic_read(&object->use_count) < 1);
> > +	WARN_ON(refcount_read(&object->use_count) < 1);
> >
> >  	/*
> >  	 * Locking here also ensures that the corresponding memory block
> > @@ -1396,9 +1396,9 @@ static void kmemleak_scan(void)
> >  		 * With a few exceptions there should be a maximum
> of
> >  		 * 1 reference to any object at this point.
> >  		 */
> > -		if (atomic_read(&object->use_count) > 1) {
> > +		if (refcount_read(&object->use_count) > 1) {
> >  			pr_debug("object->use_count =3D
> %d\n",
> > -				 atomic_read(&object-
> >use_count));
> > +
> refcount_read(&object->use_count));
> >  			dump_object_info(object);
> >  		}
> >  #endif
> > diff --git a/mm/ksm.c b/mm/ksm.c
> > index 9ae6011..8076183 100644
> > --- a/mm/ksm.c
> > +++ b/mm/ksm.c
> > @@ -352,7 +352,7 @@ static void insert_to_mm_slots_hash(struct mm_struc=
t
> *mm,
> >   */
> >  static inline bool ksm_test_exit(struct mm_struct *mm)
> >  {
> > -	return atomic_read(&mm->mm_users) =3D=3D 0;
> > +	return refcount_read(&mm->mm_users) =3D=3D 0;
> >  }
> >
> >  /*
> > @@ -1813,7 +1813,7 @@ int __ksm_enter(struct mm_struct *mm)
> >  	spin_unlock(&ksm_mmlist_lock);
> >
> >  	set_bit(MMF_VM_MERGEABLE, &mm->flags);
> > -	atomic_inc(&mm->mm_count);
> > +	refcount_inc(&mm->mm_count);
> >
> >  	if (needs_wakeup)
> >  		wake_up_interruptible(&ksm_thread_wait);
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 455c3e6..9e50d9c 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -375,7 +375,7 @@ void tlb_remove_table(struct mmu_gather *tlb, void
> *table)
> >  	 * When there's less then two users of this mm there cannot be a
> >  	 * concurrent page-table walk.
> >  	 */
> > -	if (atomic_read(&tlb->mm->mm_users) < 2) {
> > +	if (refcount_read(&tlb->mm->mm_users) < 2) {
> >  		__tlb_remove_table(table);
> >  		return;
> >  	}
> > diff --git a/mm/mmu_context.c b/mm/mmu_context.c
> > index 6f4d27c..b5071e3 100644
> > --- a/mm/mmu_context.c
> > +++ b/mm/mmu_context.c
> > @@ -25,7 +25,7 @@ void use_mm(struct mm_struct *mm)
> >  	task_lock(tsk);
> >  	active_mm =3D tsk->active_mm;
> >  	if (active_mm !=3D mm) {
> > -		atomic_inc(&mm->mm_count);
> > +		refcount_inc(&mm->mm_count);
> >  		tsk->active_mm =3D mm;
> >  	}
> >  	tsk->mm =3D mm;
> > diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
> > index f4259e4..00c2833 100644
> > --- a/mm/mmu_notifier.c
> > +++ b/mm/mmu_notifier.c
> > @@ -249,7 +249,7 @@ static int do_mmu_notifier_register(struct mmu_noti=
fier
> *mn,
> >  	struct mmu_notifier_mm *mmu_notifier_mm;
> >  	int ret;
> >
> > -	BUG_ON(atomic_read(&mm->mm_users) <=3D 0);
> > +	BUG_ON(refcount_read(&mm->mm_users) <=3D 0);
> >
> >  	/*
> >  	 * Verify that mmu_notifier_init() already run and the global srcu is
> > @@ -275,7 +275,7 @@ static int do_mmu_notifier_register(struct mmu_noti=
fier
> *mn,
> >  		mm->mmu_notifier_mm =3D mmu_notifier_mm;
> >  		mmu_notifier_mm =3D NULL;
> >  	}
> > -	atomic_inc(&mm->mm_count);
> > +	refcount_inc(&mm->mm_count);
> >
> >  	/*
> >  	 * Serialize the update against mmu_notifier_unregister. A
> > @@ -295,7 +295,7 @@ static int do_mmu_notifier_register(struct mmu_noti=
fier
> *mn,
> >  		up_write(&mm->mmap_sem);
> >  	kfree(mmu_notifier_mm);
> >  out:
> > -	BUG_ON(atomic_read(&mm->mm_users) <=3D 0);
> > +	BUG_ON(refcount_read(&mm->mm_users) <=3D 0);
> >  	return ret;
> >  }
> >
> > @@ -348,7 +348,7 @@ void __mmu_notifier_mm_destroy(struct mm_struct
> *mm)
> >   */
> >  void mmu_notifier_unregister(struct mmu_notifier *mn, struct mm_struct=
 *mm)
> >  {
> > -	BUG_ON(atomic_read(&mm->mm_count) <=3D 0);
> > +	BUG_ON(refcount_read(&mm->mm_count) <=3D 0);
> >
> >  	if (!hlist_unhashed(&mn->hlist)) {
> >  		/*
> > @@ -381,7 +381,7 @@ void mmu_notifier_unregister(struct mmu_notifier *m=
n,
> struct mm_struct *mm)
> >  	 */
> >  	synchronize_srcu(&srcu);
> >
> > -	BUG_ON(atomic_read(&mm->mm_count) <=3D 0);
> > +	BUG_ON(refcount_read(&mm->mm_count) <=3D 0);
> >
> >  	mmdrop(mm);
> >  }
> > @@ -401,7 +401,7 @@ void mmu_notifier_unregister_no_release(struct
> mmu_notifier *mn,
> >  	hlist_del_init_rcu(&mn->hlist);
> >  	spin_unlock(&mm->mmu_notifier_mm->lock);
> >
> > -	BUG_ON(atomic_read(&mm->mm_count) <=3D 0);
> > +	BUG_ON(refcount_read(&mm->mm_count) <=3D 0);
> >  	mmdrop(mm);
> >  }
> >  EXPORT_SYMBOL_GPL(mmu_notifier_unregister_no_release);
> > diff --git a/mm/mprotect.c b/mm/mprotect.c
> > index cc2459c..4c38b4c 100644
> > --- a/mm/mprotect.c
> > +++ b/mm/mprotect.c
> > @@ -77,7 +77,7 @@ static unsigned long change_pte_range(struct
> vm_area_struct *vma, pmd_t *pmd,
> >
> >  	/* Get target node for single threaded private VMAs */
> >  	if (prot_numa && !(vma->vm_flags & VM_SHARED) &&
> > -	    atomic_read(&vma->vm_mm->mm_users) =3D=3D 1)
> > +	    refcount_read(&vma->vm_mm->mm_users) =3D=3D 1)
> >  		target_node =3D numa_node_id();
> >
> >  	arch_enter_lazy_mmu_mode();
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index ec9f11d..8a98e1b 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -660,7 +660,7 @@ static void mark_oom_victim(struct task_struct *tsk=
)
> >
> >  	/* oom_mm is bound to the signal struct life time. */
> >  	if (!cmpxchg(&tsk->signal->oom_mm, NULL, mm))
> > -		atomic_inc(&tsk->signal->oom_mm->mm_count);
> > +		refcount_inc(&tsk->signal->oom_mm->mm_count);
> >
> >  	/*
> >  	 * Make sure that the task is woken up from uninterruptible sleep
> > @@ -781,7 +781,7 @@ static bool task_will_free_mem(struct task_struct *=
task)
> >  	if (test_bit(MMF_OOM_SKIP, &mm->flags))
> >  		return false;
> >
> > -	if (atomic_read(&mm->mm_users) <=3D 1)
> > +	if (refcount_read(&mm->mm_users) <=3D 1)
> >  		return true;
> >
> >  	/*
> > @@ -877,7 +877,7 @@ static void oom_kill_process(struct oom_control *oc=
,
> const char *message)
> >
> >  	/* Get a reference to safely compare mm after task_unlock(victim)
> */
> >  	mm =3D victim->mm;
> > -	atomic_inc(&mm->mm_count);
> > +	refcount_inc(&mm->mm_count);
> >  	/*
> >  	 * We should send SIGKILL before setting TIF_MEMDIE in order to
> prevent
> >  	 * the OOM victim from depleting the memory reserves from the
> user
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index 91619fd..47fbdfd 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -77,7 +77,7 @@ static inline struct anon_vma *anon_vma_alloc(void)
> >
> >  	anon_vma =3D kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
> >  	if (anon_vma) {
> > -		atomic_set(&anon_vma->refcount, 1);
> > +		refcount_set(&anon_vma->refcount, 1);
> >  		anon_vma->degree =3D 1;	/* Reference for first
> vma */
> >  		anon_vma->parent =3D anon_vma;
> >  		/*
> > @@ -92,7 +92,7 @@ static inline struct anon_vma *anon_vma_alloc(void)
> >
> >  static inline void anon_vma_free(struct anon_vma *anon_vma)
> >  {
> > -	VM_BUG_ON(atomic_read(&anon_vma->refcount));
> > +	VM_BUG_ON(refcount_read(&anon_vma->refcount));
> >
> >  	/*
> >  	 * Synchronize against page_lock_anon_vma_read() such that
> > @@ -421,7 +421,7 @@ static void anon_vma_ctor(void *data)
> >  	struct anon_vma *anon_vma =3D data;
> >
> >  	init_rwsem(&anon_vma->rwsem);
> > -	atomic_set(&anon_vma->refcount, 0);
> > +	refcount_set(&anon_vma->refcount, 0);
> >  	anon_vma->rb_root =3D RB_ROOT;
> >  }
> >
> > @@ -470,7 +470,7 @@ struct anon_vma *page_get_anon_vma(struct page
> *page)
> >  		goto out;
> >
> >  	anon_vma =3D (struct anon_vma *) (anon_mapping -
> PAGE_MAPPING_ANON);
> > -	if (!atomic_inc_not_zero(&anon_vma->refcount)) {
> > +	if (!refcount_inc_not_zero(&anon_vma->refcount)) {
> >  		anon_vma =3D NULL;
> >  		goto out;
> >  	}
> > @@ -529,7 +529,7 @@ struct anon_vma *page_lock_anon_vma_read(struct
> page *page)
> >  	}
> >
> >  	/* trylock failed, we got to sleep */
> > -	if (!atomic_inc_not_zero(&anon_vma->refcount)) {
> > +	if (!refcount_inc_not_zero(&anon_vma->refcount)) {
> >  		anon_vma =3D NULL;
> >  		goto out;
> >  	}
> > @@ -544,7 +544,7 @@ struct anon_vma *page_lock_anon_vma_read(struct
> page *page)
> >  	rcu_read_unlock();
> >  	anon_vma_lock_read(anon_vma);
> >
> > -	if (atomic_dec_and_test(&anon_vma->refcount)) {
> > +	if (refcount_dec_and_test(&anon_vma->refcount)) {
> >  		/*
> >  		 * Oops, we held the last refcount, release the lock
> >  		 * and bail -- can't simply use put_anon_vma()
> because
> > @@ -1711,7 +1711,7 @@ void __put_anon_vma(struct anon_vma *anon_vma)
> >  	struct anon_vma *root =3D anon_vma->root;
> >
> >  	anon_vma_free(anon_vma);
> > -	if (root !=3D anon_vma && atomic_dec_and_test(&root->refcount))
> > +	if (root !=3D anon_vma && refcount_dec_and_test(&root->refcount))
> >  		anon_vma_free(root);
> >  }
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 1c6e032..6e870f7 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -1401,7 +1401,7 @@ int try_to_unuse(unsigned int type, bool frontswa=
p,
> >  	 * that.
> >  	 */
> >  	start_mm =3D &init_mm;
> > -	atomic_inc(&init_mm.mm_users);
> > +	refcount_inc(&init_mm.mm_users);
> >
> >  	/*
> >  	 * Keep on scanning until all entries have gone.  Usually,
> > @@ -1447,10 +1447,10 @@ int try_to_unuse(unsigned int type, bool fronts=
wap,
> >  		/*
> >  		 * Don't hold on to start_mm if it looks like exiting.
> >  		 */
> > -		if (atomic_read(&start_mm->mm_users) =3D=3D 1) {
> > +		if (refcount_read(&start_mm->mm_users) =3D=3D 1) {
> >  			mmput(start_mm);
> >  			start_mm =3D &init_mm;
> > -			atomic_inc(&init_mm.mm_users);
> > +			refcount_inc(&init_mm.mm_users);
> >  		}
> >
> >  		/*
> > @@ -1487,13 +1487,13 @@ int try_to_unuse(unsigned int type, bool fronts=
wap,
> >  			struct mm_struct *prev_mm =3D
> start_mm;
> >  			struct mm_struct *mm;
> >
> > -			atomic_inc(&new_start_mm-
> >mm_users);
> > -			atomic_inc(&prev_mm->mm_users);
> > +			refcount_inc(&new_start_mm-
> >mm_users);
> > +			refcount_inc(&prev_mm-
> >mm_users);
> >  			spin_lock(&mmlist_lock);
> >  			while (swap_count(*swap_map) &&
> !retval &&
> >  					(p =3D p-
> >next) !=3D &start_mm->mmlist) {
> >  				mm =3D list_entry(p,
> struct mm_struct, mmlist);
> > -				if
> (!atomic_inc_not_zero(&mm->mm_users))
> > +				if
> (!refcount_inc_not_zero(&mm->mm_users))
> >
> 	continue;
> >
> 	spin_unlock(&mmlist_lock);
> >  				mmput(prev_mm);
> > @@ -1511,7 +1511,7 @@ int try_to_unuse(unsigned int type, bool frontswa=
p,
> >
> >  				if (set_start_mm &&
> *swap_map < swcount) {
> >
> 	mmput(new_start_mm);
> > -
> 	atomic_inc(&mm->mm_users);
> > +
> 	refcount_inc(&mm->mm_users);
> >
> 	new_start_mm =3D mm;
> >
> 	set_start_mm =3D 0;
> >  				}
> > diff --git a/mm/vmacache.c b/mm/vmacache.c
> > index 035fdeb..4747ee6 100644
> > --- a/mm/vmacache.c
> > +++ b/mm/vmacache.c
> > @@ -26,7 +26,7 @@ void vmacache_flush_all(struct mm_struct *mm)
> >  	 * to worry about other threads' seqnum. Current's
> >  	 * flush will occur upon the next lookup.
> >  	 */
> > -	if (atomic_read(&mm->mm_users) =3D=3D 1)
> > +	if (refcount_read(&mm->mm_users) =3D=3D 1)
> >  		return;
> >
> >  	rcu_read_lock();
> > diff --git a/mm/zpool.c b/mm/zpool.c
> > index fd3ff71..48ec64f 100644
> > --- a/mm/zpool.c
> > +++ b/mm/zpool.c
> > @@ -56,11 +56,11 @@ EXPORT_SYMBOL(zpool_register_driver);
> >   */
> >  int zpool_unregister_driver(struct zpool_driver *driver)
> >  {
> > -	int ret =3D 0, refcount;
> > +	int ret =3D 0;
> > +	unsigned int refcount;
> >
> >  	spin_lock(&drivers_lock);
> >  	refcount =3D atomic_read(&driver->refcount);
> > -	WARN_ON(refcount < 0);
> >  	if (refcount > 0)
> >  		ret =3D -EBUSY;
> >  	else
> > diff --git a/net/sunrpc/auth_null.c b/net/sunrpc/auth_null.c
> > index 4d17376..8c2470b 100644
> > --- a/net/sunrpc/auth_null.c
> > +++ b/net/sunrpc/auth_null.c
> > @@ -137,7 +137,7 @@ struct rpc_cred null_cred =3D {
> >  	.cr_lru		=3D LIST_HEAD_INIT(null_cred.cr_lru),
> >  	.cr_auth	=3D &null_auth,
> >  	.cr_ops		=3D &null_credops,
> > -	.cr_count	=3D ATOMIC_INIT(1),
> > +	.cr_count	=3D REFCOUNT_INIT(1),
> >  	.cr_flags	=3D 1UL << RPCAUTH_CRED_UPTODATE,
> >  #if IS_ENABLED(CONFIG_SUNRPC_DEBUG)
> >  	.cr_magic	=3D RPCAUTH_CRED_MAGIC,
> > diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> > index 3815e94..8a298fc 100644
> > --- a/virt/kvm/async_pf.c
> > +++ b/virt/kvm/async_pf.c
> > @@ -204,7 +204,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t
> gva, unsigned long hva,
> >  	work->addr =3D hva;
> >  	work->arch =3D *arch;
> >  	work->mm =3D current->mm;
> > -	atomic_inc(&work->mm->mm_users);
> > +	refcount_inc(&work->mm->mm_users);
> >  	kvm_get_kvm(work->vcpu->kvm);
> >
> >  	/* this can't really happen otherwise gfn_to_pfn_async
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index de102ca..f0f27c7 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -616,13 +616,13 @@ static struct kvm *kvm_create_vm(unsigned long
> type)
> >  		return ERR_PTR(-ENOMEM);
> >
> >  	spin_lock_init(&kvm->mmu_lock);
> > -	atomic_inc(&current->mm->mm_count);
> > +	refcount_inc(&current->mm->mm_count);
> >  	kvm->mm =3D current->mm;
> >  	kvm_eventfd_init(kvm);
> >  	mutex_init(&kvm->lock);
> >  	mutex_init(&kvm->irq_lock);
> >  	mutex_init(&kvm->slots_lock);
> > -	atomic_set(&kvm->users_count, 1);
> > +	refcount_set(&kvm->users_count, 1);
> >  	INIT_LIST_HEAD(&kvm->devices);
> >
> >  	r =3D kvm_arch_init_vm(kvm, type);
> > @@ -745,13 +745,13 @@ static void kvm_destroy_vm(struct kvm *kvm)
> >
> >  void kvm_get_kvm(struct kvm *kvm)
> >  {
> > -	atomic_inc(&kvm->users_count);
> > +	refcount_inc(&kvm->users_count);
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_get_kvm);
> >
> >  void kvm_put_kvm(struct kvm *kvm)
> >  {
> > -	if (atomic_dec_and_test(&kvm->users_count))
> > +	if (refcount_dec_and_test(&kvm->users_count))
> >  		kvm_destroy_vm(kvm);
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_put_kvm);
> > @@ -3640,7 +3640,7 @@ static int kvm_debugfs_open(struct inode *inode,
> struct file *file,
> >  	 * To avoid the race between open and the removal of the debugfs
> >  	 * directory we test against the users count.
> >  	 */
> > -	if (!atomic_add_unless(&stat_data->kvm->users_count, 1, 0))
> > +	if (!refcount_inc_not_zero(&stat_data->kvm->users_count))
> >  		return -ENOENT;
> >
> >  	if (simple_attr_open(inode, file, get, set, fmt)) {
> > --
> > 2.7.4
> >
