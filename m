From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue,  6 Jun 2017 02:50:58 +0200
Message-Id: <20170606005108.5646-4-Jason@zx2c4.com>
In-Reply-To: <20170606005108.5646-1-Jason@zx2c4.com>
References: <20170606005108.5646-1-Jason@zx2c4.com>
Subject: [kernel-hardening] [PATCH v3 03/13] random: invalidate batched entropy after crng init
To: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

It's possible that get_random_{u32,u64} is used before the crng has
initialized, in which case, its output might not be cryptographically
secure. For this problem, directly, this patch set is introducing the
*_wait variety of functions, but even with that, there's a subtle issue:
what happens to our batched entropy that was generated before
initialization. Prior to this commit, it'd stick around, supplying bad
numbers. After this commit, we force the entropy to be re-extracted
after each phase of the crng has initialized.

In order to avoid a race condition with the position counter, we
introduce a simple rwlock for this invalidation. Since it's only during
this awkward transition period, after things are all set up, we stop
using it, so that it doesn't have an impact on performance.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/char/random.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 035a5d7c06bd..c328e9b11f1f 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -762,6 +762,8 @@ static DECLARE_WAIT_QUEUE_HEAD(crng_init_wait);
 static struct crng_state **crng_node_pool __read_mostly;
 #endif
 
+static void invalidate_batched_entropy(void);
+
 static void crng_initialize(struct crng_state *crng)
 {
 	int		i;
@@ -800,6 +802,7 @@ static int crng_fast_load(const char *cp, size_t len)
 	}
 	if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
 		crng_init = 1;
+		invalidate_batched_entropy();
 		wake_up_interruptible(&crng_init_wait);
 		pr_notice("random: fast init done\n");
 	}
@@ -837,6 +840,7 @@ static void crng_reseed(struct crng_state *crng, struct entropy_store *r)
 	crng->init_time = jiffies;
 	if (crng == &primary_crng && crng_init < 2) {
 		crng_init = 2;
+		invalidate_batched_entropy();
 		process_random_ready_list();
 		wake_up_interruptible(&crng_init_wait);
 		pr_notice("random: crng init done\n");
@@ -2037,6 +2041,7 @@ struct batched_entropy {
 	};
 	unsigned int position;
 };
+static rwlock_t batched_entropy_reset_lock = __RW_LOCK_UNLOCKED(batched_entropy_reset_lock);
 
 /*
  * Get a random word for internal kernel use only. The quality of the random
@@ -2050,6 +2055,8 @@ static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u64);
 u64 get_random_u64(void)
 {
 	u64 ret;
+	bool use_lock = crng_init < 2;
+	unsigned long flags;
 	struct batched_entropy *batch;
 
 #if BITS_PER_LONG == 64
@@ -2062,11 +2069,15 @@ u64 get_random_u64(void)
 #endif
 
 	batch = &get_cpu_var(batched_entropy_u64);
+	if (use_lock)
+		read_lock_irqsave(&batched_entropy_reset_lock, flags);
 	if (batch->position % ARRAY_SIZE(batch->entropy_u64) == 0) {
 		extract_crng((u8 *)batch->entropy_u64);
 		batch->position = 0;
 	}
 	ret = batch->entropy_u64[batch->position++];
+	if (use_lock)
+		read_unlock_irqrestore(&batched_entropy_reset_lock, flags);
 	put_cpu_var(batched_entropy_u64);
 	return ret;
 }
@@ -2076,22 +2087,45 @@ static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u32);
 u32 get_random_u32(void)
 {
 	u32 ret;
+	bool use_lock = crng_init < 2;
+	unsigned long flags;
 	struct batched_entropy *batch;
 
 	if (arch_get_random_int(&ret))
 		return ret;
 
 	batch = &get_cpu_var(batched_entropy_u32);
+	if (use_lock)
+		read_lock_irqsave(&batched_entropy_reset_lock, flags);
 	if (batch->position % ARRAY_SIZE(batch->entropy_u32) == 0) {
 		extract_crng((u8 *)batch->entropy_u32);
 		batch->position = 0;
 	}
 	ret = batch->entropy_u32[batch->position++];
+	if (use_lock)
+		read_unlock_irqrestore(&batched_entropy_reset_lock, flags);
 	put_cpu_var(batched_entropy_u32);
 	return ret;
 }
 EXPORT_SYMBOL(get_random_u32);
 
+/* It's important to invalidate all potential batched entropy that might
+ * be stored before the crng is initialized, which we can do lazily by
+ * simply resetting the counter to zero so that it's re-extracted on the
+ * next usage. */
+static void invalidate_batched_entropy(void)
+{
+	int cpu;
+	unsigned long flags;
+
+	write_lock_irqsave(&batched_entropy_reset_lock, flags);
+	for_each_possible_cpu (cpu) {
+		per_cpu_ptr(&batched_entropy_u32, cpu)->position = 0;
+		per_cpu_ptr(&batched_entropy_u64, cpu)->position = 0;
+	}
+	write_unlock_irqrestore(&batched_entropy_reset_lock, flags);
+}
+
 /**
  * randomize_page - Generate a random, page aligned address
  * @start:	The smallest acceptable address the caller will take.
-- 
2.13.0
