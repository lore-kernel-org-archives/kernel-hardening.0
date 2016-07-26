Reply-To: kernel-hardening@lists.openwall.com
From: Jason Cooper <jason@lakedaemon.net>
Date: Tue, 26 Jul 2016 03:01:55 +0000
Message-Id: <20160726030201.6775-1-jason@lakedaemon.net>
In-Reply-To: <1469471141-25669-1-git-send-email-william.c.roberts@intel.com>
References: <1469471141-25669-1-git-send-email-william.c.roberts@intel.com>
Subject: [kernel-hardening] [RFC patch 1/6] random: Simplify API for random address requests
To: william.c.roberts@intel.com, linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: Jason Cooper <jason@lakedaemon.net>, linux@arm.linux.org.uk, akpm@linux-foundation.org, keescook@chromium.org, tytso@mit.edu, arnd@arndb.de, gregkh@linuxfoundation.org, catalin.marinas@arm.com, will.deacon@arm.com, ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au, davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, viro@zeniv.linux.org.uk, nnk@google.com, jeffv@google.com, alyzyn@android.com, dcashman@android.com
List-ID: <kernel-hardening.lists.openwall.com>

To date, all callers of randomize_range() have set the length to 0, and
check for a zero return value.  For the current callers, the only way
to get zero returned is if end <= start.  Since they are all adding a
constant to the start address, this is unnecessary.

We can remove a bunch of needless checks by simplifying the API to do
just what everyone wants, return an address between [start, start +
range].

While we're here, s/get_random_int/get_random_long/.  No current call
site is adversely affected by get_random_int(), since all current range
requests are < MAX_UINT.  However, we should match caller expectations
to avoid coming up short (ha!) in the future.

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 drivers/char/random.c  | 17 ++++-------------
 include/linux/random.h |  2 +-
 2 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 0158d3bff7e5..1251cb2cbab2 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1822,22 +1822,13 @@ unsigned long get_random_long(void)
 EXPORT_SYMBOL(get_random_long);
 
 /*
- * randomize_range() returns a start address such that
- *
- *    [...... <range> .....]
- *  start                  end
- *
- * a <range> with size "len" starting at the return value is inside in the
- * area defined by [start, end], but is otherwise randomized.
+ * randomize_addr() returns a page aligned address within [start, start +
+ * range]
  */
 unsigned long
-randomize_range(unsigned long start, unsigned long end, unsigned long len)
+randomize_addr(unsigned long start, unsigned long range)
 {
-	unsigned long range = end - len - start;
-
-	if (end <= start + len)
-		return 0;
-	return PAGE_ALIGN(get_random_int() % range + start);
+	return PAGE_ALIGN(get_random_long() % range + start);
 }
 
 /* Interface for in-kernel drivers of true hardware RNGs.
diff --git a/include/linux/random.h b/include/linux/random.h
index e47e533742b5..1ad877a98186 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -34,7 +34,7 @@ extern const struct file_operations random_fops, urandom_fops;
 
 unsigned int get_random_int(void);
 unsigned long get_random_long(void);
-unsigned long randomize_range(unsigned long start, unsigned long end, unsigned long len);
+unsigned long randomize_addr(unsigned long start, unsigned long range);
 
 u32 prandom_u32(void);
 void prandom_bytes(void *buf, size_t nbytes);
-- 
2.9.2
