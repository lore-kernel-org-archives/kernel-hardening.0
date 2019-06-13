From: Yann Droneaud <ydroneaud@opteya.com>
Date: Thu, 13 Jun 2019 13:26:05 +0200
Message-Id: <42e5c3182c28b2e5c5d10fde340fd0cfcfac376f.1560423331.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1560423331.git.ydroneaud@opteya.com>
References: <cover.1560423331.git.ydroneaud@opteya.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 2/3] binfmt/elf: align AT_RANDOM array
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Alexey Dobriyan <adobriyan@gmail.com>, Yann Droneaud <ydroneaud@opteya.com>
List-ID: <kernel-hardening.lists.openwall.com>

Because AT_RANDOM array is put on stack after AT_PLATFORM and
AT_BASE_PLATFORM strings, it's aligned on a 1 byte boundary:

on x86:

  $ for i in 1 2 3 ; do LD_SHOW_AUXV=1 ./bin32 | grep AT_RANDOM ; done
  AT_RANDOM:            0xffb91ffb
  AT_RANDOM:            0xffcd60eb
  AT_RANDOM:            0xffd7d99b

on x86_64:

  $ for i in 1 2 3 ; do LD_SHOW_AUXV=1 ./bin64 | grep AT_RANDOM ; done
  AT_RANDOM:            0x7ffe3ce7d559
  AT_RANDOM:            0x7ffeb9ecd2b9
  AT_RANDOM:            0x7ffd37cebd49

Unlike AT_ENTROPY1 and AT_ENTROPY2, AT_ENTROPY, or AT_RANDOM1 and
AT_RANDOM2 proposals[1][2][3] which would be 32bits or 64bits integers,
kernel never promise AT_RANDOM array to be aligned[4].

But having a 16bytes array not aligned might not be optimal. Userspace
could benefit from an aligned array.

As the AT_PLATFORM and AT_BASE_PLATFORM are asciiz C strings, they don't
need to be aligned, thus they can be put after AT_RANDOM array.

As AT_RANDOM array is first put on stack, it's alignment should match
the one set by arch_align_stack().

[1] https://lore.kernel.org/lkml/4675C678.3080807@gentoo.org/
[2] https://lore.kernel.org/lkml/467948F5.3010709@gentoo.org/
[3] https://sourceware.org/ml/libc-alpha/2008-10/msg00013.html
[1] https://lore.kernel.org/lkml/20081003001616.GN10632@outflux.net/

Link: https://lore.kernel.org/lkml/cover.1560423331.git.ydroneaud@opteya.com
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 fs/binfmt_elf.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 87f0c8a21350..cfcc01fff4ae 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -219,6 +219,14 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 
 	p = arch_align_stack(p);
 
+	/*
+	 * Generate 16 random bytes for userspace PRNG seeding.
+	 */
+	get_random_bytes(k_rand_bytes, sizeof(k_rand_bytes));
+	u_rand_bytes = elf_stack_alloc(&p, sizeof(k_rand_bytes));
+	if (__copy_to_user(u_rand_bytes, k_rand_bytes, sizeof(k_rand_bytes)))
+		return -EFAULT;
+
 	/*
 	 * If this architecture has a platform capability string, copy it
 	 * to userspace.  In some cases (Sparc), this info is impossible
@@ -247,14 +255,6 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 			return -EFAULT;
 	}
 
-	/*
-	 * Generate 16 random bytes for userspace PRNG seeding.
-	 */
-	get_random_bytes(k_rand_bytes, sizeof(k_rand_bytes));
-	u_rand_bytes = elf_stack_alloc(&p, sizeof(k_rand_bytes));
-	if (__copy_to_user(u_rand_bytes, k_rand_bytes, sizeof(k_rand_bytes)))
-		return -EFAULT;
-
 	/* Create the ELF interpreter info */
 	elf_info = (elf_addr_t *)current->mm->saved_auxv;
 	/* update AT_VECTOR_SIZE_BASE if the number of NEW_AUX_ENT() changes */
-- 
2.21.0
