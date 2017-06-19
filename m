From: Kees Cook <keescook@chromium.org>
Date: Mon, 19 Jun 2017 13:56:41 -0700
Message-Id: <1497905801-69164-5-git-send-email-keescook@chromium.org>
In-Reply-To: <1497905801-69164-1-git-send-email-keescook@chromium.org>
References: <1497905801-69164-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 4/4] randstruct: Enable function pointer struct detection
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This enables the automatic structure selection logic in the randstruct
GCC plugin. The selection logic randomizes all structures that contain
only function pointers, unless marked with __no_randomize_layout.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/Kconfig                                  | 12 +++++++-----
 scripts/gcc-plugins/randomize_layout_plugin.c |  3 ---
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 810bf206f221..d8e57d6216b4 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -448,11 +448,13 @@ config GCC_PLUGIN_RANDSTRUCT
 	depends on GCC_PLUGINS
 	select MODVERSIONS if MODULES
 	help
-	  If you say Y here, the layouts of structures explicitly
-	  marked by __randomize_layout will be randomized at
-	  compile-time.  This can introduce the requirement of an
-	  additional information exposure vulnerability for exploits
-	  targeting these structure types.
+	  If you say Y here, the layouts of structures that are entirely
+	  function pointers (and have not been manually annotated with
+	  __no_randomize_layout), or structures that have been explicitly
+	  marked with __randomize_layout, will be randomized at compile-time.
+	  This can introduce the requirement of an additional information
+	  exposure vulnerability for exploits targeting these structure
+	  types.
 
 	  Enabling this feature will introduce some performance impact,
 	  slightly increase memory usage, and prevent the use of forensic
diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
index e6e02a40d522..bb2c6789c4b7 100644
--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -437,9 +437,6 @@ static int is_pure_ops_struct(const_tree node)
 
 	gcc_assert(TREE_CODE(node) == RECORD_TYPE || TREE_CODE(node) == UNION_TYPE);
 
-	/* XXX: Do not apply randomization to all-ftpr structs yet. */
-	return 0;
-
 	for (field = TYPE_FIELDS(node); field; field = TREE_CHAIN(field)) {
 		const_tree fieldtype = get_field_type(field);
 		enum tree_code code = TREE_CODE(fieldtype);
-- 
2.7.4
