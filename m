From: Kees Cook <keescook@chromium.org>
Date: Fri, 26 May 2017 13:17:13 -0700
Message-Id: <1495829844-69341-10-git-send-email-keescook@chromium.org>
In-Reply-To: <1495829844-69341-1-git-send-email-keescook@chromium.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 09/20] randstruct: Mark various structs for randomization
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This marks many critical kernel structures for randomization. These are
structures that have been targeted in the past in security exploits, or
contain functions pointers, pointers to function pointer tables, lists,
workqueues, ref-counters, credentials, permissions, or are otherwise
sensitive. This initial list was extracted from grsecurity.

Left out of this list is task_struct, which requires special handling
and is covered in a subsequent patch.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/processor.h |  2 +-
 fs/mount.h                       |  4 ++--
 fs/namei.c                       |  2 +-
 fs/proc/internal.h               |  6 +++---
 include/linux/binfmts.h          |  4 ++--
 include/linux/cdev.h             |  2 +-
 include/linux/cred.h             |  4 ++--
 include/linux/dcache.h           |  2 +-
 include/linux/fs.h               | 17 +++++++++--------
 include/linux/fs_struct.h        |  2 +-
 include/linux/ipc.h              |  2 +-
 include/linux/ipc_namespace.h    |  2 +-
 include/linux/key-type.h         |  4 ++--
 include/linux/kmod.h             |  2 +-
 include/linux/kobject.h          |  2 +-
 include/linux/lsm_hooks.h        |  4 ++--
 include/linux/mm_types.h         |  4 ++--
 include/linux/module.h           |  4 ++--
 include/linux/mount.h            |  2 +-
 include/linux/msg.h              |  2 +-
 include/linux/path.h             |  2 +-
 include/linux/pid_namespace.h    |  2 +-
 include/linux/proc_ns.h          |  2 +-
 include/linux/sched.h            |  2 +-
 include/linux/sched/signal.h     |  2 +-
 include/linux/sem.h              |  2 +-
 include/linux/shm.h              |  2 +-
 include/linux/sysctl.h           |  2 +-
 include/linux/tty.h              |  2 +-
 include/linux/tty_driver.h       |  4 ++--
 include/linux/user_namespace.h   |  2 +-
 include/linux/utsname.h          |  2 +-
 include/net/af_unix.h            |  2 +-
 include/net/neighbour.h          |  2 +-
 include/net/net_namespace.h      |  2 +-
 include/net/sock.h               |  2 +-
 kernel/futex.c                   |  4 ++--
 security/keys/internal.h         |  2 +-
 38 files changed, 57 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 3cada998a402..e2335edb9fc5 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -129,7 +129,7 @@ struct cpuinfo_x86 {
 	/* Index into per_cpu list: */
 	u16			cpu_index;
 	u32			microcode;
-};
+} __randomize_layout;
 
 struct cpuid_regs {
 	u32 eax, ebx, ecx, edx;
diff --git a/fs/mount.h b/fs/mount.h
index de45d9e76748..6790767d1883 100644
--- a/fs/mount.h
+++ b/fs/mount.h
@@ -16,7 +16,7 @@ struct mnt_namespace {
 	u64 event;
 	unsigned int		mounts; /* # of mounts in the namespace */
 	unsigned int		pending_mounts;
-};
+} __randomize_layout;
 
 struct mnt_pcp {
 	int mnt_count;
@@ -69,7 +69,7 @@ struct mount {
 	struct hlist_head mnt_pins;
 	struct fs_pin mnt_umount;
 	struct dentry *mnt_ex_mountpoint;
-};
+} __randomize_layout;
 
 #define MNT_NS_INTERNAL ERR_PTR(-EINVAL) /* distinct from any mnt_namespace */
 
diff --git a/fs/namei.c b/fs/namei.c
index bbb9d01e70e7..9db9c5418d90 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -524,7 +524,7 @@ struct nameidata {
 	struct inode	*link_inode;
 	unsigned	root_seq;
 	int		dfd;
-};
+} __randomize_layout;
 
 static void set_nameidata(struct nameidata *p, int dfd, struct filename *name)
 {
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index c5ae09b6c726..07b16318223f 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -51,7 +51,7 @@ struct proc_dir_entry {
 	spinlock_t pde_unload_lock; /* proc_fops checks and pde_users bumps */
 	u8 namelen;
 	char name[];
-};
+} __randomize_layout;
 
 union proc_op {
 	int (*proc_get_link)(struct dentry *, struct path *);
@@ -70,7 +70,7 @@ struct proc_inode {
 	struct list_head sysctl_inodes;
 	const struct proc_ns_operations *ns_ops;
 	struct inode vfs_inode;
-};
+} __randomize_layout;
 
 /*
  * General functions
@@ -279,7 +279,7 @@ struct proc_maps_private {
 #ifdef CONFIG_NUMA
 	struct mempolicy *task_mempolicy;
 #endif
-};
+} __randomize_layout;
 
 struct mm_struct *proc_mem_open(struct inode *inode, unsigned int mode);
 
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 05488da3aee9..3ae9013eeaaa 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -46,7 +46,7 @@ struct linux_binprm {
 	unsigned interp_flags;
 	unsigned interp_data;
 	unsigned long loader, exec;
-};
+} __randomize_layout;
 
 #define BINPRM_FLAGS_ENFORCE_NONDUMP_BIT 0
 #define BINPRM_FLAGS_ENFORCE_NONDUMP (1 << BINPRM_FLAGS_ENFORCE_NONDUMP_BIT)
@@ -81,7 +81,7 @@ struct linux_binfmt {
 	int (*load_shlib)(struct file *);
 	int (*core_dump)(struct coredump_params *cprm);
 	unsigned long min_coredump;	/* minimal dump size */
-};
+} __randomize_layout;
 
 extern void __register_binfmt(struct linux_binfmt *fmt, int insert);
 
diff --git a/include/linux/cdev.h b/include/linux/cdev.h
index 408bc09ce497..cb28eb21e3ca 100644
--- a/include/linux/cdev.h
+++ b/include/linux/cdev.h
@@ -17,7 +17,7 @@ struct cdev {
 	struct list_head list;
 	dev_t dev;
 	unsigned int count;
-};
+} __randomize_layout;
 
 void cdev_init(struct cdev *, const struct file_operations *);
 
diff --git a/include/linux/cred.h b/include/linux/cred.h
index c728d515e5e2..099058e1178b 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -31,7 +31,7 @@ struct group_info {
 	atomic_t	usage;
 	int		ngroups;
 	kgid_t		gid[0];
-};
+} __randomize_layout;
 
 /**
  * get_group_info - Get a reference to a group info structure
@@ -145,7 +145,7 @@ struct cred {
 	struct user_namespace *user_ns; /* user_ns the caps and keyrings are relative to. */
 	struct group_info *group_info;	/* supplementary groups for euid/fsgid */
 	struct rcu_head	rcu;		/* RCU deletion hook */
-};
+} __randomize_layout;
 
 extern void __put_cred(struct cred *);
 extern void exit_creds(struct task_struct *);
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index d2e38dc6172c..7eb262e13d3c 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -113,7 +113,7 @@ struct dentry {
 		struct hlist_bl_node d_in_lookup_hash;	/* only for in-lookup ones */
 	 	struct rcu_head d_rcu;
 	} d_u;
-};
+} __randomize_layout;
 
 /*
  * dentry->d_lock spinlock nesting subclasses:
diff --git a/include/linux/fs.h b/include/linux/fs.h
index aa4affb38c39..f1798a4c0cfc 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -275,7 +275,7 @@ struct kiocb {
 	void (*ki_complete)(struct kiocb *iocb, long ret, long ret2);
 	void			*private;
 	int			ki_flags;
-};
+} __randomize_layout;
 
 static inline bool is_sync_kiocb(struct kiocb *kiocb)
 {
@@ -392,7 +392,7 @@ struct address_space {
 	gfp_t			gfp_mask;	/* implicit gfp mask for allocations */
 	struct list_head	private_list;	/* ditto */
 	void			*private_data;	/* ditto */
-} __attribute__((aligned(sizeof(long))));
+} __attribute__((aligned(sizeof(long)))) __randomize_layout;
 	/*
 	 * On most architectures that alignment is already the case; but
 	 * must be enforced here for CRIS, to let the least significant bit
@@ -435,7 +435,7 @@ struct block_device {
 	int			bd_fsfreeze_count;
 	/* Mutex for freeze */
 	struct mutex		bd_fsfreeze_mutex;
-};
+} __randomize_layout;
 
 /*
  * Radix-tree tags, for tagging dirty and writeback pages within the pagecache
@@ -653,7 +653,7 @@ struct inode {
 #endif
 
 	void			*i_private; /* fs or device private pointer */
-};
+} __randomize_layout;
 
 static inline unsigned int i_blocksize(const struct inode *node)
 {
@@ -868,7 +868,8 @@ struct file {
 	struct list_head	f_tfile_llink;
 #endif /* #ifdef CONFIG_EPOLL */
 	struct address_space	*f_mapping;
-} __attribute__((aligned(4)));	/* lest something weird decides that 2 is OK */
+} __randomize_layout
+  __attribute__((aligned(4)));	/* lest something weird decides that 2 is OK */
 
 struct file_handle {
 	__u32 handle_bytes;
@@ -1005,7 +1006,7 @@ struct file_lock {
 			int state;		/* state of grant or error if -ve */
 		} afs;
 	} fl_u;
-};
+} __randomize_layout;
 
 struct file_lock_context {
 	spinlock_t		flc_lock;
@@ -1404,7 +1405,7 @@ struct super_block {
 
 	spinlock_t		s_inode_wblist_lock;
 	struct list_head	s_inodes_wb;	/* writeback inodes */
-};
+} __randomize_layout;
 
 /* Helper functions so that in most cases filesystems will
  * not need to deal directly with kuid_t and kgid_t and can
@@ -1690,7 +1691,7 @@ struct file_operations {
 			u64);
 	ssize_t (*dedupe_file_range)(struct file *, u64, u64, struct file *,
 			u64);
-};
+} __randomize_layout;
 
 struct inode_operations {
 	struct dentry * (*lookup) (struct inode *,struct dentry *, unsigned int);
diff --git a/include/linux/fs_struct.h b/include/linux/fs_struct.h
index 0efc3e62843a..7a026240cbb1 100644
--- a/include/linux/fs_struct.h
+++ b/include/linux/fs_struct.h
@@ -12,7 +12,7 @@ struct fs_struct {
 	int umask;
 	int in_exec;
 	struct path root, pwd;
-};
+} __randomize_layout;
 
 extern struct kmem_cache *fs_cachep;
 
diff --git a/include/linux/ipc.h b/include/linux/ipc.h
index 71fd92d81b26..ea0eb0b5f98c 100644
--- a/include/linux/ipc.h
+++ b/include/linux/ipc.h
@@ -20,6 +20,6 @@ struct kern_ipc_perm {
 	umode_t		mode;
 	unsigned long	seq;
 	void		*security;
-} ____cacheline_aligned_in_smp;
+} ____cacheline_aligned_in_smp __randomize_layout;
 
 #endif /* _LINUX_IPC_H */
diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index 848e5796400e..65327ee0936b 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -61,7 +61,7 @@ struct ipc_namespace {
 	struct ucounts *ucounts;
 
 	struct ns_common ns;
-};
+} __randomize_layout;
 
 extern struct ipc_namespace init_ipc_ns;
 extern spinlock_t mq_lock;
diff --git a/include/linux/key-type.h b/include/linux/key-type.h
index 8496cf64575c..9520fc3c3b9a 100644
--- a/include/linux/key-type.h
+++ b/include/linux/key-type.h
@@ -45,7 +45,7 @@ struct key_preparsed_payload {
 	size_t		datalen;	/* Raw datalen */
 	size_t		quotalen;	/* Quota length for proposed payload */
 	time_t		expiry;		/* Expiry time of key */
-};
+} __randomize_layout;
 
 typedef int (*request_key_actor_t)(struct key_construction *key,
 				   const char *op, void *aux);
@@ -158,7 +158,7 @@ struct key_type {
 	/* internal fields */
 	struct list_head	link;		/* link in types list */
 	struct lock_class_key	lock_class;	/* key->sem lock class */
-};
+} __randomize_layout;
 
 extern struct key_type key_type_keyring;
 
diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index c4e441e00db5..655082c88fd9 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -64,7 +64,7 @@ struct subprocess_info {
 	int (*init)(struct subprocess_info *info, struct cred *new);
 	void (*cleanup)(struct subprocess_info *info);
 	void *data;
-};
+} __randomize_layout;
 
 extern int
 call_usermodehelper(const char *path, char **argv, char **envp, int wait);
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index ca85cb80e99a..084513350317 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -172,7 +172,7 @@ struct kset {
 	spinlock_t list_lock;
 	struct kobject kobj;
 	const struct kset_uevent_ops *uevent_ops;
-};
+} __randomize_layout;
 
 extern void kset_init(struct kset *kset);
 extern int __must_check kset_register(struct kset *kset);
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index f7914d96e1d7..8c1182fcc6d2 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1910,7 +1910,7 @@ struct security_hook_heads {
 	struct list_head audit_rule_match;
 	struct list_head audit_rule_free;
 #endif /* CONFIG_AUDIT */
-};
+} __randomize_layout;
 
 /*
  * Security module hook list structure.
@@ -1921,7 +1921,7 @@ struct security_hook_list {
 	struct list_head		*head;
 	union security_list_options	hook;
 	char				*lsm;
-};
+} __randomize_layout;
 
 /*
  * Initializing a security_hook_list structure takes
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 45cdb27791a3..ff151814a02d 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -342,7 +342,7 @@ struct vm_area_struct {
 	struct mempolicy *vm_policy;	/* NUMA policy for the VMA */
 #endif
 	struct vm_userfaultfd_ctx vm_userfaultfd_ctx;
-};
+} __randomize_layout;
 
 struct core_thread {
 	struct task_struct *task;
@@ -500,7 +500,7 @@ struct mm_struct {
 	atomic_long_t hugetlb_usage;
 #endif
 	struct work_struct async_put_work;
-};
+} __randomize_layout;
 
 extern struct mm_struct init_mm;
 
diff --git a/include/linux/module.h b/include/linux/module.h
index 21f56393602f..d93111d7def6 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -45,7 +45,7 @@ struct module_kobject {
 	struct kobject *drivers_dir;
 	struct module_param_attrs *mp;
 	struct completion *kobj_completion;
-};
+} __randomize_layout;
 
 struct module_attribute {
 	struct attribute attr;
@@ -475,7 +475,7 @@ struct module {
 	ctor_fn_t *ctors;
 	unsigned int num_ctors;
 #endif
-} ____cacheline_aligned;
+} ____cacheline_aligned __randomize_layout;
 #ifndef MODULE_ARCH_INIT
 #define MODULE_ARCH_INIT {}
 #endif
diff --git a/include/linux/mount.h b/include/linux/mount.h
index 8e0352af06b7..1ce85e6fd95f 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -67,7 +67,7 @@ struct vfsmount {
 	struct dentry *mnt_root;	/* root of the mounted tree */
 	struct super_block *mnt_sb;	/* pointer to superblock */
 	int mnt_flags;
-};
+} __randomize_layout;
 
 struct file; /* forward dec */
 struct path;
diff --git a/include/linux/msg.h b/include/linux/msg.h
index f3f302f9c197..a001305f5a79 100644
--- a/include/linux/msg.h
+++ b/include/linux/msg.h
@@ -29,7 +29,7 @@ struct msg_queue {
 	struct list_head q_messages;
 	struct list_head q_receivers;
 	struct list_head q_senders;
-};
+} __randomize_layout;
 
 /* Helper routines for sys_msgsnd and sys_msgrcv */
 extern long do_msgsnd(int msqid, long mtype, void __user *mtext,
diff --git a/include/linux/path.h b/include/linux/path.h
index d1372186f431..cde895cc4af4 100644
--- a/include/linux/path.h
+++ b/include/linux/path.h
@@ -7,7 +7,7 @@ struct vfsmount;
 struct path {
 	struct vfsmount *mnt;
 	struct dentry *dentry;
-};
+} __randomize_layout;
 
 extern void path_get(const struct path *);
 extern void path_put(const struct path *);
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index c2a989dee876..b09136f88cf4 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -52,7 +52,7 @@ struct pid_namespace {
 	int hide_pid;
 	int reboot;	/* group exit code if this pidns was rebooted */
 	struct ns_common ns;
-};
+} __randomize_layout;
 
 extern struct pid_namespace init_pid_ns;
 
diff --git a/include/linux/proc_ns.h b/include/linux/proc_ns.h
index 58ab28d81fc2..06844b54dfc1 100644
--- a/include/linux/proc_ns.h
+++ b/include/linux/proc_ns.h
@@ -21,7 +21,7 @@ struct proc_ns_operations {
 	int (*install)(struct nsproxy *nsproxy, struct ns_common *ns);
 	struct user_namespace *(*owner)(struct ns_common *ns);
 	struct ns_common *(*get_parent)(struct ns_common *ns);
-};
+} __randomize_layout;
 
 extern const struct proc_ns_operations netns_operations;
 extern const struct proc_ns_operations utsns_operations;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index c5338510628a..b1298ad4da63 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -408,7 +408,7 @@ struct sched_rt_entity {
 	/* rq "owned" by this entity/group: */
 	struct rt_rq			*my_q;
 #endif
-};
+} __randomize_layout;
 
 struct sched_dl_entity {
 	struct rb_node			rb_node;
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index c06d63b3a583..2a0dd40b15db 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -222,7 +222,7 @@ struct signal_struct {
 	struct mutex cred_guard_mutex;	/* guard against foreign influences on
 					 * credential calculations
 					 * (notably. ptrace) */
-};
+} __randomize_layout;
 
 /*
  * Bits in flags field of signal_struct.
diff --git a/include/linux/sem.h b/include/linux/sem.h
index fc7af8eaa527..a4dddb20a697 100644
--- a/include/linux/sem.h
+++ b/include/linux/sem.h
@@ -41,7 +41,7 @@ struct sem_array {
 	unsigned int		use_global_lock;/* >0: global lock required */
 
 	struct sem		sems[0];
-};
+} __randomize_layout;
 
 #ifdef CONFIG_SYSVIPC
 
diff --git a/include/linux/shm.h b/include/linux/shm.h
index 04e881829625..0fb7061ec54c 100644
--- a/include/linux/shm.h
+++ b/include/linux/shm.h
@@ -22,7 +22,7 @@ struct shmid_kernel /* private to the kernel */
 	/* The task created the shm object.  NULL if the task is dead. */
 	struct task_struct	*shm_creator;
 	struct list_head	shm_clist;	/* list by creator */
-};
+} __randomize_layout;
 
 /* shm_mode upper byte flags */
 #define	SHM_DEST	01000	/* segment will be destroyed on last detach */
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 80d07816def0..9ddeef2c03e2 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -117,7 +117,7 @@ struct ctl_table
 	struct ctl_table_poll *poll;
 	void *extra1;
 	void *extra2;
-};
+} __randomize_layout;
 
 struct ctl_node {
 	struct rb_node node;
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 5c3f01f49b10..99ecb38bac04 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -333,7 +333,7 @@ struct tty_struct {
 	/* If the tty has a pending do_SAK, queue it here - akpm */
 	struct work_struct SAK_work;
 	struct tty_port *port;
-};
+} __randomize_layout;
 
 /* Each of a tty's open files has private_data pointing to tty_file_private */
 struct tty_file_private {
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index b742b5e47cc2..00b2213f6a35 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -291,7 +291,7 @@ struct tty_operations {
 	void (*poll_put_char)(struct tty_driver *driver, int line, char ch);
 #endif
 	const struct file_operations *proc_fops;
-};
+} __randomize_layout;
 
 struct tty_driver {
 	int	magic;		/* magic number for this structure */
@@ -325,7 +325,7 @@ struct tty_driver {
 
 	const struct tty_operations *ops;
 	struct list_head tty_drivers;
-};
+} __randomize_layout;
 
 extern struct list_head tty_drivers;
 
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 32354b4b4b2b..b3575ce29148 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -66,7 +66,7 @@ struct user_namespace {
 #endif
 	struct ucounts		*ucounts;
 	int ucount_max[UCOUNT_COUNTS];
-};
+} __randomize_layout;
 
 struct ucounts {
 	struct hlist_node node;
diff --git a/include/linux/utsname.h b/include/linux/utsname.h
index 60f0bb83b313..da826ed059cf 100644
--- a/include/linux/utsname.h
+++ b/include/linux/utsname.h
@@ -26,7 +26,7 @@ struct uts_namespace {
 	struct user_namespace *user_ns;
 	struct ucounts *ucounts;
 	struct ns_common ns;
-};
+} __randomize_layout;
 extern struct uts_namespace init_uts_ns;
 
 #ifdef CONFIG_UTS_NS
diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index fd60eccb59a6..64e2a1e24a2c 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -36,7 +36,7 @@ struct unix_skb_parms {
 	u32			secid;		/* Security ID		*/
 #endif
 	u32			consumed;
-};
+} __randomize_layout;
 
 #define UNIXCB(skb) 	(*(struct unix_skb_parms *)&((skb)->cb))
 
diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index e4dd3a214034..a62959d2b3f7 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -155,7 +155,7 @@ struct neighbour {
 	struct rcu_head		rcu;
 	struct net_device	*dev;
 	u8			primary_key[0];
-};
+} __randomize_layout;
 
 struct neigh_ops {
 	int			family;
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index fe80bb48ab1f..a224196d16ac 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -147,7 +147,7 @@ struct net {
 #endif
 	struct sock		*diag_nlsk;
 	atomic_t		fnhe_genid;
-};
+} __randomize_layout;
 
 #include <linux/seq_file_net.h>
 
diff --git a/include/net/sock.h b/include/net/sock.h
index 12b2912de420..1b035dbb95d9 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1120,7 +1120,7 @@ struct proto {
 	atomic_t		socks;
 #endif
 	int			(*diag_destroy)(struct sock *sk, int err);
-};
+} __randomize_layout;
 
 int proto_register(struct proto *prot, int alloc_slab);
 void proto_unregister(struct proto *prot);
diff --git a/kernel/futex.c b/kernel/futex.c
index b8ae87d227da..0a865bc119c6 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -212,7 +212,7 @@ struct futex_pi_state {
 	atomic_t refcount;
 
 	union futex_key key;
-};
+} __randomize_layout;
 
 /**
  * struct futex_q - The hashed futex queue entry, one per waiting task
@@ -246,7 +246,7 @@ struct futex_q {
 	struct rt_mutex_waiter *rt_waiter;
 	union futex_key *requeue_pi_key;
 	u32 bitset;
-};
+} __randomize_layout;
 
 static const struct futex_q futex_q_init = {
 	/* list gets initialized in queue_me()*/
diff --git a/security/keys/internal.h b/security/keys/internal.h
index c0f8682eba69..6494954e9980 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -197,7 +197,7 @@ struct request_key_auth {
 	void			*callout_info;
 	size_t			callout_len;
 	pid_t			pid;
-};
+} __randomize_layout;
 
 extern struct key_type key_type_request_key_auth;
 extern struct key *request_key_auth_new(struct key *target,
-- 
2.7.4
