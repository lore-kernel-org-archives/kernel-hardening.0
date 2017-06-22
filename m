Date: Thu, 22 Jun 2017 10:38:38 -0700
From: Kees Cook <keescook@chromium.org>
Message-ID: <20170622173838.GA43308@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] binfmt_elf: Safely increment argv pointers
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Daniel Micay <danielmicay@gmail.com>, Qualys Security Advisory <qsa@qualys.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dmitry Safonov <dsafonov@virtuozzo.com>, Andy Lutomirski <luto@amacapital.net>, Grzegorz Andrejczuk <grzegorz.andrejczuk@intel.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

When building the argv/envp pointers, the envp is needlessly
pre-incremented instead of just continuing after the argv pointers are
finished. In some (likely impossible) race where the strings could
be changed from userspace between copy_strings() and here, it might
be possible to confuse the envp position. Instead, just use sp like
everything else.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/binfmt_elf.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 7465c3ea5dd5..879ff9c7ffd0 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -163,8 +163,6 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	unsigned long p = bprm->p;
 	int argc = bprm->argc;
 	int envc = bprm->envc;
-	elf_addr_t __user *argv;
-	elf_addr_t __user *envp;
 	elf_addr_t __user *sp;
 	elf_addr_t __user *u_platform;
 	elf_addr_t __user *u_base_platform;
@@ -304,38 +302,38 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	/* Now, let's put argc (and argv, envp if appropriate) on the stack */
 	if (__put_user(argc, sp++))
 		return -EFAULT;
-	argv = sp;
-	envp = argv + argc + 1;
 
-	/* Populate argv and envp */
+	/* Populate list of argv pointers back to argv strings. */
 	p = current->mm->arg_end = current->mm->arg_start;
 	while (argc-- > 0) {
 		size_t len;
-		if (__put_user((elf_addr_t)p, argv++))
+		if (__put_user((elf_addr_t)p, sp++))
 			return -EFAULT;
 		len = strnlen_user((void __user *)p, MAX_ARG_STRLEN);
 		if (!len || len > MAX_ARG_STRLEN)
 			return -EINVAL;
 		p += len;
 	}
-	if (__put_user(0, argv))
+	if (__put_user(0, sp++))
 		return -EFAULT;
-	current->mm->arg_end = current->mm->env_start = p;
+	current->mm->arg_end = p;
+
+	/* Populate list of envp pointers back to envp strings. */
+	current->mm->env_end = current->mm->env_start = p;
 	while (envc-- > 0) {
 		size_t len;
-		if (__put_user((elf_addr_t)p, envp++))
+		if (__put_user((elf_addr_t)p, sp++))
 			return -EFAULT;
 		len = strnlen_user((void __user *)p, MAX_ARG_STRLEN);
 		if (!len || len > MAX_ARG_STRLEN)
 			return -EINVAL;
 		p += len;
 	}
-	if (__put_user(0, envp))
+	if (__put_user(0, sp++))
 		return -EFAULT;
 	current->mm->env_end = p;
 
 	/* Put the elf_info on the stack in the right place.  */
-	sp = (elf_addr_t __user *)envp + 1;
 	if (copy_to_user(sp, elf_info, ei_index * sizeof(elf_addr_t)))
 		return -EFAULT;
 	return 0;
-- 
2.7.4


-- 
Kees Cook
Pixel Security
