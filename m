From: "Tobin C. Harding" <me@tobin.cc>
Date: Tue, 24 Oct 2017 09:33:28 +1100
Message-Id: <1508798008-1692-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH v7] printk: hash addresses printed with %p
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org
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

V7:
 - Use tabs instead of spaces (ouch!).

V6:
 - Use __early_initcall() to fill the SipHash key.
 - Use static keys to guard hashing before the key is available.

V5:
 - Remove spin lock.
 - Add Jason A. Donenfeld to CC list by request.
 - Add Theodore Ts'o to CC list due to comment on previous version.

V4:
 - Remove changes to siphash.{ch}
 - Do word size check, and return value cast, directly in ptr_to_id().
 - Use add_ready_random_callback() to guard call to get_random_bytes()

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

 lib/vsprintf.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 86c3385b9eb3..3faecf219412 100644
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
@@ -1591,6 +1592,55 @@ char *device_node_string(char *buf, char *end, struct device_node *dn,
 	return widen_string(buf, buf - buf_start, end, spec);
 }
 
+static siphash_key_t ptr_secret __read_mostly;
+static DEFINE_STATIC_KEY_TRUE(no_ptr_secret);
+
+static void fill_random_ptr_key(struct random_ready_callback *rdy)
+{
+	get_random_bytes(&ptr_secret, sizeof(ptr_secret));
+	static_branch_disable(&no_ptr_secret);
+}
+
+static struct random_ready_callback random_ready = {
+	.func = fill_random_ptr_key
+};
+
+static int __init initialize_ptr_random(void)
+{
+	int ret = add_random_ready_callback(&random_ready);
+
+	if (!ret)
+		return 0;
+	else if (ret == -EALREADY) {
+		fill_random_ptr_key(&random_ready);
+		return 0;
+	}
+
+	return ret;
+}
+early_initcall(initialize_ptr_random);
+
+/* Maps a pointer to a 32 bit unique identifier. */
+static char *ptr_to_id(char *buf, char *end, void *ptr, struct printf_spec spec)
+{
+	unsigned int hashval;
+
+	if (static_branch_unlikely(&no_ptr_secret))
+		return "(pointer value)";
+
+#ifdef CONFIG_64BIT
+	hashval = (unsigned int)siphash_1u64((u64)ptr, &ptr_secret);
+#else
+	hashval = (unsigned int)siphash_1u32((u32)ptr, &ptr_secret);
+#endif
+
+	spec.field_width = 2 * sizeof(unsigned int);
+	spec.flags = SMALL;
+	spec.base = 16;
+
+	return number(buf, end, hashval, spec);
+}
+
 int kptr_restrict __read_mostly;
 
 /*
@@ -1703,6 +1753,9 @@ int kptr_restrict __read_mostly;
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
  * pointer to the real address.
+ *
+ * Note: The default behaviour (unadorned %p) is to hash the address,
+ * rendering it useful as a unique identifier.
  */
 static noinline_for_stack
 char *pointer(const char *fmt, char *buf, char *end, void *ptr,
@@ -1857,7 +1910,11 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		case 'F':
 			return device_node_string(buf, end, ptr, spec, fmt + 1);
 		}
+	default:  /* default is to _not_ leak addresses, hash before printing */
+		return ptr_to_id(buf, end, ptr, spec);
 	}
+
+	/* OK, let's print the address */
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
 		spec.field_width = default_width;
-- 
2.7.4
