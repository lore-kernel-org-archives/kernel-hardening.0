From: Kees Cook <keescook@chromium.org>
Date: Thu,  6 Apr 2017 14:18:22 -0700
Message-Id: <1491513513-84351-8-git-send-email-keescook@chromium.org>
In-Reply-To: <1491513513-84351-1-git-send-email-keescook@chromium.org>
References: <1491513513-84351-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [PATCH 07/18] randstruct: Whitelist struct security_hook_heads cast
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Michael Leibowitz <michael.leibowitz@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

The LSM initialization routines walk security_hook_heads as an array
of struct list_head instead of via names to avoid a ton of needless
source. Whitelist this to avoid the false positive warning from the
plugin:

security/security.c: In function ‘security_init’:
security/security.c:59:20: note: found mismatched op0 struct pointer types: ‘struct list_head’ and ‘struct security_hook_heads’

  struct list_head *list = (struct list_head *) &security_hook_heads;
                    ^

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 scripts/gcc-plugins/randomize_layout_plugin.c | 38 ++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
index dc03a6beb06b..63c654a00249 100644
--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -762,6 +762,33 @@ static void handle_local_var_initializers(void)
 	}
 }
 
+static bool type_name_eq(gimple stmt, const_tree type_tree, const char *wanted_name)
+{
+	const char *type_name;
+
+	if (type_tree == NULL_TREE)
+		return false;
+
+	switch (TREE_CODE(type_tree)) {
+	case RECORD_TYPE:
+		type_name = TYPE_NAME_POINTER(type_tree);
+		break;
+	default:
+		inform(gimple_location(stmt), "unhandled cast comparison: %qT\n", type_tree);
+		debug_tree(type_tree);
+		return false;
+	}
+
+	return strcmp(type_name, wanted_name) == 0;
+}
+
+static bool whitelisted_cast(gimple stmt,
+			     const_tree lhs_tree, const_tree rhs_tree,
+			     const char *lhs, const char *rhs)
+{
+	return type_name_eq(stmt, lhs_tree, lhs) && type_name_eq(stmt, rhs_tree, rhs);
+}
+
 /*
  * iterate over all statements to find "bad" casts:
  * those where the address of the start of a structure is cast
@@ -859,8 +886,17 @@ static unsigned int find_bad_casts_execute(void)
 
 #ifndef __DEBUG_PLUGIN
 				if (lookup_attribute("randomize_performed", TYPE_ATTRIBUTES(op0_type)))
+				{
 #endif
-				inform(gimple_location(stmt), "found mismatched op0 struct pointer types: %qT and %qT\n", ptr_lhs_type, op0_type);
+					/*
+					 * Whitelist walking struct security_hook_heads
+					 * as an array of struct list_head.
+					 */
+					if (whitelisted_cast(stmt, ptr_lhs_type, op0_type, "list_head", "security_hook_heads"))
+						continue;
+
+					inform(gimple_location(stmt), "found mismatched op0 struct pointer types: %qT and %qT\n", ptr_lhs_type, op0_type);
+				}
 			} else {
 				const_tree ssa_name_var = SSA_NAME_VAR(rhs1);
 				/* skip bogus type casts introduced by container_of */
-- 
2.7.4
