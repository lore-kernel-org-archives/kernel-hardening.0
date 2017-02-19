From: Hoeun Ryu <hoeun.ryu@gmail.com>
Date: Sun, 19 Feb 2017 19:04:10 +0900
Message-Id: <1487498660-16600-7-git-send-email-hoeun.ryu@gmail.com>
In-Reply-To: <1487498660-16600-1-git-send-email-hoeun.ryu@gmail.com>
References: <1487498660-16600-1-git-send-email-hoeun.ryu@gmail.com>
Subject: [kernel-hardening] [RFC 7/7] arm64: map seperately rodata sections for __ro_mostly_after_init section
To: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Cc: Hoeun Ryu <hoeun.ryu@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Laura Abbott <labbott@redhat.com>, Kefeng Wang <wangkefeng.wang@huawei.com>, Jeremy Linton <jeremy.linton@arm.com>, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

Map rodata sections seperately for the new __ro_mostly_after_init section.
Attribute of memory for __ro_mostly_after_init section can be changed later
so we need a dedicated vmalloced region for set_memory_rw/ro api.

Signed-off-by: Hoeun Ryu <hoeun.ryu@gmail.com>
---
 arch/arm64/mm/mmu.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 91271b1..4a89a2e 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -434,8 +434,22 @@ void mark_rodata_ro(void)
 	 * mark .rodata as read only. Use __init_begin rather than __end_rodata
 	 * to cover NOTES and EXCEPTION_TABLE.
 	 */
-	section_size = (unsigned long)__init_begin - (unsigned long)__start_rodata;
-	create_mapping_late(__pa_symbol(__start_rodata), (unsigned long)__start_rodata,
+	section_size = (unsigned long)__start_data_ro_mostly_after_init -
+		(unsigned long)__start_rodata;
+	create_mapping_late(__pa_symbol(__start_rodata),
+			    (unsigned long)__start_rodata,
+			    section_size, PAGE_KERNEL_RO);
+
+	section_size = (unsigned long)__end_data_ro_mostly_after_init -
+		(unsigned long)__start_data_ro_mostly_after_init;
+	create_mapping_late(__pa_symbol(__start_data_ro_mostly_after_init),
+			    (unsigned long)__start_data_ro_mostly_after_init,
+			    section_size, PAGE_KERNEL_RO);
+
+	section_size = (unsigned long)__init_begin -
+		(unsigned long)__end_data_ro_mostly_after_init;
+	create_mapping_late(__pa_symbol(__end_data_ro_mostly_after_init),
+			    (unsigned long)__end_data_ro_mostly_after_init,
 			    section_size, PAGE_KERNEL_RO);
 
 	/* flush the TLBs after updating live kernel mappings */
@@ -478,10 +492,18 @@ static void __init map_kernel_segment(pgd_t *pgd, void *va_start, void *va_end,
  */
 static void __init map_kernel(pgd_t *pgd)
 {
-	static struct vm_struct vmlinux_text, vmlinux_rodata, vmlinux_init, vmlinux_data;
+	static struct vm_struct vmlinux_text, vmlinux_rodata1, vmlinux_rodata2, vmlinux_ro_mostly_after_init, vmlinux_init, vmlinux_data;
 
 	map_kernel_segment(pgd, _text, _etext, PAGE_KERNEL_EXEC, &vmlinux_text);
-	map_kernel_segment(pgd, __start_rodata, __init_begin, PAGE_KERNEL, &vmlinux_rodata);
+	map_kernel_segment(pgd, __start_rodata, __start_data_ro_mostly_after_init, PAGE_KERNEL, &vmlinux_rodata1);
+	__map_kernel_segment(pgd,
+			     __start_data_ro_mostly_after_init,
+			     __end_data_ro_mostly_after_init,
+			     PAGE_KERNEL,
+			     &vmlinux_ro_mostly_after_init,
+			     VM_MAP | VM_ALLOC);
+	map_kernel_segment(pgd, __end_data_ro_mostly_after_init, __init_begin, PAGE_KERNEL, &vmlinux_rodata2);
+
 	map_kernel_segment(pgd, __init_begin, __init_end, PAGE_KERNEL_EXEC,
 			   &vmlinux_init);
 	map_kernel_segment(pgd, _data, _end, PAGE_KERNEL, &vmlinux_data);
-- 
2.7.4
