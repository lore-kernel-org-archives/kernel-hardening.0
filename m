From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Date: Sat, 17 Jun 2017 12:25:41 -0300
Message-Id: <956283e0d9f9c01a437ab75c5c9a324959ead132.1497713142.git.mchehab@s-opensource.com>
In-Reply-To: <f0f77a106d183325dce9eecd3c11214154050e11.1497713142.git.mchehab@s-opensource.com>
References: <f0f77a106d183325dce9eecd3c11214154050e11.1497713142.git.mchehab@s-opensource.com>
In-Reply-To: <f0f77a106d183325dce9eecd3c11214154050e11.1497713142.git.mchehab@s-opensource.com>
References: <f0f77a106d183325dce9eecd3c11214154050e11.1497713142.git.mchehab@s-opensource.com>
Sender: Mauro Carvalho Chehab <mchehab@smtp.s-opensource.com>
Subject: [kernel-hardening] [PATCH v2 22/31] gcc-plugins.txt: standardize document format
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Each text file under Documentation follows a different
format. Some doesn't even have titles!

Change its representation to follow the adopted standard,
using ReST markups for it to be parseable by Sphinx:

- promote main title;
- use the right markup for footnotes;
- use bold markup for files name;
- identify literal blocks;
- add blank lines to avoid Sphinx to complain;
- remove numeration from titles.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/gcc-plugins.txt | 58 ++++++++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 26 deletions(-)

diff --git a/Documentation/gcc-plugins.txt b/Documentation/gcc-plugins.txt
index 433eaefb4aa1..8502f24396fb 100644
--- a/Documentation/gcc-plugins.txt
+++ b/Documentation/gcc-plugins.txt
@@ -1,14 +1,15 @@
+=========================
 GCC plugin infrastructure
 =========================
 
 
-1. Introduction
-===============
+Introduction
+============
 
 GCC plugins are loadable modules that provide extra features to the
-compiler [1]. They are useful for runtime instrumentation and static analysis.
+compiler [1]_. They are useful for runtime instrumentation and static analysis.
 We can analyse, change and add further code during compilation via
-callbacks [2], GIMPLE [3], IPA [4] and RTL passes [5].
+callbacks [2]_, GIMPLE [3]_, IPA [4]_ and RTL passes [5]_.
 
 The GCC plugin infrastructure of the kernel supports all gcc versions from
 4.5 to 6.0, building out-of-tree modules, cross-compilation and building in a
@@ -21,56 +22,61 @@ and versions 4.8+ can only be compiled by a C++ compiler.
 Currently the GCC plugin infrastructure supports only the x86, arm, arm64 and
 powerpc architectures.
 
-This infrastructure was ported from grsecurity [6] and PaX [7].
+This infrastructure was ported from grsecurity [6]_ and PaX [7]_.
 
 --
-[1] https://gcc.gnu.org/onlinedocs/gccint/Plugins.html
-[2] https://gcc.gnu.org/onlinedocs/gccint/Plugin-API.html#Plugin-API
-[3] https://gcc.gnu.org/onlinedocs/gccint/GIMPLE.html
-[4] https://gcc.gnu.org/onlinedocs/gccint/IPA.html
-[5] https://gcc.gnu.org/onlinedocs/gccint/RTL.html
-[6] https://grsecurity.net/
-[7] https://pax.grsecurity.net/
 
+.. [1] https://gcc.gnu.org/onlinedocs/gccint/Plugins.html
+.. [2] https://gcc.gnu.org/onlinedocs/gccint/Plugin-API.html#Plugin-API
+.. [3] https://gcc.gnu.org/onlinedocs/gccint/GIMPLE.html
+.. [4] https://gcc.gnu.org/onlinedocs/gccint/IPA.html
+.. [5] https://gcc.gnu.org/onlinedocs/gccint/RTL.html
+.. [6] https://grsecurity.net/
+.. [7] https://pax.grsecurity.net/
 
-2. Files
-========
 
-$(src)/scripts/gcc-plugins
+Files
+=====
+
+**$(src)/scripts/gcc-plugins**
+
 	This is the directory of the GCC plugins.
 
-$(src)/scripts/gcc-plugins/gcc-common.h
+**$(src)/scripts/gcc-plugins/gcc-common.h**
+
 	This is a compatibility header for GCC plugins.
 	It should be always included instead of individual gcc headers.
 
-$(src)/scripts/gcc-plugin.sh
+**$(src)/scripts/gcc-plugin.sh**
+
 	This script checks the availability of the included headers in
 	gcc-common.h and chooses the proper host compiler to build the plugins
 	(gcc-4.7 can be built by either gcc or g++).
 
-$(src)/scripts/gcc-plugins/gcc-generate-gimple-pass.h
-$(src)/scripts/gcc-plugins/gcc-generate-ipa-pass.h
-$(src)/scripts/gcc-plugins/gcc-generate-simple_ipa-pass.h
-$(src)/scripts/gcc-plugins/gcc-generate-rtl-pass.h
+**$(src)/scripts/gcc-plugins/gcc-generate-gimple-pass.h,
+$(src)/scripts/gcc-plugins/gcc-generate-ipa-pass.h,
+$(src)/scripts/gcc-plugins/gcc-generate-simple_ipa-pass.h,
+$(src)/scripts/gcc-plugins/gcc-generate-rtl-pass.h**
+
 	These headers automatically generate the registration structures for
 	GIMPLE, SIMPLE_IPA, IPA and RTL passes. They support all gcc versions
 	from 4.5 to 6.0.
 	They should be preferred to creating the structures by hand.
 
 
-3. Usage
-========
+Usage
+=====
 
 You must install the gcc plugin headers for your gcc version,
-e.g., on Ubuntu for gcc-4.9:
+e.g., on Ubuntu for gcc-4.9::
 
 	apt-get install gcc-4.9-plugin-dev
 
-Enable a GCC plugin based feature in the kernel config:
+Enable a GCC plugin based feature in the kernel config::
 
 	CONFIG_GCC_PLUGIN_CYC_COMPLEXITY = y
 
-To compile only the plugin(s):
+To compile only the plugin(s)::
 
 	make gcc-plugins
 
-- 
2.9.4
