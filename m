Return-Path: <SRS0=VvxH=ZL=lists.openwall.com=kernel-hardening-return-17397-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7AF1C432C3
	for <kernel-hardening@archiver.kernel.org>; Tue, 19 Nov 2019 15:54:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D459C20891
	for <kernel-hardening@archiver.kernel.org>; Tue, 19 Nov 2019 15:54:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=digitalocean.com header.i=@digitalocean.com header.b="fp+Fz+C/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D459C20891
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=digitalocean.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17397-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12047 invoked by uid 550); 19 Nov 2019 15:54:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11981 invoked from network); 19 Nov 2019 15:54:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=jfljifxYQ3oIOUbpvad+cJbB+hT9t9MKSwAZPLYrU0s=;
        b=fp+Fz+C/jK3qDKuPil11TCIKspnT7jYf+JJxGNv9KZKvw4YBCGlaZ/k/TF29OBZFsB
         k+Xfv/H7Rl5d1nW+pENWl0mccABLnc+2b4qGDRFCatcf1hMcODrGD5wSDfPkpSI8DEFl
         0riYboAyIzKijlWSTz1diXQcUettD8fkLd20M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jfljifxYQ3oIOUbpvad+cJbB+hT9t9MKSwAZPLYrU0s=;
        b=OEZeHiwCRLS06skKQH4ALH+6wmpT3Kylo71MLTq1YohKU5fKGKq3NCqX9IKximNMjN
         0lNDdZ4w4ad5diZPkm5MFHi906apoR8QtnghpTaUQhSr3SzSBOxTiKXOGmmaKuRcZiR6
         81fiZgYs3EKBAkOHDOcwyZNU5Dne/yE58dqJHML2mO/jCdmF7bZYYKWtrCL6BE5m/eV0
         NLel7P0mHShmzwBir5ew51nH3v/Qq+TFX/yPokRb2khrXvdJw9Zrm5Ko2xBDv44I3ULw
         KTkfGMK9EL1PMtuTdcYbdHGbt7/iEcdmoUs84NB7o8JPUuxY7EDasMk8R/0FxtEvxthx
         99cQ==
X-Gm-Message-State: APjAAAVDdFs4kFbuh2z4KMQZdwhKvSKthq+Q5yhrZS827Qu1u+/T1iC3
	Rouq94utmT4YaGnaYlAZvDSS
X-Google-Smtp-Source: APXvYqyPVijKHaTFjt6HPwLVF8QE8iiQNDiCZyuAktGLKQLC/y5XSVo/cPL9jHilmAt4fab1N2J30A==
X-Received: by 2002:ac8:1084:: with SMTP id a4mr33615888qtj.114.1574178831711;
        Tue, 19 Nov 2019 07:53:51 -0800 (PST)
From: Tianlin Li <tli@digitalocean.com>
To: kernel-hardening@lists.openwall.com,
	keescook@chromium.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Ingo Molnar <mingo@redhat.com>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Greentime Hu <green.hu@gmail.com>,
	Vincent Chen <deanbo422@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	"H . Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Jessica Yu <jeyu@kernel.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Tianlin Li <tli@digitalocean.com>
Subject: [RFC PATCH] kernel/module: have the callers of set_memory_*() check the return value
Date: Tue, 19 Nov 2019 09:51:49 -0600
Message-Id: <20191119155149.20396-1-tli@digitalocean.com>
X-Mailer: git-send-email 2.17.1

Right now several architectures allow their set_memory_*() family of 
functions to fail, but callers may not be checking the return values. We 
need to fix the callers and add the __must_check attribute. They also may
not provide any level of atomicity, in the sense that the memory 
protections may be left incomplete on failure. This issue likely has a few 
steps on effects architectures[1]:
1)Have all callers of set_memory_*() helpers check the return value.
2)Add __much_check to all set_memory_*() helpers so that new uses do not 
ignore the return value.
3)Add atomicity to the calls so that the memory protections aren't left in 
a partial state.

Ideally, the failure of set_memory_*() should be passed up the call stack, 
and callers should examine the failure and deal with it. But currently, 
some callers just have void return type.

We need to fix the callers to handle the return all the way to the top of 
stack, and it will require a large series of patches to finish all the three 
steps mentioned above. I start with kernel/module, and will move onto other 
subsystems. I am not entirely sure about the failure modes for each caller. 
So I would like to get some comments before I move forward. This single 
patch is just for fixing the return value of set_memory_*() function in 
kernel/module, and also the related callers. Any feedback would be greatly 
appreciated.

[1]:https://github.com/KSPP/linux/issues/7

Signed-off-by: Tianlin Li <tli@digitalocean.com>
---
 arch/arm/kernel/ftrace.c   |   8 +-
 arch/arm64/kernel/ftrace.c |   6 +-
 arch/nds32/kernel/ftrace.c |   6 +-
 arch/x86/kernel/ftrace.c   |  13 ++-
 include/linux/module.h     |  16 ++--
 kernel/livepatch/core.c    |  15 +++-
 kernel/module.c            | 170 +++++++++++++++++++++++++++----------
 kernel/trace/ftrace.c      |  15 +++-
 8 files changed, 175 insertions(+), 74 deletions(-)

diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index bda949fd84e8..7ea1338821d6 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -59,13 +59,15 @@ static unsigned long adjust_address(struct dyn_ftrace *rec, unsigned long addr)
 
 int ftrace_arch_code_modify_prepare(void)
 {
-	set_all_modules_text_rw();
-	return 0;
+	return set_all_modules_text_rw();
 }
 
 int ftrace_arch_code_modify_post_process(void)
 {
-	set_all_modules_text_ro();
+	int ret;
+	ret = set_all_modules_text_ro();
+	if (ret)
+		return ret;
 	/* Make sure any TLB misses during machine stop are cleared. */
 	flush_tlb_all();
 	return 0;
diff --git a/arch/arm64/kernel/ftrace.c b/arch/arm64/kernel/ftrace.c
index 171773257974..97a89c38f6b9 100644
--- a/arch/arm64/kernel/ftrace.c
+++ b/arch/arm64/kernel/ftrace.c
@@ -115,9 +115,11 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 			}
 
 			/* point the trampoline to our ftrace entry point */
-			module_disable_ro(mod);
+			if (module_disable_ro(mod))
+				return -EINVAL;
 			*dst = trampoline;
-			module_enable_ro(mod, true);
+			if (module_enable_ro(mod, true))
+				return -EINVAL;
 
 			/*
 			 * Ensure updated trampoline is visible to instruction
diff --git a/arch/nds32/kernel/ftrace.c b/arch/nds32/kernel/ftrace.c
index fd2a54b8cd57..e9e63e703a3e 100644
--- a/arch/nds32/kernel/ftrace.c
+++ b/arch/nds32/kernel/ftrace.c
@@ -91,14 +91,12 @@ int __init ftrace_dyn_arch_init(void)
 
 int ftrace_arch_code_modify_prepare(void)
 {
-	set_all_modules_text_rw();
-	return 0;
+	return set_all_modules_text_rw();
 }
 
 int ftrace_arch_code_modify_post_process(void)
 {
-	set_all_modules_text_ro();
-	return 0;
+	return set_all_modules_text_ro();
 }
 
 static unsigned long gen_sethi_insn(unsigned long addr)
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 024c3053dbba..7fdee06e2a76 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -42,19 +42,26 @@ int ftrace_arch_code_modify_prepare(void)
 	 * and live kernel patching from changing the text permissions while
 	 * ftrace has it set to "read/write".
 	 */
+	int ret;
 	mutex_lock(&text_mutex);
 	set_kernel_text_rw();
-	set_all_modules_text_rw();
+	ret = set_all_modules_text_rw();
+	if (ret) {
+		set_kernel_text_ro();
+		mutex_unlock(&text_mutex);
+		return ret;
+	}
 	return 0;
 }
 
 int ftrace_arch_code_modify_post_process(void)
     __releases(&text_mutex)
 {
-	set_all_modules_text_ro();
+	int ret;
+	ret = set_all_modules_text_ro();
 	set_kernel_text_ro();
 	mutex_unlock(&text_mutex);
-	return 0;
+	return ret;
 }
 
 union ftrace_code_union {
diff --git a/include/linux/module.h b/include/linux/module.h
index 1455812dd325..e6c7f3b719a3 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -847,15 +847,15 @@ extern int module_sysfs_initialized;
 #define __MODULE_STRING(x) __stringify(x)
 
 #ifdef CONFIG_STRICT_MODULE_RWX
-extern void set_all_modules_text_rw(void);
-extern void set_all_modules_text_ro(void);
-extern void module_enable_ro(const struct module *mod, bool after_init);
-extern void module_disable_ro(const struct module *mod);
+extern int set_all_modules_text_rw(void);
+extern int set_all_modules_text_ro(void);
+extern int module_enable_ro(const struct module *mod, bool after_init);
+extern int module_disable_ro(const struct module *mod);
 #else
-static inline void set_all_modules_text_rw(void) { }
-static inline void set_all_modules_text_ro(void) { }
-static inline void module_enable_ro(const struct module *mod, bool after_init) { }
-static inline void module_disable_ro(const struct module *mod) { }
+static inline int set_all_modules_text_rw(void) { return 0; }
+static inline int set_all_modules_text_ro(void) { return 0; }
+static inline int module_enable_ro(const struct module *mod, bool after_init) { return 0; }
+static inline int module_disable_ro(const struct module *mod) { return 0; }
 #endif
 
 #ifdef CONFIG_GENERIC_BUG
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index c4ce08f43bd6..39bfc0685854 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -721,16 +721,25 @@ static int klp_init_object_loaded(struct klp_patch *patch,
 
 	mutex_lock(&text_mutex);
 
-	module_disable_ro(patch->mod);
+	ret = module_disable_ro(patch->mod);
+	if (ret) {
+		mutex_unlock(&text_mutex);
+		return ret;
+	}
 	ret = klp_write_object_relocations(patch->mod, obj);
 	if (ret) {
-		module_enable_ro(patch->mod, true);
+		if (module_enable_ro(patch->mod, true));
+			pr_err("module_enable_ro failed.\n");
 		mutex_unlock(&text_mutex);
 		return ret;
 	}
 
 	arch_klp_init_object_loaded(patch, obj);
-	module_enable_ro(patch->mod, true);
+	ret = module_enable_ro(patch->mod, true);
+	if (ret) {
+		mutex_unlock(&text_mutex);
+		return ret;
+	}
 
 	mutex_unlock(&text_mutex);
 
diff --git a/kernel/module.c b/kernel/module.c
index 9ee93421269c..87125b5e315c 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1900,111 +1900,162 @@ static void mod_sysfs_teardown(struct module *mod)
  *
  * These values are always page-aligned (as is base)
  */
-static void frob_text(const struct module_layout *layout,
+static int frob_text(const struct module_layout *layout,
 		      int (*set_memory)(unsigned long start, int num_pages))
 {
 	BUG_ON((unsigned long)layout->base & (PAGE_SIZE-1));
 	BUG_ON((unsigned long)layout->text_size & (PAGE_SIZE-1));
-	set_memory((unsigned long)layout->base,
+	return set_memory((unsigned long)layout->base,
 		   layout->text_size >> PAGE_SHIFT);
 }
 
 #ifdef CONFIG_STRICT_MODULE_RWX
-static void frob_rodata(const struct module_layout *layout,
+static int frob_rodata(const struct module_layout *layout,
 			int (*set_memory)(unsigned long start, int num_pages))
 {
 	BUG_ON((unsigned long)layout->base & (PAGE_SIZE-1));
 	BUG_ON((unsigned long)layout->text_size & (PAGE_SIZE-1));
 	BUG_ON((unsigned long)layout->ro_size & (PAGE_SIZE-1));
-	set_memory((unsigned long)layout->base + layout->text_size,
+	return set_memory((unsigned long)layout->base + layout->text_size,
 		   (layout->ro_size - layout->text_size) >> PAGE_SHIFT);
 }
 
-static void frob_ro_after_init(const struct module_layout *layout,
+static int frob_ro_after_init(const struct module_layout *layout,
 				int (*set_memory)(unsigned long start, int num_pages))
 {
 	BUG_ON((unsigned long)layout->base & (PAGE_SIZE-1));
 	BUG_ON((unsigned long)layout->ro_size & (PAGE_SIZE-1));
 	BUG_ON((unsigned long)layout->ro_after_init_size & (PAGE_SIZE-1));
-	set_memory((unsigned long)layout->base + layout->ro_size,
+	return set_memory((unsigned long)layout->base + layout->ro_size,
 		   (layout->ro_after_init_size - layout->ro_size) >> PAGE_SHIFT);
 }
 
-static void frob_writable_data(const struct module_layout *layout,
+static int frob_writable_data(const struct module_layout *layout,
 			       int (*set_memory)(unsigned long start, int num_pages))
 {
 	BUG_ON((unsigned long)layout->base & (PAGE_SIZE-1));
 	BUG_ON((unsigned long)layout->ro_after_init_size & (PAGE_SIZE-1));
 	BUG_ON((unsigned long)layout->size & (PAGE_SIZE-1));
-	set_memory((unsigned long)layout->base + layout->ro_after_init_size,
+	return set_memory((unsigned long)layout->base + layout->ro_after_init_size,
 		   (layout->size - layout->ro_after_init_size) >> PAGE_SHIFT);
 }
 
 /* livepatching wants to disable read-only so it can frob module. */
-void module_disable_ro(const struct module *mod)
+int module_disable_ro(const struct module *mod)
 {
+	int ret;
 	if (!rodata_enabled)
-		return;
+		return 0;
 
-	frob_text(&mod->core_layout, set_memory_rw);
-	frob_rodata(&mod->core_layout, set_memory_rw);
-	frob_ro_after_init(&mod->core_layout, set_memory_rw);
-	frob_text(&mod->init_layout, set_memory_rw);
-	frob_rodata(&mod->init_layout, set_memory_rw);
+	ret = frob_text(&mod->core_layout, set_memory_rw);
+	if (ret)
+		return ret;
+	ret = frob_rodata(&mod->core_layout, set_memory_rw);
+	if (ret)
+		return ret;
+	ret = frob_ro_after_init(&mod->core_layout, set_memory_rw);
+	if (ret)
+		return ret;
+	ret = frob_text(&mod->init_layout, set_memory_rw);
+	if (ret)
+		return ret;
+	ret = frob_rodata(&mod->init_layout, set_memory_rw);
+	if (ret)
+		return ret;
+
+	return 0;
 }
 
-void module_enable_ro(const struct module *mod, bool after_init)
+int module_enable_ro(const struct module *mod, bool after_init)
 {
+	int ret;
 	if (!rodata_enabled)
-		return;
+		return 0;
 
 	set_vm_flush_reset_perms(mod->core_layout.base);
 	set_vm_flush_reset_perms(mod->init_layout.base);
-	frob_text(&mod->core_layout, set_memory_ro);
+	ret = frob_text(&mod->core_layout, set_memory_ro);
+	if (ret)
+		return ret;
 
-	frob_rodata(&mod->core_layout, set_memory_ro);
-	frob_text(&mod->init_layout, set_memory_ro);
-	frob_rodata(&mod->init_layout, set_memory_ro);
+	ret = frob_rodata(&mod->core_layout, set_memory_ro);
+	if (ret)
+		return ret;
+	ret = frob_text(&mod->init_layout, set_memory_ro);
+	if (ret)
+		return ret;
+	ret = frob_rodata(&mod->init_layout, set_memory_ro);
+	if (ret)
+		return ret;
 
-	if (after_init)
-		frob_ro_after_init(&mod->core_layout, set_memory_ro);
+	if (after_init) {
+		ret = frob_ro_after_init(&mod->core_layout, set_memory_ro);
+		if (ret)
+			return ret;
+	}
+	return 0;
 }
 
-static void module_enable_nx(const struct module *mod)
+static int module_enable_nx(const struct module *mod)
 {
-	frob_rodata(&mod->core_layout, set_memory_nx);
-	frob_ro_after_init(&mod->core_layout, set_memory_nx);
-	frob_writable_data(&mod->core_layout, set_memory_nx);
-	frob_rodata(&mod->init_layout, set_memory_nx);
-	frob_writable_data(&mod->init_layout, set_memory_nx);
+	int ret;
+
+	ret = frob_rodata(&mod->core_layout, set_memory_nx);
+	if (ret)
+		return ret;
+	ret = frob_ro_after_init(&mod->core_layout, set_memory_nx);
+	if (ret)
+		return ret;
+	ret = frob_writable_data(&mod->core_layout, set_memory_nx);
+	if (ret)
+		return ret;
+	ret = frob_rodata(&mod->init_layout, set_memory_nx);
+	if (ret)
+		return ret;
+	ret = frob_writable_data(&mod->init_layout, set_memory_nx);
+	if (ret)
+		return ret;
+
+	return 0;
 }
 
 /* Iterate through all modules and set each module's text as RW */
-void set_all_modules_text_rw(void)
+int set_all_modules_text_rw(void)
 {
 	struct module *mod;
+	int ret;
 
 	if (!rodata_enabled)
-		return;
+		return 0;
 
 	mutex_lock(&module_mutex);
 	list_for_each_entry_rcu(mod, &modules, list) {
 		if (mod->state == MODULE_STATE_UNFORMED)
 			continue;
 
-		frob_text(&mod->core_layout, set_memory_rw);
-		frob_text(&mod->init_layout, set_memory_rw);
+		ret = frob_text(&mod->core_layout, set_memory_rw);
+		if (ret) {
+			mutex_unlock(&module_mutex);
+			return ret;
+		}
+		ret = frob_text(&mod->init_layout, set_memory_rw);
+		if (ret) {
+			mutex_unlock(&module_mutex);
+			return ret;
+		}
 	}
 	mutex_unlock(&module_mutex);
+	return 0;
 }
 
 /* Iterate through all modules and set each module's text as RO */
-void set_all_modules_text_ro(void)
+int set_all_modules_text_ro(void)
 {
 	struct module *mod;
+	int ret;
 
 	if (!rodata_enabled)
-		return;
+		return 0;
 
 	mutex_lock(&module_mutex);
 	list_for_each_entry_rcu(mod, &modules, list) {
@@ -2017,22 +2068,37 @@ void set_all_modules_text_ro(void)
 			mod->state == MODULE_STATE_GOING)
 			continue;
 
-		frob_text(&mod->core_layout, set_memory_ro);
-		frob_text(&mod->init_layout, set_memory_ro);
+		ret = frob_text(&mod->core_layout, set_memory_ro);
+		if (ret) {
+			mutex_unlock(&module_mutex);
+			return ret;
+		}
+		ret = frob_text(&mod->init_layout, set_memory_ro);
+		if (ret) {
+			mutex_unlock(&module_mutex);
+			return ret;
+		}
 	}
 	mutex_unlock(&module_mutex);
+	return 0;
 }
 #else /* !CONFIG_STRICT_MODULE_RWX */
-static void module_enable_nx(const struct module *mod) { }
+static int module_enable_nx(const struct module *mod) { return 0; }
 #endif /*  CONFIG_STRICT_MODULE_RWX */
-static void module_enable_x(const struct module *mod)
+static int module_enable_x(const struct module *mod)
 {
-	frob_text(&mod->core_layout, set_memory_x);
-	frob_text(&mod->init_layout, set_memory_x);
+	int ret;
+	ret = frob_text(&mod->core_layout, set_memory_x);
+	if (ret)
+		return ret;
+	ret = frob_text(&mod->init_layout, set_memory_x);
+	if (ret)
+		return ret;
+	return 0;
 }
 #else /* !CONFIG_ARCH_HAS_STRICT_MODULE_RWX */
-static void module_enable_nx(const struct module *mod) { }
-static void module_enable_x(const struct module *mod) { }
+static int module_enable_nx(const struct module *mod) { return 0; }
+static int module_enable_x(const struct module *mod) { return 0; }
 #endif /* CONFIG_ARCH_HAS_STRICT_MODULE_RWX */
 
 
@@ -3534,7 +3600,11 @@ static noinline int do_init_module(struct module *mod)
 	/* Switch to core kallsyms now init is done: kallsyms may be walking! */
 	rcu_assign_pointer(mod->kallsyms, &mod->core_kallsyms);
 #endif
-	module_enable_ro(mod, true);
+	ret = module_enable_ro(mod, true);
+	if (ret) {
+		mutex_unlock(&module_mutex);
+		goto fail_free_freeinit;
+	}
 	mod_tree_remove_init(mod);
 	module_arch_freeing_init(mod);
 	mod->init_layout.base = NULL;
@@ -3640,9 +3710,15 @@ static int complete_formation(struct module *mod, struct load_info *info)
 	/* This relies on module_mutex for list integrity. */
 	module_bug_finalize(info->hdr, info->sechdrs, mod);
 
-	module_enable_ro(mod, false);
-	module_enable_nx(mod);
-	module_enable_x(mod);
+	err = module_enable_ro(mod, false);
+	if (err)
+		goto out;
+	err = module_enable_nx(mod);
+	if (err)
+		goto out;
+	err = module_enable_x(mod);
+	if (err)
+		goto out;
 
 	/* Mark state as coming so strong_try_module_get() ignores us,
 	 * but kallsyms etc. can see us. */
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f9821a3374e9..d4532bb65d1b 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5814,8 +5814,13 @@ void ftrace_module_enable(struct module *mod)
 	 * text to read-only, as we now need to set it back to read-write
 	 * so that we can modify the text.
 	 */
-	if (ftrace_start_up)
-		ftrace_arch_code_modify_prepare();
+	if (ftrace_start_up) {
+		int ret = ftrace_arch_code_modify_prepare();
+		if (ret) {
+			FTRACE_WARN_ON(ret);
+			goto out_unlock;
+		}
+	}
 
 	do_for_each_ftrace_rec(pg, rec) {
 		int cnt;
@@ -5854,8 +5859,10 @@ void ftrace_module_enable(struct module *mod)
 	} while_for_each_ftrace_rec();
 
  out_loop:
-	if (ftrace_start_up)
-		ftrace_arch_code_modify_post_process();
+	if (ftrace_start_up) {
+		int ret = ftrace_arch_code_modify_post_process();
+		FTRACE_WARN_ON(ret);
+	}
 
  out_unlock:
 	mutex_unlock(&ftrace_lock);
-- 
2.17.1

