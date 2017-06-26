Date: Mon, 26 Jun 2017 16:30:38 -0700
From: Kees Cook <keescook@chromium.org>
Message-ID: <20170626233038.GA48751@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] random: Do not ignore early device randomness
To: Theodore Ts'o <tytso@mit.edu>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Jessica Yu <jeyu@redhat.com>, "Steven Rostedt (VMware)" <rostedt@goodmis.org>, Viresh Kumar <viresh.kumar@linaro.org>, Tejun Heo <tj@kernel.org>, Prarit Bhargava <prarit@redhat.com>, Lokesh Vutla <lokeshvutla@ti.com>, Nicholas Piggin <npiggin@gmail.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

The add_device_randomness() function would ignore incoming bytes if the
crng wasn't ready. This additionally makes sure to make an early enough
call to add_latent_entropy() to influence the initial stack canary, which
is especially important on non-x86 systems where it stays the same through
the life of the boot.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/char/random.c | 5 +++++
 init/main.c           | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 01a260f67437..23cab7a8c1c1 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -987,6 +987,11 @@ void add_device_randomness(const void *buf, unsigned int size)
 	unsigned long time = random_get_entropy() ^ jiffies;
 	unsigned long flags;
 
+	if (!crng_ready()) {
+		crng_fast_load(buf, size);
+		return;
+	}
+
 	trace_add_device_randomness(size, _RET_IP_);
 	spin_lock_irqsave(&input_pool.lock, flags);
 	_mix_pool_bytes(&input_pool, buf, size);
diff --git a/init/main.c b/init/main.c
index f866510472d7..6b2c3ab7d76b 100644
--- a/init/main.c
+++ b/init/main.c
@@ -497,6 +497,7 @@ asmlinkage __visible void __init start_kernel(void)
 	/*
 	 * Set up the initial canary ASAP:
 	 */
+	add_latent_entropy();
 	boot_init_stack_canary();
 
 	cgroup_init_early();
-- 
2.7.4


-- 
Kees Cook
Pixel Security
