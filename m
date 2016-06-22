Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Tue, 21 Jun 2016 17:47:01 -0700
Message-Id: <1466556426-32664-5-git-send-email-keescook@chromium.org>
In-Reply-To: <1466556426-32664-1-git-send-email-keescook@chromium.org>
References: <1466556426-32664-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v7 4/9] x86/mm: Separate variable for trampoline PGD (x86_64)
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Andy Lutomirski <luto@kernel.org>, x86@kernel.org, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Juergen Gross <jgross@suse.com>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Dave Young <dyoung@redhat.com>, Joerg Roedel <jroedel@suse.de>, Lv Zheng <lv.zheng@intel.com>, Mark Salter <msalter@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, Stephen Smalley <sds@tycho.nsa.gov>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Jan Beulich <JBeulich@suse.com>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Thomas Garnier <thgarnie@google.com>

Use a separate global variable to define the trampoline PGD used to
start other processors. This change will allow KALSR memory
randomization to change the trampoline PGD to be correctly aligned with
physical memory.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/pgtable.h | 12 ++++++++++++
 arch/x86/mm/init.c             |  3 +++
 arch/x86/realmode/init.c       |  5 ++++-
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 1a27396b6ea0..d455bef39e9c 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -729,6 +729,18 @@ extern int direct_gbpages;
 void init_mem_mapping(void);
 void early_alloc_pgt_buf(void);
 
+#ifdef CONFIG_X86_64
+/* Realmode trampoline initialization. */
+extern pgd_t trampoline_pgd_entry;
+static inline void __meminit init_trampoline(void)
+{
+	/* Default trampoline pgd value */
+	trampoline_pgd_entry = init_level4_pgt[pgd_index(__PAGE_OFFSET)];
+}
+#else
+static inline void init_trampoline(void) { }
+#endif
+
 /* local pte updates need not use xchg for locking */
 static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
 {
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 372aad2b3291..4252acdfcbbd 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -590,6 +590,9 @@ void __init init_mem_mapping(void)
 	/* the ISA range is always mapped regardless of memory holes */
 	init_memory_mapping(0, ISA_END_ADDRESS);
 
+	/* Init the trampoline, possibly with KASLR memory offset */
+	init_trampoline();
+
 	/*
 	 * If the allocation is in bottom-up direction, we setup direct mapping
 	 * in bottom-up, otherwise we setup direct mapping in top-down.
diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index 0b7a63d98440..705e3fffb4a1 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -8,6 +8,9 @@
 struct real_mode_header *real_mode_header;
 u32 *trampoline_cr4_features;
 
+/* Hold the pgd entry used on booting additional CPUs */
+pgd_t trampoline_pgd_entry;
+
 void __init reserve_real_mode(void)
 {
 	phys_addr_t mem;
@@ -84,7 +87,7 @@ void __init setup_real_mode(void)
 	*trampoline_cr4_features = __read_cr4();
 
 	trampoline_pgd = (u64 *) __va(real_mode_header->trampoline_pgd);
-	trampoline_pgd[0] = init_level4_pgt[pgd_index(__PAGE_OFFSET)].pgd;
+	trampoline_pgd[0] = trampoline_pgd_entry.pgd;
 	trampoline_pgd[511] = init_level4_pgt[511].pgd;
 #endif
 }
-- 
2.7.4
