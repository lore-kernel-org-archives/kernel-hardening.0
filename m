From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH v2 18/21] gcc-plugins: move GCC version check for PowerPC to Kconfig
Date: Tue, 27 Mar 2018 14:29:32 +0900
Message-Id: <1522128575-5326-19-git-send-email-yamada.masahiro@socionext.com>
In-Reply-To: <1522128575-5326-1-git-send-email-yamada.masahiro@socionext.com>
References: <1522128575-5326-1-git-send-email-yamada.masahiro@socionext.com>
To: linux-kbuild@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Linus Torvalds <torvalds@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Ulf Magnusson <ulfalizer@gmail.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Nicolas Pitre <nico@linaro.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

For PowerPC, GCC 5.2 is the requirement for GCC plugins.  Move the
version check to Kconfig so that the GCC plugin menus will be hidden
if an older compiler is in use.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Acked-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
---

Changes in v2: None

 arch/powerpc/Kconfig         | 2 +-
 scripts/Makefile.gcc-plugins | 8 --------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 73ce5dd..b8474c2 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -195,7 +195,7 @@ config PPC
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_TRACER
-	select HAVE_GCC_PLUGINS
+	select HAVE_GCC_PLUGINS			if GCC_VERSION >= 50200
 	select HAVE_GENERIC_GUP
 	select HAVE_HW_BREAKPOINT		if PERF_EVENTS && (PPC_BOOK3S || PPC_8xx)
 	select HAVE_IDE
diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index b0f9108..25da4c0 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -56,14 +56,6 @@ gcc-plugins-check: FORCE
 ifdef CONFIG_GCC_PLUGINS
   ifeq ($(PLUGINCC),)
     ifneq ($(GCC_PLUGINS_CFLAGS),)
-      # Various gccs between 4.5 and 5.1 have bugs on powerpc due to missing
-      # header files. gcc <= 4.6 doesn't work at all, gccs from 4.8 to 5.1 have
-      # issues with 64-bit targets.
-      ifeq ($(ARCH),powerpc)
-        ifeq ($(call cc-ifversion, -le, 0501, y), y)
-	  @echo "Cannot use CONFIG_GCC_PLUGINS: plugin support on gcc <= 5.1 is buggy on powerpc, please upgrade to gcc 5.2 or newer" >&2 && exit 1
-        endif
-      endif
       $(Q)$(srctree)/scripts/gcc-plugin.sh --show-error $(HOSTCXX) $(CC) || true
       @echo "Cannot use CONFIG_GCC_PLUGINS: your gcc installation does not support plugins, perhaps the necessary headers are missing?" >&2 && exit 1
     endif
-- 
2.7.4
