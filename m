Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 19 Sep 2016 11:44:51 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160919104254.GA12473@leverpostej>
References: <1473947349-14521-1-git-send-email-mark.rutland@arm.com>
 <1473947349-14521-3-git-send-email-mark.rutland@arm.com>
 <CALCETrWni0aZ71r-R6oYG98kZvZA8a184UR0YURk_=tXu8HXMw@mail.gmail.com>
 <20160916103101.GA21702@leverpostej>
 <CALCETrUDWiDmLbMqw9sQYEzvDuSVfmT_UscxQXfmf8YYyTOC=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUDWiDmLbMqw9sQYEzvDuSVfmT_UscxQXfmf8YYyTOC=Q@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC PATCH 2/8] thread_info: allow custom in-task thread_info
To: Andy Lutomirski <luto@amacapital.net>, Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, james.morse@arm.com, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, lorenzo.pieralisi@arm.com, Andrew Lutomirski <luto@kernel.org>, suzuki.poulose@arm.com, Takahiro Akashi <takahiro.akashi@linaro.org>, Will Deacon <will.deacon@arm.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

[Adding Yosinori Sato for h8300]

On Fri, Sep 16, 2016 at 08:11:14AM -0700, Andy Lutomirski wrote:
> > On Thu, Sep 15, 2016 at 11:37:47AM -0700, Andy Lutomirski wrote:
> > > On Thu, Sep 15, 2016 at 6:49 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> > Just to check, what do you mean to happen with the flags field? Should
> > that always be in the generic thread_info? e.g.
> >
> > struct thread_info {
> >         u32 flags;
> > #ifdef arch_thread_info
> >         struct arch_thread_info arch_ti;
> > #endif
> > };
> 
> Exactly.  Possibly with a comment that using thread_struct should be
> preferred and that arch_thread_info should be used only if some header
> file requires access via current_thread_info() or task_thread_info().

Sure thing.

While looking at that, I spotted that would cause a circular include on
h8300, but that appears to be because of a larger bug anyhow. It seems
h8300 has thread_info::restart_block, and manipulates this in its signal
code, yet core code manipulates task_struct::restart_block.

I think we need something like the below (which is completely untested).

Thanks,
Mark.

---->8----
>From 4dfbdc7706bfb03a48999ff69e85e0c7361adffe Mon Sep 17 00:00:00 2001
From: Mark Rutland <mark.rutland@arm.com>
Date: Mon, 19 Sep 2016 11:33:42 +0100
Subject: [PATCH] h8300: fix syscall restarting

Back in commit f56141e3e2d9aabf ("all arches, signal: move restart_block
to struct task_struct"), all architectures and core code were changed to
use task_struct::restart_block. However, when h8300 support was
subsequently restored in v4.2, it was not updated to account for this,
and maintains thread_info::restart_block, which is not kept in sync.

This patch drops the redundant restart_block from thread_info, and moves
h8300 to the common one in task_struct, ensuring that syscall restarting
always works as expected.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: stable@vger.kernel.org # v4.2+
---
 arch/h8300/include/asm/thread_info.h | 4 ----
 arch/h8300/kernel/signal.c           | 2 +-
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/h8300/include/asm/thread_info.h b/arch/h8300/include/asm/thread_info.h
index b408fe6..3cef068 100644
--- a/arch/h8300/include/asm/thread_info.h
+++ b/arch/h8300/include/asm/thread_info.h
@@ -31,7 +31,6 @@ struct thread_info {
 	int		   cpu;			/* cpu we're on */
 	int		   preempt_count;	/* 0 => preemptable, <0 => BUG */
 	mm_segment_t		addr_limit;
-	struct restart_block restart_block;
 };
 
 /*
@@ -44,9 +43,6 @@ struct thread_info {
 	.cpu =		0,			\
 	.preempt_count = INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
-	.restart_block	= {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff --git a/arch/h8300/kernel/signal.c b/arch/h8300/kernel/signal.c
index ad1f81f..7138303 100644
--- a/arch/h8300/kernel/signal.c
+++ b/arch/h8300/kernel/signal.c
@@ -79,7 +79,7 @@ restore_sigcontext(struct sigcontext *usc, int *pd0)
 	unsigned int er0;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/* restore passed registers */
 #define COPY(r)  do { err |= get_user(regs->r, &usc->sc_##r); } while (0)
-- 
1.9.1
