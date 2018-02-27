From: P J P <ppandit@redhat.com>
Subject: [PATCH 1/1] Add an option to build kernel with -finit-local-vars
Date: Tue, 27 Feb 2018 16:45:32 +0530
Message-Id: <20180227111532.1144-2-ppandit@redhat.com>
In-Reply-To: <20180227111532.1144-1-ppandit@redhat.com>
References: <20180227111532.1144-1-ppandit@redhat.com>
To: kernel-hardening@lists.openwall.com
Cc: Florian Weimer <fweimer@redhat.com>, P J P <pjp@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: P J P <pjp@fedoraproject.org>

Add a configuration option to build kernel with -finit-local-vars
compiler option.[*] It'll zero initialize the automatic kernel
function variables, thus helping to reduce kernel information
leakage issues.

[*] https://gcc.gnu.org/ml/gcc-patches/2014-06/msg00615.html

Signed-off-by: P J P <pjp@fedoraproject.org>
---
 Makefile          | 4 ++++
 lib/Kconfig.debug | 8 ++++++++
 2 files changed, 12 insertions(+)

diff --git a/Makefile b/Makefile
index 659a7780aeb3..7b25a77470ca 100644
--- a/Makefile
+++ b/Makefile
@@ -781,6 +781,10 @@ KBUILD_CFLAGS 	+= $(call cc-option, -femit-struct-debug-baseonly) \
 		   $(call cc-option,-fno-var-tracking)
 endif
 
+ifdef CONFIG_FINIT_LOCAL_VARS
+KBUILD_CFLAGS  += $(call cc-option, -finit-local-vars)
+endif
+
 ifdef CONFIG_FUNCTION_TRACER
 ifndef CC_FLAGS_FTRACE
 CC_FLAGS_FTRACE := -pg
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 64155e310a9f..8da18d145c5b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -206,6 +206,14 @@ config ENABLE_WARN_DEPRECATED
 	  Disable this to suppress the "warning: 'foo' is deprecated
 	  (declared at kernel/power/somefile.c:1234)" messages.
 
+config FINIT_LOCAL_VARS
+       bool "Enable -finit-local-vars"
+       default n
+       help
+         Enable the -finit-local-vars compiler option during the kernel build.
+         It'll zero initialise the automatic kernel function variables, thus
+         helping to reduce kernel information leakage issues.
+
 config ENABLE_MUST_CHECK
 	bool "Enable __must_check logic"
 	default y
-- 
2.14.3
