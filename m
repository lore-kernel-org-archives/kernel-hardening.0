From: Kees Cook <keescook@chromium.org>
Date: Thu,  6 Apr 2017 14:18:18 -0700
Message-Id: <1491513513-84351-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1491513513-84351-1-git-send-email-keescook@chromium.org>
References: <1491513513-84351-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 03/18] randstruct: Set designated_init attribute
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Michael Leibowitz <michael.leibowitz@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

Since randomized structures need designated initializers, make
sure the designated_init attribute is set for GCC 5.1 and later's
-Werror=designated-init. Since this marking is needed for both manually
and automatically identified structures, have the plugin perform the
marking when active, otherwise fall back to just the manually marked
structures.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/compiler.h                      | 2 +-
 scripts/gcc-plugins/randomize_layout_plugin.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 40e584448605..105410d776a6 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -449,7 +449,7 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
 #endif
 
 #ifndef __randomize_layout
-# define __randomize_layout
+# define __randomize_layout __designated_init
 #endif
 
 #ifndef __no_randomize_layout
diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
index eb8ac6cc315e..6e5dccc4f221 100644
--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -377,6 +377,7 @@ static int relayout_struct(tree type)
 		TYPE_FIELDS(variant) = list;
 		TYPE_ATTRIBUTES(variant) = copy_list(TYPE_ATTRIBUTES(variant));
 		TYPE_ATTRIBUTES(variant) = tree_cons(get_identifier("randomize_performed"), NULL_TREE, TYPE_ATTRIBUTES(variant));
+		TYPE_ATTRIBUTES(variant) = tree_cons(get_identifier("designated_init"), NULL_TREE, TYPE_ATTRIBUTES(variant));
 		if (has_flexarray)
 			TYPE_ATTRIBUTES(type) = tree_cons(get_identifier("has_flexarray"), NULL_TREE, TYPE_ATTRIBUTES(type));
 	}
-- 
2.7.4
