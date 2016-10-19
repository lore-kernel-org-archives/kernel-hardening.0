Reply-To: kernel-hardening@lists.openwall.com
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Wed, 19 Oct 2016 08:21:06 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41BE01A7@IRSMSX102.ger.corp.intel.com>
References: <1476802761-24340-1-git-send-email-colin@cvidal.org>
 <1476802761-24340-2-git-send-email-colin@cvidal.org>
In-Reply-To: <1476802761-24340-2-git-send-email-colin@cvidal.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [RFC 1/2] Reordering / guard definition on atomic_*_wrap
 function in order to avoid implicitly defined / redefined error on them,
 when CONFIG_HARDENED_ATOMIC is unset.
To: Colin Vidal <colin@cvidal.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, David Windsor <dave@progbits.org>, Kees Cook <keescook@chromium.org>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Signed-off-by: Colin Vidal <colin@cvidal.org>
---
 include/asm-generic/atomic-long.h | 55 +++++++++++++++++++++--------------=
----
 include/linux/atomic.h            | 55 +++++++++++++++++++++++++++++++++++=
++++
 2 files changed, 85 insertions(+), 25 deletions(-)

diff --git a/include/asm-generic/atomic-long.h b/include/asm-generic/atomic=
-long.h
index 790cb00..94d712b 100644
--- a/include/asm-generic/atomic-long.h
+++ b/include/asm-generic/atomic-long.h
@@ -46,6 +46,30 @@ typedef atomic_t atomic_long_wrap_t;
=20
 #endif
=20
+#ifndef CONFIG_HARDENED_ATOMIC
+#define atomic_read_wrap(v) atomic_read(v) #define atomic_set_wrap(v,=20
+i) atomic_set((v), (i)) #define atomic_add_wrap(i, v) atomic_add((i),=20
+(v)) #define atomic_add_unless_wrap(v, i, j) atomic_add_unless((v),=20
+(i), (j)) #define atomic_sub_wrap(i, v) atomic_sub((i), (v)) #define=20
+atomic_inc_wrap(v) atomic_inc(v) #define atomic_inc_and_test_wrap(v)=20
+atomic_inc_and_test(v) #ifndef atomic_inc_return_wrap #define=20
+atomic_inc_return_wrap(v) atomic_inc_return(v) #endif #ifndef=20
+atomic_add_return_wrap #define atomic_add_return_wrap(i, v)=20
+atomic_add_return((i), (v)) #endif #define atomic_dec_wrap(v)=20
+atomic_dec(v) #ifndef atomic_xchg_wrap #define atomic_xchg_wrap(v, i)=20
+atomic_xchg((v), (i)) #endif #define atomic_long_inc_wrap(v)=20
+atomic_long_inc(v) #define atomic_long_dec_wrap(v) atomic_long_dec(v)=20
+#define atomic_long_xchg_wrap(v, n) atomic_long_xchg(v, n) #define=20
+atomic_long_cmpxchg_wrap(l, o, n) atomic_long_cmpxchg(l, o, n) #endif=20
+/* CONFIG_HARDENED_ATOMIC */
+
 #define ATOMIC_LONG_READ_OP(mo, suffix)						\
 static inline long atomic_long_read##mo##suffix(const atomic_long##suffix#=
#_t *l)\
 {									\
@@ -104,6 +128,12 @@ ATOMIC_LONG_ADD_SUB_OP(sub, _release,)  #define atomic=
_long_cmpxchg(l, old, new) \
 	(ATOMIC_LONG_PFX(_cmpxchg)((ATOMIC_LONG_PFX(_t) *)(l), (old), (new)))
=20
+#ifdef CONFIG_HARDENED_ATOMIC
+#define atomic_long_cmpxchg_wrap(l, old, new)				\
+	(ATOMIC_LONG_PFX(_cmpxchg_wrap)((ATOMIC_LONG_PFX(_wrap_t) *)(l),\
+					(old), (new)))
+#endif
+
 #define atomic_long_xchg_relaxed(v, new) \
 	(ATOMIC_LONG_PFX(_xchg_relaxed)((ATOMIC_LONG_PFX(_t) *)(v), (new)))  #def=
ine atomic_long_xchg_acquire(v, new) \ @@ -291,29 +321,4 @@ static inline l=
ong atomic_long_add_unless(atomic_long_t *l, long a, long u)  #define atomi=
c_long_inc_not_zero(l) \
 	ATOMIC_LONG_PFX(_inc_not_zero)((ATOMIC_LONG_PFX(_t) *)(l))
=20
-#ifndef CONFIG_HARDENED_ATOMIC
-#define atomic_read_wrap(v) atomic_read(v) -#define atomic_set_wrap(v, i) =
atomic_set((v), (i)) -#define atomic_add_wrap(i, v) atomic_add((i), (v)) -#=
define atomic_add_unless_wrap(v, i, j) atomic_add_unless((v), (i), (j)) -#d=
efine atomic_sub_wrap(i, v) atomic_sub((i), (v)) -#define atomic_inc_wrap(v=
) atomic_inc(v) -#define atomic_inc_and_test_wrap(v) atomic_inc_and_test(v)=
 -#define atomic_inc_return_wrap(v) atomic_inc_return(v) -#define atomic_ad=
d_return_wrap(i, v) atomic_add_return((i), (v)) -#define atomic_dec_wrap(v)=
 atomic_dec(v) -#define atomic_cmpxchg_wrap(v, o, n) atomic_cmpxchg((v), (o=
), (n)) -#define atomic_xchg_wrap(v, i) atomic_xchg((v), (i)) -#define atom=
ic_long_read_wrap(v) atomic_long_read(v) -#define atomic_long_set_wrap(v, i=
) atomic_long_set((v), (i)) -#define atomic_long_add_wrap(i, v) atomic_long=
_add((i), (v)) -#define atomic_long_sub_wrap(i, v) atomic_long_sub((i), (v)=
) -#define atomic_long_inc_wrap(v) atomic_long_inc(v) -#define atomic_long_=
add_return_wrap(i, v) atomic_long_add_return((i), (v)) -#define atomic_long=
_inc_return_wrap(v) atomic_long_inc_return(v) -#define atomic_long_sub_and_=
test_wrap(i, v) atomic_long_sub_and_test((i), (v)) -#define atomic_long_dec=
_wrap(v) atomic_long_dec(v) -#define atomic_long_xchg_wrap(v, i) atomic_lon=
g_xchg((v), (i)) -#endif /* CONFIG_HARDENED_ATOMIC */
-
 #endif  /*  _ASM_GENERIC_ATOMIC_LONG_H  */ diff --git a/include/linux/atom=
ic.h b/include/linux/atomic.h index b5817c8..be16ea1 100644
--- a/include/linux/atomic.h
+++ b/include/linux/atomic.h
@@ -89,6 +89,11 @@
 #define  atomic_add_return(...)						\
 	__atomic_op_fence(atomic_add_return, __VA_ARGS__)  #endif
+
+#ifndef atomic_add_return_wrap_relaxed

ER: I guess this is a typo, should be ifndef atomic_add_return_wrap

+#define atomic_add_return_wrap(...)		                        \
+	__atomic_op_fence(atomic_add_return_wrap, __VA_ARGS__) #endif
 #endif /* atomic_add_return_relaxed */
=20
 /* atomic_inc_return_relaxed */
@@ -113,6 +118,11 @@
 #define  atomic_inc_return(...)						\
 	__atomic_op_fence(atomic_inc_return, __VA_ARGS__)  #endif
+
+#ifndef atomic_inc_return_wrap
+#define  atomic_inc_return_wrap(...)					\
+	__atomic_op_fence(atomic_inc_return_wrap, __VA_ARGS__) #endif
 #endif /* atomic_inc_return_relaxed */
=20
 /* atomic_sub_return_relaxed */
@@ -137,6 +147,11 @@
 #define  atomic_sub_return(...)						\
 	__atomic_op_fence(atomic_sub_return, __VA_ARGS__)  #endif
+
+#ifndef atomic_sub_return_wrap_relaxed

ER: Same as above

+#define atomic_sub_return_wrap(...)		                        \
+	__atomic_op_fence(atomic_sub_return_wrap, __VA_ARGS__) #endif
 #endif /* atomic_sub_return_relaxed */
=20
 /* atomic_dec_return_relaxed */
@@ -161,6 +176,11 @@
 #define  atomic_dec_return(...)						\
 	__atomic_op_fence(atomic_dec_return, __VA_ARGS__)  #endif
+
+#ifndef atomic_dec_return_wrap
+#define  atomic_dec_return_wrap(...)					\
+	__atomic_op_fence(atomic_dec_return, __VA_ARGS__) #endif

ER: Another typo? atomic_dec_return_wrap?


Actually we will hopefully send next rfc today-tomorrow and we plan to incl=
ude the above and other general declarations, so hopefully you don't need t=
o carry this part with your rfc anymore!

Best Regards,
Elena.
