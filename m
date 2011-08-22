Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 22 Aug 2011 13:34:05 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110822093405.GA2450@albatros>
References: <20110718194803.GA5337@albatros>
 <20110723153751.GB11156@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110723153751.GB11156@openwall.com>
Subject: Re: [kernel-hardening] GNU_STACK policy problem
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Sat, Jul 23, 2011 at 19:37 +0400, Solar Designer wrote:
> > One solution I see is somehow passing this information (GNU_STACK
> > handling policy for 2 cases) at the task creation time.  Something like
> > VDSO symbol (2) or auxv entry (3).  VDSO case is complicated as IIRC now
> > it is global to the kernel and is not per pid namespace (I recall a
> > problem in OpenVZ kernel when kernel version symbol was globally removed
> > to fool some pid namespaces expecting new kernel).  auxv is complicated
> > as it is ELF ABI changing :-(
> 
> I like the auxv approach.
> 
> I don't know who is the central authority to allocate new AT_* values or
> AT_FLAGS bits (perhaps for Linux only) - do you?  My guess is that if we
> get a couple of extra AT_FLAGS bits accepted into mainline kernels, that
> will be it.

Looking into ELF documentation:

In MIPS, SPARC no AT_FLAGS bits are used currently.  And "bits under the
0xff000000 mask are reserved for system semantics."

In IA-32 and PPC no bits are used.  No "system" flags are mentioned.


I didn't find any definition of "system semantics", I guess it means any
non-standard usage on local system.  Probably we should use these bits.
For now I used two low order bits.

$ LD_SHOW_AUXV=1 /bin/true | grep FLAGS
AT_FLAGS:        0x0
# sysctl kernel.execstack_mode=7
kernel.execstack_mode = 7
$ LD_SHOW_AUXV=1 /bin/true | grep FLAGS
AT_FLAGS:        0x3

The changes relative to the previous patch:

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 64330e5..17aad10 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -134,6 +134,20 @@ static int padzero(unsigned long elf_bss)
 #define ELF_BASE_PLATFORM NULL
 #endif
 
+static
+elf_addr_t get_at_flags(void)
+{
+	enum execstack_mode stack = current->nsproxy->pid_ns->execstack_mode;
+	elf_addr_t flags = 0;
+
+	if (stack & GNU_STACK_X_FORCE_NX)
+		flags |= 1;
+	if (stack & NO_GNU_STACK_FORCE_NX)
+		flags |= 2;
+
+	return flags;
+}
+
 static int
 create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 		unsigned long load_addr, unsigned long interp_load_addr)
@@ -155,6 +169,7 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	int ei_index = 0;
 	const struct cred *cred = current_cred();
 	struct vm_area_struct *vma;
+	elf_addr_t at_flags = get_at_flags();
 
 	/*
 	 * In some cases (e.g. Hyper-Threading), we want to avoid L1
@@ -226,7 +241,7 @@ create_elf_tables(struct linux_binprm *bprm, struct elfhdr *exec,
 	NEW_AUX_ENT(AT_PHENT, sizeof(struct elf_phdr));
 	NEW_AUX_ENT(AT_PHNUM, exec->e_phnum);
 	NEW_AUX_ENT(AT_BASE, interp_load_addr);
-	NEW_AUX_ENT(AT_FLAGS, 0);
+	NEW_AUX_ENT(AT_FLAGS, at_flags);
 	NEW_AUX_ENT(AT_ENTRY, exec->e_entry);
 	NEW_AUX_ENT(AT_UID, cred->uid);
 	NEW_AUX_ENT(AT_EUID, cred->euid);
-- 
Vasiliy
