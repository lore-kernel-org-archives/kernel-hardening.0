Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 16 Dec 2016 12:56:14 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20161216205614.GA62291@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] gcc-plugins: update gcc-common.h for gcc-7
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, Kugan <kugan.vivekanandarajah@linaro.org>, Arnd Bergmann <arnd@arndb.de>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This updates gcc-common.h from Emese Revfy for gcc 7. This fixes issues seen
by Kugan and Arnd. Build tested with gcc 5.4 and 7 snapshot.

Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 scripts/gcc-plugins/gcc-common.h | 86 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/scripts/gcc-plugins/gcc-common.h b/scripts/gcc-plugins/gcc-common.h
index 172850bcd0d9..12262c0cc691 100644
--- a/scripts/gcc-plugins/gcc-common.h
+++ b/scripts/gcc-plugins/gcc-common.h
@@ -39,6 +39,9 @@
 #include "hash-map.h"
 #endif
 
+#if BUILDING_GCC_VERSION >= 7000
+#include "memmodel.h"
+#endif
 #include "emit-rtl.h"
 #include "debug.h"
 #include "target.h"
@@ -91,6 +94,9 @@
 #include "tree-ssa-alias.h"
 #include "tree-ssa.h"
 #include "stringpool.h"
+#if BUILDING_GCC_VERSION >= 7000
+#include "tree-vrp.h"
+#endif
 #include "tree-ssanames.h"
 #include "print-tree.h"
 #include "tree-eh.h"
@@ -130,6 +136,7 @@ extern void dump_gimple_stmt(pretty_printer *, gimple, int, int);
 #endif
 
 #define __unused __attribute__((__unused__))
+#define __visible __attribute__((visibility("default")))
 
 #define DECL_NAME_POINTER(node) IDENTIFIER_POINTER(DECL_NAME(node))
 #define DECL_NAME_LENGTH(node) IDENTIFIER_LENGTH(DECL_NAME(node))
@@ -286,6 +293,22 @@ static inline struct cgraph_node *cgraph_next_function_with_gimple_body(struct c
 	return NULL;
 }
 
+static inline bool cgraph_for_node_and_aliases(cgraph_node_ptr node, bool (*callback)(cgraph_node_ptr, void *), void *data, bool include_overwritable)
+{
+	cgraph_node_ptr alias;
+
+	if (callback(node, data))
+		return true;
+
+	for (alias = node->same_body; alias; alias = alias->next) {
+		if (include_overwritable || cgraph_function_body_availability(alias) > AVAIL_OVERWRITABLE)
+			if (cgraph_for_node_and_aliases(alias, callback, data, include_overwritable))
+				return true;
+	}
+
+	return false;
+}
+
 #define FOR_EACH_FUNCTION_WITH_GIMPLE_BODY(node) \
 	for ((node) = cgraph_first_function_with_gimple_body(); (node); \
 		(node) = cgraph_next_function_with_gimple_body(node))
@@ -398,6 +421,7 @@ typedef union gimple_statement_d gassign;
 typedef union gimple_statement_d gcall;
 typedef union gimple_statement_d gcond;
 typedef union gimple_statement_d gdebug;
+typedef union gimple_statement_d ggoto;
 typedef union gimple_statement_d gphi;
 typedef union gimple_statement_d greturn;
 
@@ -451,6 +475,16 @@ static inline const gdebug *as_a_const_gdebug(const_gimple stmt)
 	return stmt;
 }
 
+static inline ggoto *as_a_ggoto(gimple stmt)
+{
+	return stmt;
+}
+
+static inline const ggoto *as_a_const_ggoto(const_gimple stmt)
+{
+	return stmt;
+}
+
 static inline gphi *as_a_gphi(gimple stmt)
 {
 	return stmt;
@@ -495,6 +529,14 @@ static inline const greturn *as_a_const_greturn(const_gimple stmt)
 
 typedef struct rtx_def rtx_insn;
 
+static inline const char *get_decl_section_name(const_tree decl)
+{
+	if (DECL_SECTION_NAME(decl) == NULL_TREE)
+		return NULL;
+
+	return TREE_STRING_POINTER(DECL_SECTION_NAME(decl));
+}
+
 static inline void set_decl_section_name(tree node, const char *value)
 {
 	if (value)
@@ -510,6 +552,7 @@ typedef struct gimple_statement_base gassign;
 typedef struct gimple_statement_call gcall;
 typedef struct gimple_statement_base gcond;
 typedef struct gimple_statement_base gdebug;
+typedef struct gimple_statement_base ggoto;
 typedef struct gimple_statement_phi gphi;
 typedef struct gimple_statement_base greturn;
 
@@ -563,6 +606,16 @@ static inline const gdebug *as_a_const_gdebug(const_gimple stmt)
 	return stmt;
 }
 
+static inline ggoto *as_a_ggoto(gimple stmt)
+{
+	return stmt;
+}
+
+static inline const ggoto *as_a_const_ggoto(const_gimple stmt)
+{
+	return stmt;
+}
+
 static inline gphi *as_a_gphi(gimple stmt)
 {
 	return as_a<gphi>(stmt);
@@ -610,6 +663,11 @@ inline bool is_a_helper<const gassign *>::test(const_gimple gs)
 
 #define INSN_DELETED_P(insn) (insn)->deleted()
 
+static inline const char *get_decl_section_name(const_tree decl)
+{
+	return DECL_SECTION_NAME(decl);
+}
+
 /* symtab/cgraph related */
 #define debug_cgraph_node(node) (node)->debug()
 #define cgraph_get_node(decl) cgraph_node::get(decl)
@@ -618,6 +676,7 @@ inline bool is_a_helper<const gassign *>::test(const_gimple gs)
 #define cgraph_n_nodes symtab->cgraph_count
 #define cgraph_max_uid symtab->cgraph_max_uid
 #define varpool_get_node(decl) varpool_node::get(decl)
+#define dump_varpool_node(file, node) (node)->dump(file)
 
 #define cgraph_create_edge(caller, callee, call_stmt, count, freq, nest) \
 	(caller)->create_edge((callee), (call_stmt), (count), (freq))
@@ -673,6 +732,11 @@ static inline cgraph_node_ptr cgraph_alias_target(cgraph_node_ptr node)
 	return node->get_alias_target();
 }
 
+static inline bool cgraph_for_node_and_aliases(cgraph_node_ptr node, bool (*callback)(cgraph_node_ptr, void *), void *data, bool include_overwritable)
+{
+	return node->call_for_symbol_thunks_and_aliases(callback, data, include_overwritable);
+}
+
 static inline struct cgraph_node_hook_list *cgraph_add_function_insertion_hook(cgraph_node_hook hook, void *data)
 {
 	return symtab->add_cgraph_insertion_hook(hook, data);
@@ -730,6 +794,13 @@ static inline gimple gimple_build_assign_with_ops(enum tree_code subcode, tree l
 
 template <>
 template <>
+inline bool is_a_helper<const ggoto *>::test(const_gimple gs)
+{
+	return gs->code == GIMPLE_GOTO;
+}
+
+template <>
+template <>
 inline bool is_a_helper<const greturn *>::test(const_gimple gs)
 {
 	return gs->code == GIMPLE_RETURN;
@@ -765,6 +836,16 @@ static inline const gcall *as_a_const_gcall(const_gimple stmt)
 	return as_a<const gcall *>(stmt);
 }
 
+static inline ggoto *as_a_ggoto(gimple stmt)
+{
+	return as_a<ggoto *>(stmt);
+}
+
+static inline const ggoto *as_a_const_ggoto(const_gimple stmt)
+{
+	return as_a<const ggoto *>(stmt);
+}
+
 static inline gphi *as_a_gphi(gimple stmt)
 {
 	return as_a<gphi *>(stmt);
@@ -827,4 +908,9 @@ static inline void debug_gimple_stmt(const_gimple s)
 #define debug_gimple_stmt(s) debug_gimple_stmt(CONST_CAST_GIMPLE(s))
 #endif
 
+#if BUILDING_GCC_VERSION >= 7000
+#define get_inner_reference(exp, pbitsize, pbitpos, poffset, pmode, punsignedp, preversep, pvolatilep, keep_aligning)	\
+	get_inner_reference(exp, pbitsize, pbitpos, poffset, pmode, punsignedp, preversep, pvolatilep)
+#endif
+
 #endif
-- 
2.7.4


-- 
Kees Cook
Nexus Security
