From: Kees Cook <keescook@chromium.org>
Date: Tue, 30 May 2017 14:39:50 -0700
Message-Id: <1496180392-98718-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1496180392-98718-1-git-send-email-keescook@chromium.org>
References: <1496180392-98718-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 1/3] refcount: Create unchecked atomic_t implementation
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Christoph Hellwig <hch@infradead.org>, Peter Zijlstra <peterz@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, PaX Team <pageexec@freemail.hu>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, arozansk@redhat.com, Davidlohr Bueso <dave@stgolabs.net>, Manfred Spraul <manfred@colorfullife.com>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Many subsystems will not use refcount_t unless there is a way to build the
kernel so that there is no regression in speed compared to atomic_t. This
adds CONFIG_REFCOUNT_FULL to enable the full refcount_t implementation
which has the validation but is slightly slower. When not enabled,
refcount_t uses the basic unchecked atomic_t routines, which results in
no code changes compared to just using atomic_t directly.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/Kconfig             |  9 +++++++++
 include/linux/refcount.h | 44 ++++++++++++++++++++++++++++++++++++++++++++
 lib/refcount.c           |  3 +++
 3 files changed, 56 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index 6c00e5b00f8b..fba3bf186728 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -867,4 +867,13 @@ config STRICT_MODULE_RWX
 config ARCH_WANT_RELAX_ORDER
 	bool
 
+config REFCOUNT_FULL
+	bool "Perform full reference count validation at the expense of speed"
+	help
+	  Enabling this switches the refcounting infrastructure from a fast
+	  unchecked atomic_t implementation to a fully state checked
+	  implementation, which can be slower but provides protections
+	  against various use-after-free conditions that can be used in
+	  security flaw exploits.
+
 source "kernel/gcov/Kconfig"
diff --git a/include/linux/refcount.h b/include/linux/refcount.h
index b34aa649d204..68ecb431dbab 100644
--- a/include/linux/refcount.h
+++ b/include/linux/refcount.h
@@ -41,6 +41,7 @@ static inline unsigned int refcount_read(const refcount_t *r)
 	return atomic_read(&r->refs);
 }
 
+#ifdef CONFIG_REFCOUNT_FULL
 extern __must_check bool refcount_add_not_zero(unsigned int i, refcount_t *r);
 extern void refcount_add(unsigned int i, refcount_t *r);
 
@@ -52,6 +53,49 @@ extern void refcount_sub(unsigned int i, refcount_t *r);
 
 extern __must_check bool refcount_dec_and_test(refcount_t *r);
 extern void refcount_dec(refcount_t *r);
+#else
+static inline __must_check bool refcount_add_not_zero(unsigned int i,
+						      refcount_t *r)
+{
+	return atomic_add_return(i, &r->refs) != 0;
+}
+
+static inline void refcount_add(unsigned int i, refcount_t *r)
+{
+	atomic_add(i, &r->refs);
+}
+
+static inline __must_check bool refcount_inc_not_zero(refcount_t *r)
+{
+	return atomic_add_unless(&r->refs, 1, 0);
+}
+
+static inline void refcount_inc(refcount_t *r)
+{
+	atomic_inc(&r->refs);
+}
+
+static inline __must_check bool refcount_sub_and_test(unsigned int i,
+						      refcount_t *r)
+{
+	return atomic_sub_return(i, &r->refs) == 0;
+}
+
+static inline void refcount_sub(unsigned int i, refcount_t *r)
+{
+	atomic_sub(i, &r->refs);
+}
+
+static inline __must_check bool refcount_dec_and_test(refcount_t *r)
+{
+	return atomic_dec_return(&r->refs) == 0;
+}
+
+static inline void refcount_dec(refcount_t *r)
+{
+	atomic_dec(&r->refs);
+}
+#endif /* CONFIG_REFCOUNT_FULL */
 
 extern __must_check bool refcount_dec_if_one(refcount_t *r);
 extern __must_check bool refcount_dec_not_one(refcount_t *r);
diff --git a/lib/refcount.c b/lib/refcount.c
index 9f906783987e..5d0582a9480c 100644
--- a/lib/refcount.c
+++ b/lib/refcount.c
@@ -37,6 +37,8 @@
 #include <linux/refcount.h>
 #include <linux/bug.h>
 
+#ifdef CONFIG_REFCOUNT_FULL
+
 /**
  * refcount_add_not_zero - add a value to a refcount unless it is 0
  * @i: the value to add to the refcount
@@ -225,6 +227,7 @@ void refcount_dec(refcount_t *r)
 	WARN_ONCE(refcount_dec_and_test(r), "refcount_t: decrement hit 0; leaking memory.\n");
 }
 EXPORT_SYMBOL(refcount_dec);
+#endif /* CONFIG_REFCOUNT_FULL */
 
 /**
  * refcount_dec_if_one - decrement a refcount if it is 1
-- 
2.7.4
