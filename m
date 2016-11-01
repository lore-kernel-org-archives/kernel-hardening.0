Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1477996972.2236.19.camel@cvidal.org>
From: Colin Vidal <colin@cvidal.org>
Date: Tue, 01 Nov 2016 11:42:52 +0100
In-Reply-To: <1477914225-11298-2-git-send-email-elena.reshetova@intel.com>
References: <1477914225-11298-1-git-send-email-elena.reshetova@intel.com>
	 <1477914225-11298-2-git-send-email-elena.reshetova@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] [RFC v3 PATCH 01/13] Add architecture
 independent hardened atomic base
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Elena,

> diff --git a/include/asm-generic/atomic-long.h b/include/asm-generic/atomic-long.h
<snip>
> +#ifndef CONFIG_HARDENED_ATOMIC
> +#ifndef atomic_read_wrap
> +#define atomic_read_wrap(v) atomic_read(v)
> +#endif /* atomic_read_wrap */
> +#ifndef atomic_set_wrap
> +#define atomic_set_wrap(v, i) atomic_set((v), (i))
> +#endif /* atomic_set_wrap */
> +#define atomic_add_wrap(i, v) atomic_add((i), (v))
> +#define atomic_sub_wrap(i, v) atomic_sub((i), (v))
> +#define atomic_inc_wrap(v) atomic_inc(v)
> +#define atomic_dec_wrap(v) atomic_dec(v)
> +#ifndef atomic_add_return_wrap
> +#define atomic_add_return_wrap(i, v) atomic_add_return((i), (v))
> +#endif /* atomic_add_return_wrap */
> +#ifndef atomic_sub_return_wrap
> +#define atomic_sub_return_wrap(i, v) atomic_sub_return((i), (v))
> +#endif /* atomic_sub_return_wrap */
> +#define atoimc_dec_return_wrap(v) atomic_dec_return(v)
> +#ifndef atomic_inc_return_wrap
> +#define atomic_inc_return_wrap(v) atomic_inc_return(v)
> +#endif /* atomic_inc_return */
> +#ifndef atomic_dec_and_test_wrap
> +#define atomic_dec_and_test_wrap(v) atomic_dec_and_test(v)
> +#endif /* atomic_dec_and_test_wrap */
> +#ifndef atomic_inc_and_test_wrap
> +#define atomic_inc_and_test_wrap(v) atomic_inc_and_test(v)
> +#endif /* atomic_inc_and_test_wrap */
> +#define atomic_sub_and_test_wrap(i, v) atomic_sub_and_test((v), (i))
> +#ifndef atomic_xchg_wrap
> +#define atomic_xchg_wrap(v, i) atomic_xchg((v), (i))
> +#endif /*  atomic_xchg_wrap(v, i) */
> +#ifndef atomic_cmpxchg_wrap
> +#define atomic_cmpxchg_wrap(v, o, n) atomic_cmpxchg((v), (o), (n))
> +#endif /* atomic_cmpxchg_wrap */
> +#define atomic_add_negative_wrap(i, v) atomic_add_negative((i), (v))
> +#define atomic_add_unless_wrap(v, i, j) atomic_add_unless((v), (i), (j))
> +#endif /* CONFIG_HARDENED_ATOMIC */
> +
>  #endif  /*  _ASM_GENERIC_ATOMIC_LONG_H  */
> 

It seems there are two missing guard here. I've got redefinition errors
on ARM (without my prototypes of arm generic atomic64 and arm hardened
atomic patches).

Thanks

Colin

diff --git a/include/asm-generic/atomic-long.h b/include/asm-
generic/atomic-long.h
index 60eb9e0..131f637 100644
--- a/include/asm-generic/atomic-long.h
+++ b/include/asm-generic/atomic-long.h
@@ -400,14 +400,18 @@ static inline long
atomic_long_add_unless_wrap(atomic_long_wrap_t *l, long a, lo
 #ifndef atomic_inc_and_test_wrap
 #define atomic_inc_and_test_wrap(v) atomic_inc_and_test(v)
 #endif /* atomic_inc_and_test_wrap */
+#ifndef atomic_sub_and_test_wrap
 #define atomic_sub_and_test_wrap(i, v) atomic_sub_and_test((v), (i))
+#endif /* atomic_sub_and_test_wrap */
 #ifndef atomic_xchg_wrap
 #define atomic_xchg_wrap(v, i) atomic_xchg((v), (i))
 #endif /*  atomic_xchg_wrap(v, i) */
 #ifndef atomic_cmpxchg_wrap
 #define atomic_cmpxchg_wrap(v, o, n) atomic_cmpxchg((v), (o), (n))
 #endif /* atomic_cmpxchg_wrap */
+#ifndef atomic_add_negative_wrap
 #define atomic_add_negative_wrap(i, v) atomic_add_negative((i), (v))
+#endif /* atomic_add_negative_wrap */
 #define atomic_add_unless_wrap(v, i, j) atomic_add_unless((v), (i),
(j))
 #endif /* CONFIG_HARDENED_ATOMIC */
