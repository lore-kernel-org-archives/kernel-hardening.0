Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 12 Mar 2018 03:03:34 +0000
Message-ID: <lsq.1520823814.932106069@decadent.org.uk>
Subject: [PATCH 3.2 087/104] x86/syscall: Sanitize syscall table
 de-references under speculation
In-Reply-To: <lsq.1520823814.606620518@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Dan Williams <dan.j.williams@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>, kernel-hardening@lists.openwall.com, alan@linux.intel.com, Jan Beulich <JBeulich@suse.com>, linux-arch@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Jinpu Wang <jinpu.wang@profitbricks.com>, gregkh@linuxfoundation.org, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

3.2.101-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 2fbd7af5af8665d18bcefae3e9700be07e22b681 upstream.

The upstream version of this, touching C code, was written by Dan Williams,
with the following description:

> The syscall table base is a user controlled function pointer in kernel
> space. Use array_index_nospec() to prevent any out of bounds speculation.
>
> While retpoline prevents speculating into a userspace directed target it
> does not stop the pointer de-reference, the concern is leaking memory
> relative to the syscall table base, by observing instruction cache
> behavior.

The x86_64 assembly version for 4.4 was written by Jiri Slaby, with
the following description:

> In 4.4.118, we have commit c8961332d6da (x86/syscall: Sanitize syscall
> table de-references under speculation), which is a backport of upstream
> commit 2fbd7af5af86. But it fixed only the C part of the upstream patch
> -- the IA32 sysentry. So it ommitted completely the assembly part -- the
> 64bit sysentry.
>
> Fix that in this patch by explicit array_index_mask_nospec written in
> assembly. The same was used in lib/getuser.S.
>
> However, to have "sbb" working properly, we have to switch from "cmp"
> against (NR_syscalls-1) to (NR_syscalls), otherwise the last syscall
> number would be "and"ed by 0. It is because the original "ja" relies on
> "CF" or "ZF", but we rely only on "CF" in "sbb". That means: switch to
> "jae" conditional jump too.
>
> Final note: use rcx for mask as this is exactly what is overwritten by
> the 4th syscall argument (r10) right after.

In 3.2 the x86_32 syscall table lookup is also written in assembly.
So I've taken Jiri's version and added similar masking in entry_32.S,
using edx as the temporary.  edx is clobbered by SAVE_REGS and seems
to be free at this point.

In 3.2 the x86_64 entry code also lacks syscall masking for x32.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Jan Beulich <JBeulich@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arch@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com
Cc: gregkh@linuxfoundation.org
Cc: Andy Lutomirski <luto@kernel.org>
Cc: alan@linux.intel.com
Cc: Jinpu Wang <jinpu.wang@profitbricks.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -429,6 +429,8 @@ sysenter_past_esp:
 sysenter_do_call:
 	cmpl $(nr_syscalls), %eax
 	jae sysenter_badsys
+	sbb %edx, %edx				/* array_index_mask_nospec() */
+	and %edx, %eax
 	call *sys_call_table(,%eax,4)
 sysenter_after_call:
 	movl %eax,PT_EAX(%esp)
@@ -512,6 +514,8 @@ ENTRY(system_call)
 	cmpl $(nr_syscalls), %eax
 	jae syscall_badsys
 syscall_call:
+	sbb %edx, %edx				/* array_index_mask_nospec() */
+	and %edx, %eax
 	call *sys_call_table(,%eax,4)
 syscall_after_call:
 	movl %eax,PT_EAX(%esp)		# store the return value
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -517,8 +517,10 @@ ENTRY(system_call_after_swapgs)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%rcx)
 	jnz tracesys
 system_call_fastpath:
-	cmpq $__NR_syscall_max,%rax
-	ja badsys
+	cmpq	$NR_syscalls, %rax
+	jae	badsys
+	sbb	%rcx, %rcx			/* array_index_mask_nospec() */
+	and	%rcx, %rax
 	movq %r10,%rcx
 #ifdef CONFIG_RETPOLINE
 	movq	sys_call_table(, %rax, 8), %rax
@@ -646,8 +648,10 @@ tracesys:
 	 */
 	LOAD_ARGS ARGOFFSET, 1
 	RESTORE_REST
-	cmpq $__NR_syscall_max,%rax
-	ja   int_ret_from_sys_call	/* RAX(%rsp) set to -ENOSYS above */
+	cmpq	$NR_syscalls, %rax
+	jae	int_ret_from_sys_call		/* RAX(%rsp) set to -ENOSYS above */
+	sbb	%rcx, %rcx			/* array_index_mask_nospec() */
+	and	%rcx, %rax
 	movq %r10,%rcx	/* fixup for C */
 #ifdef CONFIG_RETPOLINE
 	movq	sys_call_table(, %rax, 8), %rax
