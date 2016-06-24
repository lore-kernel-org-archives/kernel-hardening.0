Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 24 Jun 2016 17:06:37 +0200
From: Michal Hocko <mhocko@kernel.org>
Message-ID: <20160624150637.GD20203@dhcp22.suse.cz>
References: <cover.1466466093.git.luto@kernel.org>
 <CA+55aFyahpuy94qqECj0ZA6oD3Vy0r=gY2cH8_dB1a-4XURV2Q@mail.gmail.com>
 <CALCETrUuG0-tGNQ5iAEO2_gaK1eUq7AoALoBeQKcOP8cvxr=eA@mail.gmail.com>
 <CA+55aFx480bxx7VAmFqdsVGHjoSav4eCvVpcx5ZSpBQuq+=1Mw@mail.gmail.com>
 <20160623143126.GA16664@redhat.com>
 <CA+55aFwBL5ArLXZ0+YggTbp6Qon+OM+Foihe0yrQOmRRvu96VQ@mail.gmail.com>
 <20160623170352.GA17372@redhat.com>
 <CA+55aFwHUw+6xEc-M+mZvwOxCsBD6zZDwyAQ-a_xupaH8py7cA@mail.gmail.com>
 <20160623185221.GA17983@redhat.com>
 <20160624140558.GA20208@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160624140558.GA20208@dhcp22.suse.cz>
Subject: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks with guard pages (x86,
 core)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri 24-06-16 16:05:58, Michal Hocko wrote:
> On Thu 23-06-16 20:52:21, Oleg Nesterov wrote:
> > On 06/23, Linus Torvalds wrote:
> > >
> > > On Thu, Jun 23, 2016 at 10:03 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > > >
> > > > Let me quote my previous email ;)
> > > >
> > > >         And we can't free/nullify it when the parent/debuger reaps a zombie,
> > > >         say, mark_oom_victim() expects that get_task_struct() protects
> > > >         thread_info as well.
> > > >
> > > > probably we can fix all such users though...
> > >
> > > TIF_MEMDIE is indeed a potential problem, but I don't think
> > > mark_oom_victim() is actually problematic.
> > >
> > > mark_oom_victim() is called with either "current",
> > 
> > This is no longer true in -mm tree.
> > 
> > But I agree, this is fixable (and in fact I still hope TIF_MEMDIE will die,
> > at least in its current form).
> 
> We can move the flag to the task_struct. There are still some bits left
> there. This would be trivial so that the oom usage doesn't stay in the
> way.

Here is the patch. I've found two bugs when the TIF_MEMDIE was checked
on current rather than the given task. I will separate them into their
own patches (was just too lazy for it now). If the approach looks
reasonable then I will repost next week.
---
>From 1baaa1f8f9568f95d8feccb28cf1994f8ca0df9f Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.com>
Date: Fri, 24 Jun 2016 16:46:18 +0200
Subject: [PATCH] mm, oom: move TIF_MEMDIE to the task_struct

There is an interest to drop thread_info->flags usage for further clean
ups. TIF_MEMDIE stands in the way so let's move it out of the
thread_info into the task_struct. We cannot use flags because the oom
killer will set it for !current task without any locking so let's add
task_struct::memdie. It has to be atomic because we need it to be
updated atomically.

Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 arch/alpha/include/asm/thread_info.h      |  1 -
 arch/arc/include/asm/thread_info.h        |  2 --
 arch/arm/include/asm/thread_info.h        |  1 -
 arch/arm64/include/asm/thread_info.h      |  1 -
 arch/avr32/include/asm/thread_info.h      |  2 --
 arch/blackfin/include/asm/thread_info.h   |  1 -
 arch/c6x/include/asm/thread_info.h        |  1 -
 arch/cris/include/asm/thread_info.h       |  1 -
 arch/frv/include/asm/thread_info.h        |  1 -
 arch/h8300/include/asm/thread_info.h      |  1 -
 arch/hexagon/include/asm/thread_info.h    |  1 -
 arch/ia64/include/asm/thread_info.h       |  1 -
 arch/m32r/include/asm/thread_info.h       |  1 -
 arch/m68k/include/asm/thread_info.h       |  1 -
 arch/metag/include/asm/thread_info.h      |  1 -
 arch/microblaze/include/asm/thread_info.h |  1 -
 arch/mips/include/asm/thread_info.h       |  1 -
 arch/mn10300/include/asm/thread_info.h    |  1 -
 arch/nios2/include/asm/thread_info.h      |  1 -
 arch/openrisc/include/asm/thread_info.h   |  1 -
 arch/parisc/include/asm/thread_info.h     |  1 -
 arch/powerpc/include/asm/thread_info.h    |  1 -
 arch/s390/include/asm/thread_info.h       |  1 -
 arch/score/include/asm/thread_info.h      |  1 -
 arch/sh/include/asm/thread_info.h         |  1 -
 arch/sparc/include/asm/thread_info_32.h   |  1 -
 arch/sparc/include/asm/thread_info_64.h   |  1 -
 arch/tile/include/asm/thread_info.h       |  2 --
 arch/um/include/asm/thread_info.h         |  2 --
 arch/unicore32/include/asm/thread_info.h  |  1 -
 arch/x86/include/asm/thread_info.h        |  1 -
 arch/xtensa/include/asm/thread_info.h     |  1 -
 drivers/staging/android/lowmemorykiller.c |  2 +-
 fs/ext4/mballoc.c                         |  2 +-
 include/linux/sched.h                     |  2 ++
 kernel/cpuset.c                           | 12 ++++++------
 kernel/exit.c                             |  2 +-
 kernel/freezer.c                          |  2 +-
 mm/ksm.c                                  |  4 ++--
 mm/memcontrol.c                           |  2 +-
 mm/oom_kill.c                             | 20 ++++++++++----------
 mm/page_alloc.c                           |  6 +++---
 42 files changed, 28 insertions(+), 62 deletions(-)

diff --git a/arch/alpha/include/asm/thread_info.h b/arch/alpha/include/asm/thread_info.h
index 32e920a83ae5..126eaaf6559d 100644
--- a/arch/alpha/include/asm/thread_info.h
+++ b/arch/alpha/include/asm/thread_info.h
@@ -65,7 +65,6 @@ register struct thread_info *__current_thread_info __asm__("$8");
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_SYSCALL_AUDIT	4	/* syscall audit active */
 #define TIF_DIE_IF_KERNEL	9	/* dik recursion lock */
-#define TIF_MEMDIE		13	/* is terminating due to OOM killer */
 #define TIF_POLLING_NRFLAG	14	/* idle is polling for TIF_NEED_RESCHED */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
diff --git a/arch/arc/include/asm/thread_info.h b/arch/arc/include/asm/thread_info.h
index 3af67455659a..46d1fc1a073d 100644
--- a/arch/arc/include/asm/thread_info.h
+++ b/arch/arc/include/asm/thread_info.h
@@ -88,14 +88,12 @@ static inline __attribute_const__ struct thread_info *current_thread_info(void)
 #define TIF_SYSCALL_TRACE	15	/* syscall trace active */
 
 /* true if poll_idle() is polling TIF_NEED_RESCHED */
-#define TIF_MEMDIE		16
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
-#define _TIF_MEMDIE		(1<<TIF_MEMDIE)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index 776757d1604a..6277e56f15fd 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -146,7 +146,6 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
 
 #define TIF_NOHZ		12	/* in adaptive nohz mode */
 #define TIF_USING_IWMMXT	17
-#define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 #define TIF_RESTORE_SIGMASK	20
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index abd64bd1f6d9..d78b3b2945a9 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -114,7 +114,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_SYSCALL_AUDIT	9
 #define TIF_SYSCALL_TRACEPOINT	10
 #define TIF_SECCOMP		11
-#define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 #define TIF_FREEZE		19
 #define TIF_RESTORE_SIGMASK	20
 #define TIF_SINGLESTEP		21
diff --git a/arch/avr32/include/asm/thread_info.h b/arch/avr32/include/asm/thread_info.h
index d4d3079541ea..680be13234ab 100644
--- a/arch/avr32/include/asm/thread_info.h
+++ b/arch/avr32/include/asm/thread_info.h
@@ -70,7 +70,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_NEED_RESCHED        2       /* rescheduling necessary */
 #define TIF_BREAKPOINT		4	/* enter monitor mode on return */
 #define TIF_SINGLE_STEP		5	/* single step in progress */
-#define TIF_MEMDIE		6	/* is terminating due to OOM killer */
 #define TIF_RESTORE_SIGMASK	7	/* restore signal mask in do_signal */
 #define TIF_CPU_GOING_TO_SLEEP	8	/* CPU is entering sleep 0 mode */
 #define TIF_NOTIFY_RESUME	9	/* callback before returning to user */
@@ -82,7 +81,6 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_BREAKPOINT		(1 << TIF_BREAKPOINT)
 #define _TIF_SINGLE_STEP	(1 << TIF_SINGLE_STEP)
-#define _TIF_MEMDIE		(1 << TIF_MEMDIE)
 #define _TIF_CPU_GOING_TO_SLEEP (1 << TIF_CPU_GOING_TO_SLEEP)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 
diff --git a/arch/blackfin/include/asm/thread_info.h b/arch/blackfin/include/asm/thread_info.h
index 2966b93850a1..a45ff075ab6a 100644
--- a/arch/blackfin/include/asm/thread_info.h
+++ b/arch/blackfin/include/asm/thread_info.h
@@ -79,7 +79,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
 #define TIF_SIGPENDING		1	/* signal pending */
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
-#define TIF_MEMDIE		4	/* is terminating due to OOM killer */
 #define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
 #define TIF_IRQ_SYNC		7	/* sync pipeline stage */
 #define TIF_NOTIFY_RESUME	8	/* callback before returning to user */
diff --git a/arch/c6x/include/asm/thread_info.h b/arch/c6x/include/asm/thread_info.h
index acc70c135ab8..22ff7b03641d 100644
--- a/arch/c6x/include/asm/thread_info.h
+++ b/arch/c6x/include/asm/thread_info.h
@@ -89,7 +89,6 @@ struct thread_info *current_thread_info(void)
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_RESTORE_SIGMASK	4	/* restore signal mask in do_signal() */
 
-#define TIF_MEMDIE		17	/* OOM killer killed process */
 
 #define TIF_WORK_MASK		0x00007FFE /* work on irq/exception return */
 #define TIF_ALLWORK_MASK	0x00007FFF /* work on any return to u-space */
diff --git a/arch/cris/include/asm/thread_info.h b/arch/cris/include/asm/thread_info.h
index 4ead1b40d2d7..79ebddc22aa3 100644
--- a/arch/cris/include/asm/thread_info.h
+++ b/arch/cris/include/asm/thread_info.h
@@ -70,7 +70,6 @@ struct thread_info {
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal() */
-#define TIF_MEMDIE		17	/* is terminating due to OOM killer */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
diff --git a/arch/frv/include/asm/thread_info.h b/arch/frv/include/asm/thread_info.h
index ccba3b6ce918..993930f59d8e 100644
--- a/arch/frv/include/asm/thread_info.h
+++ b/arch/frv/include/asm/thread_info.h
@@ -86,7 +86,6 @@ register struct thread_info *__current_thread_info asm("gr15");
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_SINGLESTEP		4	/* restore singlestep on return to user mode */
 #define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
-#define TIF_MEMDIE		7	/* is terminating due to OOM killer */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
diff --git a/arch/h8300/include/asm/thread_info.h b/arch/h8300/include/asm/thread_info.h
index b408fe660cf8..68c10bce921e 100644
--- a/arch/h8300/include/asm/thread_info.h
+++ b/arch/h8300/include/asm/thread_info.h
@@ -73,7 +73,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_SIGPENDING		1	/* signal pending */
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
 #define TIF_SINGLESTEP		3	/* singlestepping active */
-#define TIF_MEMDIE		4	/* is terminating due to OOM killer */
 #define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
 #define TIF_NOTIFY_RESUME	6	/* callback before returning to user */
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
diff --git a/arch/hexagon/include/asm/thread_info.h b/arch/hexagon/include/asm/thread_info.h
index b80fe1db7b64..e55c7d0a1755 100644
--- a/arch/hexagon/include/asm/thread_info.h
+++ b/arch/hexagon/include/asm/thread_info.h
@@ -112,7 +112,6 @@ register struct thread_info *__current_thread_info asm(QUOTED_THREADINFO_REG);
 #define TIF_SINGLESTEP          4       /* restore ss @ return to usr mode */
 #define TIF_RESTORE_SIGMASK     6       /* restore sig mask in do_signal() */
 /* true if poll_idle() is polling TIF_NEED_RESCHED */
-#define TIF_MEMDIE              17      /* OOM killer killed process */
 
 #define _TIF_SYSCALL_TRACE      (1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME      (1 << TIF_NOTIFY_RESUME)
diff --git a/arch/ia64/include/asm/thread_info.h b/arch/ia64/include/asm/thread_info.h
index aa995b67c3f5..77064b1d188a 100644
--- a/arch/ia64/include/asm/thread_info.h
+++ b/arch/ia64/include/asm/thread_info.h
@@ -97,7 +97,6 @@ struct thread_info {
 #define TIF_SYSCALL_AUDIT	3	/* syscall auditing active */
 #define TIF_SINGLESTEP		4	/* restore singlestep on return to user mode */
 #define TIF_NOTIFY_RESUME	6	/* resumption notification requested */
-#define TIF_MEMDIE		17	/* is terminating due to OOM killer */
 #define TIF_MCA_INIT		18	/* this task is processing MCA or INIT */
 #define TIF_DB_DISABLED		19	/* debug trap disabled for fsyscall */
 #define TIF_RESTORE_RSE		21	/* user RBS is newer than kernel RBS */
diff --git a/arch/m32r/include/asm/thread_info.h b/arch/m32r/include/asm/thread_info.h
index f630d9c30b28..bc54a574fad0 100644
--- a/arch/m32r/include/asm/thread_info.h
+++ b/arch/m32r/include/asm/thread_info.h
@@ -102,7 +102,6 @@ static inline unsigned int get_thread_fault_code(void)
 #define TIF_NOTIFY_RESUME	5	/* callback before returning to user */
 #define TIF_RESTORE_SIGMASK	8	/* restore signal mask in do_signal() */
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
-#define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
diff --git a/arch/m68k/include/asm/thread_info.h b/arch/m68k/include/asm/thread_info.h
index cee13c2e5161..ed497d31ea5d 100644
--- a/arch/m68k/include/asm/thread_info.h
+++ b/arch/m68k/include/asm/thread_info.h
@@ -68,7 +68,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_NEED_RESCHED	7	/* rescheduling necessary */
 #define TIF_DELAYED_TRACE	14	/* single step a syscall */
 #define TIF_SYSCALL_TRACE	15	/* syscall trace active */
-#define TIF_MEMDIE		16	/* is terminating due to OOM killer */
 #define TIF_RESTORE_SIGMASK	18	/* restore signal mask in do_signal */
 
 #endif	/* _ASM_M68K_THREAD_INFO_H */
diff --git a/arch/metag/include/asm/thread_info.h b/arch/metag/include/asm/thread_info.h
index 32677cc278aa..c506e5a61714 100644
--- a/arch/metag/include/asm/thread_info.h
+++ b/arch/metag/include/asm/thread_info.h
@@ -111,7 +111,6 @@ static inline int kstack_end(void *addr)
 #define TIF_SECCOMP		5	/* secure computing */
 #define TIF_RESTORE_SIGMASK	6	/* restore signal mask in do_signal() */
 #define TIF_NOTIFY_RESUME	7	/* callback before returning to user */
-#define TIF_MEMDIE		8	/* is terminating due to OOM killer */
 #define TIF_SYSCALL_TRACEPOINT	9	/* syscall tracepoint instrumentation */
 
 
diff --git a/arch/microblaze/include/asm/thread_info.h b/arch/microblaze/include/asm/thread_info.h
index 383f387b4eee..281a365bec48 100644
--- a/arch/microblaze/include/asm/thread_info.h
+++ b/arch/microblaze/include/asm/thread_info.h
@@ -113,7 +113,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_NEED_RESCHED	3 /* rescheduling necessary */
 /* restore singlestep on return to user mode */
 #define TIF_SINGLESTEP		4
-#define TIF_MEMDIE		6	/* is terminating due to OOM killer */
 #define TIF_SYSCALL_AUDIT	9       /* syscall auditing active */
 #define TIF_SECCOMP		10      /* secure computing */
 
diff --git a/arch/mips/include/asm/thread_info.h b/arch/mips/include/asm/thread_info.h
index e309d8fcb516..3dd906330867 100644
--- a/arch/mips/include/asm/thread_info.h
+++ b/arch/mips/include/asm/thread_info.h
@@ -102,7 +102,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_UPROBE		6	/* breakpointed or singlestepping */
 #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal() */
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
-#define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 #define TIF_NOHZ		19	/* in adaptive nohz mode */
 #define TIF_FIXADE		20	/* Fix address errors in software */
 #define TIF_LOGADE		21	/* Log address errors to syslog */
diff --git a/arch/mn10300/include/asm/thread_info.h b/arch/mn10300/include/asm/thread_info.h
index 4861a78c7160..1dd24f251a98 100644
--- a/arch/mn10300/include/asm/thread_info.h
+++ b/arch/mn10300/include/asm/thread_info.h
@@ -145,7 +145,6 @@ void arch_release_thread_info(struct thread_info *ti);
 #define TIF_SINGLESTEP		4	/* restore singlestep on return to user mode */
 #define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
-#define TIF_MEMDIE		17	/* is terminating due to OOM killer */
 
 #define _TIF_SYSCALL_TRACE	+(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	+(1 << TIF_NOTIFY_RESUME)
diff --git a/arch/nios2/include/asm/thread_info.h b/arch/nios2/include/asm/thread_info.h
index d69c338bd19c..bf7d38c1c6e2 100644
--- a/arch/nios2/include/asm/thread_info.h
+++ b/arch/nios2/include/asm/thread_info.h
@@ -86,7 +86,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_NOTIFY_RESUME	1	/* resumption notification requested */
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
-#define TIF_MEMDIE		4	/* is terminating due to OOM killer */
 #define TIF_SECCOMP		5	/* secure computing */
 #define TIF_SYSCALL_AUDIT	6	/* syscall auditing active */
 #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal() */
diff --git a/arch/openrisc/include/asm/thread_info.h b/arch/openrisc/include/asm/thread_info.h
index 6e619a79a401..7678a1b2dc64 100644
--- a/arch/openrisc/include/asm/thread_info.h
+++ b/arch/openrisc/include/asm/thread_info.h
@@ -108,7 +108,6 @@ register struct thread_info *current_thread_info_reg asm("r10");
 #define TIF_RESTORE_SIGMASK     9
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling						 * TIF_NEED_RESCHED
 					 */
-#define TIF_MEMDIE              17
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
diff --git a/arch/parisc/include/asm/thread_info.h b/arch/parisc/include/asm/thread_info.h
index e96e693fd58c..bcebec0b9418 100644
--- a/arch/parisc/include/asm/thread_info.h
+++ b/arch/parisc/include/asm/thread_info.h
@@ -48,7 +48,6 @@ struct thread_info {
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
 #define TIF_POLLING_NRFLAG	3	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_32BIT               4       /* 32 bit binary */
-#define TIF_MEMDIE		5	/* is terminating due to OOM killer */
 #define TIF_RESTORE_SIGMASK	6	/* restore saved signal mask */
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_NOTIFY_RESUME	8	/* callback before returning to user */
diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index 7efee4a3240b..d744fa455dd2 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -97,7 +97,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_SYSCALL_TRACEPOINT	15	/* syscall tracepoint instrumentation */
 #define TIF_EMULATE_STACK_STORE	16	/* Is an instruction emulation
 						for stack store? */
-#define TIF_MEMDIE		17	/* is terminating due to OOM killer */
 #if defined(CONFIG_PPC64)
 #define TIF_ELF2ABI		18	/* function descriptors must die! */
 #endif
diff --git a/arch/s390/include/asm/thread_info.h b/arch/s390/include/asm/thread_info.h
index 2fffc2c27581..8fc2704dd263 100644
--- a/arch/s390/include/asm/thread_info.h
+++ b/arch/s390/include/asm/thread_info.h
@@ -79,7 +79,6 @@ void arch_release_task_struct(struct task_struct *tsk);
 #define TIF_SYSCALL_TRACEPOINT	6	/* syscall tracepoint instrumentation */
 #define TIF_UPROBE		7	/* breakpointed or single-stepping */
 #define TIF_31BIT		16	/* 32bit process */
-#define TIF_MEMDIE		17	/* is terminating due to OOM killer */
 #define TIF_RESTORE_SIGMASK	18	/* restore signal mask in do_signal() */
 #define TIF_SINGLE_STEP		19	/* This task is single stepped */
 #define TIF_BLOCK_STEP		20	/* This task is block stepped */
diff --git a/arch/score/include/asm/thread_info.h b/arch/score/include/asm/thread_info.h
index 7d9ffb15c477..f6e1cc89cef9 100644
--- a/arch/score/include/asm/thread_info.h
+++ b/arch/score/include/asm/thread_info.h
@@ -78,7 +78,6 @@ register struct thread_info *__current_thread_info __asm__("r28");
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
 #define TIF_NOTIFY_RESUME	5	/* callback before returning to user */
 #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal() */
-#define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
diff --git a/arch/sh/include/asm/thread_info.h b/arch/sh/include/asm/thread_info.h
index 2afa321157be..017f3993f384 100644
--- a/arch/sh/include/asm/thread_info.h
+++ b/arch/sh/include/asm/thread_info.h
@@ -117,7 +117,6 @@ extern void init_thread_xstate(void);
 #define TIF_NOTIFY_RESUME	7	/* callback before returning to user */
 #define TIF_SYSCALL_TRACEPOINT	8	/* for ftrace syscall instrumentation */
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling TIF_NEED_RESCHED */
-#define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
diff --git a/arch/sparc/include/asm/thread_info_32.h b/arch/sparc/include/asm/thread_info_32.h
index 229475f0d7ce..bcf81999db0b 100644
--- a/arch/sparc/include/asm/thread_info_32.h
+++ b/arch/sparc/include/asm/thread_info_32.h
@@ -110,7 +110,6 @@ register struct thread_info *current_thread_info_reg asm("g6");
 					 * this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	9	/* true if poll_idle() is polling
 					 * TIF_NEED_RESCHED */
-#define TIF_MEMDIE		10	/* is terminating due to OOM killer */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
diff --git a/arch/sparc/include/asm/thread_info_64.h b/arch/sparc/include/asm/thread_info_64.h
index bde59825d06c..63b3285b7d46 100644
--- a/arch/sparc/include/asm/thread_info_64.h
+++ b/arch/sparc/include/asm/thread_info_64.h
@@ -191,7 +191,6 @@ register struct thread_info *current_thread_info_reg asm("g6");
  *       an immediate value in instructions such as andcc.
  */
 /* flag bit 12 is available */
-#define TIF_MEMDIE		13	/* is terminating due to OOM killer */
 #define TIF_POLLING_NRFLAG	14
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
diff --git a/arch/tile/include/asm/thread_info.h b/arch/tile/include/asm/thread_info.h
index 4b7cef9e94e0..734d53f4b435 100644
--- a/arch/tile/include/asm/thread_info.h
+++ b/arch/tile/include/asm/thread_info.h
@@ -121,7 +121,6 @@ extern void _cpu_idle(void);
 #define TIF_SYSCALL_TRACE	4	/* syscall trace active */
 #define TIF_SYSCALL_AUDIT	5	/* syscall auditing active */
 #define TIF_SECCOMP		6	/* secure computing */
-#define TIF_MEMDIE		7	/* OOM killer at work */
 #define TIF_NOTIFY_RESUME	8	/* callback before returning to user */
 #define TIF_SYSCALL_TRACEPOINT	9	/* syscall tracepoint instrumentation */
 #define TIF_POLLING_NRFLAG	10	/* idle is polling for TIF_NEED_RESCHED */
@@ -134,7 +133,6 @@ extern void _cpu_idle(void);
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
-#define _TIF_MEMDIE		(1<<TIF_MEMDIE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SYSCALL_TRACEPOINT	(1<<TIF_SYSCALL_TRACEPOINT)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
diff --git a/arch/um/include/asm/thread_info.h b/arch/um/include/asm/thread_info.h
index 053baff03674..b13047eeaede 100644
--- a/arch/um/include/asm/thread_info.h
+++ b/arch/um/include/asm/thread_info.h
@@ -58,7 +58,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_SIGPENDING		1	/* signal pending */
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
 #define TIF_RESTART_BLOCK	4
-#define TIF_MEMDIE		5	/* is terminating due to OOM killer */
 #define TIF_SYSCALL_AUDIT	6
 #define TIF_RESTORE_SIGMASK	7
 #define TIF_NOTIFY_RESUME	8
@@ -67,7 +66,6 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
-#define _TIF_MEMDIE		(1 << TIF_MEMDIE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 
diff --git a/arch/unicore32/include/asm/thread_info.h b/arch/unicore32/include/asm/thread_info.h
index e79ad6d5b5b2..2487cf9dd41e 100644
--- a/arch/unicore32/include/asm/thread_info.h
+++ b/arch/unicore32/include/asm/thread_info.h
@@ -121,7 +121,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_NEED_RESCHED	1
 #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
 #define TIF_SYSCALL_TRACE	8
-#define TIF_MEMDIE		18
 #define TIF_RESTORE_SIGMASK	20
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index ffae84df8a93..79a4b75e814c 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -101,7 +101,6 @@ struct thread_info {
 #define TIF_IA32		17	/* IA32 compatibility process */
 #define TIF_FORK		18	/* ret_from_fork */
 #define TIF_NOHZ		19	/* in adaptive nohz mode */
-#define TIF_MEMDIE		20	/* is terminating due to OOM killer */
 #define TIF_POLLING_NRFLAG	21	/* idle is polling for TIF_NEED_RESCHED */
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
 #define TIF_FORCED_TF		24	/* true if TF in eflags artificially */
diff --git a/arch/xtensa/include/asm/thread_info.h b/arch/xtensa/include/asm/thread_info.h
index 7be2400f745a..791a0a0b5827 100644
--- a/arch/xtensa/include/asm/thread_info.h
+++ b/arch/xtensa/include/asm/thread_info.h
@@ -108,7 +108,6 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_SIGPENDING		1	/* signal pending */
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
 #define TIF_SINGLESTEP		3	/* restore singlestep on return to user mode */
-#define TIF_MEMDIE		5	/* is terminating due to OOM killer */
 #define TIF_RESTORE_SIGMASK	6	/* restore signal mask in do_signal() */
 #define TIF_NOTIFY_RESUME	7	/* callback before returning to user */
 #define TIF_DB_DISABLED		8	/* debug trap disabled for syscall */
diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index 2509e5df7244..55d02f2376ab 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -131,7 +131,7 @@ static unsigned long lowmem_scan(struct shrinker *s, struct shrink_control *sc)
 		if (!p)
 			continue;
 
-		if (test_tsk_thread_flag(p, TIF_MEMDIE) &&
+		if (atomic_read(&p->memdie) &&
 		    time_before_eq(jiffies, lowmem_deathpending_timeout)) {
 			task_unlock(p);
 			rcu_read_unlock();
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c1ab3ec30423..ddc12f571c50 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4815,7 +4815,7 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 #endif
 	trace_ext4_mballoc_free(sb, inode, block_group, bit, count_clusters);
 
-	/* __GFP_NOFAIL: retry infinitely, ignore TIF_MEMDIE and memcg limit. */
+	/* __GFP_NOFAIL: retry infinitely, ignore memdie tasks and memcg limit. */
 	err = ext4_mb_load_buddy_gfp(sb, block_group, &e4b,
 				     GFP_NOFS|__GFP_NOFAIL);
 	if (err)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6d81a1eb974a..4c91fc0c2e8e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1856,6 +1856,8 @@ struct task_struct {
 	unsigned long	task_state_change;
 #endif
 	int pagefault_disabled;
+	/* oom victim - give it access to memory reserves */
+	atomic_t	memdie;
 #ifdef CONFIG_MMU
 	struct task_struct *oom_reaper_list;
 #endif
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 73e93e53884d..857fac0b973d 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1038,9 +1038,9 @@ static void cpuset_change_task_nodemask(struct task_struct *tsk,
 	 * Allow tasks that have access to memory reserves because they have
 	 * been OOM killed to get memory anywhere.
 	 */
-	if (unlikely(test_thread_flag(TIF_MEMDIE)))
+	if (unlikely(atomic_read(&tsk->memdie)))
 		return;
-	if (current->flags & PF_EXITING) /* Let dying task have memory */
+	if (tsk->flags & PF_EXITING) /* Let dying task have memory */
 		return;
 
 	task_lock(tsk);
@@ -2496,12 +2496,12 @@ static struct cpuset *nearest_hardwall_ancestor(struct cpuset *cs)
  * If we're in interrupt, yes, we can always allocate.  If @node is set in
  * current's mems_allowed, yes.  If it's not a __GFP_HARDWALL request and this
  * node is set in the nearest hardwalled cpuset ancestor to current's cpuset,
- * yes.  If current has access to memory reserves due to TIF_MEMDIE, yes.
+ * yes.  If current has access to memory reserves due to memdie, yes.
  * Otherwise, no.
  *
  * GFP_USER allocations are marked with the __GFP_HARDWALL bit,
  * and do not allow allocations outside the current tasks cpuset
- * unless the task has been OOM killed as is marked TIF_MEMDIE.
+ * unless the task has been OOM killed as is marked memdie.
  * GFP_KERNEL allocations are not so marked, so can escape to the
  * nearest enclosing hardwalled ancestor cpuset.
  *
@@ -2524,7 +2524,7 @@ static struct cpuset *nearest_hardwall_ancestor(struct cpuset *cs)
  * affect that:
  *	in_interrupt - any node ok (current task context irrelevant)
  *	GFP_ATOMIC   - any node ok
- *	TIF_MEMDIE   - any node ok
+ *	memdie       - any node ok
  *	GFP_KERNEL   - any node in enclosing hardwalled cpuset ok
  *	GFP_USER     - only nodes in current tasks mems allowed ok.
  */
@@ -2542,7 +2542,7 @@ bool __cpuset_node_allowed(int node, gfp_t gfp_mask)
 	 * Allow tasks that have access to memory reserves because they have
 	 * been OOM killed to get memory anywhere.
 	 */
-	if (unlikely(test_thread_flag(TIF_MEMDIE)))
+	if (unlikely(atomic_read(&current->memdie)))
 		return true;
 	if (gfp_mask & __GFP_HARDWALL)	/* If hardwall request, stop here */
 		return false;
diff --git a/kernel/exit.c b/kernel/exit.c
index 9e6e1356e6bb..8bfdda9bc99a 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -434,7 +434,7 @@ static void exit_mm(struct task_struct *tsk)
 	task_unlock(tsk);
 	mm_update_next_owner(mm);
 	mmput(mm);
-	if (test_thread_flag(TIF_MEMDIE))
+	if (atomic_read(&current->memdie))
 		exit_oom_victim(tsk);
 }
 
diff --git a/kernel/freezer.c b/kernel/freezer.c
index a8900a3bc27a..e1bd9f2780fe 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -42,7 +42,7 @@ bool freezing_slow_path(struct task_struct *p)
 	if (p->flags & (PF_NOFREEZE | PF_SUSPEND_TASK))
 		return false;
 
-	if (test_thread_flag(TIF_MEMDIE))
+	if (atomic_read(&p->memdie))
 		return false;
 
 	if (pm_nosig_freezing || cgroup_freezing(p))
diff --git a/mm/ksm.c b/mm/ksm.c
index 73d43bafd9fb..8d5a295fb955 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -396,11 +396,11 @@ static int break_ksm(struct vm_area_struct *vma, unsigned long addr)
 	 *
 	 * VM_FAULT_OOM: at the time of writing (late July 2009), setting
 	 * aside mem_cgroup limits, VM_FAULT_OOM would only be set if the
-	 * current task has TIF_MEMDIE set, and will be OOM killed on return
+	 * current task has memdie set, and will be OOM killed on return
 	 * to user; and ksmd, having no mm, would never be chosen for that.
 	 *
 	 * But if the mm is in a limited mem_cgroup, then the fault may fail
-	 * with VM_FAULT_OOM even if the current task is not TIF_MEMDIE; and
+	 * with VM_FAULT_OOM even if the current task is not memdie; and
 	 * even ksmd can fail in this way - though it's usually breaking ksm
 	 * just to undo a merge it made a moment before, so unlikely to oom.
 	 *
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3e8f9e5e9291..df411de17a75 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1987,7 +1987,7 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * bypass the last charges so that they can exit quickly and
 	 * free their memory.
 	 */
-	if (unlikely(test_thread_flag(TIF_MEMDIE) ||
+	if (unlikely(atomic_read(&current->memdie) ||
 		     fatal_signal_pending(current) ||
 		     current->flags & PF_EXITING))
 		goto force;
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 4c21f744daa6..9d24007cdb82 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -473,7 +473,7 @@ static bool __oom_reap_task(struct task_struct *tsk)
 	 *				[...]
 	 *				out_of_memory
 	 *				  select_bad_process
-	 *				    # no TIF_MEMDIE task selects new victim
+	 *				    # no memdie task selects new victim
 	 *  unmap_page_range # frees some memory
 	 */
 	mutex_lock(&oom_lock);
@@ -593,7 +593,7 @@ static void oom_reap_task(struct task_struct *tsk)
 	}
 
 	/*
-	 * Clear TIF_MEMDIE because the task shouldn't be sitting on a
+	 * Clear memdie because the task shouldn't be sitting on a
 	 * reasonably reclaimable memory anymore or it is not a good candidate
 	 * for the oom victim right now because it cannot release its memory
 	 * itself nor by the oom reaper.
@@ -669,14 +669,14 @@ void mark_oom_victim(struct task_struct *tsk)
 {
 	WARN_ON(oom_killer_disabled);
 	/* OOM killer might race with memcg OOM */
-	if (test_and_set_tsk_thread_flag(tsk, TIF_MEMDIE))
+	if (!atomic_add_unless(&tsk->memdie, 1, 1))
 		return;
 	atomic_inc(&tsk->signal->oom_victims);
 	/*
 	 * Make sure that the task is woken up from uninterruptible sleep
 	 * if it is frozen because OOM killer wouldn't be able to free
 	 * any memory and livelock. freezing_slow_path will tell the freezer
-	 * that TIF_MEMDIE tasks should be ignored.
+	 * that memdie tasks should be ignored.
 	 */
 	__thaw_task(tsk);
 	atomic_inc(&oom_victims);
@@ -687,7 +687,7 @@ void mark_oom_victim(struct task_struct *tsk)
  */
 void exit_oom_victim(struct task_struct *tsk)
 {
-	if (!test_and_clear_tsk_thread_flag(tsk, TIF_MEMDIE))
+	if (!atomic_add_unless(&tsk->memdie, -1, 0))
 		return;
 	atomic_dec(&tsk->signal->oom_victims);
 
@@ -771,7 +771,7 @@ bool task_will_free_mem(struct task_struct *task)
 	 * If the process has passed exit_mm we have to skip it because
 	 * we have lost a link to other tasks sharing this mm, we do not
 	 * have anything to reap and the task might then get stuck waiting
-	 * for parent as zombie and we do not want it to hold TIF_MEMDIE
+	 * for parent as zombie and we do not want it to hold memdie
 	 */
 	p = find_lock_task_mm(task);
 	if (!p)
@@ -836,7 +836,7 @@ void oom_kill_process(struct oom_control *oc, struct task_struct *p,
 
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
-	 * its children or threads, just set TIF_MEMDIE so it can die quickly
+	 * its children or threads, just set memdie so it can die quickly
 	 */
 	if (task_will_free_mem(p)) {
 		mark_oom_victim(p);
@@ -893,7 +893,7 @@ void oom_kill_process(struct oom_control *oc, struct task_struct *p,
 	mm = victim->mm;
 	atomic_inc(&mm->mm_count);
 	/*
-	 * We should send SIGKILL before setting TIF_MEMDIE in order to prevent
+	 * We should send SIGKILL before setting memdie in order to prevent
 	 * the OOM victim from depleting the memory reserves from the user
 	 * space under its control.
 	 */
@@ -1016,7 +1016,7 @@ bool out_of_memory(struct oom_control *oc)
 	 * quickly exit and free its memory.
 	 *
 	 * But don't select if current has already released its mm and cleared
-	 * TIF_MEMDIE flag at exit_mm(), otherwise an OOM livelock may occur.
+	 * memdie flag at exit_mm(), otherwise an OOM livelock may occur.
 	 */
 	if (current->mm && task_will_free_mem(current)) {
 		mark_oom_victim(current);
@@ -1096,7 +1096,7 @@ void pagefault_out_of_memory(void)
 		 * be a racing OOM victim for which oom_killer_disable()
 		 * is waiting for.
 		 */
-		WARN_ON(test_thread_flag(TIF_MEMDIE));
+		WARN_ON(atomic_read(&current->memdie));
 	}
 
 	mutex_unlock(&oom_lock);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 89128d64d662..6c550afde6a4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3050,7 +3050,7 @@ void warn_alloc_failed(gfp_t gfp_mask, unsigned int order, const char *fmt, ...)
 	 * of allowed nodes.
 	 */
 	if (!(gfp_mask & __GFP_NOMEMALLOC))
-		if (test_thread_flag(TIF_MEMDIE) ||
+		if (atomic_read(&current->memdie) ||
 		    (current->flags & (PF_MEMALLOC | PF_EXITING)))
 			filter &= ~SHOW_MEM_FILTER_NODES;
 	if (in_interrupt() || !(gfp_mask & __GFP_DIRECT_RECLAIM))
@@ -3428,7 +3428,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 			alloc_flags |= ALLOC_NO_WATERMARKS;
 		else if (!in_interrupt() &&
 				((current->flags & PF_MEMALLOC) ||
-				 unlikely(test_thread_flag(TIF_MEMDIE))))
+				 unlikely(atomic_read(&current->memdie))))
 			alloc_flags |= ALLOC_NO_WATERMARKS;
 	}
 #ifdef CONFIG_CMA
@@ -3637,7 +3637,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	}
 
 	/* Avoid allocations with no watermarks from looping endlessly */
-	if (test_thread_flag(TIF_MEMDIE) && !(gfp_mask & __GFP_NOFAIL))
+	if (atomic_read(&current->memdie) && !(gfp_mask & __GFP_NOFAIL))
 		goto nopage;
 
 	/*
-- 
2.8.1

-- 
Michal Hocko
SUSE Labs
