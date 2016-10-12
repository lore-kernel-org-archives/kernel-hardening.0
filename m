Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1476301332.19131.24.camel@cvidal.org>
From: Colin Vidal <colin@cvidal.org>
Date: Wed, 12 Oct 2016 21:42:12 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] atomic64_wrap_t generic implementation
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Elena,

diff --git a/include/asm-generic/atomic64.h b/include/asm-generic/atomic64.h
index dad68bf..4987419 100644
--- a/include/asm-generic/atomic64.h
+++ b/include/asm-generic/atomic64.h
@@ -16,6 +16,8 @@ typedef struct {
        long long counter;
 } atomic64_t;
 
+typedef atomic64_t atomic64_wrap_t;
+
 #define ATOMIC64_INIT(i)       { (i) }
 
 extern long long atomic64_read(const atomic64_t *v);
@@ -62,4 +64,15 @@ extern int    atomic64_add_unless(atomic64_t *v, long long a, long long u);
 #define atomic64_dec_and_test(v)       (atomic64_dec_return((v)) == 0)
 #define atomic64_inc_not_zero(v)       atomic64_add_unless((v), 1LL, 0LL)
 
+#define atomic64_read_wrap(v) atomic64_read(v)
+#define atomic64_set_wrap(v, i) atomic64_set((v), (i))
+#define atomic64_add_wrap(a, v) atomic64_add((a), (v))
+#define atomic64_add_return_wrap(a, v) atomic64_add_return((a), (v))
+#define atomic64_sub_wrap(a, v) atomic64_sub((a), (v))
+#define atomic64_inc_wrap(v) atomic64_inc(v)
+#define atomic64_inc_return_wrap(v) atomic64_inc_return(v)
+#define atomic64_dec_wrap(v) atomic64_dec(v)
+#define atomic64_cmpxchg_wrap(v, o, n) atomic64_cmpxchg((v), (o), (n))
+#define atomic64_xchg_wrap(v, n) atomic64_xchg((v), (n))

Isen't there a type error ? For instance:

atomic64_wrap_t atom_wrap;

atomic64_read_wrap(atom_wrap) will be expanded into
atomic64_read(atom_wrap), which would lead to a type error (atomic64_t
expected).

Perhaps the more simple thing to do would be

-typedef atomic64_t atomic64_wrap_t;
+#define atomic64_wrap_t atomic64_t

since the implementations are the same here.

Or I missed something obvious?

Thanks,

Colin
