Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 3 Jul 2011 14:01:31 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110703100131.GA2472@albatros>
References: <20110626190622.GB4217@albatros>
 <20110626194618.GA21740@elte.hu>
 <20110626202518.GA4915@albatros>
 <20110626220126.GA24004@elte.hu>
 <20110627083633.GA5846@albatros>
 <20110627104058.45e93c41@pyx>
 <20110627183829.GA16033@albatros>
 <BANLkTikyzxXgfFuwBRdDLvrRN4+fExMwWA@mail.gmail.com>
 <20110701143757.GA22567@albatros>
 <20110701154947.133c30f5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701154947.133c30f5@lxorguk.ukuu.org.uk>
Subject: [kernel-hardening] Re: [PATCH v2] kernel: escape non-ASCII and control characters in
 printk()
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jul 01, 2011 at 15:49 +0100, Alan Cox wrote:
> Your expectation for printk is 
> 
> "multiple new lines are cool providing they are in the format string"

Sigh...  After implementing controls filtering including \n inside of
%s, I got numerous false positives.  Most of them are startup messages
with driver/hardware name/version, in drivers/.

I'm attaching the patch with both vscnprintf() changes and drivers fixes
just to show the idea.  Before applying the vscnprintf patch all/most of
such drivers should be fixed.  If someone think it's better to apply the
patch to some tree to learn the list of such false positives - tell me,
I'll resend the vscnprintf part of the patch.


Also, the problem with CSI code is still here.  It cannot be filtered
because it is a valid byte inside of UTF-8 character.  For a console
with IUTF bit set all dangerous characters are filtered, but for the
rest they are not.  As at the stage of vscnprintf the presence of IUTF
bit is not clear, users of non-IUTF console should still use "| less" or
similar.  Obviously, \n is filtered for all consoles.

Thanks,

---
 arch/blackfin/kernel/early_printk.c  |    1 +
 arch/blackfin/kernel/trace.c         |    2 +-
 arch/powerpc/kernel/prom_init.c      |    2 +-
 arch/x86/kernel/smpboot.c            |    4 ++-
 drivers/gpu/drm/nouveau/nouveau_pm.c |   11 ++++++---
 drivers/scsi/bnx2i/bnx2i_init.c      |    4 +-
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c   |    4 +-
 include/linux/kernel.h               |    2 +
 init/main.c                          |    2 +-
 init/version.c                       |    2 +-
 kernel/printk.c                      |    4 +-
 lib/vsprintf.c                       |   40 ++++++++++++++++++++++++++-------
 12 files changed, 54 insertions(+), 24 deletions(-)

---
diff --git a/arch/blackfin/kernel/early_printk.c b/arch/blackfin/kernel/early_printk.c
index 84ed837..5a9ba3e 100644
--- a/arch/blackfin/kernel/early_printk.c
+++ b/arch/blackfin/kernel/early_printk.c
@@ -173,6 +173,7 @@ asmlinkage void __init init_early_exception_vectors(void)
 	 */
 	mark_shadow_error();
 	early_shadow_puts(linux_banner);
+	early_shadow_puts("\n");
 	early_shadow_stamp();
 
 	if (CPUID != bfin_cpuid()) {
diff --git a/arch/blackfin/kernel/trace.c b/arch/blackfin/kernel/trace.c
index 050db44..16678b0 100644
--- a/arch/blackfin/kernel/trace.c
+++ b/arch/blackfin/kernel/trace.c
@@ -872,7 +872,7 @@ void show_regs(struct pt_regs *fp)
 #endif
 		);
 
-	pr_notice("%s", linux_banner);
+	pr_notice("%s\n", linux_banner);
 
 	pr_notice("\nSEQUENCER STATUS:\t\t%s\n", print_tainted());
 	pr_notice(" SEQSTAT: %08lx  IPEND: %04lx  IMASK: %04lx  SYSCFG: %04lx\n",
diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index c016033..c84e3b3 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -2544,7 +2544,7 @@ unsigned long __init prom_init(unsigned long r3, unsigned long r4,
 	 */
 	prom_init_stdout();
 
-	prom_printf("Preparing to boot %s", RELOC(linux_banner));
+	prom_printf("Preparing to boot %s\n", RELOC(linux_banner));
 
 	/*
 	 * Get default machine type. At this point, we do not differentiate
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 33a0c11..258659c 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -644,7 +644,9 @@ static void __cpuinit announce_cpu(int cpu, int apicid)
 			current_node = node;
 			pr_info("Booting Node %3d, Processors ", node);
 		}
-		pr_cont(" #%d%s", cpu, cpu == (nr_cpu_ids - 1) ? " Ok.\n" : "");
+		pr_cont(" #%d%s", cpu, cpu == (nr_cpu_ids - 1) ? " Ok." : "");
+		if (cpu == (nr_cpu_ids - 1))
+			pr_cont("\n");
 		return;
 	} else
 		pr_info("Booting Node %d Processor %d APIC 0x%x\n",
diff --git a/drivers/gpu/drm/nouveau/nouveau_pm.c b/drivers/gpu/drm/nouveau/nouveau_pm.c
index da8d994..0997d2c 100644
--- a/drivers/gpu/drm/nouveau/nouveau_pm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_pm.c
@@ -178,7 +178,7 @@ nouveau_pm_perflvl_info(struct nouveau_pm_level *perflvl, char *ptr, int len)
 	if (perflvl->timing)
 		snprintf(t, sizeof(t), " timing %d", perflvl->timing->id);
 
-	snprintf(ptr, len, "memory %dMHz%s%s%s%s%s\n", perflvl->memory / 1000,
+	snprintf(ptr, len, "memory %dMHz%s%s%s%s%s", perflvl->memory / 1000,
 		 c, s, v, f, t);
 }
 
@@ -195,6 +195,7 @@ nouveau_pm_get_perflvl_info(struct device *d,
 	len -= strlen(buf);
 
 	nouveau_pm_perflvl_info(perflvl, ptr, len);
+	strcat(ptr, "\n");
 	return strlen(buf);
 }
 
@@ -218,8 +219,10 @@ nouveau_pm_get_perflvl(struct device *d, struct device_attribute *a, char *buf)
 	len -= strlen(buf);
 
 	ret = nouveau_pm_perflvl_get(dev, &cur);
-	if (ret == 0)
+	if (ret == 0) {
 		nouveau_pm_perflvl_info(&cur, ptr, len);
+		strcat(ptr, "\n");
+	}
 	return strlen(buf);
 }
 
@@ -488,7 +491,7 @@ nouveau_pm_init(struct drm_device *dev)
 	NV_INFO(dev, "%d available performance level(s)\n", pm->nr_perflvl);
 	for (i = 0; i < pm->nr_perflvl; i++) {
 		nouveau_pm_perflvl_info(&pm->perflvl[i], info, sizeof(info));
-		NV_INFO(dev, "%d: %s", pm->perflvl[i].id, info);
+		NV_INFO(dev, "%d: %s\n", pm->perflvl[i].id, info);
 	}
 
 	/* determine current ("boot") performance level */
@@ -498,7 +501,7 @@ nouveau_pm_init(struct drm_device *dev)
 		pm->cur = &pm->boot;
 
 		nouveau_pm_perflvl_info(&pm->boot, info, sizeof(info));
-		NV_INFO(dev, "c: %s", info);
+		NV_INFO(dev, "c: %s\n", info);
 	}
 
 	/* switch performance levels now if requested */
diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 6adbdc3..f1354a6 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -23,7 +23,7 @@ static u32 adapter_count;
 
 static char version[] __devinitdata =
 		"Broadcom NetXtreme II iSCSI Driver " DRV_MODULE_NAME \
-		" v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
+		" v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")";
 
 
 MODULE_AUTHOR("Anil Veerabhadrappa <anilgv@broadcom.com> and "
@@ -372,7 +372,7 @@ static int __init bnx2i_mod_init(void)
 {
 	int err;
 
-	printk(KERN_INFO "%s", version);
+	printk(KERN_INFO "%s\n", version);
 
 	if (sq_size && !is_power_of_2(sq_size))
 		sq_size = roundup_pow_of_two(sq_size);
diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index fc2cdb6..b2a659b 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -38,7 +38,7 @@ static unsigned int dbg_level;
 
 static char version[] =
 	DRV_MODULE_DESC " " DRV_MODULE_NAME
-	" v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
+	" v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")";
 
 MODULE_AUTHOR("Chelsio Communications, Inc.");
 MODULE_DESCRIPTION(DRV_MODULE_DESC);
@@ -1402,7 +1402,7 @@ static int __init cxgb3i_init_module(void)
 {
 	int rc;
 
-	printk(KERN_INFO "%s", version);
+	printk(KERN_INFO "%s\b", version);
 
 	rc = cxgbi_iscsi_init(&cxgb3i_iscsi_transport, &cxgb3i_stt);
 	if (rc < 0)
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index fb0e732..db729ad 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -300,6 +300,8 @@ extern int scnprintf(char * buf, size_t size, const char * fmt, ...)
 	__attribute__ ((format (printf, 3, 4)));
 extern int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
 	__attribute__ ((format (printf, 3, 0)));
+extern int _vscnprintf(char *buf, size_t size, const char *fmt, va_list args, bool unsafe_args)
+	__attribute__ ((format (printf, 3, 0)));
 extern char *kasprintf(gfp_t gfp, const char *fmt, ...)
 	__attribute__ ((format (printf, 2, 3)));
 extern char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
diff --git a/init/main.c b/init/main.c
index cafba67..b28e364 100644
--- a/init/main.c
+++ b/init/main.c
@@ -484,7 +484,7 @@ asmlinkage void __init start_kernel(void)
 	tick_init();
 	boot_cpu_init();
 	page_address_init();
-	printk(KERN_NOTICE "%s", linux_banner);
+	printk(KERN_NOTICE "%s\b", linux_banner);
 	setup_arch(&command_line);
 	mm_init_owner(&init_mm, &init_task);
 	mm_init_cpumask(&init_mm);
diff --git a/init/version.c b/init/version.c
index 86fe0cc..256cfff 100644
--- a/init/version.c
+++ b/init/version.c
@@ -40,7 +40,7 @@ EXPORT_SYMBOL_GPL(init_uts_ns);
 /* FIXED STRINGS! Don't touch! */
 const char linux_banner[] =
 	"Linux version " UTS_RELEASE " (" LINUX_COMPILE_BY "@"
-	LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION "\n";
+	LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION;
 
 const char linux_proc_banner[] =
 	"%s version %s"
diff --git a/kernel/printk.c b/kernel/printk.c
index 3518539..67a7fb6 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -869,8 +869,8 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 		printed_len = strlen(recursion_bug_msg);
 	}
 	/* Emit the output into the temporary buffer */
-	printed_len += vscnprintf(printk_buf + printed_len,
-				  sizeof(printk_buf) - printed_len, fmt, args);
+	printed_len += _vscnprintf(printk_buf + printed_len,
+				  sizeof(printk_buf) - printed_len, fmt, args, true);
 
 	p = printk_buf;
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index c112056..86e4332 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -395,8 +395,7 @@ char *number(char *buf, char *end, unsigned long long num,
 	return buf;
 }
 
-static noinline_for_stack
-char *string(char *buf, char *end, const char *s, struct printf_spec spec)
+char *_string(char *buf, char *end, const char *s, struct printf_spec spec, bool unsafe)
 {
 	int len, i;
 
@@ -413,8 +412,12 @@ char *string(char *buf, char *end, const char *s, struct printf_spec spec)
 		}
 	}
 	for (i = 0; i < len; ++i) {
-		if (buf < end)
-			*buf = *s;
+		if (buf < end) {
+			if (unsafe && iscntrl(*s))
+				*buf = '?';
+			else
+				*buf = *s;
+		}
 		++buf; ++s;
 	}
 	while (len < spec.field_width--) {
@@ -427,6 +430,12 @@ char *string(char *buf, char *end, const char *s, struct printf_spec spec)
 }
 
 static noinline_for_stack
+char *string(char *buf, char *end, const char *s, struct printf_spec spec)
+{
+	return _string(buf, end, s, spec, false);
+}
+
+static noinline_for_stack
 char *symbol_string(char *buf, char *end, void *ptr,
 		    struct printf_spec spec, char ext)
 {
@@ -1163,7 +1172,7 @@ qualifier:
  *
  * If you're not already dealing with a va_list consider using snprintf().
  */
-int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
+int _vsnprintf(char *buf, size_t size, const char *fmt, va_list args, bool unsafe_args)
 {
 	unsigned long long num;
 	char *str, *end;
@@ -1233,7 +1242,7 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 		}
 
 		case FORMAT_TYPE_STR:
-			str = string(str, end, va_arg(args, char *), spec);
+			str = _string(str, end, va_arg(args, char *), spec, unsafe_args);
 			break;
 
 		case FORMAT_TYPE_PTR:
@@ -1322,14 +1331,21 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 	return str-buf;
 
 }
+
+int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
+{
+	return _vsnprintf(buf, size, fmt, args, false);
+}
 EXPORT_SYMBOL(vsnprintf);
 
 /**
- * vscnprintf - Format a string and place it in a buffer
+ * _vscnprintf - Format a string and place it in a buffer
  * @buf: The buffer to place the result into
  * @size: The size of the buffer, including the trailing null space
  * @fmt: The format string to use
  * @args: Arguments for the format string
+ * @unsafe_args: Whether some of args are user supplied.  If true, control
+ *         characters like \n and cursor movements are escaped.
  *
  * The return value is the number of characters which have been written into
  * the @buf not including the trailing '\0'. If @size is == 0 the function
@@ -1339,11 +1355,11 @@ EXPORT_SYMBOL(vsnprintf);
  *
  * See the vsnprintf() documentation for format string extensions over C99.
  */
-int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
+int _vscnprintf(char *buf, size_t size, const char *fmt, va_list args, bool unsafe_args)
 {
 	int i;
 
-	i = vsnprintf(buf, size, fmt, args);
+	i = _vsnprintf(buf, size, fmt, args, unsafe_args);
 
 	if (likely(i < size))
 		return i;
@@ -1351,6 +1367,12 @@ int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
 		return size - 1;
 	return 0;
 }
+EXPORT_SYMBOL(_vscnprintf);
+
+int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
+{
+	return _vscnprintf(buf, size, fmt, args, false);
+}
 EXPORT_SYMBOL(vscnprintf);
 
 /**
---
