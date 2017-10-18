From: "Tobin C. Harding" <me@tobin.cc>
Date: Wed, 18 Oct 2017 11:54:48 +1100
Message-Id: <1508288088-31867-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH v3] printk: hash addresses printed with %p
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <me@tobin.cc>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Currently there are many places in the kernel where addresses are being
printed using an unadorned %p. Kernel pointers should be printed using
%pK allowing some control via the kptr_restrict sysctl. Exposing addresses
gives attackers sensitive information about the kernel layout in memory.

We can reduce the attack surface by hashing all addresses printed with
%p. This will of course break some users, forcing code printing needed
addresses to be updated.

For what it's worth, usage of unadorned %p can be broken down as
follows (thanks to Joe Perches).

$ git grep -E '%p[^A-Za-z0-9]' | cut -f1 -d"/" | sort | uniq -c
   1084 arch
     20 block
     10 crypto
     32 Documentation
   8121 drivers
   1221 fs
    143 include
    101 kernel
     69 lib
    100 mm
   1510 net
     40 samples
      7 scripts
     11 security
    166 sound
    152 tools
      2 virt

Add function ptr_to_id() to map an address to a 32 bit unique identifier.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---

V3:
 - Use atomic_xchg() to guard setting [random] key.
 - Remove erroneous white space change.

V2:
 - Use SipHash to do the hashing.

The discussion related to this patch has been fragmented. There are
three threads associated with this patch. Email threads by subject:

[PATCH] printk: hash addresses printed with %p
[PATCH 0/3] add %pX specifier
[kernel-hardening] [RFC V2 0/6] add more kernel pointer filter options

 include/linux/siphash.h |  2 ++
 lib/siphash.c           | 13 +++++++++++++
 lib/vsprintf.c          | 28 +++++++++++++++++++++++++---
 3 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/include/linux/siphash.h b/include/linux/siphash.h
index fa7a6b9cedbf..a9392568c8b8 100644
--- a/include/linux/siphash.h
+++ b/include/linux/siphash.h
@@ -26,6 +26,8 @@ u64 __siphash_aligned(const void *data, size_t len, const siphash_key_t *key);
 u64 __siphash_unaligned(const void *data, size_t len, const siphash_key_t *key);
 #endif
 
+unsigned long siphash_1ulong(const unsigned long a, const siphash_key_t *key);
+
 u64 siphash_1u64(const u64 a, const siphash_key_t *key);
 u64 siphash_2u64(const u64 a, const u64 b, const siphash_key_t *key);
 u64 siphash_3u64(const u64 a, const u64 b, const u64 c,
diff --git a/lib/siphash.c b/lib/siphash.c
index 3ae58b4edad6..63f4ff57c9ce 100644
--- a/lib/siphash.c
+++ b/lib/siphash.c
@@ -116,6 +116,19 @@ EXPORT_SYMBOL(__siphash_unaligned);
 #endif
 
 /**
+ * siphash_1ulong - computes siphash PRF value
+ * @first: value to hash
+ * @key: the siphash key
+ */
+unsigned long siphash_1ulong(const unsigned long first, const siphash_key_t *key)
+{
+#ifdef CONFIG_64BIT
+	return (unsigned long)siphash_1u64((u64)first, key);
+#endif
+	return (unsigned long)siphash_1u32((u32)first, key);
+}
+
+/**
  * siphash_1u64 - compute 64-bit siphash PRF value of a u64
  * @first: first u64
  * @key: the siphash key
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 86c3385b9eb3..b3b680357a85 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -33,6 +33,7 @@
 #include <linux/uuid.h>
 #include <linux/of.h>
 #include <net/addrconf.h>
+#include <linux/siphash.h>
 #ifdef CONFIG_BLOCK
 #include <linux/blkdev.h>
 #endif
@@ -1591,6 +1592,25 @@ char *device_node_string(char *buf, char *end, struct device_node *dn,
 	return widen_string(buf, buf - buf_start, end, spec);
 }
 
+/* Maps a pointer to a 32 bit unique identifier. */
+static char *ptr_to_id(char *buf, char *end, void *ptr, struct printf_spec spec)
+{
+	static siphash_key_t ptr_secret __read_mostly;
+	static atomic_t have_key = ATOMIC_INIT(0);
+	unsigned long hashval;
+
+        if (atomic_xchg(&have_key, 1) == 0)
+		get_random_bytes(&ptr_secret, sizeof(ptr_secret));
+
+	hashval = siphash_1ulong((unsigned long)ptr, &ptr_secret);
+
+	spec.field_width = 2 + 2 * sizeof(unsigned int); /* 0x + hex */
+	spec.flags = SPECIAL | SMALL | ZEROPAD;
+	spec.base = 16;
+
+	return number(buf, end, (u32)hashval, spec);
+}
+
 int kptr_restrict __read_mostly;
 
 /*
@@ -1703,6 +1723,9 @@ int kptr_restrict __read_mostly;
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
  * pointer to the real address.
+ *
+ * Default behaviour (unadorned %p) is to hash the address, rendering it useful
+ * as a unique identifier.
  */
 static noinline_for_stack
 char *pointer(const char *fmt, char *buf, char *end, void *ptr,
@@ -1858,14 +1881,13 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 			return device_node_string(buf, end, ptr, spec, fmt + 1);
 		}
 	}
-	spec.flags |= SMALL;
+
 	if (spec.field_width == -1) {
 		spec.field_width = default_width;
 		spec.flags |= ZEROPAD;
 	}
-	spec.base = 16;
 
-	return number(buf, end, (unsigned long) ptr, spec);
+	return ptr_to_id(buf, end, ptr, spec);
 }
 
 /*
-- 
2.7.4
