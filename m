Return-Path: <SRS0=pxJu=IH=lists.openwall.com=kernel-hardening-return-20897-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B071DC433DB
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Mar 2021 21:44:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9391864FD1
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Mar 2021 21:44:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9391864FD1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20897-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16032 invoked by uid 550); 9 Mar 2021 21:43:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15927 invoked from network); 9 Mar 2021 21:43:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8RR/gKm83SIV1ashXcsFL/lRx7PJhODu8ZSMn6SRrJQ=;
        b=Aa3aRs4OJPwblM5njJZhnEgcytwXidQByjYa9Ay6CSQY4T61mreRXkEIfUuJk4kW7V
         +SLSgbpCymc8I1YZCygo9ETUz9nK6SsozbQgbB/9c4IouQIbXj4TNJksDzJKw3cuGJl/
         KrVvzIjE9iyZn7H8MJwRXZuySati6yJN0RMhI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8RR/gKm83SIV1ashXcsFL/lRx7PJhODu8ZSMn6SRrJQ=;
        b=kmt/QMmwbJxr1JyBg1t207zs1jcFioLz+ivAGUrNEa9bhq8rhPIRXSRZ8QkwrMyXN0
         OUSI+9OQFUIhI6jVEqaqamzCi1g5M0dwr7M19q73IlRk72g8otAJQi+xJvuog8WvCIC5
         mMowzm1NO/9JnSpO0+tejR1hQoxgCSy1jxEx1uqP8z1FVfL6URUKAj4c/809d5pPbxTf
         N8rKQu+mF4DIyARKs+H9zEuJauEHN7DWaepp3Wj44yfG1EDDC8Iam9EL5p+TKzZyYurU
         0L0EcEGceJCL+6t6Z4Dcw2B0KebVURhhgoUTxFWjWoZHyELWaNK9mcQOhLq2LgwMJEZd
         nfaw==
X-Gm-Message-State: AOAM532vynIJr8STpdPOmKyDCQpcoU1QBvU+K70uwMPvrNwUv2o4HcvE
	7Ofz7dWAzn9omELH+Jp1f+Wh2w==
X-Google-Smtp-Source: ABdhPJybP/9TJUD7D2FkuRFBUCYyX6YkmGRAq9gsWFwEjp+OFZfSYratNXF5gBKSQlHH8qnkVl7yvA==
X-Received: by 2002:a17:90a:c249:: with SMTP id d9mr6828303pjx.104.1615326194695;
        Tue, 09 Mar 2021 13:43:14 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>,
	Elena Reshetova <elena.reshetova@intel.com>,
	x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Alexander Popov <alex.popov@linux.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>,
	kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v5 4/7] stack: Optionally randomize kernel stack offset each syscall
Date: Tue,  9 Mar 2021 13:42:58 -0800
Message-Id: <20210309214301.678739-5-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210309214301.678739-1-keescook@chromium.org>
References: <20210309214301.678739-1-keescook@chromium.org>
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=4a65f719103e0800c3c67a72875df15eff769bc7; i=R0fcIKmEUh8zot7Dpk8JcJdIeXVfXkVsg5oQI7Df8iY=; m=MAP5vDRMDqR2Ss+UnPKNUGFW/8cuHmj3fGsgmrr5dWA=; p=FEZkCJfgrReOcdjubtlCDCLRXPUj5jJvx3leLrrKn8I=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmBH6+QACgkQiXL039xtwCYt/A//ZpW xIrPYTNqy9sJdKRbFSzhEskkhjw9aomRWQn/jYttnfZ4rtdHNQHHpeclAZFgY22YwhHqtQGw+n5hO XysR3g3QUyJDpHmdk2cOC7f9hQGr8nZmLutiw6eJshqxWlcLeK1kkXdvy09dASoExLEaO7WGVI2fV AuEg1C/N/DQSBcPG4F3RnjLvrhO4mKRAAMh5vQI16POw2F4DMtdDt6D4i59WyMf9b/18S5XuJacEz g0KJXCxHkLhm0t749F4I9OLhlWMVrev6z84lLnIEvrtGWIFDph68bz1LcwARlpBZQPmw2hQZWNpNj qyAobPazh6XAZLnWFjnhf6HtzR4I9a6efBEGig5QgQLFAoEavmWP6frgRESxXVZCTuaxPWqFU8UHc LS1mdbmBh+VepFNQ3ILtuZfZ4n0Kb9ri0jmjsxtOHU8vf5bphCXY7kstoSf0CjCvnn12SfPYBFYxU FgCatXZ1IfFzOpFD5jmqswppdv4BZkm8Lpgd7j1HhqMx785XkbkjHxjN9+Fe6VfjDiUtMa8TduRed R/TSmTcMzP6YBxXs+f/2smfORgho7h6a9mn6WsJ6n9yYPWATd3duVP+Hotd7wghl3DNlfcKbop1h3 NBc6ALYGrdHlh5oQWnmmmhR6kTp+a7nZJrAsgkEy1JY/bSQqZMlPcRUWLVydNK8g=
Content-Transfer-Encoding: 8bit

This provides the ability for architectures to enable kernel stack base
address offset randomization. This feature is controlled by the boot
param "randomize_kstack_offset=on/off", with its default value set by
CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT.

This feature is based on the original idea from the last public release
of PaX's RANDKSTACK feature: https://pax.grsecurity.net/docs/randkstack.txt
All the credit for the original idea goes to the PaX team. Note that
the design and implementation of this upstream randomize_kstack_offset
feature differs greatly from the RANDKSTACK feature (see below).

Reasoning for the feature:

This feature aims to make harder the various stack-based attacks that
rely on deterministic stack structure. We have had many such attacks in
past (just to name few):

https://jon.oberheide.org/files/infiltrate12-thestackisback.pdf
https://jon.oberheide.org/files/stackjacking-infiltrate11.pdf
https://googleprojectzero.blogspot.com/2016/06/exploiting-recursion-in-linux-kernel_20.html

As Linux kernel stack protections have been constantly improving
(vmap-based stack allocation with guard pages, removal of thread_info,
STACKLEAK), attackers have had to find new ways for their exploits
to work. They have done so, continuing to rely on the kernel's stack
determinism, in situations where VMAP_STACK and THREAD_INFO_IN_TASK_STRUCT
were not relevant. For example, the following recent attacks would have
been hampered if the stack offset was non-deterministic between syscalls:

https://repositorio-aberto.up.pt/bitstream/10216/125357/2/374717.pdf
(page 70: targeting the pt_regs copy with linear stack overflow)

https://a13xp0p0v.github.io/2020/02/15/CVE-2019-18683.html
(leaked stack address from one syscall as a target during next syscall)

The main idea is that since the stack offset is randomized on each system
call, it is harder for an attack to reliably land in any particular place
on the thread stack, even with address exposures, as the stack base will
change on the next syscall. Also, since randomization is performed after
placing pt_regs, the ptrace-based approach[1] to discover the randomized
offset during a long-running syscall should not be possible.

Design description:

During most of the kernel's execution, it runs on the "thread stack",
which is pretty deterministic in its structure: it is fixed in size,
and on every entry from userspace to kernel on a syscall the thread
stack starts construction from an address fetched from the per-cpu
cpu_current_top_of_stack variable. The first element to be pushed to the
thread stack is the pt_regs struct that stores all required CPU registers
and syscall parameters. Finally the specific syscall function is called,
with the stack being used as the kernel executes the resulting request.

The goal of randomize_kstack_offset feature is to add a random offset
after the pt_regs has been pushed to the stack and before the rest of the
thread stack is used during the syscall processing, and to change it every
time a process issues a syscall. The source of randomness is currently
architecture-defined (but x86 is using the low byte of rdtsc()). Future
improvements for different entropy sources is possible, but out of scope
for this patch. As suggested by Andy Lutomirski, the offset is added
using alloca() and an empty asm() statement with an output constraint,
since it avoid changes to assembly syscall entry code, to the unwinder,
and provides correct stack alignment as defined by the compiler.

In order to make this available by default with zero performance impact
for those that don't want it, it is boot-time selectable with static
branches. This way, if the overhead is not wanted, it can just be
left turned off with no performance impact.

The generated assembly for x86_64 with GCC looks like this:

...
ffffffff81003977: 65 8b 05 02 ea 00 7f  mov %gs:0x7f00ea02(%rip),%eax
					    # 12380 <kstack_offset>
ffffffff8100397e: 25 ff 03 00 00        and $0x3ff,%eax
ffffffff81003983: 48 83 c0 0f           add $0xf,%rax
ffffffff81003987: 25 f8 07 00 00        and $0x7f8,%eax
ffffffff8100398c: 48 29 c4              sub %rax,%rsp
ffffffff8100398f: 48 8d 44 24 0f        lea 0xf(%rsp),%rax
ffffffff81003994: 48 83 e0 f0           and $0xfffffffffffffff0,%rax
...

As a result of the above stack alignment, this patch introduces about
5 bits of randomness after pt_regs is spilled to the thread stack on
x86_64, and 6 bits on x86_32 (since its has 1 fewer bit required for
stack alignment). The amount of entropy could be adjusted based on how
much of the stack space we wish to trade for security.

My measure of syscall performance overhead (on x86_64):

lmbench: /usr/lib/lmbench/bin/x86_64-linux-gnu/lat_syscall -N 10000 null
    randomize_kstack_offset=y	Simple syscall: 0.7082 microseconds
    randomize_kstack_offset=n	Simple syscall: 0.7016 microseconds

So, roughly 0.9% overhead growth for a no-op syscall, which is very
manageable. And for people that don't want this, it's off by default.

There are two gotchas with using the alloca() trick. First,
compilers that have Stack Clash protection (-fstack-clash-protection)
enabled by default (e.g. Ubuntu[3]) add pagesize stack probes to
any dynamic stack allocations. While the randomization offset is
always less than a page, the resulting assembly would still contain
(unreachable!) probing routines, bloating the resulting assembly. To
avoid this, -fno-stack-clash-protection is unconditionally added to
the kernel Makefile since this is the only dynamic stack allocation in
the kernel (now that VLAs have been removed) and it is provably safe
from Stack Clash style attacks.

The second gotcha with alloca() is a negative interaction with
-fstack-protector*, in that it sees the alloca() as an array allocation,
which triggers the unconditional addition of the stack canary function
pre/post-amble which slows down syscalls regardless of the static
branch. In order to avoid adding this unneeded check and its associated
performance impact, architectures need to carefully remove uses of
-fstack-protector-strong (or -fstack-protector) in the compilation units
that use the add_random_kstack() macro and to audit the resulting stack
mitigation coverage (to make sure no desired coverage disappears). No
change is visible for this on x86 because the stack protector is already
unconditionally disabled for the compilation unit, but the change is
required on arm64. There is, unfortunately, no attribute that can be
used to disable stack protector for specific functions.

Comparison to PaX RANDKSTACK feature:

The RANDKSTACK feature randomizes the location of the stack start
(cpu_current_top_of_stack), i.e. including the location of pt_regs
structure itself on the stack. Initially this patch followed the same
approach, but during the recent discussions[2], it has been determined
to be of a little value since, if ptrace functionality is available for
an attacker, they can use PTRACE_PEEKUSR/PTRACE_POKEUSR to read/write
different offsets in the pt_regs struct, observe the cache behavior of
the pt_regs accesses, and figure out the random stack offset. Another
difference is that the random offset is stored in a per-cpu variable,
rather than having it be per-thread. As a result, these implementations
differ a fair bit in their implementation details and results, though
obviously the intent is similar.

[1] https://lore.kernel.org/kernel-hardening/2236FBA76BA1254E88B949DDB74E612BA4BC57C1@IRSMSX102.ger.corp.intel.com/
[2] https://lore.kernel.org/kernel-hardening/20190329081358.30497-1-elena.reshetova@intel.com/
[3] https://lists.ubuntu.com/archives/ubuntu-devel/2019-June/040741.html

Co-developed-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Link: https://lore.kernel.org/r/20190415060918.3766-1-elena.reshetova@intel.com
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 .../admin-guide/kernel-parameters.txt         | 11 +++++
 Makefile                                      |  4 ++
 arch/Kconfig                                  | 23 ++++++++++
 include/linux/randomize_kstack.h              | 42 +++++++++++++++++++
 init/main.c                                   | 23 ++++++++++
 5 files changed, 103 insertions(+)
 create mode 100644 include/linux/randomize_kstack.h

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 04545725f187..bee8644a192e 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4061,6 +4061,17 @@
 			fully seed the kernel's CRNG. Default is controlled
 			by CONFIG_RANDOM_TRUST_CPU.
 
+	randomize_kstack_offset=
+			[KNL] Enable or disable kernel stack offset
+			randomization, which provides roughly 5 bits of
+			entropy, frustrating memory corruption attacks
+			that depend on stack address determinism or
+			cross-syscall address exposures. This is only
+			available on architectures that have defined
+			CONFIG_HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET.
+			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
+			Default is CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT.
+
 	ras=option[,option,...]	[KNL] RAS-specific options
 
 		cec_disable	[X86]
diff --git a/Makefile b/Makefile
index 31dcdb3d61fa..8a959a264588 100644
--- a/Makefile
+++ b/Makefile
@@ -811,6 +811,10 @@ KBUILD_CFLAGS	+= -ftrivial-auto-var-init=zero
 KBUILD_CFLAGS	+= -enable-trivial-auto-var-init-zero-knowing-it-will-be-removed-from-clang
 endif
 
+# While VLAs have been removed, GCC produces unreachable stack probes
+# for the randomize_kstack_offset feature. Disable it for all compilers.
+KBUILD_CFLAGS	+= $(call cc-option, -fno-stack-clash-protection)
+
 DEBUG_CFLAGS	:=
 
 # Workaround for GCC versions < 5.0
diff --git a/arch/Kconfig b/arch/Kconfig
index 2bb30673d8e6..4fe6b047fcbc 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1055,6 +1055,29 @@ config VMAP_STACK
 	  backing virtual mappings with real shadow memory, and KASAN_VMALLOC
 	  must be enabled.
 
+config HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
+	def_bool n
+	help
+	  An arch should select this symbol if it can support kernel stack
+	  offset randomization with calls to add_random_kstack_offset()
+	  during syscall entry and choose_random_kstack_offset() during
+	  syscall exit. Careful removal of -fstack-protector-strong and
+	  -fstack-protector should also be applied to the entry code and
+	  closely examined, as the artificial stack bump looks like an array
+	  to the compiler, so it will attempt to add canary checks regardless
+	  of the static branch state.
+
+config RANDOMIZE_KSTACK_OFFSET_DEFAULT
+	bool "Randomize kernel stack offset on syscall entry"
+	depends on HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
+	help
+	  The kernel stack offset can be randomized (after pt_regs) by
+	  roughly 5 bits of entropy, frustrating memory corruption
+	  attacks that depend on stack address determinism or
+	  cross-syscall address exposures. This feature is controlled
+	  by kernel boot param "randomize_kstack_offset=on/off", and this
+	  config chooses the default boot state.
+
 config ARCH_OPTIONAL_KERNEL_RWX
 	def_bool n
 
diff --git a/include/linux/randomize_kstack.h b/include/linux/randomize_kstack.h
new file mode 100644
index 000000000000..c4701a39c21f
--- /dev/null
+++ b/include/linux/randomize_kstack.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _LINUX_RANDOMIZE_KSTACK_H
+#define _LINUX_RANDOMIZE_KSTACK_H
+
+#include <linux/kernel.h>
+#include <linux/jump_label.h>
+#include <linux/percpu-defs.h>
+
+DECLARE_STATIC_KEY_MAYBE(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,
+			 randomize_kstack_offset);
+DECLARE_PER_CPU(u32, kstack_offset);
+
+/*
+ * Do not use this anywhere else in the kernel. This is used here because
+ * it provides an arch-agnostic way to grow the stack with correct
+ * alignment. Also, since this use is being explicitly masked to a max of
+ * 10 bits, stack-clash style attacks are unlikely. For more details see
+ * "VLAs" in Documentation/process/deprecated.rst
+ * The asm statement is designed to convince the compiler to keep the
+ * allocation around even after "ptr" goes out of scope.
+ */
+void *__builtin_alloca(size_t size);
+
+#define add_random_kstack_offset() do {					\
+	if (static_branch_maybe(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,	\
+				&randomize_kstack_offset)) {		\
+		u32 offset = this_cpu_read(kstack_offset);		\
+		u8 *ptr = __builtin_alloca(offset & 0x3FF);		\
+		asm volatile("" : "=m"(*ptr) :: "memory");		\
+	}								\
+} while (0)
+
+#define choose_random_kstack_offset(rand) do {				\
+	if (static_branch_maybe(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,	\
+				&randomize_kstack_offset)) {		\
+		u32 offset = this_cpu_read(kstack_offset);		\
+		offset ^= (rand);					\
+		this_cpu_write(kstack_offset, offset);			\
+	}								\
+} while (0)
+
+#endif
diff --git a/init/main.c b/init/main.c
index 53b278845b88..f498aac26e8c 100644
--- a/init/main.c
+++ b/init/main.c
@@ -844,6 +844,29 @@ static void __init mm_init(void)
 	pti_init();
 }
 
+#ifdef CONFIG_HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
+DEFINE_STATIC_KEY_MAYBE_RO(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,
+			   randomize_kstack_offset);
+DEFINE_PER_CPU(u32, kstack_offset);
+
+static int __init early_randomize_kstack_offset(char *buf)
+{
+	int ret;
+	bool bool_result;
+
+	ret = kstrtobool(buf, &bool_result);
+	if (ret)
+		return ret;
+
+	if (bool_result)
+		static_branch_enable(&randomize_kstack_offset);
+	else
+		static_branch_disable(&randomize_kstack_offset);
+	return 0;
+}
+early_param("randomize_kstack_offset", early_randomize_kstack_offset);
+#endif
+
 void __init __weak arch_call_rest_init(void)
 {
 	rest_init();
-- 
2.25.1

