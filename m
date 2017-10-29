From: "Tobin C. Harding" <me@tobin.cc>
Date: Mon, 30 Oct 2017 09:59:16 +1100
Message-Id: <1509317956-28041-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH V9] printk: hash addresses printed with %p
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

Add function ptr_to_id() to map an address to a 32 bit unique
identifier. Hash any unadorned usage of specifier %p and any malformed
specifiers. 

Signed-off-by: Tobin C. Harding <me@tobin.cc>

---

It seems we don't have consensus on a couple of things

1. The size of the hashed address on 64 bit architectures.
2. The use of '0x' pre-fix for hashed addresses.

In regards to (1), we are agreed that we only need 32 bits of
information. There is some questions however that outputting _only_ 32
bits may break userland.

In regards to (2), irrespective of the arguments for and against, if
point 1 is correct and changing the format will break userland then we
can't add the '0x' suffix for the same reason.

Therefore this patch masks off the first 32 bits, retaining
only 32 bits of information. We do not add a '0x' suffix. All in all,
that results in _no_ change to the format of output only the content of
the output.

The leading 0's also make explicit that we have messed with the address,
maybe this will save some debugging time by doing so. Although this
would probably already be obvious since there is no leading 'ffff'.

We hash malformed specifiers also. Malformed specifiers include
incomplete (e.g %pi) and also non-existent specifiers. checkpatch should
warn for non-existent specifiers but AFAICT won't warn for incomplete
specifiers.

Here is the behaviour that this patch implements.

For kpt_restrict==0

Randomness not ready:
  printed with %p: 		(pointer value)     # NOTE: with padding
Valid pointer:
  printed with %pK: 		deadbeefdeadbeef
  printed with %p: 		00000000deadbeef
  malformed specifier (eg %i):  00000000deadbeef
NULL pointer:
  printed with %pK: 		0000000000000000
  printed with %p: 		         (null)     # NOTE: with padding
  malformed specifier (eg %i):           (null)

For kpt_restrict==2

Valid pointer:
  printed with %pK: 		0000000000000000

All other output as for kptr_restrict==0

V9:
 - Drop the initial patch from V8, leaving null pointer handling as is.
 - Print the hashed ID _without_ a '0x' suffix.
 - Mask the first 32 bits of the hashed ID to all zeros on 64 bit
   architectures.

V8:
 - Add second patch cleaning up null pointer printing in pointer()
 - Move %pK handling to separate function, further cleaning up pointer()
 - Move ptr_to_id() call outside of switch statement making hashing
   the default behaviour (including malformed specifiers).
 - Remove use of static_key, replace with simple boolean.

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

 lib/vsprintf.c | 167 ++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 119 insertions(+), 48 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 86c3385b9eb3..0c9a008fc256 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -33,6 +33,8 @@
 #include <linux/uuid.h>
 #include <linux/of.h>
 #include <net/addrconf.h>
+#include <linux/siphash.h>
+#include <linux/compiler.h>
 #ifdef CONFIG_BLOCK
 #include <linux/blkdev.h>
 #endif
@@ -1344,6 +1346,57 @@ char *uuid_string(char *buf, char *end, const u8 *addr,
 }
 
 static noinline_for_stack
+char *kernel_pointer(char *buf, char *end, const void *ptr,
+		     struct printf_spec spec)
+{
+	spec.base = 16;
+	spec.flags |= SMALL;
+	if (spec.field_width == -1) {
+		spec.field_width = 2 * sizeof(void *);
+		spec.flags |= ZEROPAD;
+	}
+
+	switch (kptr_restrict) {
+	case 0:
+		/* Always print %pK values */
+		break;
+	case 1: {
+		const struct cred *cred;
+
+		/*
+		 * kptr_restrict==1 cannot be used in IRQ context
+		 * because its test for CAP_SYSLOG would be meaningless.
+		 */
+		if (in_irq() || in_serving_softirq() || in_nmi())
+			return string(buf, end, "pK-error", spec);
+
+		/*
+		 * Only print the real pointer value if the current
+		 * process has CAP_SYSLOG and is running with the
+		 * same credentials it started with. This is because
+		 * access to files is checked at open() time, but %pK
+		 * checks permission at read() time. We don't want to
+		 * leak pointer values if a binary opens a file using
+		 * %pK and then elevates privileges before reading it.
+		 */
+		cred = current_cred();
+		if (!has_capability_noaudit(current, CAP_SYSLOG) ||
+		    !uid_eq(cred->euid, cred->uid) ||
+		    !gid_eq(cred->egid, cred->gid))
+			ptr = NULL;
+		break;
+	}
+	case 2:
+	default:
+		/* Always print 0's for %pK */
+		ptr = NULL;
+		break;
+	}
+
+	return number(buf, end, (unsigned long)ptr, spec);
+}
+
+static noinline_for_stack
 char *netdev_bits(char *buf, char *end, const void *addr, const char *fmt)
 {
 	unsigned long long num;
@@ -1591,6 +1644,66 @@ char *device_node_string(char *buf, char *end, struct device_node *dn,
 	return widen_string(buf, buf - buf_start, end, spec);
 }
 
+static bool have_filled_random_ptr_key __read_mostly;
+static siphash_key_t ptr_key __read_mostly;
+
+static void fill_random_ptr_key(struct random_ready_callback *unused)
+{
+	get_random_bytes(&ptr_key, sizeof(ptr_key));
+	WRITE_ONCE(have_filled_random_ptr_key, true);
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
+	unsigned long hashval;
+	const int default_width = 2 * sizeof(void *);
+
+	if (unlikely(!have_filled_random_ptr_key)) {
+		spec.field_width = default_width;
+		return string(buf, end, "(pointer value)", spec);
+	}
+
+#ifdef CONFIG_64BIT
+	hashval = (unsigned long)siphash_1u64((u64)ptr, &ptr_key);
+	/*
+	 * Mask off the first 32 bits, this makes explicit that we have
+	 * modified the address (and 32 bits is plenty for a unique ID).
+	 */
+	hashval = hashval & 0xffffffff;
+#else
+	hashval = (unsigned long)siphash_1u32((u32)ptr, &ptr_key);
+#endif
+
+	spec.flags |= SMALL;
+	if (spec.field_width == -1) {
+		spec.field_width = default_width;
+		spec.flags |= ZEROPAD;
+	}
+	spec.base = 16;
+
+	return number(buf, end, hashval, spec);
+}
+
 int kptr_restrict __read_mostly;
 
 /*
@@ -1703,6 +1816,9 @@ int kptr_restrict __read_mostly;
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
  * pointer to the real address.
+ *
+ * Note: The default behaviour (unadorned %p) is to hash the address,
+ * rendering it useful as a unique identifier.
  */
 static noinline_for_stack
 char *pointer(const char *fmt, char *buf, char *end, void *ptr,
@@ -1792,47 +1908,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 			return buf;
 		}
 	case 'K':
-		switch (kptr_restrict) {
-		case 0:
-			/* Always print %pK values */
-			break;
-		case 1: {
-			const struct cred *cred;
-
-			/*
-			 * kptr_restrict==1 cannot be used in IRQ context
-			 * because its test for CAP_SYSLOG would be meaningless.
-			 */
-			if (in_irq() || in_serving_softirq() || in_nmi()) {
-				if (spec.field_width == -1)
-					spec.field_width = default_width;
-				return string(buf, end, "pK-error", spec);
-			}
-
-			/*
-			 * Only print the real pointer value if the current
-			 * process has CAP_SYSLOG and is running with the
-			 * same credentials it started with. This is because
-			 * access to files is checked at open() time, but %pK
-			 * checks permission at read() time. We don't want to
-			 * leak pointer values if a binary opens a file using
-			 * %pK and then elevates privileges before reading it.
-			 */
-			cred = current_cred();
-			if (!has_capability_noaudit(current, CAP_SYSLOG) ||
-			    !uid_eq(cred->euid, cred->uid) ||
-			    !gid_eq(cred->egid, cred->gid))
-				ptr = NULL;
-			break;
-		}
-		case 2:
-		default:
-			/* Always print 0's for %pK */
-			ptr = NULL;
-			break;
-		}
-		break;
-
+		return kernel_pointer(buf, end, ptr, spec);
 	case 'N':
 		return netdev_bits(buf, end, ptr, fmt);
 	case 'a':
@@ -1858,14 +1934,9 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 			return device_node_string(buf, end, ptr, spec, fmt + 1);
 		}
 	}
-	spec.flags |= SMALL;
-	if (spec.field_width == -1) {
-		spec.field_width = default_width;
-		spec.flags |= ZEROPAD;
-	}
-	spec.base = 16;
 
-	return number(buf, end, (unsigned long) ptr, spec);
+	/* default is to _not_ leak addresses, hash before printing */
+	return ptr_to_id(buf, end, ptr, spec);
 }
 
 /*
-- 
2.7.4
