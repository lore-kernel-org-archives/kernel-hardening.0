From: Kees Cook <keescook@chromium.org>
Date: Thu,  6 Apr 2017 14:18:19 -0700
Message-Id: <1491513513-84351-5-git-send-email-keescook@chromium.org>
In-Reply-To: <1491513513-84351-1-git-send-email-keescook@chromium.org>
References: <1491513513-84351-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 04/18] randstruct: Differentiate bad cast warnings
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Michael Leibowitz <michael.leibowitz@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

This updates the bad cast warnings to be more specific about which kind
of comparison failed.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 scripts/gcc-plugins/randomize_layout_plugin.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
index 6e5dccc4f221..dc03a6beb06b 100644
--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -668,7 +668,7 @@ static void check_bad_casts_in_constructor(tree var, tree init)
 
 		if (!lookup_attribute("randomize_performed", TYPE_ATTRIBUTES(val_type)))
 			continue;
-		inform(DECL_SOURCE_LOCATION(var), "found mismatched struct pointer types: %qT and %qT\n", TYPE_MAIN_VARIANT(field_type), TYPE_MAIN_VARIANT(val_type));
+		inform(DECL_SOURCE_LOCATION(var), "found mismatched constructor struct pointer types: %qT and %qT\n", TYPE_MAIN_VARIANT(field_type), TYPE_MAIN_VARIANT(val_type));
 	}
 }
 
@@ -837,7 +837,7 @@ static unsigned int find_bad_casts_execute(void)
 #ifndef __DEBUG_PLUGIN
 				if (lookup_attribute("randomize_performed", TYPE_ATTRIBUTES(ptr_lhs_type)))
 #endif
-				inform(gimple_location(stmt), "found mismatched struct pointer types: %qT and %qT\n", ptr_lhs_type, ptr_rhs_type);
+				inform(gimple_location(stmt), "found mismatched rhs struct pointer types: %qT and %qT\n", ptr_lhs_type, ptr_rhs_type);
 				continue;
 			}
 
@@ -860,7 +860,7 @@ static unsigned int find_bad_casts_execute(void)
 #ifndef __DEBUG_PLUGIN
 				if (lookup_attribute("randomize_performed", TYPE_ATTRIBUTES(op0_type)))
 #endif
-				inform(gimple_location(stmt), "found mismatched struct pointer types: %qT and %qT\n", ptr_lhs_type, op0_type);
+				inform(gimple_location(stmt), "found mismatched op0 struct pointer types: %qT and %qT\n", ptr_lhs_type, op0_type);
 			} else {
 				const_tree ssa_name_var = SSA_NAME_VAR(rhs1);
 				/* skip bogus type casts introduced by container_of */
@@ -870,7 +870,7 @@ static unsigned int find_bad_casts_execute(void)
 #ifndef __DEBUG_PLUGIN
 				if (lookup_attribute("randomize_performed", TYPE_ATTRIBUTES(ptr_rhs_type)))
 #endif
-				inform(gimple_location(stmt), "found mismatched struct pointer types: %qT and %qT\n", ptr_lhs_type, ptr_rhs_type);
+				inform(gimple_location(stmt), "found mismatched ssa struct pointer types: %qT and %qT\n", ptr_lhs_type, ptr_rhs_type);
 			}
 
 		}
-- 
2.7.4
