From: "Tobin C. Harding" <me@tobin.cc>
Date: Wed, 11 Oct 2017 14:48:16 +1100
Message-Id: <1507693696-3777-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH] printk: hash addresses printed with %p
To: kernel-hardening@lists.openwall.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Tobin C. Harding" <me@tobin.cc>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Currently there are many places in the kernel where addresses are being
printed using an unadorned %p. Kernel pointers should be printed using
%pK allowing some control via the kptr_restrict sysctl. Exposing addresses
gives attackers sensitive information about the kernel layout in memory.

We can reduce the attack surface by hashing all addresses printed with
%p. This will of course break some users, forcing code printing needed
addresses to be updated.

For what it's worth, usage of unadorned %p can be broken down as follows

    git grep '%p[^KFfSsBRrbMmIiEUVKNhdDgCGO]' | wc -l

arch: 2512
block: 20
crypto: 12
fs: 1221
include: 147
kernel: 109
lib: 77
mm: 120
net: 1516
security: 11
sound: 168
virt: 2
drivers: 8420

Add function ptr_to_id() to map an address to a unique identifier. This
mapping is created by calling ptr_obfuscate() to hash the address. The
hashing algorithm is carried out in two stages. First the address is
xor'd by a random value then we multiply the xor production by a second
random value.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---

This is version 2 of the series (of which I sent only the cover letter,
failing to send the actual patches)

	[PATCH 0/3] add %pX specifier

Implementing changes as suggested by Linus (in response to the cover
letter). Patch 2 and 3 of the original series dropped.

 include/linux/printk.h | 17 +++++++++++++++++
 lib/vsprintf.c         | 35 +++++++++++++++++++++++++++++++++--
 2 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index e10f27468322..60c3d018efcf 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -41,6 +41,23 @@ static inline const char *printk_skip_headers(const char *buffer)
 	return buffer;
 }
 
+/*
+ * Obfuscates pointer (algorithm taken from kptr_obfuscate(). See kernel/kcmp.c)
+ * v is the pointer value, randval is some random value, oddval is some random
+ * odd value.
+ *
+ * The obfuscation is done in two steps. First we xor the kernel pointer with
+ * a random value, which puts pointer into a new position in a reordered space.
+ * Secondly we multiply the xor production with a large odd random number to
+ * permute its bits even more (the odd multiplier guarantees that the product
+ * is unique ever after the high bits are truncated, since any odd number is
+ * relative prime to 2^n).
+ */
+static inline long ptr_obfuscate(long v, long randval, long oddval)
+{
+	return (v ^ randval) * oddval;
+}
+
 #define CONSOLE_EXT_LOG_MAX	8192
 
 /* printk's without a loglevel use this.. */
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 86c3385b9eb3..399cc090be75 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1591,6 +1591,35 @@ char *device_node_string(char *buf, char *end, struct device_node *dn,
 	return widen_string(buf, buf - buf_start, end, spec);
 }
 
+static long get_random_odd_long(void)
+{
+	long val = 0;
+
+	while((val & 1) == 0) {
+		val = get_random_long();
+	}
+
+	return val;
+}
+
+/* Maps a pointer to a unique identifier. */
+static char *ptr_to_id(char *buf, char *end, void *ptr, struct printf_spec spec)
+{
+	long hashval;
+	static long randval = 0;
+	static long oddval = 0;
+
+	if (oddval == 0 && randval == 0) {
+		randval = get_random_long();
+		oddval = get_random_odd_long();
+	}
+
+	hashval = ptr_obfuscate((unsigned long)ptr, randval, oddval);
+	spec.base = 16;
+
+	return number(buf, end, hashval, spec);
+}
+
 int kptr_restrict __read_mostly;
 
 /*
@@ -1703,6 +1732,9 @@ int kptr_restrict __read_mostly;
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
  * pointer to the real address.
+ *
+ * Default behaviour (unadorned %p) is to hash the address, rendering it useful
+ * as a unique identifier.
  */
 static noinline_for_stack
 char *pointer(const char *fmt, char *buf, char *end, void *ptr,
@@ -1858,14 +1890,13 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 			return device_node_string(buf, end, ptr, spec, fmt + 1);
 		}
 	}
-	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
 		spec.field_width = default_width;
 		spec.flags |= ZEROPAD;
 	}
 	spec.base = 16;
 
-	return number(buf, end, (unsigned long) ptr, spec);
+	return ptr_to_id(buf, end, ptr, spec);
 }
 
 /*
-- 
2.7.4
