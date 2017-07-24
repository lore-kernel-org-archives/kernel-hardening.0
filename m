Sender: Hans Liljestrand <ishkamiel@gmail.com>
From: Hans Liljestrand <liljestrandh@gmail.com>
Date: Mon, 24 Jul 2017 16:38:22 +0300
Message-Id: <20170724133824.27223-4-LiljestrandH@gmail.com>
In-Reply-To: <20170724133824.27223-1-LiljestrandH@gmail.com>
References: <20170724133824.27223-1-LiljestrandH@gmail.com>
Subject: [kernel-hardening] [RFC PATCH 3/5] x86: add mpxk-wrappers
To: kernel-hardening@lists.openwall.com
Cc: elena.reshetova@intel.com, dave.hansen@intel.com, keescook@chromium.org, hpa@zytor.com, Hans Liljestrand <LiljestrandH@gmail.com>, Hans Liljestrand <liljestrandh@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

This adds actual implementation for mpxk-wrapper functions. The wrapper
function are used by the instrumentation to update and check pointer bounds
on functions that alter memory, e.g. kmalloc and memcpy. The kmalloc
wrapper function for instance simply executes kmalloc, associates bounds
with the returned pointer, and returns both. Other wrapper functions, such
as for memcpy, also check the bounds of incoming arguments.

For future work these wrappers could potentially be replaced by direct
instrumentation without the need to incur the cost of calling the wrapper
function. In this scenario every kmalloc would simply be preceded by an
appropriate mkbnd instruction, and memcpy preceded by bndcu+bndcl
instructions.

The wrappers are added by the MPXK gcc-plugin, and as such work on
preprocessed code. This introduces another problem with our
implementation since macros might actually be used to direct "base
functions" into specific implementations (e.g. memcpy might be a macro
pointing to __memcpy). One solution is covering all possibilities, but
this might introduce unwanted code bloat.

Signed-off-by: Hans Liljestrand <liljestrandh@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/lib/mpxk-wrappers.c | 157 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 157 insertions(+)
 create mode 100644 arch/x86/lib/mpxk-wrappers.c

diff --git a/arch/x86/lib/mpxk-wrappers.c b/arch/x86/lib/mpxk-wrappers.c
new file mode 100644
index 000000000000..0b0fe235c90f
--- /dev/null
+++ b/arch/x86/lib/mpxk-wrappers.c
@@ -0,0 +1,157 @@
+/*
+ * arch/x86/lib/mpxk-wrappers.h
+ *
+ * Copyright (C) 2017 Aalto University
+ */
+#include <linux/page-flags.h>
+#include <linux/vmalloc.h>
+#include <linux/slab.h>
+#include <linux/mm.h>
+#include <asm/page.h>
+#include <asm/pgtable_64.h>
+
+#define MPXK_BUILTIN_DEF(r, f, ...) extern r f(__VA_ARGS__);
+#define MPXK_WRAPPER_DEF(r, f, ...) extern r mpxk_wrapper_##f(__VA_ARGS__);
+
+#include "../../../../scripts/gcc-plugins/mpxk_builtins.def"
+
+#undef MPXK_WRAPPER_DEF
+#undef MPXK_BUILTIN_DEF
+
+void *mpxk_wrapper_kmalloc(size_t s, gfp_t f)
+{
+	void *p = kmalloc(s, f);
+
+	if (p)
+		return __bnd_set_ptr_bounds(p, s);
+	return __bnd_null_ptr_bounds(p);
+}
+
+void *mpxk_wrapper_krealloc(void *p, size_t s, gfp_t f)
+{
+	if (!p)
+		return mpxk_wrapper_kmalloc(s, f);
+
+	__bnd_chk_ptr_lbounds(p);
+	p = krealloc(p, s, f);
+
+	if (p)
+		return __bnd_set_ptr_bounds(p, s);
+	return __bnd_null_ptr_bounds(p);
+}
+
+void *mpxk_wrapper_memmove(void *d, const void *s, size_t c)
+{
+	if (c == 0)
+		return d;
+
+	__bnd_chk_ptr_bounds(d, c);
+	__bnd_chk_ptr_bounds(s, c);
+
+	return memmove(d, s, c);
+}
+
+void *mpxk_wrapper_memcpy(void *d, const void *s, size_t c)
+{
+	if (c == 0)
+		return d;
+
+	__bnd_chk_ptr_bounds(d, c);
+	__bnd_chk_ptr_bounds(s, c);
+
+	return memcpy(d, s, c);
+}
+
+/* Because the MPXK gcc-plugin works on preprocessed code it cannot properly
+ * handle macro expanded calls such as potential memcpy -> __memcpy changes.
+ * This probably needs to be solved in some cleaner way, and probably also
+ * affects other function besides memcpy.
+ */
+void *mpxk_wrapper___inline_memcpy(void *d, const void *s, size_t c)
+{
+	if (c == 0)
+		return d;
+
+	__bnd_chk_ptr_bounds(d, c);
+	__bnd_chk_ptr_bounds(s, c);
+
+	return __inline_memcpy(d, s, c);
+}
+
+void *mpxk_wrapper___memcpy(void *d, const void *s, size_t c)
+{
+	if (c == 0)
+		return d;
+
+	__bnd_chk_ptr_bounds(d, c);
+	__bnd_chk_ptr_bounds(s, c);
+
+	return __memcpy(d, s, c);
+}
+
+void *mpxk_wrapper_memset(void *s, int c, size_t l)
+{
+	if (l > 0) {
+		__bnd_chk_ptr_bounds(s, l);
+		memset(s, c, l);
+	}
+	return s;
+}
+
+char *mpxk_wrapper_strcat(char *d, const char *s)
+{
+	size_t ds = mpxk_wrapper_strlen(d);
+	size_t ss = mpxk_wrapper_strlen(s);
+
+	__bnd_chk_ptr_bounds(d, ds + ss + 1);
+	__bnd_chk_ptr_bounds(s, ss + 1);
+
+	return strcat(d, s);
+}
+
+char *mpxk_wrapper_strncat(char *d, const char *s, size_t c)
+{
+	size_t ds = mpxk_wrapper_strlen(d);
+	size_t ss = mpxk_wrapper_strnlen(s, c);
+
+	__bnd_chk_ptr_bounds(d, ds + ss + 1);
+	__bnd_chk_ptr_bounds(s, (ss < c ? ss + 1 : ss));
+
+	return strncat(d, s, c);
+}
+
+char *mpxk_wrapper_strcpy(char *d, const char *s)
+{
+	size_t ss = mpxk_wrapper_strlen(s);
+
+	__bnd_chk_ptr_bounds(d, ss + 1);
+	__bnd_chk_ptr_bounds(s, ss + 1);
+
+	return strcpy(d, s);
+}
+
+char *mpxk_wrapper_strncpy(char *d, const char *s, size_t c)
+{
+	size_t ss = strnlen(s, c);
+
+	__bnd_chk_ptr_bounds(d, c);
+	__bnd_chk_ptr_bounds(s, (ss < c ? ss + 1 : ss));
+
+	return strncpy(d, s, c);
+}
+
+size_t mpxk_wrapper_strlen(const char *s)
+{
+	const size_t l = strlen(s);
+
+	__bnd_chk_ptr_bounds(s, l + 1);
+	return l;
+}
+
+size_t mpxk_wrapper_strnlen(const char *s, size_t c)
+{
+	const size_t l = strnlen(s, c);
+
+	__bnd_chk_ptr_bounds(s, l + 1);
+	return l;
+}
-- 
2.11.0
