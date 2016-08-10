Reply-To: kernel-hardening@lists.openwall.com
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Date: Wed, 10 Aug 2016 02:21:18 +0200
Message-ID: <2010434.TyoHiO9eal@vostro.rjw.lan>
In-Reply-To: <CAJZ5v0hWRH0zVjNDH6cjNn8kSSXSW0qc-aQZ8p_5EVS3cajcQA@mail.gmail.com>
References: <2206547.eDj3RJQyE5@vostro.rjw.lan> <alpine.LNX.2.00.1608092119260.22028@cbobk.fhfr.pm> <CAJZ5v0hWRH0zVjNDH6cjNn8kSSXSW0qc-aQZ8p_5EVS3cajcQA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Subject: [kernel-hardening] Re: [Resend][PATCH] x86/power/64: Always create temporary identity mapping correctly
To: Jiri Kosina <jikos@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Thomas Garnier <thgarnie@google.com>, Linux PM list <linux-pm@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Pavel Machek <pavel@ucw.cz>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bpetkov@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tuesday, August 09, 2016 11:23:31 PM Rafael J. Wysocki wrote:
> On Tue, Aug 9, 2016 at 10:02 PM, Jiri Kosina <jikos@kernel.org> wrote:
> > On Tue, 9 Aug 2016, Rafael J. Wysocki wrote:
> >
> >> I have a murky suspicion, but it is really weird.  Namely, what if
> >> restore_jump_address in set_up_temporary_text_mapping() happens to be
> >> covered by the restore kernel's identity mapping?  Then, the image
> >> kernel's entry point may get overwritten by something else in
> >> core_restore_code().
> >
> > So this made me to actually test a scenario where I'd suspend a kernel
> > that's known-broken (i.e. contains 021182e52fe), and then have it resumed
> > by a kernel that has 021182e52fe reverted. It resumed successfully.
> >
> > Just a datapoint.
> 
> That indicates the problem is somewhere in the restore kernel and no
> surprises there.
> 
> I am able to reproduce the original problem (a triple fault on resume
> with CONFIG_RANDOMIZE_MEMORY set) without the $subject patch, but the
> patch fixes it for me.
> 
> Question is why it is not sufficient for you and Boris and the above
> theory is about the only one I can come up with ATM.
> 
> I'm going to compare the configs etc, but I guess I just end up
> writing a patch to test that theory unless someone has any other idea
> in the meantime.

For the lack of better ideas, below is a patch to try.

It avoids the possible issue with the restore kernel's identity mapping overlap
with restore_jump_address by creating special super-simple page tables just
for the final jump to the image kernel.

It is on top of the $subject patch.  My test box still works with this applied,
but then it worked without it as well.

If it doesn't help, the identity mapping created by set_up_temporary_mappings()
is still not adequate for some reason most likely and we'll need to find out
why.

Thanks,
Rafael


---
 arch/x86/power/hibernate_64.c     |   40 +++++++++++++++++++++++++++++++-------
 arch/x86/power/hibernate_asm_64.S |   10 +++++++++
 2 files changed, 43 insertions(+), 7 deletions(-)

Index: linux-pm/arch/x86/power/hibernate_64.c
===================================================================
--- linux-pm.orig/arch/x86/power/hibernate_64.c
+++ linux-pm/arch/x86/power/hibernate_64.c
@@ -38,14 +38,20 @@ unsigned long jump_address_phys;
 unsigned long restore_cr3 __visible;
 
 unsigned long temp_level4_pgt __visible;
+unsigned long jump_level4_pgt __visible;
 
 unsigned long relocated_restore_code __visible;
 
-static int set_up_temporary_text_mapping(pgd_t *pgd)
+static int set_up_temporary_text_mapping(void)
 {
+	pgd_t *pgd;
 	pmd_t *pmd;
 	pud_t *pud;
 
+	pgd = (pgd_t *)get_safe_page(GFP_ATOMIC);
+	if (!pgd)
+		return -ENOMEM;
+
 	/*
 	 * The new mapping only has to cover the page containing the image
 	 * kernel's entry point (jump_address_phys), because the switch over to
@@ -74,6 +80,23 @@ static int set_up_temporary_text_mapping
 	set_pgd(pgd + pgd_index(restore_jump_address),
 		__pgd(__pa(pud) | _KERNPG_TABLE));
 
+	pud = (pud_t *)get_safe_page(GFP_ATOMIC);
+	if (!pud)
+		return -ENOMEM;
+
+	pmd = (pmd_t *)get_safe_page(GFP_ATOMIC);
+	if (!pmd)
+		return -ENOMEM;
+
+	set_pmd(pmd + pmd_index(relocated_restore_code),
+		__pmd((__pa(relocated_restore_code) & PMD_MASK) | __PAGE_KERNEL_LARGE_EXEC));
+	set_pud(pud + pud_index(relocated_restore_code),
+		__pud(__pa(pmd) | _KERNPG_TABLE));
+	set_pgd(pgd + pgd_index(relocated_restore_code),
+		__pgd(__pa(pud) | _KERNPG_TABLE));
+
+	jump_level4_pgt = __pa(pgd);
+
 	return 0;
 }
 
@@ -98,11 +121,6 @@ static int set_up_temporary_mappings(voi
 	if (!pgd)
 		return -ENOMEM;
 
-	/* Prepare a temporary mapping for the kernel text */
-	result = set_up_temporary_text_mapping(pgd);
-	if (result)
-		return result;
-
 	/* Set up the direct mapping from scratch */
 	for (i = 0; i < nr_pfn_mapped; i++) {
 		mstart = pfn_mapped[i].start << PAGE_SHIFT;
@@ -122,7 +140,10 @@ static int relocate_restore_code(void)
 	pgd_t *pgd;
 	pud_t *pud;
 
-	relocated_restore_code = get_safe_page(GFP_ATOMIC);
+	do
+		relocated_restore_code = get_safe_page(GFP_ATOMIC);
+	while ((relocated_restore_code & PMD_MASK) == (restore_jump_address & PMD_MASK));
+
 	if (!relocated_restore_code)
 		return -ENOMEM;
 
@@ -162,6 +183,11 @@ int swsusp_arch_resume(void)
 	if (error)
 		return error;
 
+	/* Prepare a temporary mapping for the jump to the image kernel */
+	error = set_up_temporary_text_mapping();
+	if (error)
+		return error;
+
 	restore_image();
 	return 0;
 }
Index: linux-pm/arch/x86/power/hibernate_asm_64.S
===================================================================
--- linux-pm.orig/arch/x86/power/hibernate_asm_64.S
+++ linux-pm/arch/x86/power/hibernate_asm_64.S
@@ -57,6 +57,7 @@ ENTRY(restore_image)
 	/* prepare to jump to the image kernel */
 	movq	restore_jump_address(%rip), %r8
 	movq	restore_cr3(%rip), %r9
+	movq	jump_level4_pgt(%rip), %r10
 
 	/* prepare to switch to temporary page tables */
 	movq	temp_level4_pgt(%rip), %rax
@@ -96,6 +97,15 @@ ENTRY(core_restore_code)
 	jmp	.Lloop
 
 .Ldone:
+	/* switch to jump page tables */
+	movq	%r10, %cr3
+	/* flush TLB */
+	movq	%rbx, %rcx
+	andq	$~(X86_CR4_PGE), %rcx
+	movq	%rcx, %cr4;  # turn off PGE
+	movq	%cr3, %rcx;  # flush TLB
+	movq	%rcx, %cr3;
+	movq	%rbx, %cr4;  # turn PGE back on
 	/* jump to the restore_registers address from the image header */
 	jmpq	*%r8
 
