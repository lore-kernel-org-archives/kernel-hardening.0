Date: Thu, 8 Jun 2017 04:19:19 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20170608081919.zbtwdjl32vbvd7jt@thunk.org>
References: <20170606174804.31124-1-Jason@zx2c4.com>
 <20170606174804.31124-14-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170606174804.31124-14-Jason@zx2c4.com>
Subject: [kernel-hardening] Re: [PATCH v4 13/13] random: warn when kernel uses unseeded
 randomness
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 06, 2017 at 07:48:04PM +0200, Jason A. Donenfeld wrote:
> This enables an important dmesg notification about when drivers have
> used the crng without it being seeded first. Prior, these errors would
> occur silently, and so there hasn't been a great way of diagnosing these
> types of bugs for obscure setups. By adding this as a config option, we
> can leave it on by default, so that we learn where these issues happen,
> in the field, will still allowing some people to turn it off, if they
> really know what they're doing and do not want the log entries.
> 
> However, we don't leave it _completely_ by default. An earlier version
> of this patch simply had `default y`. I'd really love that, but it turns
> out, this problem with unseeded randomness being used is really quite
> present and is going to take a long time to fix. Thus, as a compromise
> between log-messages-for-all and nobody-knows, this is `default y`,
> except it is also `depends on DEBUG_KERNEL`. This will ensure that the
> curious see the messages while others don't have to.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

This patch is pretty spammy.  On my KVM test kernel:

random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0
random: neigh_hash_alloc+0x77/0x8f get_random_u32 called with crng_init = 0
random: neigh_hash_alloc+0x77/0x8f get_random_u32 called with crng_init = 0
random: neigh_hash_alloc+0x77/0x8f get_random_u32 called with crng_init = 0
random: neigh_hash_alloc+0x77/0x8f get_random_u32 called with crng_init = 0
random: rt_genid_init+0x24/0x2f get_random_u32 called with crng_init = 0
random: bucket_table_alloc+0x15f/0x190 get_random_u32 called with crng_init = 0

At the very least we probably should do a logical "uniq" on the output
(e.g., if we have complained about the previous callsite, don't whinge
about it again).

						- Ted

commit 9d9035bc6d7871a73d7f9aada4e63cb190874a68
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Jun 8 04:16:59 2017 -0400

    random: suppress duplicate crng_init=0 warnings
    
    Suppress duplicate CONFIG_WARN_UNSEEDED_RANDOM warnings to avoid
    spamming dmesg.
    
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 798f353f0d3c..3bdeef13afda 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1481,9 +1481,14 @@ void get_random_bytes(void *buf, int nbytes)
 	__u8 tmp[CHACHA20_BLOCK_SIZE];
 
 #ifdef CONFIG_WARN_UNSEEDED_RANDOM
-	if (!crng_ready())
+	static void *previous = NULL;
+	void *caller = (void *) _RET_IP_;
+
+	if (!crng_ready() && (READ_ONCE(previous) != caller)) {
 		printk(KERN_NOTICE "random: %pF get_random_bytes called "
-		       "with crng_init = %d\n", (void *) _RET_IP_, crng_init);
+		       "with crng_init=%d\n", caller, crng_init);
+		WRITE_ONCE(previous, caller);
+	}
 #endif
 	trace_get_random_bytes(nbytes, _RET_IP_);
 
@@ -2064,6 +2069,10 @@ u64 get_random_u64(void)
 	bool use_lock = crng_init < 2;
 	unsigned long flags;
 	struct batched_entropy *batch;
+#ifdef CONFIG_WARN_UNSEEDED_RANDOM
+	static void *previous = NULL;
+	void *caller = (void *) _RET_IP_;
+#endif
 
 #if BITS_PER_LONG == 64
 	if (arch_get_random_long((unsigned long *)&ret))
@@ -2075,9 +2084,11 @@ u64 get_random_u64(void)
 #endif
 
 #ifdef CONFIG_WARN_UNSEEDED_RANDOM
-	if (!crng_ready())
+	if (!crng_ready() && (READ_ONCE(previous) != caller))  {
 		printk(KERN_NOTICE "random: %pF get_random_u64 called "
-		       "with crng_init = %d\n", (void *) _RET_IP_, crng_init);
+		       "with crng_init=%d\n", caller, crng_init);
+		WRITE_ONCE(previous, caller);
+	}
 #endif
 
 	batch = &get_cpu_var(batched_entropy_u64);
@@ -2102,14 +2113,20 @@ u32 get_random_u32(void)
 	bool use_lock = crng_init < 2;
 	unsigned long flags;
 	struct batched_entropy *batch;
+#ifdef CONFIG_WARN_UNSEEDED_RANDOM
+	static void *previous = NULL;
+	void *caller = (void *) _RET_IP_;
+#endif
 
 	if (arch_get_random_int(&ret))
 		return ret;
 
 #ifdef CONFIG_WARN_UNSEEDED_RANDOM
-	if (!crng_ready())
+	if (!crng_ready() && READ_ONCE(previous) != caller) {
 		printk(KERN_NOTICE "random: %pF get_random_u32 called "
-		       "with crng_init = %d\n", (void *) _RET_IP_, crng_init);
+		       "with crng_init=%d\n", caller, crng_init);
+		WRITE_ONCE(previous, caller);
+	}
 #endif
 
 	batch = &get_cpu_var(batched_entropy_u32);
