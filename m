Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Sun, 26 Jun 2016 14:55:42 -0700
Message-Id: <6c8610ea4d224d14699f62c07e569e2f01499234.1466974736.git.luto@kernel.org>
In-Reply-To: <cover.1466974736.git.luto@kernel.org>
References: <cover.1466974736.git.luto@kernel.org>
In-Reply-To: <cover.1466974736.git.luto@kernel.org>
References: <cover.1466974736.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH v4 20/29] x86/smp: Remove stack_smp_processor_id()
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

It serves no purpose -- raw_smp_processor_id() works fine.  This
change will be needed to move thread_info off the stack.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/include/asm/cpu.h   | 1 -
 arch/x86/include/asm/smp.h   | 6 ------
 arch/x86/kernel/cpu/common.c | 2 +-
 3 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 678637ad7476..59d34c521d96 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -17,7 +17,6 @@ static inline void prefill_possible_map(void) {}
 
 #define cpu_physical_id(cpu)			boot_cpu_physical_apicid
 #define safe_smp_processor_id()			0
-#define stack_smp_processor_id()		0
 
 #endif /* CONFIG_SMP */
 
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 66b057306f40..0576b6157f3a 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -172,12 +172,6 @@ extern int safe_smp_processor_id(void);
 #elif defined(CONFIG_X86_64_SMP)
 #define raw_smp_processor_id() (this_cpu_read(cpu_number))
 
-#define stack_smp_processor_id()					\
-({								\
-	struct thread_info *ti;						\
-	__asm__("andq %%rsp,%0; ":"=r" (ti) : "0" (CURRENT_MASK));	\
-	ti->cpu;							\
-})
 #define safe_smp_processor_id()		smp_processor_id()
 
 #endif
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 0fe6953f421c..d22a7b9c4f0e 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1452,7 +1452,7 @@ void cpu_init(void)
 	struct task_struct *me;
 	struct tss_struct *t;
 	unsigned long v;
-	int cpu = stack_smp_processor_id();
+	int cpu = raw_smp_processor_id();
 	int i;
 
 	wait_for_master_cpu(cpu);
-- 
2.7.4
