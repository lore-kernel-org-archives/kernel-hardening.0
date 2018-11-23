From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 2/2] kbuild: descend into scripts/gcc-plugins/ via scripts/Makefile
Date: Fri, 23 Nov 2018 13:51:27 +0900
Message-Id: <1542948687-7326-2-git-send-email-yamada.masahiro@socionext.com>
In-Reply-To: <1542948687-7326-1-git-send-email-yamada.masahiro@socionext.com>
References: <1542948687-7326-1-git-send-email-yamada.masahiro@socionext.com>
To: linux-kbuild@vger.kernel.org
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, Michal Marek <michal.lkml@markovi.net>, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Now that 'prepare0' depends on 'scripts', building GCC plugins can
go into scripts/Makefile, which is a more standard way.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 Makefile                     | 2 +-
 scripts/Makefile             | 3 ++-
 scripts/Makefile.gcc-plugins | 8 --------
 3 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/Makefile b/Makefile
index cee4cec..a8bbe68 100644
--- a/Makefile
+++ b/Makefile
@@ -1114,7 +1114,7 @@ macroprepare: prepare1 archmacros
 
 archprepare: archheaders archscripts macroprepare scripts_basic
 
-prepare0: scripts archprepare gcc-plugins
+prepare0: scripts archprepare
 	$(Q)$(MAKE) $(build)=scripts/mod
 	$(Q)$(MAKE) $(build)=.
 
diff --git a/scripts/Makefile b/scripts/Makefile
index b48259d..feb1f71 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -36,9 +36,10 @@ PHONY += build_unifdef
 build_unifdef: $(obj)/unifdef
 	@:
 
+subdir-$(CONFIG_GCC_PLUGINS) += gcc-plugins
 subdir-$(CONFIG_MODVERSIONS) += genksyms
 subdir-$(CONFIG_SECURITY_SELINUX) += selinux
 subdir-$(CONFIG_GDB_SCRIPTS) += gdb
 
 # Let clean descend into subdirs
-subdir-	+= basic dtc kconfig mod package gcc-plugins
+subdir-	+= basic dtc kconfig mod package
diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index 46c5c68..c36f199 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -49,11 +49,3 @@ KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
 # All enabled GCC plugins are collected here for building below.
 GCC_PLUGIN := $(gcc-plugin-y)
 export GCC_PLUGIN
-
-# Actually do the build, if requested.
-PHONY += gcc-plugins
-gcc-plugins: scripts_basic
-ifdef CONFIG_GCC_PLUGINS
-	$(Q)$(MAKE) $(build)=scripts/gcc-plugins
-endif
-	@:
-- 
2.7.4
