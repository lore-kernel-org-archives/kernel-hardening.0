Date: Fri,  8 Mar 2019 14:27:01 +0100
In-Reply-To: <20190308132701.133598-1-glider@google.com>
Message-Id: <20190308132701.133598-3-glider@google.com>
Mime-Version: 1.0
References: <20190308132701.133598-1-glider@google.com>
Subject: [PATCH v2 2/2] initmem: introduce CONFIG_INIT_ALL_HEAP
From: Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"
To: yamada.masahiro@socionext.com, jmorris@namei.org, serge@hallyn.com
Cc: linux-security-module@vger.kernel.org, linux-kbuild@vger.kernel.org, ndesaulniers@google.com, kcc@google.com, dvyukov@google.com, keescook@chromium.org, sspatil@android.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This config option enables CONFIG_SLUB_DEBUG and CONFIG_PAGE_POISONING
without the need to pass any boot parameters.

No performance optimizations are done at the moment to reduce double
initialization of memory regions.

Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Kostya Serebryany <kcc@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Sandeep Patil <sspatil@android.com>
Cc: linux-security-module@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com
---
 mm/page_poison.c         |  5 +++++
 mm/slub.c                |  2 ++
 security/Kconfig.initmem | 11 +++++++++++
 3 files changed, 18 insertions(+)

diff --git a/mm/page_poison.c b/mm/page_poison.c
index 21d4f97cb49b..a1985f33f635 100644
--- a/mm/page_poison.c
+++ b/mm/page_poison.c
@@ -12,9 +12,14 @@ static bool want_page_poisoning __read_mostly;
 
 static int __init early_page_poison_param(char *buf)
 {
+#ifdef CONFIG_INIT_ALL_HEAP
+	want_page_poisoning = true;
+	return 0;
+#else
 	if (!buf)
 		return -EINVAL;
 	return strtobool(buf, &want_page_poisoning);
+#endif
 }
 early_param("page_poison", early_page_poison_param);
 
diff --git a/mm/slub.c b/mm/slub.c
index 1b08fbcb7e61..00e0197d3f35 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1287,6 +1287,8 @@ static int __init setup_slub_debug(char *str)
 	if (*str == ',')
 		slub_debug_slabs = str + 1;
 out:
+	if (IS_ENABLED(CONFIG_INIT_ALL_HEAP))
+		slub_debug |= SLAB_POISON;
 	return 1;
 }
 
diff --git a/security/Kconfig.initmem b/security/Kconfig.initmem
index 27aec394365e..5ce49663777a 100644
--- a/security/Kconfig.initmem
+++ b/security/Kconfig.initmem
@@ -13,6 +13,17 @@ config INIT_ALL_MEMORY
 
 if INIT_ALL_MEMORY
 
+config INIT_ALL_HEAP
+	bool "Initialize all heap"
+	depends on INIT_ALL_MEMORY
+	select CONFIG_PAGE_POISONING
+	select CONFIG_PAGE_POISONING_NO_SANITY
+	select CONFIG_PAGE_POISONING_ZERO
+	select CONFIG_SLUB_DEBUG
+	default y
+	help
+	  Enable page poisoning and slub poisoning by default.
+
 config INIT_ALL_STACK
 	bool "Initialize all stack"
 	depends on INIT_ALL_MEMORY
-- 
2.21.0.360.g471c308f928-goog
