Message-Id: <20170203132737.666333770@infradead.org>
Date: Fri, 03 Feb 2017 14:26:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
References: <20170203132558.474916683@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=peterz-ref-6.patch
Subject: [kernel-hardening] [PATCH 5/5] refcount: Use atomic_try_cmpxchg()
To: elena.reshetova@intel.com, gregkh@linuxfoundation.org, keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@kernel.org, h.peter.anvin@intel.com, will.deacon@arm.com, dwindsor@gmail.com, dhowells@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Generates better code (GCC-6.2.1):

0000000000000420 <ihold>:
     420:       55                      push   %rbp
     421:       8b 97 48 01 00 00       mov    0x148(%rdi),%edx
     427:       48 89 e5                mov    %rsp,%rbp
     42a:       eb 10                   jmp    43c <ihold+0x1c>
     42c:       89 d0                   mov    %edx,%eax
     42e:       f0 0f b1 8f 48 01 00    lock cmpxchg %ecx,0x148(%rdi)
     435:       00 
     436:       39 c2                   cmp    %eax,%edx
     438:       74 0d                   je     447 <ihold+0x27>
     43a:       89 c2                   mov    %eax,%edx
     43c:       8d 42 ff                lea    -0x1(%rdx),%eax
     43f:       8d 4a 01                lea    0x1(%rdx),%ecx
     442:       83 f8 fd                cmp    $0xfffffffd,%eax
     445:       76 e5                   jbe    42c <ihold+0xc>
     447:       5d                      pop    %rbp
     448:       c3                      retq   

0000000000001490 <ihold>:
    1490:       55                      push   %rbp
    1491:       8b 87 48 01 00 00       mov    0x148(%rdi),%eax
    1497:       48 89 e5                mov    %rsp,%rbp
    149a:       eb 0a                   jmp    14a6 <ihold+0x16>
    149c:       f0 0f b1 97 48 01 00    lock cmpxchg %edx,0x148(%rdi)
    14a3:       00 
    14a4:       74 0b                   je     14b1 <ihold+0x21>
    14a6:       8d 48 ff                lea    -0x1(%rax),%ecx
    14a9:       8d 50 01                lea    0x1(%rax),%edx
    14ac:       83 f9 fd                cmp    $0xfffffffd,%ecx
    14af:       76 eb                   jbe    149c <ihold+0xc>
    14b1:       5d                      pop    %rbp
    14b2:       c3                      retq   

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/refcount.h |   33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

--- a/include/linux/refcount.h
+++ b/include/linux/refcount.h
@@ -69,7 +69,7 @@ static inline unsigned int refcount_read
 static inline __refcount_check
 bool refcount_add_not_zero(unsigned int i, refcount_t *r)
 {
-	unsigned int old, new, val = atomic_read(&r->refs);
+	unsigned int new, val = atomic_read(&r->refs);
 
 	for (;;) {
 		if (!val)
@@ -81,11 +81,9 @@ bool refcount_add_not_zero(unsigned int
 		new = val + i;
 		if (new < val)
 			new = UINT_MAX;
-		old = atomic_cmpxchg_relaxed(&r->refs, val, new);
-		if (old == val)
-			break;
 
-		val = old;
+		if (atomic_try_cmpxchg_relaxed(&r->refs, &val, new))
+			break;
 	}
 
 	REFCOUNT_WARN(new == UINT_MAX, "refcount_t: saturated; leaking memory.\n");
@@ -108,7 +106,7 @@ static inline void refcount_add(unsigned
 static inline __refcount_check
 bool refcount_inc_not_zero(refcount_t *r)
 {
-	unsigned int old, new, val = atomic_read(&r->refs);
+	unsigned int new, val = atomic_read(&r->refs);
 
 	for (;;) {
 		new = val + 1;
@@ -119,11 +117,8 @@ bool refcount_inc_not_zero(refcount_t *r
 		if (unlikely(!new))
 			return true;
 
-		old = atomic_cmpxchg_relaxed(&r->refs, val, new);
-		if (old == val)
+		if (atomic_try_cmpxchg_relaxed(&r->refs, &val, new))
 			break;
-
-		val = old;
 	}
 
 	REFCOUNT_WARN(new == UINT_MAX, "refcount_t: saturated; leaking memory.\n");
@@ -153,7 +148,7 @@ static inline void refcount_inc(refcount
 static inline __refcount_check
 bool refcount_sub_and_test(unsigned int i, refcount_t *r)
 {
-	unsigned int old, new, val = atomic_read(&r->refs);
+	unsigned int new, val = atomic_read(&r->refs);
 
 	for (;;) {
 		if (unlikely(val == UINT_MAX))
@@ -165,11 +160,8 @@ bool refcount_sub_and_test(unsigned int
 			return false;
 		}
 
-		old = atomic_cmpxchg_release(&r->refs, val, new);
-		if (old == val)
+		if (atomic_try_cmpxchg_release(&r->refs, &val, new))
 			break;
-
-		val = old;
 	}
 
 	return !new;
@@ -208,7 +200,9 @@ void refcount_dec(refcount_t *r)
 static inline __refcount_check
 bool refcount_dec_if_one(refcount_t *r)
 {
-	return atomic_cmpxchg_release(&r->refs, 1, 0) == 1;
+	int val = 1;
+
+	return atomic_try_cmpxchg_release(&r->refs, &val, 0);
 }
 
 /*
@@ -220,7 +214,7 @@ bool refcount_dec_if_one(refcount_t *r)
 static inline __refcount_check
 bool refcount_dec_not_one(refcount_t *r)
 {
-	unsigned int old, new, val = atomic_read(&r->refs);
+	unsigned int new, val = atomic_read(&r->refs);
 
 	for (;;) {
 		if (unlikely(val == UINT_MAX))
@@ -235,11 +229,8 @@ bool refcount_dec_not_one(refcount_t *r)
 			return true;
 		}
 
-		old = atomic_cmpxchg_release(&r->refs, val, new);
-		if (old == val)
+		if (atomic_try_cmpxchg_release(&r->refs, &val, new))
 			break;
-
-		val = old;
 	}
 
 	return true;
