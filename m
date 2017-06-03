From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sat,  3 Jun 2017 04:32:03 +0200
Message-Id: <20170603023204.30933-3-Jason@zx2c4.com>
In-Reply-To: <20170603023204.30933-1-Jason@zx2c4.com>
References: <CAHmME9oLHP85ENr5aZgKsTSrxiUWoQ_pfv7C6XYxmcoxPfq3Ew@mail.gmail.com>
 <20170603023204.30933-1-Jason@zx2c4.com>
Subject: [kernel-hardening] [PATCH RFC 2/3] random: add get_random_{bytes,u32,u64,int,long}_wait family
To: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

These functions are simple convience wrappers that call
wait_for_random_bytes before calling the respective get_random_*
function.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 include/linux/random.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/include/linux/random.h b/include/linux/random.h
index 20dd73418bd5..6a19da815ff1 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -58,6 +58,36 @@ static inline unsigned long get_random_long(void)
 #endif
 }
 
+/* Calls wait_for_random_bytes(is_interruptable, timeout) and then
+ * calls get_random_bytes(buf, nbytes). Returns the result of the
+ * call to wait_for_random_bytes.
+ */
+static inline int get_random_bytes_wait(void *buf, int nbytes,
+			bool is_interruptable, unsigned long timeout)
+{
+	int ret = wait_for_random_bytes(is_interruptable, timeout);
+	if (unlikely(ret))
+		return ret;
+	get_random_bytes(buf, nbytes);
+	return 0;
+}
+
+#define declare_get_random_var_wait(var) \
+	static inline int get_random_ ## var ## _wait(var *out, \
+			bool is_interruptable, unsigned long timeout) { \
+		int ret = wait_for_random_bytes(is_interruptable, timeout); \
+		if (unlikely(ret)) \
+			return ret; \
+		*out = get_random_ ## var(); \
+		return 0; \
+	}
+declare_get_random_var_wait(u32)
+declare_get_random_var_wait(u64)
+declare_get_random_var_wait(int)
+declare_get_random_var_wait(long)
+#undef declare_get_random_var
+
+
 unsigned long randomize_page(unsigned long start, unsigned long range);
 
 u32 prandom_u32(void);
-- 
2.13.0
