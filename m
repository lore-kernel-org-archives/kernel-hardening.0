Date: Wed, 1 Feb 2017 12:23:47 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20170201202347.GA75273@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] randstruct: Use -Werror=designated-init
To: Brad Spengler <spender@grsecurity.net>
Cc: Josh Triplett <josh@joshtriplett.org>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

GCC 5.1 and later supports -Werror=designated-init, which can be used with
randstruct to locate places where designated initializers are missing.

Suggested-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Makefile                                      | 3 +++
 include/linux/compiler-gcc.h                  | 2 ++
 scripts/gcc-plugins/randomize_layout_plugin.c | 1 +
 3 files changed, 6 insertions(+)

diff --git a/Makefile b/Makefile
index f21d750fa022..1f94aba409b5 100644
--- a/Makefile
+++ b/Makefile
@@ -781,6 +781,9 @@ KBUILD_CFLAGS   += $(call cc-option,-Werror=date-time)
 # enforce correct pointer usage
 KBUILD_CFLAGS   += $(call cc-option,-Werror=incompatible-pointer-types)
 
+# Require designated initializers for all marked structures
+KBUILD_CFLAGS   += $(call cc-option,-Werror=designated-init)
+
 # use the deterministic mode of AR if available
 KBUILD_ARFLAGS := $(call ar-option,D)
 
diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 3ae2773b0498..fc411495e534 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -197,6 +197,8 @@
 #ifdef RANDSTRUCT_PLUGIN
 #define __randomize_layout __attribute__((randomize_layout))
 #define __no_randomize_layout __attribute__((no_randomize_layout))
+#else
+#define __randomize_layout __attribute__((designated_init))
 #endif
 
 #ifdef CONSTIFY_PLUGIN
diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
index 1f62fabc1141..9e314e4d9162 100644
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


-- 
Kees Cook
Pixel Security
