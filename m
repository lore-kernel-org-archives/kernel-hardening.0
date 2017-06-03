From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sat,  3 Jun 2017 04:32:04 +0200
Message-Id: <20170603023204.30933-4-Jason@zx2c4.com>
In-Reply-To: <20170603023204.30933-1-Jason@zx2c4.com>
References: <CAHmME9oLHP85ENr5aZgKsTSrxiUWoQ_pfv7C6XYxmcoxPfq3Ew@mail.gmail.com>
 <20170603023204.30933-1-Jason@zx2c4.com>
Subject: [kernel-hardening] [PATCH RFC 3/3] random: warn when kernel uses unseeded randomness
To: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

This enables an important dmesg notification about when drivers have
used the crng without it being seeded first. Prior, these errors would
occur silently, and so there hasn't been a great way of diagnosing these
types of bugs for obscure setups. By adding this as a config option, we
can leave it on by default, so that we learn where these issues happen,
in the field, will still allowing some people to turn it off, if they
really know what they're doing and do not want the log entries.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/char/random.c |  3 +--
 lib/Kconfig.debug     | 15 +++++++++++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index bee7b1349bcb..f64844383d86 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -285,7 +285,6 @@
 #define SEC_XFER_SIZE		512
 #define EXTRACT_SIZE		10
 
-#define DEBUG_RANDOM_BOOT 0
 
 #define LONGS(x) (((x) + sizeof(unsigned long) - 1)/sizeof(unsigned long))
 
@@ -1475,7 +1474,7 @@ void get_random_bytes(void *buf, int nbytes)
 {
 	__u8 tmp[CHACHA20_BLOCK_SIZE];
 
-#if DEBUG_RANDOM_BOOT > 0
+#ifdef CONFIG_WARN_UNSEEDED_RANDOM
 	if (!crng_ready())
 		printk(KERN_NOTICE "random: %pF get_random_bytes called "
 		       "with crng_init = %d\n", (void *) _RET_IP_, crng_init);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index e4587ebe52c7..fd5e67bcd46c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1209,6 +1209,21 @@ config STACKTRACE
 	  It is also used by various kernel debugging features that require
 	  stack trace generation.
 
+config WARN_UNSEEDED_RANDOM
+	bool "Warn when kernel uses unseeded randomness"
+	default y
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
