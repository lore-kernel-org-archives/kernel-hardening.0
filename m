From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Mon, 12 Jun 2017 18:57:00 +0200
Message-Id: <1497286620-15027-12-git-send-email-s.mesoraca16@gmail.com>
In-Reply-To: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com>
References: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com>
Subject: [kernel-hardening] [PATCH 11/11] S.A.R.A. WX Protection procattr interface
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, Salvatore Mesoraca <s.mesoraca16@gmail.com>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey@schaufler-ca.com>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>
List-ID: <kernel-hardening.lists.openwall.com>

This allow processes to get current WX Protection flags for themselves or
for other processes of the same user.
It also allow a process to set itself flags to a stricter set of rules than
the current one.
Via a new wxprot flag (SARA_WXP_FORCE_WXORX) is it possible to ask the
kernel to rescan the process memory and remove the VM_WRITE flag from any
area that is marked both writable and executable.
Protections that prevent the runtime creation of executable code
can be troublesome for all those programs that actually need to do it
e.g. programs shipping with a JIT compiler built-in.
Given that it's possible to segregate the part that runs untrusted
code from the rest through a fork, this feature can be use to run the JIT
compiler with few restrictions while enforcing full WX Protection in the
rest of the program.
To simplify access to this interface a CC0 licensed library is available
here: https://github.com/smeso/saralib

Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
---
 security/sara/wxprot.c | 123 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 123 insertions(+)

diff --git a/security/sara/wxprot.c b/security/sara/wxprot.c
index 44e42be..00cd22c 100644
--- a/security/sara/wxprot.c
+++ b/security/sara/wxprot.c
@@ -40,6 +40,7 @@
 #define SARA_WXP_COMPLAIN	0x0010
 #define SARA_WXP_VERBOSE	0x0020
 #define SARA_WXP_MMAP		0x0040
+#define SARA_WXP_FORCE_WXORX	0x0080
 #define SARA_WXP_EMUTRAMP	0x0100
 #define SARA_WXP_TRANSFER	0x0200
 #define SARA_WXP_NONE		0x0000
@@ -496,6 +497,126 @@ static inline int sara_pagefault_handler_x86_64(struct pt_regs *regs)
 
 #endif /* CONFIG_SECURITY_SARA_WXPROT_EMUTRAMP */
 
+static int sara_getprocattr(struct task_struct *p, char *name, char **value)
+{
+	int ret;
+	u16 flags;
+	char *buf;
+
+	ret = -EINVAL;
+	if (strcmp(name, "wxprot") != 0)
+		goto out;
+
+	ret = -EACCES;
+	if (unlikely(current != p &&
+		     current_euid().val))
+		goto out;
+
+	ret = -ENOMEM;
+	buf = kzalloc(8, GFP_KERNEL);
+	if (unlikely(buf == NULL))
+		goto out;
+
+	if (!sara_enabled || !wxprot_enabled) {
+		flags = 0x0;
+	} else {
+		rcu_read_lock();
+		flags = get_sara_wxp_flags(__task_cred(p));
+		rcu_read_unlock();
+	}
+
+	snprintf(buf, 8, "0x%04x\n", flags);
+	ret = strlen(buf);
+	*value = buf;
+
+out:
+	return ret;
+}
+
+static int sara_setprocattr(const char *name, void *value, size_t size)
+{
+	int ret;
+	struct vm_area_struct *vma;
+	struct cred *new = prepare_creds();
+	u16 cur_flags;
+	u16 req_flags;
+	char *buf = NULL;
+
+	ret = -EINVAL;
+	if (!sara_enabled || !wxprot_enabled)
+		goto error;
+	if (unlikely(new == NULL))
+		return -ENOMEM;
+	if (strcmp(name, "wxprot") != 0)
+		goto error;
+	if (unlikely(value == NULL || size == 0 || size > 7))
+		goto error;
+	ret = -ENOMEM;
+	buf = kmalloc(size+1, GFP_KERNEL);
+	if (unlikely(buf == NULL))
+		goto error;
+	buf[size] = '\0';
+	memcpy(buf, value, size);
+	ret = -EINVAL;
+	if (unlikely(strlen(buf) != size))
+		goto error;
+	if (unlikely(kstrtou16(buf, 16, &req_flags) != 0))
+		goto error;
+	if (unlikely(!are_flags_valid(req_flags & ~SARA_WXP_FORCE_WXORX)))
+		goto error;
+	if (unlikely(req_flags & SARA_WXP_FORCE_WXORX &&
+		     !(req_flags & SARA_WXP_WXORX)))
+		goto error;
+	if (unlikely(!get_current_sara_relro_page_found() &&
+		     req_flags & SARA_WXP_MMAP))
+		goto error;
+	cur_flags = get_current_sara_wxp_flags();
+	if (unlikely((req_flags & SARA_WXP_COMPLAIN) &&
+		     !(cur_flags & SARA_WXP_COMPLAIN)))
+		goto error;
+	if (unlikely((req_flags & SARA_WXP_EMUTRAMP) &&
+		     !(cur_flags & SARA_WXP_EMUTRAMP) &&
+		     (cur_flags & (SARA_WXP_MPROTECT |
+				   SARA_WXP_WXORX))))
+		goto error;
+	if (cur_flags & SARA_WXP_VERBOSE)
+		req_flags |= SARA_WXP_VERBOSE;
+	else
+		req_flags &= ~SARA_WXP_VERBOSE;
+	if (unlikely(cur_flags & (req_flags ^ cur_flags) &
+		     ~(SARA_WXP_COMPLAIN|SARA_WXP_EMUTRAMP)))
+		goto error;
+	ret = -EINTR;
+	if (req_flags & SARA_WXP_FORCE_WXORX) {
+		if (down_write_killable(&current->mm->mmap_sem))
+			goto error;
+		for (vma = current->mm->mmap; vma; vma = vma->vm_next) {
+			if (vma->vm_flags & VM_EXEC &&
+			    vma->vm_flags & VM_WRITE) {
+				vma->vm_flags &= ~VM_WRITE;
+				vma_set_page_prot(vma);
+				change_protection(vma,
+						  vma->vm_start,
+						  vma->vm_end,
+						  vma->vm_page_prot,
+						  0,
+						  0);
+			}
+		}
+		up_write(&current->mm->mmap_sem);
+	}
+	get_sara_wxp_flags(new) = req_flags & ~SARA_WXP_FORCE_WXORX;
+	commit_creds(new);
+	ret = size;
+	goto out;
+
+error:
+	abort_creds(new);
+out:
+	kfree(buf);
+	return ret;
+}
+
 static struct security_hook_list wxprot_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(bprm_set_creds, sara_bprm_set_creds),
 	LSM_HOOK_INIT(check_vmflags, sara_check_vmflags),
@@ -503,6 +624,8 @@ static inline int sara_pagefault_handler_x86_64(struct pt_regs *regs)
 #ifdef CONFIG_SECURITY_SARA_WXPROT_EMUTRAMP
 	LSM_HOOK_INIT(pagefault_handler_x86, sara_pagefault_handler_x86),
 #endif
+	LSM_HOOK_INIT(getprocattr, sara_getprocattr),
+	LSM_HOOK_INIT(setprocattr, sara_setprocattr),
 };
 
 struct binary_config_header {
-- 
1.9.1
