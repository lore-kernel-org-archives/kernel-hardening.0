Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 6 Aug 2016 21:41:28 +0200
From: Pavel Machek <pavel@denx.de>
Message-ID: <20160806194128.GA7153@amd>
References: <1470071280-78706-1-git-send-email-thgarnie@google.com>
 <1601227.1rWnhT6gJp@vostro.rjw.lan>
 <CAJcbSZFTA8v6KEdWZ9rj8qMQUREhpexExO0BxmaWBmW2_f2TxA@mail.gmail.com>
 <3091490.MoJzMOfeFu@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3091490.MoJzMOfeFu@vostro.rjw.lan>
Subject: [kernel-hardening] Re: [PATCH] x86/power/64: Do not refer to __PAGE_OFFSET from
 assembly code
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Thomas Garnier <thgarnie@google.com>, the arch/x86 maintainers <x86@kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi!

> > >> Is similar patch needed for i386?
> > >
> > > Yes, it is, in general, for i386 hibernation to work with ASLR.
> > >
> > > But it doesn't work with it for other reasons ATM, AFAICS.
> > >
> > > Unfortunately, I won't really have the time to take care of this any time
> > > soon.
> > >
> > 
> > KASLR memory randomization is only available for x64 right now. I plan
> > on porting to 32bit eventually and will test/adapt hibernation as part
> > of it.
> 
> Great to hear that, but you need to be aware that the i386 hibernate code has
> not been touched for a long time and it makes some heavy assumptions that
> are not made on x86-64.

Yes, we did pretty bad job keeping i386 and x86-64 in sync.

This should bring them closer together. (My original motivation was to
enable hibernation and resume using differnet kernel versions. That
worked. Merge with v4.7 changes was not trivial, but it still appears
to work, probably doing some stuff that is not neccessary on 32-bit.)

Signed-off-by: Pavel Machek <pavel@ucw.cz> (but cleanup before
applying :-))

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3a9add5..b5c48f1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2236,7 +2236,7 @@ menu "Power management and ACPI options"
 
 config ARCH_HIBERNATION_HEADER
 	def_bool y
-	depends on X86_64 && HIBERNATION
+	depends on HIBERNATION
 
 source "kernel/power/Kconfig"
 
diff --git a/arch/x86/include/asm/suspend_32.h b/arch/x86/include/asm/suspend_32.h
index 8e9dbe7..81c5bfc 100644
--- a/arch/x86/include/asm/suspend_32.h
+++ b/arch/x86/include/asm/suspend_32.h
@@ -25,4 +25,7 @@ struct saved_context {
 	unsigned long return_address;
 } __attribute__((packed));
 
+extern char core_restore_code;
+extern char restore_registers;
+
 #endif /* _ASM_X86_SUSPEND_32_H */
diff --git a/arch/x86/power/hibernate.c b/arch/x86/power/hibernate.c
new file mode 100644
index 0000000..c0b0572
--- /dev/null
+++ b/arch/x86/power/hibernate.c
@@ -0,0 +1,49 @@
+int reallocate_restore_code(void)
+{
+	relocated_restore_code = (void *)get_safe_page(GFP_ATOMIC);
+	if (!relocated_restore_code)
+		return -ENOMEM;
+	memcpy(relocated_restore_code, &core_restore_code,
+	       &restore_registers - &core_restore_code);
+	return 0;
+}
+
+struct restore_data_record {
+	unsigned long jump_address;
+	unsigned long jump_address_phys;
+	unsigned long cr3;
+	unsigned long magic;
+};
+
+/**
+ *	arch_hibernation_header_save - populate the architecture specific part
+ *		of a hibernation image header
+ *	@addr: address to save the data at
+ */
+int arch_hibernation_header_save(void *addr, unsigned int max_size)
+{
+	struct restore_data_record *rdr = addr;
+
+	if (max_size < sizeof(struct restore_data_record))
+		return -EOVERFLOW;
+	rdr->jump_address = (unsigned long)&restore_registers;
+	rdr->jump_address_phys = __pa_symbol(&restore_registers);
+	rdr->cr3 = restore_cr3;
+	rdr->magic = RESTORE_MAGIC;
+	return 0;
+}
+
+/**
+ *	arch_hibernation_header_restore - read the architecture specific data
+ *		from the hibernation image header
+ *	@addr: address to read the data from
+ */
+int arch_hibernation_header_restore(void *addr)
+{
+	struct restore_data_record *rdr = addr;
+
+	restore_jump_address = rdr->jump_address;
+	jump_address_phys = rdr->jump_address_phys;
+	restore_cr3 = rdr->cr3;
+	return (rdr->magic == RESTORE_MAGIC) ? 0 : -EINVAL;
+}
diff --git a/arch/x86/power/hibernate_32.c b/arch/x86/power/hibernate_32.c
index 9f14bd3..784e6c7 100644
--- a/arch/x86/power/hibernate_32.c
+++ b/arch/x86/power/hibernate_32.c
@@ -4,6 +4,7 @@
  * Distribute under GPLv2
  *
  * Copyright (c) 2006 Rafael J. Wysocki <rjw@sisk.pl>
+ * Copyright (c) 2015 Pavel Machek <pavel@ucw.cz>
  */
 
 #include <linux/gfp.h>
@@ -14,13 +15,30 @@
 #include <asm/pgtable.h>
 #include <asm/mmzone.h>
 #include <asm/sections.h>
+#include <asm/suspend.h>
+#include <asm/tlbflush.h>
 
 /* Defined in hibernate_asm_32.S */
 extern int restore_image(void);
 
+/*
+ * Address to jump to in the last phase of restore in order to get to the image
+ * kernel's text (this value is passed in the image header).
+ */
+unsigned long restore_jump_address __visible;
+unsigned long jump_address_phys;
+
+/*
+ * Value of the cr3 register from before the hibernation (this value is passed
+ * in the image header).
+ */
+unsigned long restore_cr3 __visible;
+
 /* Pointer to the temporary resume page tables */
 pgd_t *resume_pg_dir;
 
+void *relocated_restore_code __visible;
+
 /* The following three functions are based on the analogous code in
  * arch/x86/mm/init_32.c
  */
@@ -142,6 +160,9 @@ static inline void resume_init_first_level_page_table(pgd_t *pg_dir)
 #endif
 }
 
+#define RESTORE_MAGIC	0x1bea1e0UL
+#include "hibernate.c"
+
 int swsusp_arch_resume(void)
 {
 	int error;
@@ -155,6 +176,10 @@ int swsusp_arch_resume(void)
 	if (error)
 		return error;
 
+	error = reallocate_restore_code();
+	if (error)
+		return error;
+
 	/* We have got enough memory and from now on we cannot recover */
 	restore_image();
 	return 0;
diff --git a/arch/x86/power/hibernate_64.c b/arch/x86/power/hibernate_64.c
index f2b5e6a..8aea0a1 100644
--- a/arch/x86/power/hibernate_64.c
+++ b/arch/x86/power/hibernate_64.c
@@ -117,6 +117,9 @@ static int set_up_temporary_mappings(void)
 	return 0;
 }
 
+#define RESTORE_MAGIC	0x123456789ABCDEF0UL
+#include "hibernate.c"
+
 static int relocate_restore_code(void)
 {
 	pgd_t *pgd;
@@ -177,44 +180,3 @@ int pfn_is_nosave(unsigned long pfn)
 	return (pfn >= nosave_begin_pfn) && (pfn < nosave_end_pfn);
 }
 
-struct restore_data_record {
-	unsigned long jump_address;
-	unsigned long jump_address_phys;
-	unsigned long cr3;
-	unsigned long magic;
-};
-
-#define RESTORE_MAGIC	0x123456789ABCDEF0UL
-
-/**
- *	arch_hibernation_header_save - populate the architecture specific part
- *		of a hibernation image header
- *	@addr: address to save the data at
- */
-int arch_hibernation_header_save(void *addr, unsigned int max_size)
-{
-	struct restore_data_record *rdr = addr;
-
-	if (max_size < sizeof(struct restore_data_record))
-		return -EOVERFLOW;
-	rdr->jump_address = (unsigned long)&restore_registers;
-	rdr->jump_address_phys = __pa_symbol(&restore_registers);
-	rdr->cr3 = restore_cr3;
-	rdr->magic = RESTORE_MAGIC;
-	return 0;
-}
-
-/**
- *	arch_hibernation_header_restore - read the architecture specific data
- *		from the hibernation image header
- *	@addr: address to read the data from
- */
-int arch_hibernation_header_restore(void *addr)
-{
-	struct restore_data_record *rdr = addr;
-
-	restore_jump_address = rdr->jump_address;
-	jump_address_phys = rdr->jump_address_phys;
-	restore_cr3 = rdr->cr3;
-	return (rdr->magic == RESTORE_MAGIC) ? 0 : -EINVAL;
-}
diff --git a/arch/x86/power/hibernate_asm_32.S b/arch/x86/power/hibernate_asm_32.S
index 1d0fa0e..f7e62d3 100644
--- a/arch/x86/power/hibernate_asm_32.S
+++ b/arch/x86/power/hibernate_asm_32.S
@@ -1,5 +1,14 @@
 /*
- * This may not use any stack, nor any variable that is not "NoSave":
+ * Hibernation support for i386
+ *
+ * Distribute under GPLv2.
+ *
+ * Copyright 2007 Rafael J. Wysocki <rjw@sisk.pl>
+ * Copyright 2005 Andi Kleen <ak@suse.de>
+ * Copyright 2004, 2015 Pavel Machek <pavel@ucw.cz>
+ *
+ * swsusp_arch_resume must not use any stack or any nonlocal variables while
+ * copying pages:
  *
  * Its rewriting one kernel image with another. What is stack in "old"
  * image could very well be data page in "new" image, and overwriting
@@ -23,6 +32,10 @@ ENTRY(swsusp_arch_suspend)
 	pushfl
 	popl saved_context_eflags
 
+	/* save cr3 */
+	movl	%cr3, %eax
+	movl	%eax, restore_cr3
+
 	call swsusp_save
 	ret
 
@@ -38,9 +51,27 @@ ENTRY(restore_image)
 	movl	%cr3, %eax;  # flush TLB
 	movl	%eax, %cr3
 1:
+
+	/* prepare to jump to the image kernel */
+	movl	restore_jump_address, %eax
+	movl	restore_cr3, %ebx
+
+#if 0
+	FIXME
+	/* prepare to switch to temporary page tables */
+	movq    temp_level4_pgt(%rip), %rax
+	movq    mmu_cr4_features(%rip), %rbx
+#endif
+	
+	/* prepare to copy image data to their original locations */
 	movl	restore_pblist, %edx
+
+	/* jump to relocated restore code */
+	movl	relocated_restore_code, %ecx
+	jmpl	*%ecx
 	.p2align 4,,7
 
+ENTRY(core_restore_code)
 copy_loop:
 	testl	%edx, %edx
 	jz	done
@@ -48,7 +79,7 @@ copy_loop:
 	movl	pbe_address(%edx), %esi
 	movl	pbe_orig_address(%edx), %edi
 
-	movl	$1024, %ecx
+	movl	$(PAGE_SIZE >> 2), %ecx
 	rep
 	movsl
 
@@ -57,6 +88,20 @@ copy_loop:
 	.p2align 4,,7
 
 done:
+	/* jump to the restore_registers address from the image header */
+	jmpl	*%eax
+	/*
+	 * NOTE: This assumes that the boot kernel's text mapping covers the
+	 * image kernel's page containing restore_registers and the address of
+	 * this page is the same as in the image kernel's text mapping (it
+	 * should always be true, because the text mapping is linear, starting
+	 * from 0, and is supposed to cover the entire kernel text for every
+	 * kernel).
+	 *
+	 * code below belongs to the image kernel
+	 */
+
+ENTRY(restore_registers)
 	/* go back to the original page tables */
 	movl	$swapper_pg_dir, %eax
 	subl	$__PAGE_OFFSET, %eax
@@ -81,4 +126,7 @@ done:
 
 	xorl	%eax, %eax
 
+	/* tell the hibernation core that we've just restored the memory */
+	movl	%eax, in_suspend
+
 	ret
diff --git a/tools/testing/selftests/power/sleep b/tools/testing/selftests/power/sleep
new file mode 100755
index 0000000..277d59d
--- /dev/null
+++ b/tools/testing/selftests/power/sleep
@@ -0,0 +1,5 @@
+#!/bin/bash
+echo 0 > /sys/class/rtc/rtc0/wakealarm
+echo `date '+%s' -d '+ 1 minutes'` > /sys/class/rtc/rtc0/wakealarm
+echo mem > /sys/power/state
+




-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
