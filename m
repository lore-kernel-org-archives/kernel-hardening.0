Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 13 Jan 2017 14:02:13 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20170113220213.GA57630@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] gcc-plugins: add PASS_INFO and build_const_char_string()
To: kernel-hardening@lists.openwall.com
Cc: PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This updates the GCC plugins gcc-common.h from PaX Team to include
more helpers and header files, specifically adds the PASS_INFO()
macro to make plugin declarations nicer and a helper for proper
const string building.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 scripts/gcc-plugins/gcc-common.h | 55 ++++++++++++++++++++++++++++++++--------
 1 file changed, 44 insertions(+), 11 deletions(-)

diff --git a/scripts/gcc-plugins/gcc-common.h b/scripts/gcc-plugins/gcc-common.h
index 12262c0cc691..b232ab15624c 100644
--- a/scripts/gcc-plugins/gcc-common.h
+++ b/scripts/gcc-plugins/gcc-common.h
@@ -26,6 +26,9 @@
 #include "except.h"
 #include "function.h"
 #include "toplev.h"
+#if BUILDING_GCC_VERSION >= 5000
+#include "expr.h"
+#endif
 #include "basic-block.h"
 #include "intl.h"
 #include "ggc.h"
@@ -80,6 +83,9 @@
 #include "diagnostic.h"
 #include "tree-dump.h"
 #include "tree-pass.h"
+#if BUILDING_GCC_VERSION >= 4009
+#include "pass_manager.h"
+#endif
 #include "predict.h"
 #include "ipa-utils.h"
 
@@ -119,20 +125,17 @@
 #include "builtins.h"
 #endif
 
-/* #include "expr.h" where are you... */
-extern rtx emit_move_insn(rtx x, rtx y);
-
 /* missing from basic_block.h... */
-extern void debug_dominance_info(enum cdi_direction dir);
-extern void debug_dominance_tree(enum cdi_direction dir, basic_block root);
+void debug_dominance_info(enum cdi_direction dir);
+void debug_dominance_tree(enum cdi_direction dir, basic_block root);
 
 #if BUILDING_GCC_VERSION == 4006
-extern void debug_gimple_stmt(gimple);
-extern void debug_gimple_seq(gimple_seq);
-extern void print_gimple_seq(FILE *, gimple_seq, int, int);
-extern void print_gimple_stmt(FILE *, gimple, int, int);
-extern void print_gimple_expr(FILE *, gimple, int, int);
-extern void dump_gimple_stmt(pretty_printer *, gimple, int, int);
+void debug_gimple_stmt(gimple);
+void debug_gimple_seq(gimple_seq);
+void print_gimple_seq(FILE *, gimple_seq, int, int);
+void print_gimple_stmt(FILE *, gimple, int, int);
+void print_gimple_expr(FILE *, gimple, int, int);
+void dump_gimple_stmt(pretty_printer *, gimple, int, int);
 #endif
 
 #define __unused __attribute__((__unused__))
@@ -146,6 +149,29 @@ extern void dump_gimple_stmt(pretty_printer *, gimple, int, int);
 /* should come from c-tree.h if only it were installed for gcc 4.5... */
 #define C_TYPE_FIELDS_READONLY(TYPE) TREE_LANG_FLAG_1(TYPE)
 
+static inline tree build_const_char_string(int len, const char *str)
+{
+	tree cstr, elem, index, type;
+
+	cstr = build_string(len, str);
+	elem = build_type_variant(char_type_node, 1, 0);
+	index = build_index_type(size_int(len - 1));
+	type = build_array_type(elem, index);
+	TREE_TYPE(cstr) = type;
+	TREE_CONSTANT(cstr) = 1;
+	TREE_READONLY(cstr) = 1;
+	TREE_STATIC(cstr) = 1;
+	return cstr;
+}
+
+#define PASS_INFO(NAME, REF, ID, POS)		\
+struct register_pass_info NAME##_pass_info = {	\
+	.pass = make_##NAME##_pass(),		\
+	.reference_pass_name = REF,		\
+	.ref_pass_instance_number = ID,		\
+	.pos_op = POS,				\
+}
+
 #if BUILDING_GCC_VERSION == 4005
 #define FOR_EACH_LOCAL_DECL(FUN, I, D)			\
 	for (tree vars = (FUN)->local_decls, (I) = 0;	\
@@ -527,6 +553,8 @@ static inline const greturn *as_a_const_greturn(const_gimple stmt)
 #define section_name_prefix LTO_SECTION_NAME_PREFIX
 #define fatal_error(loc, gmsgid, ...) fatal_error((gmsgid), __VA_ARGS__)
 
+rtx emit_move_insn(rtx x, rtx y);
+
 typedef struct rtx_def rtx_insn;
 
 static inline const char *get_decl_section_name(const_tree decl)
@@ -643,6 +671,11 @@ static inline const greturn *as_a_const_greturn(const_gimple stmt)
 #define NODE_DECL(node) (node)->decl
 #define cgraph_node_name(node) (node)->name()
 #define NODE_IMPLICIT_ALIAS(node) (node)->cpp_implicit_alias
+
+static inline opt_pass *get_pass_for_id(int id)
+{
+	return g->get_passes()->get_pass_for_id(id);
+}
 #endif
 
 #if BUILDING_GCC_VERSION >= 5000 && BUILDING_GCC_VERSION < 6000
-- 
2.7.4


-- 
Kees Cook
Nexus Security
