From: Igor Stoppa <igor.stoppa@gmail.com>
Subject: [PATCH 01/17] prmem: linker section for static write rare
Date: Wed, 24 Oct 2018 00:34:48 +0300
Message-Id: <20181023213504.28905-2-igor.stoppa@huawei.com>
In-Reply-To: <20181023213504.28905-1-igor.stoppa@huawei.com>
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: igor.stoppa@huawei.com, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Introduce a section and a label for statically allocated write rare
data.

The label is named "__write_rare_after_init".
As the name implies, after the init phase is completed, this section
will be modifiable only by invoking write rare functions.

NOTE:
this needs rework, because the current write-rare mechanism works
only on x86_64 and not arm64, due to arm64 mappings.

Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
CC: Arnd Bergmann <arnd@arndb.de>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Kate Stewart <kstewart@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Philippe Ombredanne <pombredanne@nexb.com>
CC: linux-arch@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 include/asm-generic/vmlinux.lds.h | 20 ++++++++++++++++++++
 include/linux/cache.h             | 17 +++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index d7701d466b60..fd40a15e3b24 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -300,6 +300,25 @@
 	. = __start_init_task + THREAD_SIZE;				\
 	__end_init_task = .;
 
+/*
+ * Allow architectures to handle wr_after_init data on their
+ * own by defining an empty WR_AFTER_INIT_DATA.
+ * However, it's important that pages containing WR_RARE data do not
+ * hold anything else, to avoid both accidentally unprotecting something
+ * that is supposed to stay read-only all the time and also to protect
+ * something else that is supposed to be writeable all the time.
+ */
+#ifndef WR_AFTER_INIT_DATA
+#define WR_AFTER_INIT_DATA(align)					\
+	. = ALIGN(PAGE_SIZE);						\
+	__start_wr_after_init = .;					\
+	. = ALIGN(align);						\
+	*(.data..wr_after_init)						\
+	. = ALIGN(PAGE_SIZE);						\
+	__end_wr_after_init = .;					\
+	. = ALIGN(align);
+#endif
+
 /*
  * Allow architectures to handle ro_after_init data on their
  * own by defining an empty RO_AFTER_INIT_DATA.
@@ -320,6 +339,7 @@
 		__start_rodata = .;					\
 		*(.rodata) *(.rodata.*)					\
 		RO_AFTER_INIT_DATA	/* Read only after init */	\
+		WR_AFTER_INIT_DATA(align) /* wr after init */	\
 		KEEP(*(__vermagic))	/* Kernel version magic */	\
 		. = ALIGN(8);						\
 		__start___tracepoints_ptrs = .;				\
diff --git a/include/linux/cache.h b/include/linux/cache.h
index 750621e41d1c..9a7e7134b887 100644
--- a/include/linux/cache.h
+++ b/include/linux/cache.h
@@ -31,6 +31,23 @@
 #define __ro_after_init __attribute__((__section__(".data..ro_after_init")))
 #endif
 
+/*
+ * __wr_after_init is used to mark objects that cannot be modified
+ * directly after init (i.e. after mark_rodata_ro() has been called).
+ * These objects become effectively read-only, from the perspective of
+ * performing a direct write, like a variable assignment.
+ * However, they can be altered through a dedicated function.
+ * It is intended for those objects which are occasionally modified after
+ * init, however they are modified so seldomly, that the extra cost from
+ * the indirect modification is either negligible or worth paying, for the
+ * sake of the protection gained.
+ */
+#ifndef __wr_after_init
+#define __wr_after_init \
+		__attribute__((__section__(".data..wr_after_init")))
+#endif
+
+
 #ifndef ____cacheline_aligned
 #define ____cacheline_aligned __attribute__((__aligned__(SMP_CACHE_BYTES)))
 #endif
-- 
2.17.1
