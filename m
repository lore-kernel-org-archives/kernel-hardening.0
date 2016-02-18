Reply-To: kernel-hardening@lists.openwall.com
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date: Fri, 19 Feb 2016 00:24:21 +0100
Message-Id: <1455837862-24189-2-git-send-email-linux@rasmusvillemoes.dk>
In-Reply-To: <1455837862-24189-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1455837862-24189-1-git-send-email-linux@rasmusvillemoes.dk>
Subject: [kernel-hardening] [RFC 1/2] plugins: implement format_template attribute
To: kernel-hardening@lists.openwall.com
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
List-ID: <kernel-hardening.lists.openwall.com>

Most format strings in the kernel are string literals, so the compiler
and other static analyzers can do type checking. This plugin covers a
few of the remaining cases, by introducing a format_template
attribute.

Consider struct usb_class_driver. Its member 'name' is used as a
format string in usb_register_dev(), and that use obviously expects
that the format string contains a single "%d" (or maybe %u). So the
idea is that we simply attach __format_template("%d") to the
declaration of the name member of struct usb_class_driver. We can then
check that any static initialization of that member is with a string
literal with the same set of specifiers. Moreover, we can use the
format template string to do type checking at the call site(s) in lieu
of a string literal.

For now, this only implements the former - mostly because I'm lazy and
don't want to write my own format checking code (again), and I suppose
there should be an internal gcc function I could (ab)use to say "check
this variadic function call, but use _this_ as format string".

Also, this only applies to struct members currently, but it should
also be possible to attach it to function parameters - e.g. the
namefmt parameter to kthread_create_on_cpu should have
__format_template("%u"); its only caller is __smpboot_create_thread
which passes struct smp_hotplug_thread->thread_comm, which in turn
should also have that attribute.

While strictly speaking "%*s" and "%d %s" both expect (int, const
char*), they're morally distinct, so I don't want to treat them as
equivalent. If this is ever a problem, I think one should let the
attribute take an optional flag argument, which could then control how
strict or lax the checking should be.

I'm not sure how much this affects compilation time, but there's not
really any point in building with this all the time - it should
suffice that the various build bots do it once in a while. Even
without the plugin, the __format_template(...) in the headers serves
as concise documentation.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 arch/Kconfig                 |  18 +++
 scripts/Makefile.gcc-plugins |   4 +
 tools/gcc/Makefile           |   2 +
 tools/gcc/format_template.c  | 331 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 355 insertions(+)
 create mode 100644 tools/gcc/format_template.c

diff --git a/arch/Kconfig b/arch/Kconfig
index c7775895ea7f..31036227724b 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -375,6 +375,24 @@ config GCC_PLUGIN_CYC_COMPLEXITY
 
 	  See Documentation/gcc-plugins.txt for details.
 
+config GCC_PLUGIN_FORMAT_TEMPLATE
+	bool "Enable format_template attribute"
+	depends on HAVE_GCC_PLUGINS
+	help
+	  This plugin implements a format_template attribute which can
+	  be attached to struct members which are supposed to hold a
+	  (printf) format string. This allows the compiler to check
+	  that (a) any string statically assigned to such a struct
+	  member has format specifiers compatible with those in the
+	  template and (b) when such a struct member is used as the
+	  format argument to a printf function, use the template in
+	  lieu of a string literal to do type checking of the variadic
+	  arguments.
+
+	  Even without using the plugin, attaching the format_template
+	  attribute can be beneficial, since it serves as
+	  documentation.
+
 endmenu # "GCC plugins"
 
 config HAVE_CC_STACKPROTECTOR
diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index c49abcd74532..f761f21e2336 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -7,7 +7,11 @@ ifneq ($(PLUGINCC),)
 ifdef CONFIG_GCC_PLUGIN_CYC_COMPLEXITY
 GCC_PLUGIN_CYC_COMPLEXITY_CFLAGS := -fplugin=$(objtree)/tools/gcc/cyc_complexity_plugin.so
 endif
+ifdef CONFIG_GCC_PLUGIN_FORMAT_TEMPLATE
+GCC_PLUGIN_FORMAT_TEMPLATE_CFLAGS := -fplugin=$(objtree)/tools/gcc/format_template.so
+endif
 GCC_PLUGINS_CFLAGS := $(GCC_PLUGIN_CYC_COMPLEXITY_CFLAGS)
+GCC_PLUGINS_CFLAGS += $(GCC_PLUGIN_FORMAT_TEMPLATE_CFLAGS)
 export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGINS_AFLAGS GCC_PLUGIN_CYC_COMPLEXITY
 ifeq ($(KBUILD_EXTMOD),)
 gcc-plugins:
diff --git a/tools/gcc/Makefile b/tools/gcc/Makefile
index 31c72bfb6188..681c4136a6e4 100644
--- a/tools/gcc/Makefile
+++ b/tools/gcc/Makefile
@@ -13,7 +13,9 @@ endif
 export GCCPLUGINS_DIR HOSTLIBS
 
 $(HOSTLIBS)-$(CONFIG_GCC_PLUGIN_CYC_COMPLEXITY) := cyc_complexity_plugin.so
+$(HOSTLIBS)-$(CONFIG_GCC_PLUGIN_FORMAT_TEMPLATE) += format_template.so
 
 always := $($(HOSTLIBS)-y)
 
 cyc_complexity_plugin-objs := cyc_complexity_plugin.o
+format_template-objs := format_template.o
diff --git a/tools/gcc/format_template.c b/tools/gcc/format_template.c
new file mode 100644
index 000000000000..09a798773cfd
--- /dev/null
+++ b/tools/gcc/format_template.c
@@ -0,0 +1,331 @@
+#include <string.h>
+#include <assert.h>
+
+#include "gcc-common.h"
+#include "c-family/c-pragma.h"
+
+int plugin_is_GPL_compatible;
+
+static struct plugin_info format_template_plugin_info = {
+	.version	= "20151209",
+	.help		= "format_template_plugin\n",
+};
+
+static tree handle_format_template_attribute(tree *node, tree name, tree args, int __unused flags, bool *no_add_attrs)
+{
+	tree tmpl, orig_attr;
+
+	*no_add_attrs = true;
+	switch (TREE_CODE(*node)) {
+	case FIELD_DECL:
+		break;
+	default:
+		error("%qE attribute only applies to struct members", name);
+		return NULL_TREE;
+	}
+
+	tmpl = TREE_VALUE(args);
+	if (TREE_CODE(tmpl) != STRING_CST) {
+		error("%qE parameter of the %qE attribute is not a string constant", args, name);
+		return NULL_TREE;
+	}
+
+	orig_attr = lookup_attribute("format_template", DECL_ATTRIBUTES(*node));
+	if (orig_attr) {
+		error("%qE attribute applied twice", name);
+		return NULL_TREE;
+	}
+	else
+		*no_add_attrs = false;
+
+	return NULL_TREE;
+}
+
+static struct attribute_spec format_template_attr = {
+	.name				= "format_template",
+	.min_length			= 1,
+	.max_length			= 1,
+	.decl_required			= true,
+	.type_required			= false,
+	.function_type_required		= false,
+	.handler			= handle_format_template_attribute,
+#if BUILDING_GCC_VERSION >= 4007
+	.affects_type_identity		= false
+#endif
+};
+
+static void register_attributes(void __unused *event_data, void __unused *data)
+{
+	register_attribute(&format_template_attr);
+}
+
+static void define_feature_macro(void __unused *event_data, void __unused *data)
+{
+	cpp_define(parse_in, "HAVE_ATTRIBUTE_FORMAT_TEMPLATE");
+}
+
+enum {
+	QUAL_NONE,
+	QUAL_SHORT, /* h */
+	QUAL_BYTE, /* hh, == QUAL_SHORT+1*/
+	QUAL_LONG, /* l */
+	QUAL_LONGLONG, /* ll, == QUAL_LONG+1 */
+	QUAL_MAX, /* j */
+	QUAL_SIZE, /* z */
+	QUAL_PTRDIFF, /* t */
+};
+#define FW_P_NONE (-1)
+#define FW_P_ARG (-2)
+
+struct spec_iter {
+	const char *spec;
+	int len;
+
+	int field_width;
+	int precision;
+	int qual;
+	char type;
+
+};
+
+static inline void
+spec_iter_init(struct spec_iter *spec, const char *s)
+{
+	spec->spec = s;
+	spec->len = 0;
+}
+
+static void get_fw_p(const char **c, int *dst, int prec)
+{
+	*dst = FW_P_NONE;
+	if (prec) {
+		if (**c != '.')
+			return;
+		++(*c);
+		*dst = 0;
+	}
+	if (**c == '*') {
+		++(*c);
+		*dst = FW_P_ARG;
+		return;
+	}
+	if (!ISDIGIT(**c))
+		return;
+	*dst = **c - '0';
+	++(*c);
+	while (ISDIGIT(**c)) {
+		/* should do if (*dst > 10000) warn("insane explicit field width/precision"); */
+		*dst *= 10;
+		*dst += **c - '0';
+		++(*c);
+	}
+}
+
+static int spec_next(struct spec_iter *spec)
+{
+	const char *c;
+	int slen = 0;
+
+	spec->spec += spec->len;
+again:
+	c = strchrnul(spec->spec, '%');
+	slen += c - spec->spec;
+	if (!c[0]) {
+		spec->spec = NULL;
+		return slen;
+	}
+	assert(c[0] == '%');
+	if (c[1] == '%') {
+		slen++;
+		spec->spec = c+2;
+		goto again;
+	}
+
+	spec->spec = c;
+	++c;
+	/* skip flags */
+	while (strchr("#0- +", *c))
+		++c;
+
+	get_fw_p(&c, &spec->field_width, 0);
+	get_fw_p(&c, &spec->precision, 1);
+
+	spec->qual = QUAL_NONE;
+	switch (*c) {
+	case 'h': spec->qual = QUAL_SHORT; break;
+	case 'l': spec->qual = QUAL_LONG; break;
+#if 0 /* The kernel doesn't grok the j qualifier */
+	case 'j': spec->qual = QUAL_MAX; break;
+#endif
+	case 'z': spec->qual = QUAL_SIZE; break;
+	case 't': spec->qual = QUAL_PTRDIFF; break;
+	}
+	if (spec->qual) {
+		++c;
+		if (*c == c[-1] && (*c == 'h' || *c == 'l')) {
+			spec->qual++;
+			++c;
+		}
+	}
+
+	spec->type = *c++;
+	spec->len = c - spec->spec;
+
+	switch (spec->type) {
+	case 'd':
+	case 'u':
+	case 'x':
+	case 'X':
+	case 'o':
+	case 'c':
+	case 's':
+		break;
+	/*
+	 * Disallowing %p is the safe and sane thing to do, given the
+	 * different interpretations based on following alphanumerics.
+	 */
+	case 'p':
+	/*
+	 * Why are there two with the same meaning? %i is the lesser
+	 * used one and should just die.
+	 */
+	case 'i':
+		error("unsupported specifier '%.*s' in template or initializer", spec->len, spec->spec);
+	default:
+		error("invalid specifier '%.*s' in template or initializer", spec->len, spec->spec);
+	}
+
+	return slen;
+}
+
+static bool specs_compatible(const struct spec_iter *a, const struct spec_iter *b)
+{
+	if (a->qual != b->qual)
+		return false;
+	if (a->field_width != b->field_width)
+		return false;
+	if (a->precision != b->precision)
+		return false;
+	if (a->type != b->type)
+		return false;
+	return true;
+}
+
+static void check_literal(tree attr, const char *str)
+{
+	const char *pattern = TREE_STRING_POINTER(TREE_VALUE(TREE_VALUE(attr)));
+	struct spec_iter sp, ss;
+	int i;
+
+	spec_iter_init(&sp, pattern);
+	spec_iter_init(&ss, str);
+
+	/*
+	 * Walk over the pattern and string in lockstep.
+	 */
+	for (i = 1; ; ++i) {
+		spec_next(&sp);
+		spec_next(&ss);
+		/*
+		 * It's ok for the template to have more specifiers
+		 * than the actual string. But issue warning(s)
+		 * anyway, conditional on -Wformat-extra-args.
+		 */
+		if (ss.spec == NULL) {
+			while (sp.spec != NULL) {
+			       warning(OPT_Wformat_extra_args,
+				       "format template '%s' contains extra specifier '%.*s' compared to initializer string '%s'",
+				       pattern, sp.len, sp.spec, str);
+			       spec_next(&sp);
+			}
+			return;
+		}
+		/*
+		 * It's absolutely not ok for the actual string to
+		 * have more specifiers than the template.
+		 */
+		if (!sp.spec) {
+			do {
+				error("initializer string '%s' contains extra format specifier '%.*s' compared to format template '%s'",
+					str, ss.len, ss.spec, pattern);
+				spec_next(&ss);
+			} while (ss.spec != NULL);
+			return;
+		}
+		if (!specs_compatible(&ss, &sp)) {
+			error("specifier %d in '%s' ('%.*s') incompatible with format template '%s'",
+			      i, str, ss.len, ss.spec, pattern);
+		}
+	}
+}
+
+static void check_declaration(void *event_data, void *data __unused)
+{
+	tree decl = (tree)event_data;
+	tree ini, type;
+	unsigned idx;
+	tree field, value;
+
+	switch (TREE_CODE(decl)) {
+	case VAR_DECL:
+		break;
+	default:
+		return;
+	}
+
+	ini = DECL_INITIAL(decl);
+	if (!ini)
+		return;
+
+	type = TREE_TYPE(decl);
+	if (TREE_CODE(type) != RECORD_TYPE)
+		return;
+
+	if (TREE_CODE(ini) != CONSTRUCTOR) {
+		// warning(0, "weird, initializer is not a CONSTRUCTOR, tree_code=%d", TREE_CODE(ini));
+		return;
+	}
+
+	FOR_EACH_CONSTRUCTOR_ELT(CONSTRUCTOR_ELTS(ini), idx, field, value) {
+		tree attr;
+
+		/* if (TREE_CODE(value) != STRING_CST) */
+		/* 	continue; */
+
+		attr = lookup_attribute("format_template", DECL_ATTRIBUTES(field));
+		if (!attr)
+			continue;
+
+		/*
+		 * Hm, apparently the string literal is hidden behind
+		 * a NOP_EXPR and a ADDR_EXPR.
+		 */
+		STRIP_NOPS(value);
+		if (TREE_CODE(value) == ADDR_EXPR)
+			value = TREE_OPERAND(value, 0);
+
+		if (TREE_CODE(value) != STRING_CST)
+			continue;
+
+		check_literal(attr, TREE_STRING_POINTER(value));
+
+	}
+
+}
+
+int plugin_init(struct plugin_name_args *plugin_info, struct plugin_gcc_version *version)
+{
+	const char *const plugin_name = plugin_info->base_name;
+
+	if (!plugin_default_version_check(version, &gcc_version)) {
+		error(G_("incompatible gcc/plugin versions"));
+		return 1;
+	}
+
+	register_callback(plugin_name, PLUGIN_INFO, NULL, &format_template_plugin_info);
+	register_callback(plugin_name, PLUGIN_START_UNIT, &define_feature_macro, NULL);
+	register_callback(plugin_name, PLUGIN_FINISH_DECL, &check_declaration, NULL);
+	register_callback(plugin_name, PLUGIN_ATTRIBUTES, &register_attributes, NULL);
+
+	return 0;
+}
-- 
2.1.4
