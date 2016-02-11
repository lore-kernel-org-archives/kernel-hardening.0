Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 11 Feb 2016 23:43:01 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160211234301.84a5ff8e513f5d5f78478283@gmail.com>
In-Reply-To: <20160211233646.97c2af3675dc5b0f525f0489@gmail.com>
References: <20160211233646.97c2af3675dc5b0f525f0489@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v2 3/3] Documentation for the GCC plugin infrastructure
To: linux-kbuild@vger.kernel.org
Cc: pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, mmarek@suse.com, keescook@chromium.org, linux@rasmusvillemoes.dk
List-ID: <kernel-hardening.lists.openwall.com>

This is the GCC infrastructure documentation about its operation, how to add
and use a new plugin with an example.
---
 Documentation/gcc-plugins.txt | 68 +++++++++++++++++++++++++++++++++++++++++++
 arch/Kconfig                  |  2 ++
 2 files changed, 70 insertions(+)
 create mode 100644 Documentation/gcc-plugins.txt

diff --git a/Documentation/gcc-plugins.txt b/Documentation/gcc-plugins.txt
new file mode 100644
index 0000000..e1171c2
--- /dev/null
+++ b/Documentation/gcc-plugins.txt
@@ -0,0 +1,68 @@
+GCC plugin infrastructure
+=========================
+
+
+1. Introduction
+===============
+
+GCC plugins are loadable modules that provide extra features to the
+compiler [1]. They are useful for runtime instrumentation and static analysis.
+We can analyse, change and add further code during compilation via
+callbacks [2], GIMPLE [3], IPA [4] and RTL passes [5].
+
+The GCC plugin infrastructure of the kernel supports all gcc versions from
+4.5 to 6.0, building out-of-tree modules, cross-compilation and building in a
+separate directory.
+
+Currently the GCC plugin infrastructure supports only the x86 architecture.
+
+This infrastructure was ported from grsecurity [6] and PaX [7].
+
+--
+[1] https://gcc.gnu.org/onlinedocs/gccint/Plugins.html
+[2] https://gcc.gnu.org/onlinedocs/gccint/Plugin-API.html#Plugin-API
+[3] https://gcc.gnu.org/onlinedocs/gccint/GIMPLE.html
+[4] https://gcc.gnu.org/onlinedocs/gccint/IPA.html
+[5] https://gcc.gnu.org/onlinedocs/gccint/RTL.html
+[6] https://grsecurity.net/
+[7] https://pax.grsecurity.net/
+
+
+2. Files
+========
+
+$(src)/tools/gcc
+	This is the directory of the GCC plugins.
+
+$(src)/tools/gcc/gcc-common.h
+	This is a compatibility header for GCC plugins.
+	It should be always included instead of individual gcc headers.
+
+$(src)/scripts/gcc-plugin.sh
+	This script checks the availability of the included headers in
+	gcc-common.h and chooses the proper host compiler to build the plugins
+	(gcc-4.7 can be built by either gcc or g++).
+
+
+3. Usage
+========
+
+Enable a GCC plugin based feature in the kernel config:
+
+	CONFIG_GCC_PLUGIN_CYC_COMPLEXITY = y
+
+To compile only the plugin(s):
+
+	make gcc-plugins
+
+or just run the kernel make and compile the whole kernel with
+the cyclomatic complexity GCC plugin.
+
+
+4. How to add a new GCC plugin
+==============================
+
+The GCC plugins are in $(src)/tools/gcc/. You can use a file or a directory
+here. It must be added to $(src)/tools/gcc/Makefile,
+$(src)/scripts/Makefile.gcc-plugins and $(src)/arch/Kconfig.
+See the cyc_complexity_plugin.c (CONFIG_GCC_PLUGIN_CYC_COMPLEXITY) GCC plugin.
diff --git a/arch/Kconfig b/arch/Kconfig
index a558ecb..38964dd 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -377,6 +377,8 @@ config GCC_PLUGIN_CYC_COMPLEXITY
 	  N = the number of nodes
 	  P = the number of connected components (exit nodes).
 
+	  See Documentation/gcc-plugins.txt for details.
+
 endmenu # "GCC plugins"
 
 config HAVE_CC_STACKPROTECTOR
-- 
2.4.1
