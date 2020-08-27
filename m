Return-Path: <SRS0=gBtk=CF=lists.openwall.com=kernel-hardening-return-19678-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB53C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 05:25:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9C09220786
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 05:25:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C09220786
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codefail.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19678-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9599 invoked by uid 550); 27 Aug 2020 05:24:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9429 invoked from network); 27 Aug 2020 05:24:47 -0000
From: "Christopher M. Riedl" <cmr@codefail.de>
To: linuxppc-dev@lists.ozlabs.org
Cc: kernel-hardening@lists.openwall.com
Subject: [PATCH v3 6/6] powerpc: Use a temporary mm for code patching
Date: Thu, 27 Aug 2020 00:26:59 -0500
Message-Id: <20200827052659.24922-7-cmr@codefail.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200827052659.24922-1-cmr@codefail.de>
References: <20200827052659.24922-1-cmr@codefail.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
X-Originating-IP: 198.54.122.47
X-SpamExperts-Domain: o3.privateemail.com
X-SpamExperts-Username: out-03
Authentication-Results: registrar-servers.com; auth=pass (plain) smtp.auth=out-03@o3.privateemail.com
X-SpamExperts-Outgoing-Class: ham
X-SpamExperts-Outgoing-Evidence: SB/global_tokens (0.000585059256087)
X-Recommended-Action: accept
X-Filter-ID: Mvzo4OR0dZXEDF/gcnlw0fJi3Ojdyt5h9PLOIGvr3lipSDasLI4SayDByyq9LIhVXNNxSVjR90Xn
 MyPKk7P6/ETNWdUk1Ol2OGx3IfrIJKyP9eGNFz9TW9u+Jt8z2T3Kq02yUY2BU41HLqp9U+7si8M8
 LdvJpZ7k99Lvu8YZXeI6p5bbhGYzvfahQ7X4A9L0Ye/JicEYVQv1wTfnWwJUGLoHT+TiZ2cHCmVO
 a6Hj9oiE0WSLndgNEtBdBgcB1mbTJODXbtOodkPED+RkHjVGH2xZ/WG2ZLv5RT/cF5Q6687AHRjU
 JmjnvGEokRBTZJpViFKfD1jKgYfH+6S5qDVYoJU2GVfilQJSaX7ehrnJEB/bhw3Crbac1ieeuRax
 ITFpzO11BRKqT8B4uLrn7iz8uvLBMzbIQcSG8L0jOzL80Q1MxDcqDeEvahfPkDkTlH91LgaQnmF8
 H6pa6B8MTK1ligAJ9G0GMvMSOAhk0taEj8weJNI+C0vMCMVtmGEXbiaCRPGqg4v6OwYy/yt5Cj+T
 3txbXpCgbiKBsA+Ddi6maweYdUirBly/K12a4uqqibUj/dHBojDbLVZkEx6TcwTT039q0aZI3qbh
 XsaDdLgW9brs8lq6YeUVTmb2st+aVE9JYOaeuiH/yEdZH8S1+TgcJBOjh0vPxcQOjKKOrYIQYpwa
 mUdylUIKhf3z2GAHxH7IMNrut00GZ5qvF8IF7tMR72KEsztVVBDOPEFKS2UxZBa4usXI0/RRtkWs
 roL69if1wov2GavqJ07j7hZY8mVbefiuK2KN35hXmy7nXQ2QuBuxX4OQOI/UQ6jnFfMBgzwOw1To
 H/cUtROfGg27pVfRPjU3fSpvtX7kDRT+AqQr2T3rxJw/s9JEmzH0m3M+UGtqNj9Evvd+SsDHzFys
 9Dg+KBYtnE0AZFYX5uoEURkdF/pDPDo3pDJlUlQ25PasjIMI9uAIvgWsH+Wq0zDLDi3S8euO5TcD
 eKjrEmYPn2IVWRsZR6NeDQwp7lDA8K9tDm+p97/T4LRRVYxF+VXiiOfHJN40eTXlWiUAYdLmsJdA
 oPKCpWwKtkkGG+bEnfOEkWTNI3SjTCvjMfNBc9ze9o81pXKSQ+GI7QB7PH97h6/L6Wb57LVs51cV
 C2TOjdXlLnr1FFwa8AyQYqjO7qYtiXb+9Q==
X-Report-Abuse-To: spam@se5.registrar-servers.com

Currently, code patching a STRICT_KERNEL_RWX exposes the temporary
mappings to other CPUs. These mappings should be kept local to the CPU
doing the patching. Use the pre-initialized temporary mm and patching
address for this purpose. Also add a check after patching to ensure the
patch succeeded.

Toggle KUAP on non-radix MMU platforms when patching since the temporary
mapping for patching uses a userspace address. With a radix MMU this is
not required since mapping a page with PAGE_KERNEL sets EAA[0] for the
PTE which means the AMR (KUAP) protection is ignored (see PowerISA
v3.0b, Fig. 35).

Based on x86 implementation:

commit b3fd8e83ada0
("x86/alternatives: Use temporary mm for text poking")

Signed-off-by: Christopher M. Riedl <cmr@codefail.de>
---
 arch/powerpc/lib/code-patching.c | 153 +++++++++++--------------------
 1 file changed, 54 insertions(+), 99 deletions(-)

diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
index 051d7ae6d8ee..9fb098680da8 100644
--- a/arch/powerpc/lib/code-patching.c
+++ b/arch/powerpc/lib/code-patching.c
@@ -149,113 +149,64 @@ void __init poking_init(void)
 	pte_unmap_unlock(ptep, ptl);
 }
 
-static DEFINE_PER_CPU(struct vm_struct *, text_poke_area);
-
 #ifdef CONFIG_LKDTM
 unsigned long read_cpu_patching_addr(unsigned int cpu)
 {
-	return (unsigned long)(per_cpu(text_poke_area, cpu))->addr;
+	return patching_addr;
 }
 #endif
 
-static int text_area_cpu_up(unsigned int cpu)
-{
-	struct vm_struct *area;
-
-	area = get_vm_area(PAGE_SIZE, VM_ALLOC);
-	if (!area) {
-		WARN_ONCE(1, "Failed to create text area for cpu %d\n",
-			cpu);
-		return -1;
-	}
-	this_cpu_write(text_poke_area, area);
-
-	return 0;
-}
-
-static int text_area_cpu_down(unsigned int cpu)
-{
-	free_vm_area(this_cpu_read(text_poke_area));
-	return 0;
-}
-
-/*
- * Run as a late init call. This allows all the boot time patching to be done
- * simply by patching the code, and then we're called here prior to
- * mark_rodata_ro(), which happens after all init calls are run. Although
- * BUG_ON() is rude, in this case it should only happen if ENOMEM, and we judge
- * it as being preferable to a kernel that will crash later when someone tries
- * to use patch_instruction().
- */
-static int __init setup_text_poke_area(void)
-{
-	BUG_ON(!cpuhp_setup_state(CPUHP_AP_ONLINE_DYN,
-		"powerpc/text_poke:online", text_area_cpu_up,
-		text_area_cpu_down));
-
-	return 0;
-}
-late_initcall(setup_text_poke_area);
+struct patch_mapping {
+	spinlock_t *ptl; /* for protecting pte table */
+	pte_t *ptep;
+	struct temp_mm temp_mm;
+};
 
 /*
  * This can be called for kernel text or a module.
  */
-static int map_patch_area(void *addr, unsigned long text_poke_addr)
+static int map_patch(const void *addr, struct patch_mapping *patch_mapping)
 {
-	unsigned long pfn;
-	int err;
+	struct page *page;
+	pte_t pte;
+	pgprot_t pgprot;
 
 	if (is_vmalloc_or_module_addr(addr))
-		pfn = vmalloc_to_pfn(addr);
+		page = vmalloc_to_page(addr);
 	else
-		pfn = __pa_symbol(addr) >> PAGE_SHIFT;
+		page = virt_to_page(addr);
 
-	err = map_kernel_page(text_poke_addr, (pfn << PAGE_SHIFT), PAGE_KERNEL);
+	if (radix_enabled())
+		pgprot = PAGE_KERNEL;
+	else
+		pgprot = PAGE_SHARED;
 
-	pr_devel("Mapped addr %lx with pfn %lx:%d\n", text_poke_addr, pfn, err);
-	if (err)
+	patch_mapping->ptep = get_locked_pte(patching_mm, patching_addr,
+					     &patch_mapping->ptl);
+	if (unlikely(!patch_mapping->ptep)) {
+		pr_warn("map patch: failed to allocate pte for patching\n");
 		return -1;
+	}
+
+	pte = mk_pte(page, pgprot);
+	pte = pte_mkdirty(pte);
+	set_pte_at(patching_mm, patching_addr, patch_mapping->ptep, pte);
+
+	init_temp_mm(&patch_mapping->temp_mm, patching_mm);
+	use_temporary_mm(&patch_mapping->temp_mm);
 
 	return 0;
 }
 
-static inline int unmap_patch_area(unsigned long addr)
+static void unmap_patch(struct patch_mapping *patch_mapping)
 {
-	pte_t *ptep;
-	pmd_t *pmdp;
-	pud_t *pudp;
-	p4d_t *p4dp;
-	pgd_t *pgdp;
-
-	pgdp = pgd_offset_k(addr);
-	if (unlikely(!pgdp))
-		return -EINVAL;
-
-	p4dp = p4d_offset(pgdp, addr);
-	if (unlikely(!p4dp))
-		return -EINVAL;
-
-	pudp = pud_offset(p4dp, addr);
-	if (unlikely(!pudp))
-		return -EINVAL;
-
-	pmdp = pmd_offset(pudp, addr);
-	if (unlikely(!pmdp))
-		return -EINVAL;
+	/* In hash, pte_clear flushes the tlb */
+	pte_clear(patching_mm, patching_addr, patch_mapping->ptep);
+	unuse_temporary_mm(&patch_mapping->temp_mm);
 
-	ptep = pte_offset_kernel(pmdp, addr);
-	if (unlikely(!ptep))
-		return -EINVAL;
-
-	pr_devel("clearing mm %p, pte %p, addr %lx\n", &init_mm, ptep, addr);
-
-	/*
-	 * In hash, pte_clear flushes the tlb, in radix, we have to
-	 */
-	pte_clear(&init_mm, addr, ptep);
-	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
-
-	return 0;
+	/* In radix, we have to explicitly flush the tlb (no-op in hash) */
+	local_flush_tlb_mm(patching_mm);
+	pte_unmap_unlock(patch_mapping->ptep, patch_mapping->ptl);
 }
 
 static int do_patch_instruction(struct ppc_inst *addr, struct ppc_inst instr)
@@ -263,32 +214,36 @@ static int do_patch_instruction(struct ppc_inst *addr, struct ppc_inst instr)
 	int err;
 	struct ppc_inst *patch_addr = NULL;
 	unsigned long flags;
-	unsigned long text_poke_addr;
-	unsigned long kaddr = (unsigned long)addr;
+	struct patch_mapping patch_mapping;
 
 	/*
-	 * During early early boot patch_instruction is called
-	 * when text_poke_area is not ready, but we still need
-	 * to allow patching. We just do the plain old patching
+	 * The patching_mm is initialized before calling mark_rodata_ro. Prior
+	 * to this, patch_instruction is called when we don't have (and don't
+	 * need) the patching_mm so just do plain old patching.
 	 */
-	if (!this_cpu_read(text_poke_area))
+	if (!patching_mm)
 		return raw_patch_instruction(addr, instr);
 
 	local_irq_save(flags);
 
-	text_poke_addr = (unsigned long)__this_cpu_read(text_poke_area)->addr;
-	if (map_patch_area(addr, text_poke_addr)) {
-		err = -1;
+	err = map_patch(addr, &patch_mapping);
+	if (err)
 		goto out;
-	}
 
-	patch_addr = (struct ppc_inst *)(text_poke_addr + (kaddr & ~PAGE_MASK));
+	patch_addr = (struct ppc_inst *)(patching_addr | offset_in_page(addr));
 
-	__patch_instruction(addr, instr, patch_addr);
+	if (!radix_enabled())
+		allow_write_to_user(patch_addr, ppc_inst_len(instr));
+	err = __patch_instruction(addr, instr, patch_addr);
+	if (!radix_enabled())
+		prevent_write_to_user(patch_addr, ppc_inst_len(instr));
 
-	err = unmap_patch_area(text_poke_addr);
-	if (err)
-		pr_warn("failed to unmap %lx\n", text_poke_addr);
+	unmap_patch(&patch_mapping);
+	/*
+	 * Something is wrong if what we just wrote doesn't match what we
+	 * think we just wrote.
+	 */
+	WARN_ON(!ppc_inst_equal(ppc_inst_read(addr), instr));
 
 out:
 	local_irq_restore(flags);
-- 
2.28.0

