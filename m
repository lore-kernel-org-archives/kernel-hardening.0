From: Shyam Saini <shyam.saini@amarulasolutions.com>
Subject: [PATCH 2/2] include: linux: Remove unused macros and their defination
Date: Sun, 14 Apr 2019 14:44:52 +0530
Message-Id: <20190414091452.22275-2-shyam.saini@amarulasolutions.com>
In-Reply-To: <20190414091452.22275-1-shyam.saini@amarulasolutions.com>
References: <20190414091452.22275-1-shyam.saini@amarulasolutions.com>
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, keescook@chromium.org, linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, netdev@vger.kernel.org, linux-ext4@vger.kernel.org, devel@lists.orangefs.org, linux-mm@kvack.org, linux-sctp@vger.kernel.org, bpf@vger.kernel.org, kvm@vger.kernel.org, mayhs11saini@gmail.com, Shyam Saini <shyam.saini@amarulasolutions.com>
List-ID: <kernel-hardening.lists.openwall.com>

In favour of FIELD_SIZEOF, lets deprecate other two similar macros
sizeof_field and SIZEOF_FIELD, and remove them completely.

Signed-off-by: Shyam Saini <shyam.saini@amarulasolutions.com>
---
 arch/mips/cavium-octeon/executive/cvmx-bootmem.c | 7 -------
 include/linux/stddef.h                           | 8 --------
 tools/testing/selftests/bpf/bpf_util.h           | 4 ----
 3 files changed, 19 deletions(-)

diff --git a/arch/mips/cavium-octeon/executive/cvmx-bootmem.c b/arch/mips/cavium-octeon/executive/cvmx-bootmem.c
index fc754d155002..44b506a14666 100644
--- a/arch/mips/cavium-octeon/executive/cvmx-bootmem.c
+++ b/arch/mips/cavium-octeon/executive/cvmx-bootmem.c
@@ -45,13 +45,6 @@ static struct cvmx_bootmem_desc *cvmx_bootmem_desc;
 /* See header file for descriptions of functions */
 
 /**
- * This macro returns the size of a member of a structure.
- * Logically it is the same as "sizeof(s::field)" in C++, but
- * C lacks the "::" operator.
- */
-#define SIZEOF_FIELD(s, field) sizeof(((s *)NULL)->field)
-
-/**
  * This macro returns a member of the
  * cvmx_bootmem_named_block_desc_t structure. These members can't
  * be directly addressed as they might be in memory not directly
diff --git a/include/linux/stddef.h b/include/linux/stddef.h
index 63f2302bc406..b888eb7795a1 100644
--- a/include/linux/stddef.h
+++ b/include/linux/stddef.h
@@ -29,14 +29,6 @@ enum {
 #define FIELD_SIZEOF(t, f) (sizeof(((t *)0)->f))
 
 /**
- * sizeof_field(TYPE, MEMBER)
- *
- * @TYPE: The structure containing the field of interest
- * @MEMBER: The field to return the size of
- */
-#define sizeof_field(TYPE, MEMBER) sizeof((((TYPE *)0)->MEMBER))
-
-/**
  * offsetofend(TYPE, MEMBER)
  *
  * @TYPE: The type of the structure
diff --git a/tools/testing/selftests/bpf/bpf_util.h b/tools/testing/selftests/bpf/bpf_util.h
index 2e90a4315b55..815e7b48fa37 100644
--- a/tools/testing/selftests/bpf/bpf_util.h
+++ b/tools/testing/selftests/bpf/bpf_util.h
@@ -67,10 +67,6 @@ static inline unsigned int bpf_num_possible_cpus(void)
  */
 #define FIELD_SIZEOF(t, f) (sizeof(((t *)0)->f))
 
-#ifndef sizeof_field
-#define sizeof_field(TYPE, MEMBER) sizeof((((TYPE *)0)->MEMBER))
-#endif
-
 #ifndef offsetofend
 #define offsetofend(TYPE, MEMBER) \
 	(offsetof(TYPE, MEMBER)	+ FIELD_SIZEOF(TYPE, MEMBER))
-- 
2.11.0
