From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Mon, 11 Sep 2017 21:50:21 +0200
Message-Id: <1505159427-11747-4-git-send-email-s.mesoraca16@gmail.com>
In-Reply-To: <1505159427-11747-1-git-send-email-s.mesoraca16@gmail.com>
References: <1505159427-11747-1-git-send-email-s.mesoraca16@gmail.com>
Subject: [kernel-hardening] [RFC v3 3/9] Creation of "check_vmflags" LSM hook
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, Salvatore Mesoraca <s.mesoraca16@gmail.com>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey@schaufler-ca.com>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>
List-ID: <kernel-hardening.lists.openwall.com>

Creation of a new LSM hook to check if a given configuration of vmflags,
for a new memory allocation request, should be allowed or not.
It's placed in "do_mmap", "do_brk_flags" and "__install_special_mapping".

Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
---
 include/linux/lsm_hooks.h |  7 +++++++
 include/linux/security.h  |  6 ++++++
 mm/mmap.c                 | 13 +++++++++++++
 security/security.c       |  5 +++++
 4 files changed, 31 insertions(+)

diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index c5a0322..2fb5c51f 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -484,6 +484,11 @@
  *	@reqprot contains the protection requested by the application.
  *	@prot contains the protection that will be applied by the kernel.
  *	Return 0 if permission is granted.
+ * @check_vmflags:
+ *	Check if the requested @vmflags are allowed.
+ *	@vmflags contains the requested vmflags.
+ *	Return 0 if the operation is allowed to continue otherwise return
+ *	the appropriate error code.
  * @file_lock:
  *	Check permission before performing file locking operations.
  *	Note: this hook mediates both flock and fcntl style locks.
@@ -1496,6 +1501,7 @@
 				unsigned long prot, unsigned long flags);
 	int (*file_mprotect)(struct vm_area_struct *vma, unsigned long reqprot,
 				unsigned long prot);
+	int (*check_vmflags)(vm_flags_t vmflags);
 	int (*file_lock)(struct file *file, unsigned int cmd);
 	int (*file_fcntl)(struct file *file, unsigned int cmd,
 				unsigned long arg);
@@ -1773,6 +1779,7 @@ struct security_hook_heads {
 	struct list_head mmap_addr;
 	struct list_head mmap_file;
 	struct list_head file_mprotect;
+	struct list_head check_vmflags;
 	struct list_head file_lock;
 	struct list_head file_fcntl;
 	struct list_head file_set_fowner;
diff --git a/include/linux/security.h b/include/linux/security.h
index 974bb9b..59840a5 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -309,6 +309,7 @@ int security_mmap_file(struct file *file, unsigned long prot,
 int security_mmap_addr(unsigned long addr);
 int security_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
 			   unsigned long prot);
+int security_check_vmflags(vm_flags_t vmflags);
 int security_file_lock(struct file *file, unsigned int cmd);
 int security_file_fcntl(struct file *file, unsigned int cmd, unsigned long arg);
 void security_file_set_fowner(struct file *file);
@@ -844,6 +845,11 @@ static inline int security_file_mprotect(struct vm_area_struct *vma,
 	return 0;
 }
 
+static inline int security_check_vmflags(vm_flags_t vmflags)
+{
+	return 0;
+}
+
 static inline int security_file_lock(struct file *file, unsigned int cmd)
 {
 	return 0;
diff --git a/mm/mmap.c b/mm/mmap.c
index 680506f..44bb1a3 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1326,6 +1326,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 {
 	struct mm_struct *mm = current->mm;
 	int pkey = 0;
+	int error;
 
 	*populate = 0;
 
@@ -1378,6 +1379,10 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 	vm_flags |= calc_vm_prot_bits(prot, pkey) | calc_vm_flag_bits(flags) |
 			mm->def_flags | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC;
 
+	error = security_check_vmflags(vm_flags);
+	if (error)
+		return error;
+
 	if (flags & MAP_LOCKED)
 		if (!can_do_mlock())
 			return -EPERM;
@@ -2873,6 +2878,10 @@ static int do_brk_flags(unsigned long addr, unsigned long request, unsigned long
 		return -EINVAL;
 	flags |= VM_DATA_DEFAULT_FLAGS | VM_ACCOUNT | mm->def_flags;
 
+	error = security_check_vmflags(flags);
+	if (error)
+		return error;
+
 	error = get_unmapped_area(NULL, addr, len, 0, MAP_FIXED);
 	if (offset_in_page(error))
 		return error;
@@ -3269,6 +3278,10 @@ static struct vm_area_struct *__install_special_mapping(
 	int ret;
 	struct vm_area_struct *vma;
 
+	ret = security_check_vmflags(vm_flags);
+	if (ret)
+		return ERR_PTR(ret);
+
 	vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
 	if (unlikely(vma == NULL))
 		return ERR_PTR(-ENOMEM);
diff --git a/security/security.c b/security/security.c
index d482e3d..484143f 100644
--- a/security/security.c
+++ b/security/security.c
@@ -938,6 +938,11 @@ int security_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
 	return call_int_hook(file_mprotect, 0, vma, reqprot, prot);
 }
 
+int security_check_vmflags(vm_flags_t vmflags)
+{
+	return call_int_hook(check_vmflags, 0, vmflags);
+}
+
 int security_file_lock(struct file *file, unsigned int cmd)
 {
 	return call_int_hook(file_lock, 0, file, cmd);
-- 
1.9.1
