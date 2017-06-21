Date: Tue, 20 Jun 2017 22:58:35 -0700
From: Kees Cook <keescook@chromium.org>
Message-ID: <20170621055835.GA27467@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] [RFC] binfmt_elf: Use ELF_ET_DYN_BASE only for PIE
To: linux-kernel@vger.kernel.org
Cc: Rik van Riel <riel@redhat.com>, Daniel Micay <danielmicay@gmail.com>, Qualys Security Advisory <qsa@qualys.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dmitry Safonov <dsafonov@virtuozzo.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Grzegorz Andrejczuk <grzegorz.andrejczuk@intel.com>, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

The ELF_ET_DYN_BASE position was originally intended to keep loaders
away from ET_EXEC binaries. (For example, running "/lib/ld-linux.so.2
/bin/cat" might cause the subsequent load of /bin/cat into where the
loader had been loaded.) With the advent of PIE (ET_DYN binaries with
an INTERP Program Header), ELF_ET_DYN_BASE continued to be used since
the kernel was only looking at ET_DYN. However, since ELF_ET_DYN_BASE
is traditionally set at the top 1/3rd of the TASK_SIZE, a substantial
portion of the address space is unused.

For 32-bit tasks when RLIMIT_STACK is set to RLIM_INFINITY, programs
are loaded below the mmap region. This means they can be made to collide
(CVE-2017-1000370) or nearly collide (CVE-2017-1000371) with pathological
stack regions. Lowering ELF_ET_DYN_BASE solves both by moving programs
above the mmap region in all cases, and will now additionally avoid
programs falling back to the mmap region by enforcing MAP_FIXED for
program loads (i.e. if it would have collided with the stack, now it
will fail to load instead of falling back to the mmap region).

To allow for a lower ELF_ET_DYN_BASE, loaders (ET_DYN without INTERP)
are loaded into the mmap region, leaving space available for either an
ET_EXEC binary with a fixed location or PIE being loaded into mmap by the
loader. Only PIE programs are loaded offset from ELF_ET_DYN_BASE, which
means architectures can now safely lower their values without risk of
loaders colliding with their subsequently loaded programs.

Thanks go to PaX for inspiration on how to approach this solution.

Fixes: d1fd836dcf00 ("mm: split ET_DYN ASLR from mmap ASLR")
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/elf.h |  8 ++------
 fs/binfmt_elf.c            | 38 +++++++++++++++++++++++++++++++-------
 2 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index e8ab9a46bc68..46549973ea98 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -245,12 +245,8 @@ extern int force_personality32;
 #define CORE_DUMP_USE_REGSET
 #define ELF_EXEC_PAGESIZE	4096
 
-/* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
-   use of this is to invoke "./ld.so someprog" to test out a new version of
-   the loader.  We need to make sure that it is out of the way of the program
-   that it will "exec", and that there is sufficient room for the brk.  */
-
-#define ELF_ET_DYN_BASE		(TASK_SIZE / 3 * 2)
+/* This is the base location for PIE (ET_DYN with INTERP) loads. */
+#define ELF_ET_DYN_BASE		0x400000UL
 
 /* This yields a mask that user programs can use to figure out what
    instruction set this CPU supports.  This could be done in user space,
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 5075fd5c62c8..a998c7251d1c 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -930,13 +930,37 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		if (loc->elf_ex.e_type == ET_EXEC || load_addr_set) {
 			elf_flags |= MAP_FIXED;
 		} else if (loc->elf_ex.e_type == ET_DYN) {
-			/* Try and get dynamic programs out of the way of the
-			 * default mmap base, as well as whatever program they
-			 * might try to exec.  This is because the brk will
-			 * follow the loader, and is not movable.  */
-			load_bias = ELF_ET_DYN_BASE - vaddr;
-			if (current->flags & PF_RANDOMIZE)
-				load_bias += arch_mmap_rnd();
+			/*
+			 * There are effectively two types of ET_DYN
+			 * binaries: programs (i.e. PIE: ET_DYN with INTERP)
+			 * and loaders (ET_DYN without INTERP, since they
+			 * _are_ the ELF interpreter). The loaders must
+			 * be loaded away from programs since the program
+			 * may otherwise collide with the loader (especially
+			 * for ET_EXEC which does not have a randomized
+			 * position). For example to handle invocations of
+			 * "./ld.so someprog" to test out a new version of
+			 * the loader, the subsequent program that the
+			 * loader loads must avoid the loader itself, so
+			 * they cannot share the same load range. Sufficient
+			 * room for the brk must be allocated with the
+			 * loader as well, since brk must be available with
+			 * the loader.
+			 *
+			 * Therefore, programs are loaded offset from
+			 * ELF_ET_DYN_BASE and loaders are loaded into the
+			 * independently randomized mmap region (0 load_bias
+			 * without MAP_FIXED).
+			 */
+			if (elf_interpreter) {
+				load_bias = ELF_ET_DYN_BASE;
+				if (current->flags & PF_RANDOMIZE)
+					load_bias += arch_mmap_rnd();
+				elf_flags |= MAP_FIXED;
+			} else
+				load_bias = 0;
+
+			load_bias -= vaddr;
 			load_bias = ELF_PAGESTART(load_bias);
 			total_size = total_mapping_size(elf_phdata,
 							loc->elf_ex.e_phnum);
-- 
2.7.4


-- 
Kees Cook
Pixel Security
