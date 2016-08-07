Reply-To: kernel-hardening@lists.openwall.com
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Date: Sun, 07 Aug 2016 03:03:26 +0200
Message-ID: <2213000.eZV9GAcFWG@vostro.rjw.lan>
In-Reply-To: <CAJZ5v0iOiLaox4CNnqRFXsY9N=+0oNfP0SD1kCNzhU1Xpxv1YA@mail.gmail.com>
References: <1470071280-78706-1-git-send-email-thgarnie@google.com> <20160803182308.19227-1-yinghai@kernel.org> <CAJZ5v0iOiLaox4CNnqRFXsY9N=+0oNfP0SD1kCNzhU1Xpxv1YA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Subject: [kernel-hardening] Re: [PATCH v2] x86/power/64: Support unaligned addresses for temporary mapping
To: Yinghai Lu <yinghai@kernel.org>, Thomas Garnier <thgarnie@google.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Pavel Machek <pavel@ucw.cz>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wednesday, August 03, 2016 11:28:48 PM Rafael J. Wysocki wrote:
> On Wed, Aug 3, 2016 at 8:23 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > From: Thomas Garnier <thgarnie@google.com>
> >
> > Correctly setup the temporary mapping for hibernation. Previous
> > implementation assumed the offset between KVA and PA was aligned on the PGD level.
> > With KASLR memory randomization enabled, the offset is randomized on the PUD
> > level. This change supports unaligned up to PMD.
> >
> > Signed-off-by: Thomas Garnier <thgarnie@google.com>
> > [yinghai: change loop to virtual address]
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

On a second thought, it seems to be better to follow your suggestion to simply
provide a special version of kernel_ident_mapping_init() for hibernation,
because it is sufficiently distinct from the other users of the code in
ident_map.c.

The patch below does just that (lightly tested).

Thomas, can you please test this one too?

Thanks,
Rafael


---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: [PATCH] x86/power/64: Always create temporary identity mapping correctly

The low-level resume-from-hibernation code on x86-64 uses
kernel_ident_mapping_init() to create the temoprary identity mapping,
but that function assumes that the offset between kernel virtual
addresses and physical addresses is aligned on the PGD level.

However, with a randomized identity mapping base, it may be aligned
on the PUD level and if that happens, the temporary identity mapping
created by set_up_temporary_mappings() will not reflect the actual
kernel identity mapping and the image restoration will fail as a
result (leading to a kernel panic most of the time).

To fix this problem, provide simplified routines for creating the
temporary identity mapping during resume from hibernation on x86-64
that support unaligned offsets between KVA and PA up to the PMD
level.

Although kernel_ident_mapping_init() might be made work in that
case too, using hibernation-specific code for that is way simpler.

Reported-by: Thomas Garnier <thgarnie@google.com>
Suggested-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 arch/x86/power/hibernate_64.c |   61 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 53 insertions(+), 8 deletions(-)

Index: linux-pm/arch/x86/power/hibernate_64.c
===================================================================
--- linux-pm.orig/arch/x86/power/hibernate_64.c
+++ linux-pm/arch/x86/power/hibernate_64.c
@@ -77,18 +77,63 @@ static int set_up_temporary_text_mapping
 	return 0;
 }
 
-static void *alloc_pgt_page(void *context)
+static void ident_pmd_init(pmd_t *pmd, unsigned long addr, unsigned long end)
 {
-	return (void *)get_safe_page(GFP_ATOMIC);
+	for (; addr < end; addr += PMD_SIZE)
+		set_pmd(pmd + pmd_index(addr),
+			__pmd((addr - __PAGE_OFFSET) | __PAGE_KERNEL_LARGE_EXEC));
+}
+
+static int ident_pud_init(pud_t *pud, unsigned long addr, unsigned long end)
+{
+	unsigned long next;
+
+	for (; addr < end; addr = next) {
+		pmd_t *pmd;
+
+		pmd = (pmd_t *)get_safe_page(GFP_ATOMIC);
+		if (!pmd)
+			return -ENOMEM;
+
+		next = (addr & PUD_MASK) + PUD_SIZE;
+		if (next > end)
+			next = end;
+
+		ident_pmd_init(pmd, addr & PMD_MASK, next);
+		set_pud(pud + pud_index(addr), __pud(__pa(pmd) | _KERNPG_TABLE));
+	}
+	return 0;
+}
+
+static int ident_mapping_init(pgd_t *pgd, unsigned long mstart, unsigned long mend)
+{
+	unsigned long addr = mstart + __PAGE_OFFSET;
+	unsigned long end = mend + __PAGE_OFFSET;
+	unsigned long next;
+
+	for (; addr < end; addr = next) {
+		pud_t *pud;
+		int result;
+
+		pud = (pud_t *)get_safe_page(GFP_ATOMIC);
+		if (!pud)
+			return -ENOMEM;
+
+		next = (addr & PGDIR_MASK) + PGDIR_SIZE;
+		if (next > end)
+			next = end;
+
+		result = ident_pud_init(pud, addr, next);
+		if (result)
+			return result;
+
+		set_pgd(pgd + pgd_index(addr), __pgd(__pa(pud) | _KERNPG_TABLE));
+	}
+	return 0;
 }
 
 static int set_up_temporary_mappings(void)
 {
-	struct x86_mapping_info info = {
-		.alloc_pgt_page	= alloc_pgt_page,
-		.pmd_flag	= __PAGE_KERNEL_LARGE_EXEC,
-		.kernel_mapping = true,
-	};
 	unsigned long mstart, mend;
 	pgd_t *pgd;
 	int result;
@@ -108,7 +153,7 @@ static int set_up_temporary_mappings(voi
 		mstart = pfn_mapped[i].start << PAGE_SHIFT;
 		mend   = pfn_mapped[i].end << PAGE_SHIFT;
 
-		result = kernel_ident_mapping_init(&info, pgd, mstart, mend);
+		result = ident_mapping_init(pgd, mstart, mend);
 		if (result)
 			return result;
 	}
