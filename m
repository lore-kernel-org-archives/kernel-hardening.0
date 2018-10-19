From: Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH v3 3/3] bpf: Add system wide BPF JIT limit
Date: Fri, 19 Oct 2018 13:47:23 -0700
Message-Id: <20181019204723.3903-4-rick.p.edgecombe@intel.com>
In-Reply-To: <20181019204723.3903-1-rick.p.edgecombe@intel.com>
References: <20181019204723.3903-1-rick.p.edgecombe@intel.com>
To: kernel-hardening@lists.openwall.com, daniel@iogearbox.net, keescook@chromium.org, catalin.marinas@arm.com, will.deacon@arm.com, davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org, arnd@arndb.de, jeyu@kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, jannh@google.com
Cc: kristen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, deneen.t.dock@intel.com, Rick Edgecombe <rick.p.edgecombe@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

In case of games played with multiple users, also add a system wide limit
(in bytes) for BPF JIT. The default intends to be big enough for 10000 BPF JIT
filters. This cannot help with the DOS in the case of
CONFIG_BPF_JIT_ALWAYS_ON, but it can help with DOS for module space and
with forcing a module to be loaded at a paticular address.

The limit can be set like this:
echo 5000000 > /proc/sys/net/core/bpf_jit_limit

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 include/linux/bpf.h        |  7 +++++++
 include/linux/filter.h     |  1 +
 kernel/bpf/core.c          | 22 +++++++++++++++++++++-
 kernel/bpf/inode.c         | 16 ++++++++++++++++
 net/core/sysctl_net_core.c |  7 +++++++
 5 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 523481a3471b..4d7b729a1fe7 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -827,4 +827,11 @@ extern const struct bpf_func_proto bpf_get_local_storage_proto;
 void bpf_user_rnd_init_once(void);
 u64 bpf_user_rnd_u32(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
 
+#ifndef MOD_BPF_LIMIT_DEFAULT
+/*
+ * Leave room for 10000 large eBPF filters as default.
+ */
+#define MOD_BPF_LIMIT_DEFAULT (5 * PAGE_SIZE * 10000)
+#endif
+
 #endif /* _LINUX_BPF_H */
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 6791a0ac0139..3e91ffc7962b 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -854,6 +854,7 @@ bpf_run_sk_reuseport(struct sock_reuseport *reuse, struct sock *sk,
 extern int bpf_jit_enable;
 extern int bpf_jit_harden;
 extern int bpf_jit_kallsyms;
+extern int bpf_jit_limit;
 
 typedef void (*bpf_jit_fill_hole_t)(void *area, unsigned int size);
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 3f5bf1af0826..12c20fa6f04b 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -369,6 +369,9 @@ void bpf_prog_kallsyms_del_all(struct bpf_prog *fp)
 int bpf_jit_enable   __read_mostly = IS_BUILTIN(CONFIG_BPF_JIT_ALWAYS_ON);
 int bpf_jit_harden   __read_mostly;
 int bpf_jit_kallsyms __read_mostly;
+int bpf_jit_limit __read_mostly;
+
+static atomic_long_t module_vm;
 
 static __always_inline void
 bpf_get_prog_addr_region(const struct bpf_prog *prog,
@@ -583,17 +586,31 @@ bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
 		     bpf_jit_fill_hole_t bpf_fill_ill_insns)
 {
 	struct bpf_binary_header *hdr;
-	unsigned int size, hole, start;
+	unsigned int size, hole, start, vpages;
 
 	/* Most of BPF filters are really small, but if some of them
 	 * fill a page, allow at least 128 extra bytes to insert a
 	 * random section of illegal instructions.
 	 */
 	size = round_up(proglen + sizeof(*hdr) + 128, PAGE_SIZE);
+
+	/* Size plus a guard page */
+	vpages = (PAGE_ALIGN(size) >> PAGE_SHIFT) + 1;
+
+	if (atomic_long_read(&module_vm) + vpages > bpf_jit_limit >> PAGE_SHIFT)
+		return NULL;
+
 	hdr = module_alloc(size);
 	if (hdr == NULL)
 		return NULL;
 
+	atomic_long_add(vpages, &module_vm);
+
+	if (atomic_long_read(&module_vm) > bpf_jit_limit >> PAGE_SHIFT) {
+		bpf_jit_binary_free(hdr);
+		return NULL;
+	}
+
 	/* Fill space with illegal/arch-dep instructions. */
 	bpf_fill_ill_insns(hdr, size);
 
@@ -610,7 +627,10 @@ bpf_jit_binary_alloc(unsigned int proglen, u8 **image_ptr,
 
 void bpf_jit_binary_free(struct bpf_binary_header *hdr)
 {
+	/* Size plus the guard page */
+	unsigned int vpages = hdr->pages + 1;
 	module_memfree(hdr);
+	atomic_long_sub(vpages, &module_vm);
 }
 
 /* This symbol is only overridden by archs that have different
diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 2ada5e21dfa6..d0a109733294 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -667,10 +667,26 @@ static struct file_system_type bpf_fs_type = {
 	.kill_sb	= kill_litter_super,
 };
 
+#ifdef CONFIG_BPF_JIT
+void set_bpf_jit_limit(void)
+{
+	bpf_jit_limit = MOD_BPF_LIMIT_DEFAULT;
+}
+#else
+void set_bpf_jit_limit(void)
+{
+}
+#endif
+
 static int __init bpf_init(void)
 {
 	int ret;
 
+	/*
+	 * Module space size can be non-compile time constant so set it here.
+	 */
+	set_bpf_jit_limit();
+
 	ret = sysfs_create_mount_point(fs_kobj, "bpf");
 	if (ret)
 		return ret;
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index b1a2c5e38530..6bdf4a3da2b2 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -396,6 +396,13 @@ static struct ctl_table net_core_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
+	{
+		.procname	= "bpf_jit_limit",
+		.data		= &bpf_jit_limit,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_dointvec,
+	},
 # endif
 #endif
 	{
-- 
2.17.1
