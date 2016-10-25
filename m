Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1477424149.2263.52.camel@cvidal.org>
From: Colin Vidal <colin@cvidal.org>
Date: Tue, 25 Oct 2016 21:35:49 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] fix typo __atomic_op_fence
To: Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Hans,

can you apply this little fix on the
commit b5cafefa6ec2dd549174edc8fbd678c06fcb0472 you have just pushed on
Elena's hardened_atomic_on_next ?

Otherwise, any build that use atomic_xchg_relaxed and
atomic_cmpxchg_relaxed is broken.

Thanks :)

Colin

diff --git a/include/linux/atomic.h b/include/linux/atomic.h
index 4e9972d..ffd2e33 100644
--- a/include/linux/atomic.h
+++ b/include/linux/atomic.h
@@ -427,7 +427,7 @@
 
 #ifndef atomic_xchg_wrap
 #define  atomic_xchg_wrap(...)                         \
-       _atomic_op_fence(atomic_xchg_wrap, __VA_ARGS__)
+       __atomic_op_fence(atomic_xchg_wrap, __VA_ARGS__)
 #endif
 #endif /* atomic_xchg_relaxed */
 
@@ -456,7 +456,7 @@
 
 #ifndef atomic_cmpxchg_wrap
 #define  atomic_cmpxchg_wrap(...)                              \
-       _atomic_op_fence(atomic_cmpxchg_wrap, __VA_ARGS__)
+       __atomic_op_fence(atomic_cmpxchg_wrap, __VA_ARGS__)
 #endif
 #endif /* atomic_cmpxchg_relaxed */
