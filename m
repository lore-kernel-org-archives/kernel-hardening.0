From: Kees Cook <keescook@chromium.org>
Date: Thu,  6 Apr 2017 14:18:30 -0700
Message-Id: <1491513513-84351-16-git-send-email-keescook@chromium.org>
In-Reply-To: <1491513513-84351-1-git-send-email-keescook@chromium.org>
References: <1491513513-84351-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 15/18] randstruct: Enable function pointer struct detection
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Michael Leibowitz <michael.leibowitz@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

With prior patches landed that clean up structure initialization, it is
now possible to enable CONFIG_GCC_PLUGIN_RANDSTRUCT's detection and
randomization of structures that contain only function pointers.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 scripts/gcc-plugins/randomize_layout_plugin.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
index cbde695e392a..716bb877b3fd 100644
--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -420,9 +420,6 @@ static int is_pure_ops_struct(const_tree node)
 
 	gcc_assert(TREE_CODE(node) == RECORD_TYPE || TREE_CODE(node) == UNION_TYPE);
 
-	/* XXX: Do not apply randomization to all-ftpr structs yet. */
-	return 0;
-
 	for (field = TYPE_FIELDS(node); field; field = TREE_CHAIN(field)) {
 		const_tree fieldtype = get_field_type(field);
 		enum tree_code code = TREE_CODE(fieldtype);
-- 
2.7.4
