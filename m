From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sat,  3 Jun 2017 04:32:02 +0200
Message-Id: <20170603023204.30933-2-Jason@zx2c4.com>
In-Reply-To: <20170603023204.30933-1-Jason@zx2c4.com>
References: <CAHmME9oLHP85ENr5aZgKsTSrxiUWoQ_pfv7C6XYxmcoxPfq3Ew@mail.gmail.com>
 <20170603023204.30933-1-Jason@zx2c4.com>
Subject: [kernel-hardening] [PATCH RFC 1/3] random: add synchronous API for the urandom pool
To: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

This enables users of get_random_{bytes,u32,u64,int,long} to wait until
the pool is ready before using this function, in case they actually want
to have reliable randomness.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/char/random.c  | 46 ++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/random.h |  1 +
 2 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 0ab024918907..bee7b1349bcb 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1466,7 +1466,10 @@ static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
  * number of good random numbers, suitable for key generation, seeding
  * TCP sequence numbers, etc.  It does not rely on the hardware random
  * number generator.  For random bytes direct from the hardware RNG
- * (when available), use get_random_bytes_arch().
+ * (when available), use get_random_bytes_arch(). In order to ensure
+ * that the randomness provided by this function is okay, the function
+ * wait_for_random_bytes() should be called and return 0 at least once
+ * at any point prior.
  */
 void get_random_bytes(void *buf, int nbytes)
 {
@@ -1496,6 +1499,42 @@ void get_random_bytes(void *buf, int nbytes)
 EXPORT_SYMBOL(get_random_bytes);
 
 /*
+ * Wait for the urandom pool to be seeded and thus guaranteed to supply
+ * cryptographically secure random numbers. This applies to: the /dev/urandom
+ * device, the get_random_bytes function, and the get_random_{u32,u64,int,long}
+ * family of functions. Using any of these functions without first calling
+ * this function forfeits the guarantee of security.
+ *
+ * If is_interruptable is true, then this uses wait_event_interruptable.
+ * Otherwise the calling process will not respond to signals. If timeout is
+ * 0, then, unless interrupted, this function will wait potentially forever.
+ * Otherwise, timeout is a measure in jiffies.
+ *
+ * Returns: 0 if the urandom pool has been seeded.
+ *          -ERESTARTSYS if the function was interrupted or timed out.
+ *          Other return values of the wait_event_* functions.
+ */
+int wait_for_random_bytes(bool is_interruptable, unsigned long timeout)
+{
+	if (likely(crng_ready()))
+		return 0;
+	if (is_interruptable && timeout)
+		return wait_event_interruptible_timeout(crng_init_wait, crng_ready(), timeout);
+	if (is_interruptable && !timeout)
+		return wait_event_interruptible(crng_init_wait, crng_ready());
+	if (!is_interruptable && timeout)
+		return wait_event_timeout(crng_init_wait, crng_ready(), timeout);
+	if (!is_interruptable && !timeout) {
+		wait_event(crng_init_wait, crng_ready());
+		return 0;
+	}
+
+	BUG(); /* This BUG() should be compiled out as unreachable code, but just in case... */
+	return -EINVAL;
+}
+EXPORT_SYMBOL(wait_for_random_bytes);
+
+/*
  * Add a callback function that will be invoked when the nonblocking
  * pool is initialised.
  *
@@ -2023,7 +2062,10 @@ struct batched_entropy {
 /*
  * Get a random word for internal kernel use only. The quality of the random
  * number is either as good as RDRAND or as good as /dev/urandom, with the
- * goal of being quite fast and not depleting entropy.
+ * goal of being quite fast and not depleting entropy. In order to ensure
+ * that the randomness provided by this function is okay, the function
+ * wait_for_random_bytes() should be called and return 0 at least once
+ * at any point prior.
  */
 static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u64);
 u64 get_random_u64(void)
diff --git a/include/linux/random.h b/include/linux/random.h
index ed5c3838780d..20dd73418bd5 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -34,6 +34,7 @@ extern void add_input_randomness(unsigned int type, unsigned int code,
 extern void add_interrupt_randomness(int irq, int irq_flags) __latent_entropy;
 
 extern void get_random_bytes(void *buf, int nbytes);
+extern int wait_for_random_bytes(bool is_interruptable, unsigned long timeout);
 extern int add_random_ready_callback(struct random_ready_callback *rdy);
 extern void del_random_ready_callback(struct random_ready_callback *rdy);
 extern void get_random_bytes_arch(void *buf, int nbytes);
-- 
2.13.0
