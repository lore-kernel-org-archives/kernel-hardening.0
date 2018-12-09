From: Tycho Andersen <tycho@tycho.ws>
Subject: [RFC v1] copy_{to,from}_user(): only inline when !__CHECKER__
Date: Sun,  9 Dec 2018 13:44:49 -0700
Message-Id: <20181209204449.18906-1-tycho@tycho.ws>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-sparse@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>
List-ID: <kernel-hardening.lists.openwall.com>

While working on some additional copy_to_user() checks for sparse, I
noticed that sparse's current copy_to_user() checks are not triggered. This
is because copy_to_user() is declared as __always_inline, and sparse
specifically looks for a call instruction to copy_to_user() when it tries
to apply the checks.

A quick fix is to explicitly not inline when __CHECKER__ is defined, so
that sparse will be able to analyze all the copy_{to,from}_user calls.
There may be some refactoring in sparse that we can do to fix this,
although it's not immediately obvious to me how, hence the RFC-ness of this
patch.

Signed-off-by: Tycho Andersen <tycho@tycho.ws>
---
 include/linux/uaccess.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index efe79c1cdd47..f20a2d173e1f 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -140,7 +140,13 @@ extern unsigned long
 _copy_to_user(void __user *, const void *, unsigned long);
 #endif
 
-static __always_inline unsigned long __must_check
+#ifdef __CHECKER__
+#define uaccess_inline __attribute__((__noinline__))
+#else
+#define uaccess_inline __always_inline
+#endif
+
+static uaccess_inline unsigned long __must_check
 copy_from_user(void *to, const void __user *from, unsigned long n)
 {
 	if (likely(check_copy_size(to, n, false)))
@@ -148,7 +154,7 @@ copy_from_user(void *to, const void __user *from, unsigned long n)
 	return n;
 }
 
-static __always_inline unsigned long __must_check
+static uaccess_inline unsigned long __must_check
 copy_to_user(void __user *to, const void *from, unsigned long n)
 {
 	if (likely(check_copy_size(from, n, true)))
-- 
2.19.1
