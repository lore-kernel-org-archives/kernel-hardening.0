Reply-To: kernel-hardening@lists.openwall.com
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 22 Dec 2016 19:07:41 +0100
Message-Id: <20161222180741.24577-2-Jason@zx2c4.com>
In-Reply-To: <20161222180741.24577-1-Jason@zx2c4.com>
References: <20161222180741.24577-1-Jason@zx2c4.com>
Subject: [kernel-hardening] [PATCH 2/2] random: convert get_random_int/long into get_random_u32/u64
To: tytso@mit.edu, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

Many times, when a user wants a random number, he wants a random number
of a guaranteed size. So, thinking of get_random_int and get_random_long
in terms of get_random_u32 and get_random_u64 makes it much easier to
achieve this. It also makes the code simpler.

On 32-bit platforms, get_random_int and get_random_long are both aliased
to get_random_u32. On 64-bit platforms, int->u32 and long->u64.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Theodore Ts'o <tytso@mit.edu>
---
I personally would find this extremely useful in my own code, where I
currently wind up doing something ugly like:

    (u64)get_random_int() << 32 | get_random_int()

But if you have some aversion, don't hesitate to just take 1/2 without
this 2/2. But hopefully you'll like this 2/2.

 drivers/char/random.c  | 55 +++++++++++++++++++++++++-------------------------
 include/linux/random.h | 17 ++++++++++++++--
 2 files changed, 42 insertions(+), 30 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 08d1dd58c0d2..ee737ef41ce9 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2044,8 +2044,8 @@ struct ctl_table random_table[] = {
 
 struct batched_entropy {
 	union {
-		unsigned long entropy_long[CHACHA20_BLOCK_SIZE / sizeof(unsigned long)];
-		unsigned int entropy_int[CHACHA20_BLOCK_SIZE / sizeof(unsigned int)];
+		u64 entropy_u64[CHACHA20_BLOCK_SIZE / sizeof(u64)];
+		u32 entropy_u32[CHACHA20_BLOCK_SIZE / sizeof(u32)];
 	};
 	unsigned int position;
 };
@@ -2055,52 +2055,51 @@ struct batched_entropy {
  * number is either as good as RDRAND or as good as /dev/urandom, with the
  * goal of being quite fast and not depleting entropy.
  */
-static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_long);
-unsigned long get_random_long(void)
+static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u64);
+u64 get_random_u64(void)
 {
-	unsigned long ret;
+	u64 ret;
 	struct batched_entropy *batch;
 
-	if (arch_get_random_long(&ret))
+#if BITS_PER_LONG == 64
+	if (arch_get_random_long((unsigned long *)&ret))
 		return ret;
+#else
+	if (arch_get_random_long((unsigned long *)&ret) &&
+	    arch_get_random_long((unsigned long *)&ret + 1))
+	    return ret;
+#endif
 
-	batch = &get_cpu_var(batched_entropy_long);
-	if (batch->position % ARRAY_SIZE(batch->entropy_long) == 0) {
-		extract_crng((u8 *)batch->entropy_long);
+	batch = &get_cpu_var(batched_entropy_u64);
+	if (batch->position % ARRAY_SIZE(batch->entropy_u64) == 0) {
+		extract_crng((u8 *)batch->entropy_u64);
 		batch->position = 0;
 	}
-	ret = batch->entropy_long[batch->position++];
-	put_cpu_var(batched_entropy_long);
+	ret = batch->entropy_u64[batch->position++];
+	put_cpu_var(batched_entropy_u64);
 	return ret;
 }
-EXPORT_SYMBOL(get_random_long);
+EXPORT_SYMBOL(get_random_u64);
 
-#if BITS_PER_LONG == 32
-unsigned int get_random_int(void)
-{
-	return get_random_long();
-}
-#else
-static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_int);
-unsigned int get_random_int(void)
+static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u32);
+u32 get_random_u32(void)
 {
-	unsigned int ret;
+	u32 ret;
 	struct batched_entropy *batch;
 
 	if (arch_get_random_int(&ret))
 		return ret;
 
-	batch = &get_cpu_var(batched_entropy_int);
-	if (batch->position % ARRAY_SIZE(batch->entropy_int) == 0) {
-		extract_crng((u8 *)batch->entropy_int);
+	batch = &get_cpu_var(batched_entropy_u32);
+	if (batch->position % ARRAY_SIZE(batch->entropy_u32) == 0) {
+		extract_crng((u8 *)batch->entropy_u32);
 		batch->position = 0;
 	}
-	ret = batch->entropy_int[batch->position++];
-	put_cpu_var(batched_entropy_int);
+	ret = batch->entropy_u32[batch->position++];
+	put_cpu_var(batched_entropy_u32);
 	return ret;
 }
-#endif
-EXPORT_SYMBOL(get_random_int);
+EXPORT_SYMBOL(get_random_u32);
 
 /**
  * randomize_page - Generate a random, page aligned address
diff --git a/include/linux/random.h b/include/linux/random.h
index 16ab429735a7..ed5c3838780d 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -42,8 +42,21 @@ extern void get_random_bytes_arch(void *buf, int nbytes);
 extern const struct file_operations random_fops, urandom_fops;
 #endif
 
-unsigned int get_random_int(void);
-unsigned long get_random_long(void);
+u32 get_random_u32(void);
+u64 get_random_u64(void);
+static inline unsigned int get_random_int(void)
+{
+	return get_random_u32();
+}
+static inline unsigned long get_random_long(void)
+{
+#if BITS_PER_LONG == 64
+	return get_random_u64();
+#else
+	return get_random_u32();
+#endif
+}
+
 unsigned long randomize_page(unsigned long start, unsigned long range);
 
 u32 prandom_u32(void);
-- 
2.11.0
