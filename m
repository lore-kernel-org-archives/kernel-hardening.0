Date: Wed, 21 Jun 2017 16:38:24 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20170621203824.khyt6uqxghhdromi@thunk.org>
References: <CAHmME9qvPL+vdY16SgV2VzuDDyM4r+hkYy8yGG3LJaa-3igxfA@mail.gmail.com>
 <20170621000300.11646-1-Jason@zx2c4.com>
 <87k245ub5y.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k245ub5y.fsf@concordia.ellerman.id.au>
Subject: Re: [kernel-hardening] [PATCH] random: warn when kernel uses
 unseeded randomness
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Jeffrey Walton <noloader@gmail.com>, tglx@breakpoint.cc, David Miller <davem@davemloft.net>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biggers <ebiggers3@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel-hardening@lists.openwall.com, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 21, 2017 at 04:06:49PM +1000, Michael Ellerman wrote:
> All the distro kernels I'm aware of have DEBUG_KERNEL=y.
> 
> Where all includes at least RHEL, SLES, Fedora, Ubuntu & Debian.
> 
> So it's still essentially default y.
> 
> Emitting *one* warning by default would be reasonable. That gives users
> who are interested something to chase, they can then turn on the option
> to get the full story.
> 
> Filling the dmesg buffer with repeated warnings is really not helpful.

I agree completely with all of this.  The following patch replaces the
current topmost patch on the random.git tree:


>From 25b683ee9bd5536807f813efbd19809333461f89 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Thu, 8 Jun 2017 04:16:59 -0400
Subject: [PATCH] random: suppress spammy warnings about unseeded randomness

Unfortunately, on some models of some architectures getting a fully
seeded CRNG is extremely difficult, and so this can result in dmesg
getting spammed for a surprisingly long time.  This is really bad from
a security perspective, and so architecture maintainers needed to do
what they can to get the CRNG seeded sooner after the system is
booted.  However, users can't do anything actionble to address this,
and spamming the kernel messages log will only just annoy people.

For developers who want to work on improving this situation,
CONFIG_WARN_UNSEEDED_RANDOM has been renamed to
CONFIG_WARN_ALL_UNSEEDED_RANDOM.  By default the kernel will always
print the first use of unseeded randomness.  This way, hopefully the
security obsessed will be happy that there is _some_ indication when
the kernel boots there may be a potential issue with that architecture
or subarchitecture.  To see all uses of unseeded randomness,
developers can enable CONFIG_WARN_ALL_UNSEEDED_RANDOM.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 drivers/char/random.c | 45 ++++++++++++++++++++++++++++++---------------
 lib/Kconfig.debug     | 24 ++++++++++++++++++------
 2 files changed, 48 insertions(+), 21 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index fa5bbd5a7ca0..7405c914bbcf 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1466,6 +1466,30 @@ static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
 	return ret;
 }
 
+#define warn_unseeded_randomness(previous) \
+	_warn_unseeded_randomness(__func__, (void *) _RET_IP_, (previous))
+
+static void _warn_unseeded_randomness(const char *func_name, void *caller,
+				      void **previous)
+{
+#ifdef CONFIG_WARN_ALL_UNSEEDED_RANDOM
+	const bool print_once = false;
+#else
+	static bool print_once __read_mostly;
+#endif
+
+	if (print_once ||
+	    crng_ready() ||
+	    (previous && (caller == READ_ONCE(*previous))))
+		return;
+	WRITE_ONCE(*previous, caller);
+#ifndef CONFIG_WARN_ALL_UNSEEDED_RANDOM
+	print_once = true;
+#endif
+	pr_notice("random: %s called from %pF with crng_init=%d\n",
+		  func_name, caller, crng_init);
+}
+
 /*
  * This function is the exported kernel interface.  It returns some
  * number of good random numbers, suitable for key generation, seeding
@@ -1479,12 +1503,9 @@ static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
 void get_random_bytes(void *buf, int nbytes)
 {
 	__u8 tmp[CHACHA20_BLOCK_SIZE];
+	static void *previous;
 
-#ifdef CONFIG_WARN_UNSEEDED_RANDOM
-	if (!crng_ready())
-		printk(KERN_NOTICE "random: %pF get_random_bytes called "
-		       "with crng_init = %d\n", (void *) _RET_IP_, crng_init);
-#endif
+	warn_unseeded_randomness(&previous);
 	trace_get_random_bytes(nbytes, _RET_IP_);
 
 	while (nbytes >= CHACHA20_BLOCK_SIZE) {
@@ -2064,6 +2085,7 @@ u64 get_random_u64(void)
 	bool use_lock = READ_ONCE(crng_init) < 2;
 	unsigned long flags = 0;
 	struct batched_entropy *batch;
+	static void *previous;
 
 #if BITS_PER_LONG == 64
 	if (arch_get_random_long((unsigned long *)&ret))
@@ -2074,11 +2096,7 @@ u64 get_random_u64(void)
 	    return ret;
 #endif
 
-#ifdef CONFIG_WARN_UNSEEDED_RANDOM
-	if (!crng_ready())
-		printk(KERN_NOTICE "random: %pF get_random_u64 called "
-		       "with crng_init = %d\n", (void *) _RET_IP_, crng_init);
-#endif
+	warn_unseeded_randomness(&previous);
 
 	batch = &get_cpu_var(batched_entropy_u64);
 	if (use_lock)
@@ -2102,15 +2120,12 @@ u32 get_random_u32(void)
 	bool use_lock = READ_ONCE(crng_init) < 2;
 	unsigned long flags = 0;
 	struct batched_entropy *batch;
+	static void *previous;
 
 	if (arch_get_random_int(&ret))
 		return ret;
 
-#ifdef CONFIG_WARN_UNSEEDED_RANDOM
-	if (!crng_ready())
-		printk(KERN_NOTICE "random: %pF get_random_u32 called "
-		       "with crng_init = %d\n", (void *) _RET_IP_, crng_init);
-#endif
+	warn_unseeded_randomness(&previous);
 
 	batch = &get_cpu_var(batched_entropy_u32);
 	if (use_lock)
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c4159605bfbf..4be6b7c66b69 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1209,10 +1209,9 @@ config STACKTRACE
 	  It is also used by various kernel debugging features that require
 	  stack trace generation.
 
-config WARN_UNSEEDED_RANDOM
-	bool "Warn when kernel uses unseeded randomness"
-	default y
-	depends on DEBUG_KERNEL
+config WARN_ALL_UNSEEDED_RANDOM
+	bool "Warn for all uses unseeded randomness"
+	default n
 	help
 	  Some parts of the kernel contain bugs relating to their use of
 	  cryptographically secure random numbers before it's actually possible
@@ -1222,8 +1221,21 @@ config WARN_UNSEEDED_RANDOM
 	  are going wrong, so that they might contact developers about fixing
 	  it.
 
-	  Say Y here, unless you simply do not care about using unseeded
-	  randomness and do not want a potential warning message in your logs.
+	  Unfortunately, on some models of some architectures getting
+	  a fully seeded CRNG is extremely difficult, and so this can
+	  result in dmesg getting spammed for a surprisingly long
+	  time.  This is really bad from a security perspective, and
+	  so architecture maintainers needed to do what they can to
+	  get the CRNG seeded sooner after the system is booted.
+	  However, since users can not do anything actionble to
+	  address this, by default the kernel will issue only a single
+	  warning for the first use of unseeded randomness.
+
+	  Say Y here if you want to receive warnings for all uses of
+	  unseeded randomness.  This will be of use primarily for
+	  those developers interersted in improving the security of
+	  Linux kernels running on their architecture (or
+	  subarchitecture).
 
 config DEBUG_KOBJECT
 	bool "kobject debugging"
-- 
2.11.0.rc0.7.gbe5a750
