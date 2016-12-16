Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Fri, 16 Dec 2016 14:06:23 -0800
Message-Id: <1481925984-98605-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1481925984-98605-1-git-send-email-keescook@chromium.org>
References: <1481925984-98605-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v4 3/4] initify: Mark functions with the __nocapture attribute
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Josh Triplett <josh@joshtriplett.org>, pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, sam@ravnborg.org
List-ID: <kernel-hardening.lists.openwall.com>

From: Emese Revfy <re.emese@gmail.com>

The nocapture gcc attribute can be on functions only. The attribute
takes zero or more signed integer constants as parameters that specify
the function parameters to initify when the passed arguments are of const
char* type.

A negative attribute parameter value means that the corresponding function
parameter is returned by the function and the passed argument will only be
initified if the data flow of the returned value is not captured in the caller.

If no values are passed to the attribute then all function parameters are
treated as nocapture.

If the marked parameter is a vararg then the plugin initifies all vararg
arguments.

I couldn't test the arm, arm64 and powerpc architectures.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/include/asm/string.h     | 10 +++---
 arch/arm64/include/asm/string.h   | 25 ++++++-------
 arch/powerpc/include/asm/string.h | 19 +++++-----
 arch/x86/include/asm/string_32.h  | 25 ++++++-------
 arch/x86/include/asm/string_64.h  | 23 ++++++------
 arch/x86/kernel/hpet.c            |  2 +-
 drivers/acpi/acpica/acutils.h     |  2 +-
 fs/char_dev.c                     |  2 +-
 fs/ntfs/debug.h                   |  6 ++--
 fs/ocfs2/cluster/masklog.h        |  2 +-
 include/acpi/acpixf.h             |  2 +-
 include/asm-generic/bug.h         |  7 ++--
 include/drm/drmP.h                |  2 +-
 include/linux/audit.h             |  5 +--
 include/linux/fs.h                |  8 +++--
 include/linux/printk.h            |  2 +-
 include/linux/ratelimit.h         |  3 +-
 include/linux/string.h            | 75 ++++++++++++++++++++-------------------
 lib/vsprintf.c                    |  6 ++--
 mm/util.c                         |  2 +-
 security/integrity/integrity.h    |  2 +-
 21 files changed, 121 insertions(+), 109 deletions(-)

diff --git a/arch/arm/include/asm/string.h b/arch/arm/include/asm/string.h
index cf4f3aad0fc1..8f2f2d9a6549 100644
--- a/arch/arm/include/asm/string.h
+++ b/arch/arm/include/asm/string.h
@@ -7,19 +7,19 @@
  */
 
 #define __HAVE_ARCH_STRRCHR
-extern char * strrchr(const char * s, int c);
+extern char * strrchr(const char * s, int c) __nocapture(-1);
 
 #define __HAVE_ARCH_STRCHR
-extern char * strchr(const char * s, int c);
+extern char * strchr(const char * s, int c) __nocapture(-1);
 
 #define __HAVE_ARCH_MEMCPY
-extern void * memcpy(void *, const void *, __kernel_size_t);
+extern void * memcpy(void *, const void *, __kernel_size_t) __nocapture(2);
 
 #define __HAVE_ARCH_MEMMOVE
-extern void * memmove(void *, const void *, __kernel_size_t);
+extern void * memmove(void *, const void *, __kernel_size_t) __nocapture(2);
 
 #define __HAVE_ARCH_MEMCHR
-extern void * memchr(const void *, int, __kernel_size_t);
+extern void * memchr(const void *, int, __kernel_size_t) __nocapture(-1);
 
 #define __HAVE_ARCH_MEMSET
 extern void * memset(void *, int, __kernel_size_t);
diff --git a/arch/arm64/include/asm/string.h b/arch/arm64/include/asm/string.h
index 2eb714c4639f..188a1022c764 100644
--- a/arch/arm64/include/asm/string.h
+++ b/arch/arm64/include/asm/string.h
@@ -17,40 +17,41 @@
 #define __ASM_STRING_H
 
 #define __HAVE_ARCH_STRRCHR
-extern char *strrchr(const char *, int c);
+extern char *strrchr(const char *, int c) __nocapture(-1);
 
 #define __HAVE_ARCH_STRCHR
-extern char *strchr(const char *, int c);
+extern char *strchr(const char *, int c) __nocapture(-1);
 
 #define __HAVE_ARCH_STRCMP
-extern int strcmp(const char *, const char *);
+extern int strcmp(const char *, const char *) __nocapture();
 
 #define __HAVE_ARCH_STRNCMP
-extern int strncmp(const char *, const char *, __kernel_size_t);
+extern int
+strncmp(const char *, const char *, __kernel_size_t) __nocapture(1, 2);
 
 #define __HAVE_ARCH_STRLEN
-extern __kernel_size_t strlen(const char *);
+extern __kernel_size_t strlen(const char *) __nocapture(1);
 
 #define __HAVE_ARCH_STRNLEN
-extern __kernel_size_t strnlen(const char *, __kernel_size_t);
+extern __kernel_size_t strnlen(const char *, __kernel_size_t) __nocapture(1);
 
 #define __HAVE_ARCH_MEMCPY
-extern void *memcpy(void *, const void *, __kernel_size_t);
-extern void *__memcpy(void *, const void *, __kernel_size_t);
+extern void *memcpy(void *, const void *, __kernel_size_t) __nocapture(2);
+extern void *__memcpy(void *, const void *, __kernel_size_t) __nocapture(2);
 
 #define __HAVE_ARCH_MEMMOVE
-extern void *memmove(void *, const void *, __kernel_size_t);
-extern void *__memmove(void *, const void *, __kernel_size_t);
+extern void *memmove(void *, const void *, __kernel_size_t) __nocapture(2);
+extern void *__memmove(void *, const void *, __kernel_size_t) __nocapture(2);
 
 #define __HAVE_ARCH_MEMCHR
-extern void *memchr(const void *, int, __kernel_size_t);
+extern void *memchr(const void *, int, __kernel_size_t) __nocapture(-1);
 
 #define __HAVE_ARCH_MEMSET
 extern void *memset(void *, int, __kernel_size_t);
 extern void *__memset(void *, int, __kernel_size_t);
 
 #define __HAVE_ARCH_MEMCMP
-extern int memcmp(const void *, const void *, size_t);
+extern int memcmp(const void *, const void *, size_t) __nocapture(1, 2);
 
 
 #if defined(CONFIG_KASAN) && !defined(__SANITIZE_ADDRESS__)
diff --git a/arch/powerpc/include/asm/string.h b/arch/powerpc/include/asm/string.h
index da3cdffca440..ba08cf461ca2 100644
--- a/arch/powerpc/include/asm/string.h
+++ b/arch/powerpc/include/asm/string.h
@@ -11,16 +11,17 @@
 #define __HAVE_ARCH_MEMCMP
 #define __HAVE_ARCH_MEMCHR
 
-extern char * strcpy(char *,const char *);
-extern char * strncpy(char *,const char *, __kernel_size_t);
-extern __kernel_size_t strlen(const char *);
-extern int strcmp(const char *,const char *);
-extern int strncmp(const char *, const char *, __kernel_size_t);
-extern char * strcat(char *, const char *);
+extern char * strcpy(char *,const char *) __nocapture(2);
+extern char * strncpy(char *,const char *, __kernel_size_t) __nocapture(2);
+extern __kernel_size_t strlen(const char *) __nocapture(1);
+extern int strcmp(const char *,const char *) __nocapture();
+extern int
+strncmp(const char *, const char *, __kernel_size_t) __nocapture(1, 2);
+extern char * strcat(char *, const char *) __nocapture(2);
 extern void * memset(void *,int,__kernel_size_t);
-extern void * memcpy(void *,const void *,__kernel_size_t);
-extern void * memmove(void *,const void *,__kernel_size_t);
-extern int memcmp(const void *,const void *,__kernel_size_t);
+extern void * memcpy(void *,const void *,__kernel_size_t) __nocapture(2);
+extern void * memmove(void *,const void *,__kernel_size_t) __nocapture(2);
+extern int memcmp(const void *,const void *,__kernel_size_t) __nocapture(1, 2);
 extern void * memchr(const void *,int,__kernel_size_t);
 
 #endif /* __KERNEL__ */
diff --git a/arch/x86/include/asm/string_32.h b/arch/x86/include/asm/string_32.h
index 3d3e8353ee5c..db6fe4c3d1e8 100644
--- a/arch/x86/include/asm/string_32.h
+++ b/arch/x86/include/asm/string_32.h
@@ -6,28 +6,29 @@
 /* Let gcc decide whether to inline or use the out of line functions */
 
 #define __HAVE_ARCH_STRCPY
-extern char *strcpy(char *dest, const char *src);
+extern char *strcpy(char *dest, const char *src) __nocapture(2);
 
 #define __HAVE_ARCH_STRNCPY
-extern char *strncpy(char *dest, const char *src, size_t count);
+extern char *strncpy(char *dest, const char *src, size_t count) __nocapture(2);
 
 #define __HAVE_ARCH_STRCAT
-extern char *strcat(char *dest, const char *src);
+extern char *strcat(char *dest, const char *src) __nocapture(2);
 
 #define __HAVE_ARCH_STRNCAT
-extern char *strncat(char *dest, const char *src, size_t count);
+extern char *strncat(char *dest, const char *src, size_t count) __nocapture(2);
 
 #define __HAVE_ARCH_STRCMP
-extern int strcmp(const char *cs, const char *ct);
+extern int strcmp(const char *cs, const char *ct) __nocapture();
 
 #define __HAVE_ARCH_STRNCMP
-extern int strncmp(const char *cs, const char *ct, size_t count);
+extern int
+strncmp(const char *cs, const char *ct, size_t count) __nocapture(1, 2);
 
 #define __HAVE_ARCH_STRCHR
-extern char *strchr(const char *s, int c);
+extern char *strchr(const char *s, int c) __nocapture(-1);
 
 #define __HAVE_ARCH_STRLEN
-extern size_t strlen(const char *s);
+extern size_t strlen(const char *s) __nocapture(1);
 
 static __always_inline void *__memcpy(void *to, const void *from, size_t n)
 {
@@ -197,12 +198,12 @@ static inline void *__memcpy3d(void *to, const void *from, size_t len)
 #endif
 
 #define __HAVE_ARCH_MEMMOVE
-void *memmove(void *dest, const void *src, size_t n);
+void *memmove(void *dest, const void *src, size_t n) __nocapture(2);
 
 #define memcmp __builtin_memcmp
 
 #define __HAVE_ARCH_MEMCHR
-extern void *memchr(const void *cs, int c, size_t count);
+extern void *memchr(const void *cs, int c, size_t count) __nocapture(-1);
 
 static inline void *__memset_generic(void *s, char c, size_t count)
 {
@@ -243,11 +244,11 @@ void *__constant_c_memset(void *s, unsigned long c, size_t count)
 
 /* Added by Gertjan van Wingerde to make minix and sysv module work */
 #define __HAVE_ARCH_STRNLEN
-extern size_t strnlen(const char *s, size_t count);
+extern size_t strnlen(const char *s, size_t count) __nocapture(1);
 /* end of additional stuff */
 
 #define __HAVE_ARCH_STRSTR
-extern char *strstr(const char *cs, const char *ct);
+extern char *strstr(const char *cs, const char *ct) __nocapture(-1, 2);
 
 /*
  * This looks horribly ugly, but the compiler can optimize it totally,
diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index a164862d77e3..e06b6eb806ac 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -28,8 +28,8 @@ static __always_inline void *__inline_memcpy(void *to, const void *from, size_t
    function. */
 
 #define __HAVE_ARCH_MEMCPY 1
-extern void *memcpy(void *to, const void *from, size_t len);
-extern void *__memcpy(void *to, const void *from, size_t len);
+extern void *memcpy(void *to, const void *from, size_t len) __nocapture(2);
+extern void *__memcpy(void *to, const void *from, size_t len) __nocapture(2);
 
 #ifndef CONFIG_KMEMCHECK
 #if (__GNUC__ == 4 && __GNUC_MINOR__ < 3) || __GNUC__ < 4
@@ -57,14 +57,14 @@ void *memset(void *s, int c, size_t n);
 void *__memset(void *s, int c, size_t n);
 
 #define __HAVE_ARCH_MEMMOVE
-void *memmove(void *dest, const void *src, size_t count);
-void *__memmove(void *dest, const void *src, size_t count);
+void *memmove(void *dest, const void *src, size_t count) __nocapture(2);
+void *__memmove(void *dest, const void *src, size_t count) __nocapture(2);
 
-int memcmp(const void *cs, const void *ct, size_t count);
-size_t strlen(const char *s);
-char *strcpy(char *dest, const char *src);
-char *strcat(char *dest, const char *src);
-int strcmp(const char *cs, const char *ct);
+int memcmp(const void *cs, const void *ct, size_t count) __nocapture(1, 2);
+size_t strlen(const char *s) __nocapture(1);
+char *strcpy(char *dest, const char *src) __nocapture(2);
+char *strcat(char *dest, const char *src) __nocapture(2);
+int strcmp(const char *cs, const char *ct) __nocapture(1, 2);
 
 #if defined(CONFIG_KASAN) && !defined(__SANITIZE_ADDRESS__)
 
@@ -79,7 +79,8 @@ int strcmp(const char *cs, const char *ct);
 #define memset(s, c, n) __memset(s, c, n)
 #endif
 
-__must_check int memcpy_mcsafe_unrolled(void *dst, const void *src, size_t cnt);
+__must_check __nocapture(2) int
+memcpy_mcsafe_unrolled(void *dst, const void *src, size_t cnt);
 DECLARE_STATIC_KEY_FALSE(mcsafe_key);
 
 /**
@@ -96,7 +97,7 @@ DECLARE_STATIC_KEY_FALSE(mcsafe_key);
  *
  * Return 0 for success, -EFAULT for fail
  */
-static __always_inline __must_check int
+static __always_inline __must_check __nocapture(2) int
 memcpy_mcsafe(void *dst, const void *src, size_t cnt)
 {
 #ifdef CONFIG_X86_MCE
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 274fab99169d..b863fc09022d 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -136,7 +136,7 @@ int is_hpet_enabled(void)
 }
 EXPORT_SYMBOL_GPL(is_hpet_enabled);
 
-static void _hpet_print_config(const char *function, int line)
+static void __nocapture(1) _hpet_print_config(const char *function, int line)
 {
 	u32 i, timers, l, h;
 	printk(KERN_INFO "hpet: %s(%d):\n", function, line);
diff --git a/drivers/acpi/acpica/acutils.h b/drivers/acpi/acpica/acutils.h
index 0a1b53c9ee0e..2349b23e86c5 100644
--- a/drivers/acpi/acpica/acutils.h
+++ b/drivers/acpi/acpica/acutils.h
@@ -289,7 +289,7 @@ void acpi_ut_init_stack_ptr_trace(void);
 
 void acpi_ut_track_stack_ptr(void);
 
-void
+__nocapture(2) void
 acpi_ut_trace(u32 line_number,
 	      const char *function_name,
 	      const char *module_name, u32 component_id);
diff --git a/fs/char_dev.c b/fs/char_dev.c
index 44a240c4bb65..3bc97002c86f 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -70,7 +70,7 @@ void chrdev_show(struct seq_file *f, off_t offset)
  *
  * Returns a -ve errno on failure.
  */
-static struct char_device_struct *
+static __nocapture(4) struct char_device_struct *
 __register_chrdev_region(unsigned int major, unsigned int baseminor,
 			   int minorct, const char *name)
 {
diff --git a/fs/ntfs/debug.h b/fs/ntfs/debug.h
index 61bf091e32a8..6ac561943118 100644
--- a/fs/ntfs/debug.h
+++ b/fs/ntfs/debug.h
@@ -30,7 +30,7 @@
 
 extern int debug_msgs;
 
-extern __printf(4, 5)
+extern __printf(4, 5) __nocapture(3)
 void __ntfs_debug(const char *file, int line, const char *function,
 		  const char *format, ...);
 /**
@@ -58,12 +58,12 @@ do {									\
 
 #endif	/* !DEBUG */
 
-extern  __printf(3, 4)
+extern  __printf(3, 4) __nocapture(1)
 void __ntfs_warning(const char *function, const struct super_block *sb,
 		    const char *fmt, ...);
 #define ntfs_warning(sb, f, a...)	__ntfs_warning(__func__, sb, f, ##a)
 
-extern  __printf(3, 4)
+extern  __printf(3, 4) __nocapture(1)
 void __ntfs_error(const char *function, const struct super_block *sb,
 		  const char *fmt, ...);
 #define ntfs_error(sb, f, a...)		__ntfs_error(__func__, sb, f, ##a)
diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
index 308ea0eb35fd..3c16da69605d 100644
--- a/fs/ocfs2/cluster/masklog.h
+++ b/fs/ocfs2/cluster/masklog.h
@@ -162,7 +162,7 @@ extern struct mlog_bits mlog_and_bits, mlog_not_bits;
 
 #endif
 
-__printf(4, 5)
+__printf(4, 5) __nocapture(2)
 void __mlog_printk(const u64 *m, const char *func, int line,
 		   const char *fmt, ...);
 
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index c7b3a132dbe7..951c1f41024f 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -929,7 +929,7 @@ ACPI_MSG_DEPENDENT_RETURN_VOID(ACPI_PRINTF_LIKE(3)
 /*
  * Debug output
  */
-ACPI_DBG_DEPENDENT_RETURN_VOID(ACPI_PRINTF_LIKE(6)
+ACPI_DBG_DEPENDENT_RETURN_VOID(ACPI_PRINTF_LIKE(6) __nocapture(3)
 			       void ACPI_INTERNAL_VAR_XFACE
 			       acpi_debug_print(u32 requested_debug_level,
 						u32 line_number,
diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 6f96247226a4..f6ae0d76f2e7 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -62,13 +62,13 @@ struct bug_entry {
  * to provide better diagnostics.
  */
 #ifndef __WARN_TAINT
-extern __printf(3, 4)
+extern __printf(3, 4) __nocapture(1)
 void warn_slowpath_fmt(const char *file, const int line,
 		       const char *fmt, ...);
-extern __printf(4, 5)
+extern __printf(4, 5) __nocapture(1)
 void warn_slowpath_fmt_taint(const char *file, const int line, unsigned taint,
 			     const char *fmt, ...);
-extern void warn_slowpath_null(const char *file, const int line);
+extern __nocapture(1) void warn_slowpath_null(const char *file, const int line);
 #define WANT_WARN_ON_SLOWPATH
 #define __WARN()		warn_slowpath_null(__FILE__, __LINE__)
 #define __WARN_printf(arg...)	warn_slowpath_fmt(__FILE__, __LINE__, arg)
@@ -84,6 +84,7 @@ extern void warn_slowpath_null(const char *file, const int line);
 /* used internally by panic.c */
 struct warn_args;
 
+__nocapture(1, 0)
 void __warn(const char *file, int line, void *caller, unsigned taint,
 	    struct pt_regs *regs, struct warn_args *args);
 
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 672644031bd5..231aebeed9be 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -136,7 +136,7 @@ struct dma_buf_attachment;
 #define DRM_UT_ATOMIC		0x10
 #define DRM_UT_VBL		0x20
 
-extern __printf(6, 7)
+extern __printf(6, 7) __nocapture(4)
 void drm_dev_printk(const struct device *dev, const char *level,
 		    unsigned int category, const char *function_name,
 		    const char *prefix, const char *format, ...);
diff --git a/include/linux/audit.h b/include/linux/audit.h
index 9d4443f93db6..730485bb4b65 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -135,7 +135,7 @@ extern void		    audit_log_n_hex(struct audit_buffer *ab,
 					  size_t len);
 extern void		    audit_log_n_string(struct audit_buffer *ab,
 					       const char *buf,
-					       size_t n);
+					       size_t n) __nocapture(2);
 extern void		    audit_log_n_untrustedstring(struct audit_buffer *ab,
 							const char *string,
 							size_t n);
@@ -552,7 +552,8 @@ static inline bool audit_loginuid_set(struct task_struct *tsk)
 	return uid_valid(audit_get_loginuid(tsk));
 }
 
-static inline void audit_log_string(struct audit_buffer *ab, const char *buf)
+static inline __nocapture(2)
+void audit_log_string(struct audit_buffer *ab, const char *buf)
 {
 	audit_log_n_string(ab, buf, strlen(buf));
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index dc0478c07b2a..37fb674893a8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2456,13 +2456,15 @@ static inline void bd_unlink_disk_holder(struct block_device *bdev,
 #define CHRDEV_MAJOR_HASH_SIZE	255
 /* Marks the bottom of the first segment of free char majors */
 #define CHRDEV_MAJOR_DYN_END 234
-extern int alloc_chrdev_region(dev_t *, unsigned, unsigned, const char *);
+extern int __nocapture(4)
+alloc_chrdev_region(dev_t *, unsigned, unsigned, const char *);
 extern int register_chrdev_region(dev_t, unsigned, const char *);
 extern int __register_chrdev(unsigned int major, unsigned int baseminor,
 			     unsigned int count, const char *name,
 			     const struct file_operations *fops);
-extern void __unregister_chrdev(unsigned int major, unsigned int baseminor,
-				unsigned int count, const char *name);
+extern __nocapture(4) void __unregister_chrdev(unsigned int major,
+				unsigned int baseminor, unsigned int count,
+				const char *name);
 extern void unregister_chrdev_region(dev_t, unsigned);
 extern void chrdev_show(struct seq_file *,off_t);
 
diff --git a/include/linux/printk.h b/include/linux/printk.h
index eac1af8502bb..e5ed13403835 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -172,7 +172,7 @@ __printf(1, 2) __cold int printk_deferred(const char *fmt, ...);
  * with all other unrelated printk_ratelimit() callsites.  Instead use
  * printk_ratelimited() or plain old __ratelimit().
  */
-extern int __printk_ratelimit(const char *func);
+extern int __printk_ratelimit(const char *func) __nocapture(1);
 #define printk_ratelimit() __printk_ratelimit(__func__)
 extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);
diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
index 57c9e0622a38..fe141261a47d 100644
--- a/include/linux/ratelimit.h
+++ b/include/linux/ratelimit.h
@@ -72,7 +72,8 @@ ratelimit_set_flags(struct ratelimit_state *rs, unsigned long flags)
 
 extern struct ratelimit_state printk_ratelimit_state;
 
-extern int ___ratelimit(struct ratelimit_state *rs, const char *func);
+extern __nocapture(2)
+int ___ratelimit(struct ratelimit_state *rs, const char *func);
 #define __ratelimit(state) ___ratelimit(state, __func__)
 
 #ifdef CONFIG_PRINTK
diff --git a/include/linux/string.h b/include/linux/string.h
index 26b6f6a66f83..8b3b97e7b2b0 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -18,51 +18,52 @@ extern void *memdup_user_nul(const void __user *, size_t);
 #include <asm/string.h>
 
 #ifndef __HAVE_ARCH_STRCPY
-extern char * strcpy(char *,const char *);
+extern char * strcpy(char *,const char *) __nocapture(2);
 #endif
 #ifndef __HAVE_ARCH_STRNCPY
-extern char * strncpy(char *,const char *, __kernel_size_t);
+extern char * strncpy(char *,const char *, __kernel_size_t) __nocapture(2);
 #endif
 #ifndef __HAVE_ARCH_STRLCPY
-size_t strlcpy(char *, const char *, size_t);
+size_t strlcpy(char *, const char *, size_t) __nocapture(2);
 #endif
 #ifndef __HAVE_ARCH_STRSCPY
 ssize_t __must_check strscpy(char *, const char *, size_t);
 #endif
 #ifndef __HAVE_ARCH_STRCAT
-extern char * strcat(char *, const char *);
+extern char * strcat(char *, const char *) __nocapture(2);
 #endif
 #ifndef __HAVE_ARCH_STRNCAT
-extern char * strncat(char *, const char *, __kernel_size_t);
+extern char * strncat(char *, const char *, __kernel_size_t) __nocapture(2);
 #endif
 #ifndef __HAVE_ARCH_STRLCAT
-extern size_t strlcat(char *, const char *, __kernel_size_t);
+extern size_t strlcat(char *, const char *, __kernel_size_t) __nocapture(2);
 #endif
 #ifndef __HAVE_ARCH_STRCMP
-extern int strcmp(const char *,const char *);
+extern int strcmp(const char *,const char *) __nocapture();
 #endif
 #ifndef __HAVE_ARCH_STRNCMP
-extern int strncmp(const char *,const char *,__kernel_size_t);
+extern int strncmp(const char *,const char *,__kernel_size_t) __nocapture(1, 2);
 #endif
 #ifndef __HAVE_ARCH_STRCASECMP
-extern int strcasecmp(const char *s1, const char *s2);
+extern int strcasecmp(const char *s1, const char *s2) __nocapture();
 #endif
 #ifndef __HAVE_ARCH_STRNCASECMP
-extern int strncasecmp(const char *s1, const char *s2, size_t n);
+extern int
+strncasecmp(const char *s1, const char *s2, size_t n) __nocapture(1, 2);
 #endif
 #ifndef __HAVE_ARCH_STRCHR
-extern char * strchr(const char *,int);
+extern char * strchr(const char *,int) __nocapture(-1);
 #endif
 #ifndef __HAVE_ARCH_STRCHRNUL
-extern char * strchrnul(const char *,int);
+extern char * strchrnul(const char *,int) __nocapture(-1);
 #endif
 #ifndef __HAVE_ARCH_STRNCHR
-extern char * strnchr(const char *, size_t, int);
+extern char * strnchr(const char *, size_t, int) __nocapture(-1);
 #endif
 #ifndef __HAVE_ARCH_STRRCHR
-extern char * strrchr(const char *,int);
+extern char * strrchr(const char *,int) __nocapture(-1);
 #endif
-extern char * __must_check skip_spaces(const char *);
+extern char * __must_check skip_spaces(const char *) __nocapture(-1);
 
 extern char *strim(char *);
 
@@ -72,63 +73,63 @@ static inline __must_check char *strstrip(char *str)
 }
 
 #ifndef __HAVE_ARCH_STRSTR
-extern char * strstr(const char *, const char *);
+extern char * strstr(const char *, const char *) __nocapture(-1, 2);
 #endif
 #ifndef __HAVE_ARCH_STRNSTR
-extern char * strnstr(const char *, const char *, size_t);
+extern char * strnstr(const char *, const char *, size_t) __nocapture(-1, 2);
 #endif
 #ifndef __HAVE_ARCH_STRLEN
-extern __kernel_size_t strlen(const char *);
+extern __kernel_size_t strlen(const char *) __nocapture(1);
 #endif
 #ifndef __HAVE_ARCH_STRNLEN
-extern __kernel_size_t strnlen(const char *,__kernel_size_t);
+extern __kernel_size_t strnlen(const char *,__kernel_size_t) __nocapture(1);
 #endif
 #ifndef __HAVE_ARCH_STRPBRK
-extern char * strpbrk(const char *,const char *);
+extern char * strpbrk(const char *,const char *) __nocapture(-1, 2);
 #endif
 #ifndef __HAVE_ARCH_STRSEP
-extern char * strsep(char **,const char *);
+extern char * strsep(char **,const char *) __nocapture(2);
 #endif
 #ifndef __HAVE_ARCH_STRSPN
-extern __kernel_size_t strspn(const char *,const char *);
+extern __kernel_size_t strspn(const char *,const char *) __nocapture();
 #endif
 #ifndef __HAVE_ARCH_STRCSPN
-extern __kernel_size_t strcspn(const char *,const char *);
+extern __kernel_size_t strcspn(const char *,const char *) __nocapture();
 #endif
 
 #ifndef __HAVE_ARCH_MEMSET
 extern void * memset(void *,int,__kernel_size_t);
 #endif
 #ifndef __HAVE_ARCH_MEMCPY
-extern void * memcpy(void *,const void *,__kernel_size_t);
+extern void * memcpy(void *,const void *,__kernel_size_t) __nocapture(2);
 #endif
 #ifndef __HAVE_ARCH_MEMMOVE
-extern void * memmove(void *,const void *,__kernel_size_t);
+extern void * memmove(void *,const void *,__kernel_size_t) __nocapture(2);
 #endif
 #ifndef __HAVE_ARCH_MEMSCAN
 extern void * memscan(void *,int,__kernel_size_t);
 #endif
 #ifndef __HAVE_ARCH_MEMCMP
-extern int memcmp(const void *,const void *,__kernel_size_t);
+extern int memcmp(const void *,const void *,__kernel_size_t) __nocapture(1, 2);
 #endif
 #ifndef __HAVE_ARCH_MEMCHR
-extern void * memchr(const void *,int,__kernel_size_t);
+extern void * memchr(const void *,int,__kernel_size_t) __nocapture(-1);
 #endif
-void *memchr_inv(const void *s, int c, size_t n);
+void *memchr_inv(const void *s, int c, size_t n) __nocapture(-1);
 char *strreplace(char *s, char old, char new);
 
 extern void kfree_const(const void *x);
 
-extern char *kstrdup(const char *s, gfp_t gfp) __malloc;
-extern const char *kstrdup_const(const char *s, gfp_t gfp);
-extern char *kstrndup(const char *s, size_t len, gfp_t gfp);
-extern void *kmemdup(const void *src, size_t len, gfp_t gfp);
+extern char *kstrdup(const char *s, gfp_t gfp) __malloc __nocapture(1);
+extern const char *kstrdup_const(const char *s, gfp_t gfp) __nocapture(1);
+extern char *kstrndup(const char *s, size_t len, gfp_t gfp) __nocapture(1);
+extern void *kmemdup(const void *src, size_t len, gfp_t gfp) __nocapture(1);
 
 extern char **argv_split(gfp_t gfp, const char *str, int *argcp);
 extern void argv_free(char **argv);
 
-extern bool sysfs_streq(const char *s1, const char *s2);
-extern int kstrtobool(const char *s, bool *res);
+extern bool sysfs_streq(const char *s1, const char *s2) __nocapture();
+extern int kstrtobool(const char *s, bool *res) __nocapture(1);
 static inline int strtobool(const char *s, bool *res)
 {
 	return kstrtobool(s, res);
@@ -137,8 +138,10 @@ static inline int strtobool(const char *s, bool *res)
 int match_string(const char * const *array, size_t n, const char *string);
 
 #ifdef CONFIG_BINARY_PRINTF
-int vbin_printf(u32 *bin_buf, size_t size, const char *fmt, va_list args);
-int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf);
+int vbin_printf(u32 *bin_buf, size_t size, const char *fmt,
+		va_list args) __nocapture(3);
+int bstr_printf(char *buf, size_t size, const char *fmt,
+		const u32 *bin_buf) __nocapture(3);
 int bprintf(u32 *bin_buf, size_t size, const char *fmt, ...) __printf(3, 4);
 #endif
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 0967771d8f7f..a192761d338a 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -118,7 +118,7 @@ long long simple_strtoll(const char *cp, char **endp, unsigned int base)
 }
 EXPORT_SYMBOL(simple_strtoll);
 
-static noinline_for_stack
+static noinline_for_stack __nocapture(1)
 int skip_atoi(const char **s)
 {
 	int i = 0;
@@ -1570,7 +1570,7 @@ int kptr_restrict __read_mostly;
  * function pointers are really function descriptors, which contain a
  * pointer to the real address.
  */
-static noinline_for_stack
+static noinline_for_stack __nocapture(1)
 char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	      struct printf_spec spec)
 {
@@ -1749,7 +1749,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
  * @precision: precision of a number
  * @qualifier: qualifier of a number (long, size_t, ...)
  */
-static noinline_for_stack
+static noinline_for_stack __nocapture(1)
 int format_decode(const char *fmt, struct printf_spec *spec)
 {
 	const char *start = fmt;
diff --git a/mm/util.c b/mm/util.c
index 5606c6b74eee..bdfb314bae35 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -17,7 +17,7 @@
 
 #include "internal.h"
 
-static inline int is_kernel_rodata(const void *addr)
+static inline __nocapture(1) int is_kernel_rodata(const void *addr)
 {
 	return (unsigned long)addr >= (unsigned long)__start_rodata &&
 		(unsigned long)addr < (unsigned long)__end_rodata;
diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
index 24520b4ef3b0..b89448a69cf4 100644
--- a/security/integrity/integrity.h
+++ b/security/integrity/integrity.h
@@ -177,7 +177,7 @@ static inline void evm_load_x509(void)
 
 #ifdef CONFIG_INTEGRITY_AUDIT
 /* declarations */
-void integrity_audit_msg(int audit_msgno, struct inode *inode,
+void __nocapture(4) integrity_audit_msg(int audit_msgno, struct inode *inode,
 			 const unsigned char *fname, const char *op,
 			 const char *cause, int result, int info);
 #else
-- 
2.7.4
