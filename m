Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 22 Apr 2016 20:26:03 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160422202603.5daf3b4c09a20a6c515ac70e@gmail.com>
In-Reply-To: <20160422201957.97ce16f0e67377d0ce613d19@gmail.com>
References: <20160422201957.97ce16f0e67377d0ce613d19@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v7 5/6] Documentation for the GCC plugin infrastructure
To: linux-kbuild@vger.kernel.org
Cc: pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, mmarek@suse.com, keescook@chromium.org, linux@rasmusvillemoes.dk, fengguang.wu@intel.com, dvyukov@google.com, linux-kernel@vger.kernel.org, david.brown@linaro.org, yamada.masahiro@socionext.com
List-ID: <kernel-hardening.lists.openwall.com>

This is the GCC infrastructure documentation about its operation, how to add
and use a new plugin with an example.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 Documentation/gcc-plugins.txt | 83 +++++++++++++++++++++++++++++++++++++++++++
 arch/Kconfig                  |  2 ++
 2 files changed, 85 insertions(+)
 create mode 100644 Documentation/gcc-plugins.txt

diff --git a/Documentation/gcc-plugins.txt b/Documentation/gcc-plugins.txt
new file mode 100644
index 0000000..9fa9bd2
--- /dev/null
+++ b/Documentation/gcc-plugins.txt
@@ -0,0 +1,83 @@
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
+Currently the GCC plugin infrastructure supports only the x86, arm and arm64
+architectures.
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
+$(src)/scripts/gcc-plugins
+	This is the directory of the GCC plugins.
+
+$(src)/scripts/gcc-plugins/gcc-common.h
+	This is a compatibility header for GCC plugins.
+	It should be always included instead of individual gcc headers.
+
+$(src)/scripts/gcc-plugin.sh
+	This script checks the availability of the included headers in
+	gcc-common.h and chooses the proper host compiler to build the plugins
+	(gcc-4.7 can be built by either gcc or g++).
+
+$(src)/scripts/gcc-plugins/gcc-generate-gimple-pass.h
+$(src)/scripts/gcc-plugins/gcc-generate-ipa-pass.h
+$(src)/scripts/gcc-plugins/gcc-generate-simple_ipa-pass.h
+$(src)/scripts/gcc-plugins/gcc-generate-rtl-pass.h
+	These headers automatically generate the registration structures for
+	GIMPLE, SIMPLE_IPA, IPA and RTL passes. They support all gcc versions
+	from 4.5 to 6.0.
+	They should be preferred to creating the structures by hand.
+
+
+3. Usage
+========
+
+You must install the gcc plugin headers for your gcc version,
+e.g., on Ubuntu for gcc-4.9:
+
+	apt-get install gcc-4.9-plugin-dev
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
+The GCC plugins are in $(src)/scripts/gcc-plugins/. You can use a file or a directory
+here. It must be added to $(src)/scripts/gcc-plugins/Makefile,
+$(src)/scripts/Makefile.gcc-plugins and $(src)/arch/Kconfig.
+See the cyc_complexity_plugin.c (CONFIG_GCC_PLUGIN_CYC_COMPLEXITY) GCC plugin.
diff --git a/arch/Kconfig b/arch/Kconfig
index ddf29b4..e783429 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -366,6 +366,8 @@ menuconfig GCC_PLUGINS
 	  GCC plugins are loadable modules that provide extra features to the
 	  compiler. They are useful for runtime instrumentation and static analysis.
 
+	  See Documentation/gcc-plugins.txt for details.
+
 config GCC_PLUGIN_CYC_COMPLEXITY
 	bool "Compute the cyclomatic complexity of a function"
 	depends on GCC_PLUGINS
-- 
2.4.1
