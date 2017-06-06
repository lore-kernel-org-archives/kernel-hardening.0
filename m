From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue,  6 Jun 2017 02:50:56 +0200
Message-Id: <20170606005108.5646-2-Jason@zx2c4.com>
In-Reply-To: <20170606005108.5646-1-Jason@zx2c4.com>
References: <20170606005108.5646-1-Jason@zx2c4.com>
Subject: [kernel-hardening] [PATCH v3 01/13] random: add synchronous API for the urandom pool
To: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

This enables users of get_random_{bytes,u32,u64,int,long} to wait until
the pool is ready before using this function, in case they actually want
to have reliable randomness.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/char/random.c  | 41 +++++++++++++++++++++++++++++++----------
 include/linux/random.h |  1 +
 2 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 0ab024918907..035a5d7c06bd 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -844,11 +844,6 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 	spin_unlock_irqrestore(&primary_crng.lock, flags);
 }
 
-static inline void crng_wait_ready(void)
-{
-	wait_event_interruptible(crng_init_wait, crng_ready());
-}
-
 static void _extract_crng(struct crng_state *crng,
 			  __u8 out[CHACHA20_BLOCK_SIZE])
 {
@@ -1466,7 +1461,10 @@ static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
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
@@ -1496,6 +1494,24 @@ void get_random_bytes(void *buf, int nbytes)
 EXPORT_SYMBOL(get_random_bytes);
 
 /*
+ * Wait for the urandom pool to be seeded and thus guaranteed to supply
+ * cryptographically secure random numbers. This applies to: the /dev/urandom
+ * device, the get_random_bytes function, and the get_random_{u32,u64,int,long}
+ * family of functions. Using any of these functions without first calling
+ * this function forfeits the guarantee of security.
+ *
+ * Returns: 0 if the urandom pool has been seeded.
+ *          -ERESTARTSYS if the function was interrupted by a signal.
+ */
+int wait_for_random_bytes(void)
+{
+	if (likely(crng_ready()))
+		return 0;
+	return wait_event_interruptible(crng_init_wait, crng_ready());
+}
+EXPORT_SYMBOL(wait_for_random_bytes);
+
+/*
  * Add a callback function that will be invoked when the nonblocking
  * pool is initialised.
  *
@@ -1849,6 +1865,8 @@ const struct file_operations urandom_fops = {
 SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
 		unsigned int, flags)
 {
+	int ret;
+
 	if (flags & ~(GRND_NONBLOCK|GRND_RANDOM))
 		return -EINVAL;
 
@@ -1861,9 +1879,9 @@ SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
 	if (!crng_ready()) {
 		if (flags & GRND_NONBLOCK)
 			return -EAGAIN;
-		crng_wait_ready();
-		if (signal_pending(current))
-			return -ERESTARTSYS;
+		ret = wait_for_random_bytes();
+		if (unlikely(ret))
+			return ret;
 	}
 	return urandom_read(NULL, buf, count, NULL);
 }
@@ -2023,7 +2041,10 @@ struct batched_entropy {
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
index ed5c3838780d..e29929347c95 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -34,6 +34,7 @@ extern void add_input_randomness(unsigned int type, unsigned int code,
 extern void add_interrupt_randomness(int irq, int irq_flags) __latent_entropy;
 
 extern void get_random_bytes(void *buf, int nbytes);
+extern int wait_for_random_bytes(void);
 extern int add_random_ready_callback(struct random_ready_callback *rdy);
 extern void del_random_ready_callback(struct random_ready_callback *rdy);
 extern void get_random_bytes_arch(void *buf, int nbytes);
-- 
2.13.0
