Return-Path: <SRS0=H8/J=5J=lists.openwall.com=kernel-hardening-return-18170-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E91CC43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:40:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0971E2073E
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:40:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="WJICj2Aj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0971E2073E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18170-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28372 invoked by uid 550); 24 Mar 2020 15:37:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28268 invoked from network); 24 Mar 2020 15:37:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585064235;
	bh=GR4XeMmA6NQzYZmo4CYLVe9o1WBbprtAV1DiHC+WeM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJICj2AjEttmGs8cbgK0je2JGKysEeIGo5ebYQQTGkV3fY7w1HV7nd+BsRkLBUflp
	 wFAgGx8cRxfH6GufkbYwhceFSxgymfE+2lmPd3kOSnDDHX1u+P0dLt3H6oHqSjT7fC
	 tbMRqX5d8fZQ69NrR4wHTMKY46Ijfg4WbB6AOom4=
From: Will Deacon <will@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Will Deacon <will@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jann Horn <jannh@google.com>,
	Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	Marco Elver <elver@google.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	kernel-team@android.com,
	kernel-hardening@lists.openwall.com
Subject: [RFC PATCH 10/21] kernel-hacking: Make DEBUG_{LIST,PLIST,SG,NOTIFIERS} non-debug options
Date: Tue, 24 Mar 2020 15:36:32 +0000
Message-Id: <20200324153643.15527-11-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324153643.15527-1-will@kernel.org>
References: <20200324153643.15527-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The CONFIG_DEBUG_{LIST,PLIST,SG,NOTIFIERS} options can provide useful
security hardening properties outside of debug scenarios. For example,
CVE-2019-2215 and CVE-2019-2025 are mitigated with negligible runtime
overhead by enabling CONFIG_DEBUG_LIST, and this option is already
enabled by default on many distributions:

https://googleprojectzero.blogspot.com/2019/11/bad-binder-android-in-wild-exploit.html

Rename these options across the tree so that the naming better reflects
their operation and remove the dependency on DEBUG_KERNEL.

Cc: Maddie Stone <maddiestone@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm/configs/tegra_defconfig              |  2 +-
 arch/mips/configs/bigsur_defconfig            |  2 +-
 arch/powerpc/configs/ppc6xx_defconfig         |  4 ++--
 arch/powerpc/configs/ps3_defconfig            |  2 +-
 arch/powerpc/configs/skiroot_defconfig        |  4 ++--
 arch/riscv/configs/defconfig                  |  6 ++---
 arch/riscv/configs/rv32_defconfig             |  6 ++---
 arch/s390/configs/debug_defconfig             |  4 ++--
 arch/sh/configs/polaris_defconfig             |  2 +-
 arch/sh/configs/rsk7203_defconfig             |  4 ++--
 arch/sh/configs/se7206_defconfig              |  2 +-
 drivers/gpu/drm/radeon/mkregtable.c           |  2 +-
 drivers/staging/wfx/fwio.c                    |  2 +-
 drivers/staging/wfx/hwio.c                    |  2 +-
 include/linux/list.h                          |  2 +-
 include/linux/list_bl.h                       |  2 +-
 include/linux/plist.h                         |  4 ++--
 include/linux/scatterlist.h                   |  6 ++---
 kernel/notifier.c                             |  2 +-
 lib/Kconfig.debug                             | 24 ++++++++-----------
 lib/Makefile                                  |  2 +-
 lib/list_debug.c                              |  2 +-
 lib/plist.c                                   |  4 ++--
 tools/include/linux/list.h                    |  4 ++--
 .../selftests/wireguard/qemu/debug.config     |  6 ++---
 tools/virtio/linux/scatterlist.h              |  4 ++--
 26 files changed, 51 insertions(+), 55 deletions(-)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index a27592d3b1fa..a7cadc9407e0 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -299,6 +299,6 @@ CONFIG_DETECT_HUNG_TASK=y
 CONFIG_SCHEDSTATS=y
 # CONFIG_DEBUG_PREEMPT is not set
 CONFIG_DEBUG_MUTEXES=y
-CONFIG_DEBUG_SG=y
+CONFIG_CHECK_INTEGRITY_SG=y
 CONFIG_DEBUG_LL=y
 CONFIG_EARLY_PRINTK=y
diff --git a/arch/mips/configs/bigsur_defconfig b/arch/mips/configs/bigsur_defconfig
index f14ad0538f4e..61fff4050486 100644
--- a/arch/mips/configs/bigsur_defconfig
+++ b/arch/mips/configs/bigsur_defconfig
@@ -259,4 +259,4 @@ CONFIG_CRC7=m
 CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_MEMORY_INIT=y
 CONFIG_DETECT_HUNG_TASK=y
-CONFIG_DEBUG_LIST=y
+CONFIG_CHECK_INTEGRITY_LIST=y
diff --git a/arch/powerpc/configs/ppc6xx_defconfig b/arch/powerpc/configs/ppc6xx_defconfig
index 3e2f44f38ac5..6d46ff7dc1bc 100644
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -1133,8 +1133,8 @@ CONFIG_DEBUG_SHIRQ=y
 CONFIG_DEBUG_RT_MUTEXES=y
 CONFIG_DEBUG_SPINLOCK=y
 CONFIG_DEBUG_MUTEXES=y
-CONFIG_DEBUG_LIST=y
-CONFIG_DEBUG_SG=y
+CONFIG_CHECK_INTEGRITY_LIST=y
+CONFIG_CHECK_INTEGRITY_SG=y
 CONFIG_FAULT_INJECTION=y
 CONFIG_FAILSLAB=y
 CONFIG_FAIL_PAGE_ALLOC=y
diff --git a/arch/powerpc/configs/ps3_defconfig b/arch/powerpc/configs/ps3_defconfig
index 4db51719342a..12d0c10914ed 100644
--- a/arch/powerpc/configs/ps3_defconfig
+++ b/arch/powerpc/configs/ps3_defconfig
@@ -160,7 +160,7 @@ CONFIG_DEBUG_STACKOVERFLOW=y
 CONFIG_DETECT_HUNG_TASK=y
 CONFIG_PROVE_LOCKING=y
 CONFIG_DEBUG_LOCKDEP=y
-CONFIG_DEBUG_LIST=y
+CONFIG_CHECK_INTEGRITY_LIST=y
 CONFIG_RCU_CPU_STALL_TIMEOUT=60
 # CONFIG_FTRACE is not set
 CONFIG_CRYPTO_PCBC=m
diff --git a/arch/powerpc/configs/skiroot_defconfig b/arch/powerpc/configs/skiroot_defconfig
index 1b6bdad36b13..8ab17a33a1af 100644
--- a/arch/powerpc/configs/skiroot_defconfig
+++ b/arch/powerpc/configs/skiroot_defconfig
@@ -306,8 +306,8 @@ CONFIG_HARDLOCKUP_DETECTOR=y
 CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
 CONFIG_WQ_WATCHDOG=y
 # CONFIG_SCHED_DEBUG is not set
-CONFIG_DEBUG_SG=y
-CONFIG_DEBUG_NOTIFIERS=y
+CONFIG_CHECK_INTEGRITY_SG=y
+CONFIG_CHECK_INTEGRITY_NOTIFIERS=y
 CONFIG_BUG_ON_DATA_CORRUPTION=y
 CONFIG_DEBUG_CREDENTIALS=y
 # CONFIG_FTRACE is not set
diff --git a/arch/riscv/configs/defconfig b/arch/riscv/configs/defconfig
index c8f084203067..dfa157c59822 100644
--- a/arch/riscv/configs/defconfig
+++ b/arch/riscv/configs/defconfig
@@ -105,9 +105,9 @@ CONFIG_DEBUG_MUTEXES=y
 CONFIG_DEBUG_RWSEMS=y
 CONFIG_DEBUG_ATOMIC_SLEEP=y
 CONFIG_STACKTRACE=y
-CONFIG_DEBUG_LIST=y
-CONFIG_DEBUG_PLIST=y
-CONFIG_DEBUG_SG=y
+CONFIG_CHECK_INTEGRITY_LIST=y
+CONFIG_CHECK_INTEGRITY_PLIST=y
+CONFIG_CHECK_INTEGRITY_SG=y
 # CONFIG_RCU_TRACE is not set
 CONFIG_RCU_EQS_DEBUG=y
 CONFIG_DEBUG_BLOCK_EXT_DEVT=y
diff --git a/arch/riscv/configs/rv32_defconfig b/arch/riscv/configs/rv32_defconfig
index a844920a261f..1893bfaf023e 100644
--- a/arch/riscv/configs/rv32_defconfig
+++ b/arch/riscv/configs/rv32_defconfig
@@ -101,9 +101,9 @@ CONFIG_DEBUG_MUTEXES=y
 CONFIG_DEBUG_RWSEMS=y
 CONFIG_DEBUG_ATOMIC_SLEEP=y
 CONFIG_STACKTRACE=y
-CONFIG_DEBUG_LIST=y
-CONFIG_DEBUG_PLIST=y
-CONFIG_DEBUG_SG=y
+CONFIG_CHECK_INTEGRITY_LIST=y
+CONFIG_CHECK_INTEGRITY_PLIST=y
+CONFIG_CHECK_INTEGRITY_SG=y
 # CONFIG_RCU_TRACE is not set
 CONFIG_RCU_EQS_DEBUG=y
 CONFIG_DEBUG_BLOCK_EXT_DEVT=y
diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
index 0c86ba19fa2b..438eb0ce4d64 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -779,8 +779,8 @@ CONFIG_LOCK_STAT=y
 CONFIG_DEBUG_LOCKDEP=y
 CONFIG_DEBUG_ATOMIC_SLEEP=y
 CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
-CONFIG_DEBUG_SG=y
-CONFIG_DEBUG_NOTIFIERS=y
+CONFIG_CHECK_INTEGRITY_SG=y
+CONFIG_CHECK_INTEGRITY_NOTIFIERS=y
 CONFIG_BUG_ON_DATA_CORRUPTION=y
 CONFIG_DEBUG_CREDENTIALS=y
 CONFIG_RCU_TORTURE_TEST=m
diff --git a/arch/sh/configs/polaris_defconfig b/arch/sh/configs/polaris_defconfig
index e3a1d3d2694a..699610cb4333 100644
--- a/arch/sh/configs/polaris_defconfig
+++ b/arch/sh/configs/polaris_defconfig
@@ -81,4 +81,4 @@ CONFIG_DEBUG_RT_MUTEXES=y
 CONFIG_DEBUG_LOCK_ALLOC=y
 CONFIG_DEBUG_SPINLOCK_SLEEP=y
 CONFIG_DEBUG_INFO=y
-CONFIG_DEBUG_SG=y
+CONFIG_CHECK_INTEGRITY_SG=y
diff --git a/arch/sh/configs/rsk7203_defconfig b/arch/sh/configs/rsk7203_defconfig
index 10a32bd4cf66..74df7ab6a3e2 100644
--- a/arch/sh/configs/rsk7203_defconfig
+++ b/arch/sh/configs/rsk7203_defconfig
@@ -118,7 +118,7 @@ CONFIG_DEBUG_MUTEXES=y
 CONFIG_DEBUG_SPINLOCK_SLEEP=y
 CONFIG_DEBUG_INFO=y
 CONFIG_DEBUG_VM=y
-CONFIG_DEBUG_LIST=y
-CONFIG_DEBUG_SG=y
+CONFIG_CHECK_INTEGRITY_LIST=y
+CONFIG_CHECK_INTEGRITY_SG=y
 CONFIG_FRAME_POINTER=y
 CONFIG_DEBUG_STACK_USAGE=y
diff --git a/arch/sh/configs/se7206_defconfig b/arch/sh/configs/se7206_defconfig
index a93402b3a319..612cba5e1fe3 100644
--- a/arch/sh/configs/se7206_defconfig
+++ b/arch/sh/configs/se7206_defconfig
@@ -99,7 +99,7 @@ CONFIG_DEBUG_KERNEL=y
 CONFIG_DETECT_HUNG_TASK=y
 CONFIG_DEBUG_SPINLOCK_SLEEP=y
 CONFIG_DEBUG_VM=y
-CONFIG_DEBUG_LIST=y
+CONFIG_CHECK_INTEGRITY_LIST=y
 CONFIG_FRAME_POINTER=y
 CONFIG_DEBUG_STACK_USAGE=y
 CONFIG_CRYPTO_DEFLATE=y
diff --git a/drivers/gpu/drm/radeon/mkregtable.c b/drivers/gpu/drm/radeon/mkregtable.c
index 52a7246fed9e..2765c9649056 100644
--- a/drivers/gpu/drm/radeon/mkregtable.c
+++ b/drivers/gpu/drm/radeon/mkregtable.c
@@ -56,7 +56,7 @@ static inline void INIT_LIST_HEAD(struct list_head *list)
  * This is only for internal list manipulation where we know
  * the prev/next entries already!
  */
-#ifndef CONFIG_DEBUG_LIST
+#ifndef CONFIG_CHECK_INTEGRITY_LIST
 static inline void __list_add(struct list_head *new,
 			      struct list_head *prev, struct list_head *next)
 {
diff --git a/drivers/staging/wfx/fwio.c b/drivers/staging/wfx/fwio.c
index 9d61082c1e6c..e10026ae7b13 100644
--- a/drivers/staging/wfx/fwio.c
+++ b/drivers/staging/wfx/fwio.c
@@ -74,7 +74,7 @@ static const char * const fwio_errors[] = {
  * underlying hardware that use DMA. Function below detect this case and
  * allocate a bounce buffer if necessary.
  *
- * Notice that, in doubt, you can enable CONFIG_DEBUG_SG to ask kernel to
+ * Notice that, in doubt, you can enable CONFIG_CHECK_INTEGRITY_SG to ask kernel to
  * detect this problem at runtime  (else, kernel silently fail).
  *
  * NOTE: it may also be possible to use 'pages' from struct firmware and avoid
diff --git a/drivers/staging/wfx/hwio.c b/drivers/staging/wfx/hwio.c
index 47e04c59ed93..3524b1b38d8e 100644
--- a/drivers/staging/wfx/hwio.c
+++ b/drivers/staging/wfx/hwio.c
@@ -22,7 +22,7 @@
  * allocated data. Functions below that work with registers (aka functions
  * ending with "32") automatically reallocate buffers with kmalloc. However,
  * functions that work with arbitrary length buffers let's caller to handle
- * memory location. In doubt, enable CONFIG_DEBUG_SG to detect badly located
+ * memory location. In doubt, enable CONFIG_CHECK_INTEGRITY_SG to detect badly located
  * buffer.
  */
 
diff --git a/include/linux/list.h b/include/linux/list.h
index b86a3f9465d4..2bef081afa69 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -36,7 +36,7 @@ static inline void INIT_LIST_HEAD(struct list_head *list)
 	list->prev = list;
 }
 
-#ifdef CONFIG_DEBUG_LIST
+#ifdef CONFIG_CHECK_INTEGRITY_LIST
 extern bool __list_add_valid(struct list_head *new,
 			      struct list_head *prev,
 			      struct list_head *next);
diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
index c93e7e3aa8fc..9f8e29142324 100644
--- a/include/linux/list_bl.h
+++ b/include/linux/list_bl.h
@@ -24,7 +24,7 @@
 #define LIST_BL_LOCKMASK	0UL
 #endif
 
-#ifdef CONFIG_DEBUG_LIST
+#ifdef CONFIG_CHECK_INTEGRITY_LIST
 #define LIST_BL_BUG_ON(x) BUG_ON(x)
 #else
 #define LIST_BL_BUG_ON(x)
diff --git a/include/linux/plist.h b/include/linux/plist.h
index 66bab1bca35c..da85b42c9ebf 100644
--- a/include/linux/plist.h
+++ b/include/linux/plist.h
@@ -229,7 +229,7 @@ static inline int plist_node_empty(const struct plist_node *node)
  * @type:	the type of the struct this is embedded in
  * @member:	the name of the list_head within the struct
  */
-#ifdef CONFIG_DEBUG_PLIST
+#ifdef CONFIG_CHECK_INTEGRITY_PLIST
 # define plist_first_entry(head, type, member)	\
 ({ \
 	WARN_ON(plist_head_empty(head)); \
@@ -246,7 +246,7 @@ static inline int plist_node_empty(const struct plist_node *node)
  * @type:	the type of the struct this is embedded in
  * @member:	the name of the list_head within the struct
  */
-#ifdef CONFIG_DEBUG_PLIST
+#ifdef CONFIG_CHECK_INTEGRITY_PLIST
 # define plist_last_entry(head, type, member)	\
 ({ \
 	WARN_ON(plist_head_empty(head)); \
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 6eec50fb36c8..f9dc7e730a68 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -93,7 +93,7 @@ static inline void sg_assign_page(struct scatterlist *sg, struct page *page)
 	 * must be aligned at a 32-bit boundary as a minimum.
 	 */
 	BUG_ON((unsigned long) page & (SG_CHAIN | SG_END));
-#ifdef CONFIG_DEBUG_SG
+#ifdef CONFIG_CHECK_INTEGRITY_SG
 	BUG_ON(sg_is_chain(sg));
 #endif
 	sg->page_link = page_link | (unsigned long) page;
@@ -123,7 +123,7 @@ static inline void sg_set_page(struct scatterlist *sg, struct page *page,
 
 static inline struct page *sg_page(struct scatterlist *sg)
 {
-#ifdef CONFIG_DEBUG_SG
+#ifdef CONFIG_CHECK_INTEGRITY_SG
 	BUG_ON(sg_is_chain(sg));
 #endif
 	return (struct page *)((sg)->page_link & ~(SG_CHAIN | SG_END));
@@ -139,7 +139,7 @@ static inline struct page *sg_page(struct scatterlist *sg)
 static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
 			      unsigned int buflen)
 {
-#ifdef CONFIG_DEBUG_SG
+#ifdef CONFIG_CHECK_INTEGRITY_SG
 	BUG_ON(!virt_addr_valid(buf));
 #endif
 	sg_set_page(sg, virt_to_page(buf), buflen, offset_in_page(buf));
diff --git a/kernel/notifier.c b/kernel/notifier.c
index 63d7501ac638..b4c799b80227 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -73,7 +73,7 @@ static int notifier_call_chain(struct notifier_block **nl,
 	while (nb && nr_to_call) {
 		next_nb = rcu_dereference_raw(nb->next);
 
-#ifdef CONFIG_DEBUG_NOTIFIERS
+#ifdef CONFIG_CHECK_INTEGRITY_NOTIFIERS
 		if (unlikely(!func_ptr_is_kernel_text(nb->notifier_call))) {
 			WARN(1, "Invalid notifier called!");
 			nb = next_nb;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1458505192cd..f05ea01b30a7 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1312,20 +1312,18 @@ config DEBUG_KOBJECT_RELEASE
 config HAVE_DEBUG_BUGVERBOSE
 	bool
 
-menu "Debug kernel data structures"
+menu "Kernel data structure integrity"
 
-config DEBUG_LIST
-	bool "Debug linked list manipulation"
-	depends on DEBUG_KERNEL || BUG_ON_DATA_CORRUPTION
+config CHECK_INTEGRITY_LIST
+	bool "Check integrity of linked list manipulation"
 	help
 	  Enable this to turn on extended checks in the linked-list
 	  walking routines.
 
 	  If unsure, say N.
 
-config DEBUG_PLIST
-	bool "Debug priority linked list manipulation"
-	depends on DEBUG_KERNEL
+config CHECK_INTEGRITY_PLIST
+	bool "Check integrity of priority linked list manipulation"
 	help
 	  Enable this to turn on extended checks in the priority-ordered
 	  linked-list (plist) walking routines.  This checks the entire
@@ -1333,9 +1331,8 @@ config DEBUG_PLIST
 
 	  If unsure, say N.
 
-config DEBUG_SG
-	bool "Debug SG table operations"
-	depends on DEBUG_KERNEL
+config CHECK_INTEGRITY_SG
+	bool "Check integrity of SG table operations"
 	help
 	  Enable this to turn on checks on scatter-gather tables. This can
 	  help find problems with drivers that do not properly initialize
@@ -1343,9 +1340,8 @@ config DEBUG_SG
 
 	  If unsure, say N.
 
-config DEBUG_NOTIFIERS
-	bool "Debug notifier call chains"
-	depends on DEBUG_KERNEL
+config CHECK_INTEGRITY_NOTIFIERS
+	bool "Check integrity of notifier call chains"
 	help
 	  Enable this to turn on sanity checking for notifier call chains.
 	  This is most useful for kernel developers to make sure that
@@ -1355,7 +1351,7 @@ config DEBUG_NOTIFIERS
 
 config BUG_ON_DATA_CORRUPTION
 	bool "Trigger a BUG when data corruption is detected"
-	select DEBUG_LIST
+	select CHECK_INTEGRITY_LIST
 	help
 	  Select this option if the kernel should BUG when it encounters
 	  data corruption in kernel memory structures when they get checked
diff --git a/lib/Makefile b/lib/Makefile
index f19b85c87fda..6a3888dac634 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -121,7 +121,7 @@ obj-$(CONFIG_BTREE) += btree.o
 obj-$(CONFIG_INTERVAL_TREE) += interval_tree.o
 obj-$(CONFIG_ASSOCIATIVE_ARRAY) += assoc_array.o
 obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
-obj-$(CONFIG_DEBUG_LIST) += list_debug.o
+obj-$(CONFIG_CHECK_INTEGRITY_LIST) += list_debug.o
 obj-$(CONFIG_DEBUG_OBJECTS) += debugobjects.o
 
 obj-$(CONFIG_BITREVERSE) += bitrev.o
diff --git a/lib/list_debug.c b/lib/list_debug.c
index 5d5424b51b74..57bf685af2ef 100644
--- a/lib/list_debug.c
+++ b/lib/list_debug.c
@@ -2,7 +2,7 @@
  * Copyright 2006, Red Hat, Inc., Dave Jones
  * Released under the General Public License (GPL).
  *
- * This file contains the linked list validation for DEBUG_LIST.
+ * This file contains the linked list validation for CHECK_INTEGRITY_LIST.
  */
 
 #include <linux/export.h>
diff --git a/lib/plist.c b/lib/plist.c
index 0d86ed7a76ac..c06e98e78259 100644
--- a/lib/plist.c
+++ b/lib/plist.c
@@ -25,7 +25,7 @@
 #include <linux/bug.h>
 #include <linux/plist.h>
 
-#ifdef CONFIG_DEBUG_PLIST
+#ifdef CONFIG_CHECK_INTEGRITY_PLIST
 
 static struct plist_head test_head;
 
@@ -172,7 +172,7 @@ void plist_requeue(struct plist_node *node, struct plist_head *head)
 	plist_check_head(head);
 }
 
-#ifdef CONFIG_DEBUG_PLIST
+#ifdef CONFIG_CHECK_INTEGRITY_PLIST
 #include <linux/sched.h>
 #include <linux/sched/clock.h>
 #include <linux/module.h>
diff --git a/tools/include/linux/list.h b/tools/include/linux/list.h
index b2fc48d5478c..7a7a7f1cf380 100644
--- a/tools/include/linux/list.h
+++ b/tools/include/linux/list.h
@@ -34,7 +34,7 @@ static inline void INIT_LIST_HEAD(struct list_head *list)
  * This is only for internal list manipulation where we know
  * the prev/next entries already!
  */
-#ifndef CONFIG_DEBUG_LIST
+#ifndef CONFIG_CHECK_INTEGRITY_LIST
 static inline void __list_add(struct list_head *new,
 			      struct list_head *prev,
 			      struct list_head *next)
@@ -96,7 +96,7 @@ static inline void __list_del(struct list_head * prev, struct list_head * next)
  * Note: list_empty() on entry does not return true after this, the entry is
  * in an undefined state.
  */
-#ifndef CONFIG_DEBUG_LIST
+#ifndef CONFIG_CHECK_INTEGRITY_LIST
 static inline void __list_del_entry(struct list_head *entry)
 {
 	__list_del(entry->prev, entry->next);
diff --git a/tools/testing/selftests/wireguard/qemu/debug.config b/tools/testing/selftests/wireguard/qemu/debug.config
index 5909e7ef2a5c..04f8ed0600e1 100644
--- a/tools/testing/selftests/wireguard/qemu/debug.config
+++ b/tools/testing/selftests/wireguard/qemu/debug.config
@@ -48,7 +48,7 @@ CONFIG_LOCKDEP=y
 CONFIG_DEBUG_ATOMIC_SLEEP=y
 CONFIG_TRACE_IRQFLAGS=y
 CONFIG_DEBUG_BUGVERBOSE=y
-CONFIG_DEBUG_LIST=y
+CONFIG_CHECK_INTEGRITY_LIST=y
 CONFIG_DEBUG_PI_LIST=y
 CONFIG_PROVE_RCU=y
 CONFIG_SPARSE_RCU_POINTER=y
@@ -56,8 +56,8 @@ CONFIG_RCU_CPU_STALL_TIMEOUT=21
 CONFIG_RCU_TRACE=y
 CONFIG_RCU_EQS_DEBUG=y
 CONFIG_USER_STACKTRACE_SUPPORT=y
-CONFIG_DEBUG_SG=y
-CONFIG_DEBUG_NOTIFIERS=y
+CONFIG_CHECK_INTEGRITY_SG=y
+CONFIG_CHECK_INTEGRITY_NOTIFIERS=y
 CONFIG_DOUBLEFAULT=y
 CONFIG_X86_DEBUG_FPU=y
 CONFIG_DEBUG_SECTION_MISMATCH=y
diff --git a/tools/virtio/linux/scatterlist.h b/tools/virtio/linux/scatterlist.h
index 369ee308b668..9fe5341b5a4a 100644
--- a/tools/virtio/linux/scatterlist.h
+++ b/tools/virtio/linux/scatterlist.h
@@ -35,7 +35,7 @@ static inline void sg_assign_page(struct scatterlist *sg, struct page *page)
 	 * must be aligned at a 32-bit boundary as a minimum.
 	 */
 	BUG_ON((unsigned long) page & 0x03);
-#ifdef CONFIG_DEBUG_SG
+#ifdef CONFIG_CHECK_INTEGRITY_SG
 	BUG_ON(sg_is_chain(sg));
 #endif
 	sg->page_link = page_link | (unsigned long) page;
@@ -65,7 +65,7 @@ static inline void sg_set_page(struct scatterlist *sg, struct page *page,
 
 static inline struct page *sg_page(struct scatterlist *sg)
 {
-#ifdef CONFIG_DEBUG_SG
+#ifdef CONFIG_CHECK_INTEGRITY_SG
 	BUG_ON(sg_is_chain(sg));
 #endif
 	return (struct page *)((sg)->page_link & ~0x3);
-- 
2.20.1

