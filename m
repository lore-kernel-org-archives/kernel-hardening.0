Reply-To: kernel-hardening@lists.openwall.com
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 22 Dec 2016 19:07:40 +0100
Message-Id: <20161222180741.24577-1-Jason@zx2c4.com>
Subject: [kernel-hardening] [PATCH 1/2] random: use chacha20 for get_random_int/long
To: tytso@mit.edu, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Hannes Frederic Sowa <hannes@stressinduktion.org>, Andy Lutomirski <luto@amacapital.net>
List-ID: <kernel-hardening.lists.openwall.com>

Now that our crng uses chacha20, we can rely on its speedy
characteristics for replacing MD5, while simultaneously achieving a
higher security guarantee. Before the idea was to use these functions if
you wanted random integers that aren't stupidly insecure but aren't
necessarily secure either, a vague gray zone, that hopefully was "good
enough" for its users. With chacha20, we can strengthen this claim,
since either we're using an rdrand-like instruction, or we're using the
same crng as /dev/urandom. And it's faster than what was before.

We could have chosen to replace this with a SipHash-derived function,
which might be slightly faster, but at the cost of having yet another
RNG construction in the kernel. By moving to chacha20, we have a single
RNG to analyze and verify, and we also already get good performance
improvements on all platforms.

Implementation-wise, rather than use a generic buffer for both
get_random_int/long and memcpy based on the size needs, we use a
specific buffer for 32-bit reads and for 64-bit reads. This way, we're
guaranteed to always have aligned accesses on all platforms. While
slightly more verbose in C, the assembly this generates is a lot
simpler than otherwise.

Finally, on 32-bit platforms where longs and ints are the same size,
we simply alias get_random_int to get_random_long.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Suggested-by: Theodore Ts'o <tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Andy Lutomirski <luto@amacapital.net>
---
 drivers/char/random.c  | 84 ++++++++++++++++++++++++++------------------------
 include/linux/random.h |  1 -
 init/main.c            |  1 -
 3 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index d6876d506220..08d1dd58c0d2 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2042,63 +2042,65 @@ struct ctl_table random_table[] = {
 };
 #endif 	/* CONFIG_SYSCTL */
 
-static u32 random_int_secret[MD5_MESSAGE_BYTES / 4] ____cacheline_aligned;
-
-int random_int_secret_init(void)
-{
-	get_random_bytes(random_int_secret, sizeof(random_int_secret));
-	return 0;
-}
-
-static DEFINE_PER_CPU(__u32 [MD5_DIGEST_WORDS], get_random_int_hash)
-		__aligned(sizeof(unsigned long));
+struct batched_entropy {
+	union {
+		unsigned long entropy_long[CHACHA20_BLOCK_SIZE / sizeof(unsigned long)];
+		unsigned int entropy_int[CHACHA20_BLOCK_SIZE / sizeof(unsigned int)];
+	};
+	unsigned int position;
+};
 
 /*
- * Get a random word for internal kernel use only. Similar to urandom but
- * with the goal of minimal entropy pool depletion. As a result, the random
- * value is not cryptographically secure but for several uses the cost of
- * depleting entropy is too high
+ * Get a random word for internal kernel use only. The quality of the random
+ * number is either as good as RDRAND or as good as /dev/urandom, with the
+ * goal of being quite fast and not depleting entropy.
  */
-unsigned int get_random_int(void)
+static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_long);
+unsigned long get_random_long(void)
 {
-	__u32 *hash;
-	unsigned int ret;
+	unsigned long ret;
+	struct batched_entropy *batch;
 
-	if (arch_get_random_int(&ret))
+	if (arch_get_random_long(&ret))
 		return ret;
 
-	hash = get_cpu_var(get_random_int_hash);
-
-	hash[0] += current->pid + jiffies + random_get_entropy();
-	md5_transform(hash, random_int_secret);
-	ret = hash[0];
-	put_cpu_var(get_random_int_hash);
-
+	batch = &get_cpu_var(batched_entropy_long);
+	if (batch->position % ARRAY_SIZE(batch->entropy_long) == 0) {
+		extract_crng((u8 *)batch->entropy_long);
+		batch->position = 0;
+	}
+	ret = batch->entropy_long[batch->position++];
+	put_cpu_var(batched_entropy_long);
 	return ret;
 }
-EXPORT_SYMBOL(get_random_int);
+EXPORT_SYMBOL(get_random_long);
 
-/*
- * Same as get_random_int(), but returns unsigned long.
- */
-unsigned long get_random_long(void)
+#if BITS_PER_LONG == 32
+unsigned int get_random_int(void)
 {
-	__u32 *hash;
-	unsigned long ret;
+	return get_random_long();
+}
+#else
+static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_int);
+unsigned int get_random_int(void)
+{
+	unsigned int ret;
+	struct batched_entropy *batch;
 
-	if (arch_get_random_long(&ret))
+	if (arch_get_random_int(&ret))
 		return ret;
 
-	hash = get_cpu_var(get_random_int_hash);
-
-	hash[0] += current->pid + jiffies + random_get_entropy();
-	md5_transform(hash, random_int_secret);
-	ret = *(unsigned long *)hash;
-	put_cpu_var(get_random_int_hash);
-
+	batch = &get_cpu_var(batched_entropy_int);
+	if (batch->position % ARRAY_SIZE(batch->entropy_int) == 0) {
+		extract_crng((u8 *)batch->entropy_int);
+		batch->position = 0;
+	}
+	ret = batch->entropy_int[batch->position++];
+	put_cpu_var(batched_entropy_int);
 	return ret;
 }
-EXPORT_SYMBOL(get_random_long);
+#endif
+EXPORT_SYMBOL(get_random_int);
 
 /**
  * randomize_page - Generate a random, page aligned address
diff --git a/include/linux/random.h b/include/linux/random.h
index 7bd2403e4fef..16ab429735a7 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -37,7 +37,6 @@ extern void get_random_bytes(void *buf, int nbytes);
 extern int add_random_ready_callback(struct random_ready_callback *rdy);
 extern void del_random_ready_callback(struct random_ready_callback *rdy);
 extern void get_random_bytes_arch(void *buf, int nbytes);
-extern int random_int_secret_init(void);
 
 #ifndef MODULE
 extern const struct file_operations random_fops, urandom_fops;
diff --git a/init/main.c b/init/main.c
index c81c9fa21bc7..222d5c2a80cc 100644
--- a/init/main.c
+++ b/init/main.c
@@ -880,7 +880,6 @@ static void __init do_basic_setup(void)
 	do_ctors();
 	usermodehelper_enable();
 	do_initcalls();
-	random_int_secret_init();
 }
 
 static void __init do_pre_smp_initcalls(void)
-- 
2.11.0
