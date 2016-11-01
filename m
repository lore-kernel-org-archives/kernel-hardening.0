Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1477995348.2236.14.camel@cvidal.org>
From: Colin Vidal <colin@cvidal.org>
Date: Tue, 01 Nov 2016 11:15:48 +0100
In-Reply-To: <1477914225-11298-2-git-send-email-elena.reshetova@intel.com>
References: <1477914225-11298-1-git-send-email-elena.reshetova@intel.com>
	 <1477914225-11298-2-git-send-email-elena.reshetova@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC v3 PATCH 01/13] Add architecture
 independent hardened atomic base
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

<snip>
>  arch/alpha/include/asm/local.h             |   2 +
>  arch/m32r/include/asm/local.h              |   2 +
>  arch/mips/include/asm/local.h              |   2 +
>  arch/powerpc/include/asm/local.h           |   2 +
>  arch/x86/include/asm/local.h               |   2 +
<snip>
>  include/asm-generic/local.h                |  20 +++
>  include/asm-generic/local_wrap.h           |  89 ++++++++++
<snip>
> diff --git a/include/asm-generic/local.h b/include/asm-generic/local.h
> index 9ceb03b..e1c81c3 100644
> --- a/include/asm-generic/local.h
> +++ b/include/asm-generic/local.h
> @@ -4,6 +4,7 @@
>  #include <linux/percpu.h>
>  #include <linux/atomic.h>
>  #include <asm/types.h>
> +#include <asm-generic/local_wrap.h>

That brake build for any architecture that uses asm-generic/local.h
(like ARM v6/v7): asm-generic/local_wrap.h contains

    typedef local_t local_wrap_t

but at this time, local_t is not yet defined, since asm-
generic/local_wrap.h is included before the definition of local_t. The
following patch fixes that.

Thanks

Colin


diff --git a/include/asm-generic/local.h b/include/asm-generic/local.h
index e1c81c3..1828c57 100644
--- a/include/asm-generic/local.h
+++ b/include/asm-generic/local.h
@@ -4,7 +4,6 @@
 #include <linux/percpu.h>
 #include <linux/atomic.h>
 #include <asm/types.h>
-#include <asm-generic/local_wrap.h>
 
 /*
  * A signed long type for operations which are atomic for a single CPU.
@@ -48,23 +47,6 @@ typedef struct
 #define local_add_unless(l, _a, u) atomic_long_add_unless((&(l)->a), (_a), (u))
 #define local_inc_not_zero(l) atomic_long_inc_not_zero(&(l)->a)
 
-#define local_read_wrap(l)             atomic_long_read_wrap(&(l)->a)
-#define local_set_wrap(l,i)            atomic_long_set_wrap((&(l)->a),(i))
-#define local_inc_wrap(l)              atomic_long_inc_wrap(&(l)->a)
-#define local_inc_return_wrap(l)       atomic_long_return_wrap(&(l)->a)
-#define local_inc_and_test_wrap(l)     atomic_long_inc_and_test_wrap(&(l)->a)
-#define local_dec_wrap(l)              atomic_long_dec_wrap(&(l)->a)
-#define local_dec_return_wrap(l)       atomic_long_dec_return_wrap(&(l)->a)
-#define local_dec_and_test_wrap(l)     atomic_long_dec_and_test_wrap(&(l)->a)
-#define local_add_wrap(i,l)            atomic_long_add_wrap((i),(&(l)->a))
-#define local_add_return_wrap(i, l)    atomic_long_add_return_wrap((i), (&(l)->a))
-#define local_sub_wrap(i,l)            atomic_long_sub_wrap((i),(&(l)->a))
-#define local_sub_return_wrap(i, l)    atomic_long_sub_return_wrap((i), (&(l)->a))
-#define local_sub_and_test_wrap(i, l)  atomic_long_sub_and_test_wrap((i), (&(l)->a))
-#define local_cmpxchg_wrap(l, o, n)    atomic_long_cmpxchg_wrap((&(l)->a), (o), (n))
-#define local_add_unless_wrap(l, _a, u) atomic_long_add_unless_wrap((&(l)->a), (_a), (u))
-#define local_add_negative_wrap(i, l)  atomic_long_add_negative_wrap((i), (&(l)->a))
-
 /* Non-atomic variants, ie. preemption disabled and won't be touched
  * in interrupt, etc.  Some archs can optimize this case well. */
 #define __local_inc(l)         local_set((l), local_read(l) + 1)
@@ -72,4 +54,6 @@ typedef struct
 #define __local_add(i,l)       local_set((l), local_read(l) + (i))
 #define __local_sub(i,l)       local_set((l), local_read(l) - (i))
 
+#include <asm-generic/local_wrap.h>
+
 #endif /* _ASM_GENERIC_LOCAL_H */
