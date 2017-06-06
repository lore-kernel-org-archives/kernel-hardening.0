From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue,  6 Jun 2017 02:51:08 +0200
Message-Id: <20170606005108.5646-14-Jason@zx2c4.com>
In-Reply-To: <20170606005108.5646-1-Jason@zx2c4.com>
References: <20170606005108.5646-1-Jason@zx2c4.com>
Subject: [kernel-hardening] [PATCH v3 13/13] random: warn when kernel uses unseeded randomness
To: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

This enables an important dmesg notification about when drivers have
used the crng without it being seeded first. Prior, these errors would
occur silently, and so there hasn't been a great way of diagnosing these
types of bugs for obscure setups. By adding this as a config option, we
can leave it on by default, so that we learn where these issues happen,
in the field, will still allowing some people to turn it off, if they
really know what they're doing and do not want the log entries.

However, we don't leave it _completely_ by default. An earlier version
of this patch simply had `default y`. I'd really love that, but it turns
out, this problem with unseeded randomness being used is really quite
present and is going to take a long time to fix. Thus, as a compromise
between log-messages-for-all and nobody-knows, this is `default y`,
except it is also `depends on DEBUG_KERNEL`. This will ensure that the
curious see the messages while others don't have to.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/char/random.c | 15 +++++++++++++--
 lib/Kconfig.debug     | 16 ++++++++++++++++
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index c328e9b11f1f..d4698c8bc35f 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -285,7 +285,6 @@
 #define SEC_XFER_SIZE		512
 #define EXTRACT_SIZE		10
 
-#define DEBUG_RANDOM_BOOT 0
 
 #define LONGS(x) (((x) + sizeof(unsigned long) - 1)/sizeof(unsigned long))
 
@@ -1474,7 +1473,7 @@ void get_random_bytes(void *buf, int nbytes)
 {
 	__u8 tmp[CHACHA20_BLOCK_SIZE];
 
-#if DEBUG_RANDOM_BOOT > 0
+#ifdef CONFIG_WARN_UNSEEDED_RANDOM
 	if (!crng_ready())
 		printk(KERN_NOTICE "random: %pF get_random_bytes called "
 		       "with crng_init = %d\n", (void *) _RET_IP_, crng_init);
@@ -2068,6 +2067,12 @@ u64 get_random_u64(void)
 	    return ret;
 #endif
 
+#ifdef CONFIG_WARN_UNSEEDED_RANDOM
+	if (!crng_ready())
+		printk(KERN_NOTICE "random: %pF get_random_u64 called "
+		       "with crng_init = %d\n", (void *) _RET_IP_, crng_init);
+#endif
+
 	batch = &get_cpu_var(batched_entropy_u64);
 	if (use_lock)
 		read_lock_irqsave(&batched_entropy_reset_lock, flags);
@@ -2094,6 +2099,12 @@ u32 get_random_u32(void)
 	if (arch_get_random_int(&ret))
 		return ret;
 
+#ifdef CONFIG_WARN_UNSEEDED_RANDOM
+	if (!crng_ready())
+		printk(KERN_NOTICE "random: %pF get_random_u32 called "
+		       "with crng_init = %d\n", (void *) _RET_IP_, crng_init);
+#endif
+
 	batch = &get_cpu_var(batched_entropy_u32);
 	if (use_lock)
 		read_lock_irqsave(&batched_entropy_reset_lock, flags);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index e4587ebe52c7..c4159605bfbf 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1209,6 +1209,22 @@ config STACKTRACE
 	  It is also used by various kernel debugging features that require
 	  stack trace generation.
 
+config WARN_UNSEEDED_RANDOM
+	bool "Warn when kernel uses unseeded randomness"
+	default y
+	depends on DEBUG_KERNEL
+	help
+	  Some parts of the kernel contain bugs relating to their use of
+	  cryptographically secure random numbers before it's actually possible
+	  to generate those numbers securely. This setting ensures that these
+	  flaws don't go unnoticed, by enabling a message, should this ever
+	  occur. This will allow people with obscure setups to know when things
+	  are going wrong, so that they might contact developers about fixing
+	  it.
+
+	  Say Y here, unless you simply do not care about using unseeded
+	  randomness and do not want a potential warning message in your logs.
+
 config DEBUG_KOBJECT
 	bool "kobject debugging"
 	depends on DEBUG_KERNEL
-- 
2.13.0
