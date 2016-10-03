Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1475476886-26232-3-git-send-email-elena.reshetova@intel.com>
References: <1475476886-26232-1-git-send-email-elena.reshetova@intel.com> <1475476886-26232-3-git-send-email-elena.reshetova@intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 3 Oct 2016 14:12:02 -0700
Message-ID: <CAGXu5jJnJODOzv4Yk=c-n9wA=hP=qza57q1EBcD4sJboVqXr3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC PATCH 02/13] percpu-refcount: leave atomic counter unprotected
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Oct 2, 2016 at 11:41 PM, Elena Reshetova
<elena.reshetova@intel.com> wrote:
> From: Hans Liljestrand <ishkamiel@gmail.com>
>
> This is a temporary solution, and a deviation from the PaX/Grsecurity
> implementation where the counter in question is protected against
> overflows. That however necessitates decreasing the PERCPU_COUNT_BIAS
> which is used in lib/percpu-refcount.c. Such a change effectively cuts
> the safe counter range down by half, and still allows the counter to,
> without warning, prematurely reach zero (which is what the bias aims to
> prevent).

It might be useful to include a link to the earlier discussions that
led to this solution.

-Kees

>
> Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
> Signed-off-by: David Windsor <dwindsor@gmail.com>
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> ---
>  include/linux/percpu-refcount.h | 18 ++++++++++++++----
>  lib/percpu-refcount.c           | 12 ++++++------
>  2 files changed, 20 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
> index 1c7eec0..7c6a482 100644
> --- a/include/linux/percpu-refcount.h
> +++ b/include/linux/percpu-refcount.h
> @@ -81,7 +81,17 @@ enum {
>  };
>
>  struct percpu_ref {
> -       atomic_long_t           count;
> +       /*
> +        * This is a temporary solution.
> +        *
> +        * The count should technically not be allowed to wrap, but due to the
> +        * way the counter is used (in lib/percpu-refcount.c) together with the
> +        * PERCPU_COUNT_BIAS it needs to wrap. This leaves the counter open
> +        * to over/underflows. A non-wrapping atomic, together with a bias
> +        * decrease would reduce the safe range in half, and also offer only
> +        * partial protection.
> +        */
> +       atomic_long_wrap_t      count;
>         /*
>          * The low bit of the pointer indicates whether the ref is in percpu
>          * mode; if set, then get/put will manipulate the atomic_t.
> @@ -174,7 +184,7 @@ static inline void percpu_ref_get_many(struct percpu_ref *ref, unsigned long nr)
>         if (__ref_is_percpu(ref, &percpu_count))
>                 this_cpu_add(*percpu_count, nr);
>         else
> -               atomic_long_add(nr, &ref->count);
> +               atomic_long_add_wrap(nr, &ref->count);
>
>         rcu_read_unlock_sched();
>  }
> @@ -272,7 +282,7 @@ static inline void percpu_ref_put_many(struct percpu_ref *ref, unsigned long nr)
>
>         if (__ref_is_percpu(ref, &percpu_count))
>                 this_cpu_sub(*percpu_count, nr);
> -       else if (unlikely(atomic_long_sub_and_test(nr, &ref->count)))
> +       else if (unlikely(atomic_long_sub_and_test_wrap(nr, &ref->count)))
>                 ref->release(ref);
>
>         rcu_read_unlock_sched();
> @@ -320,7 +330,7 @@ static inline bool percpu_ref_is_zero(struct percpu_ref *ref)
>
>         if (__ref_is_percpu(ref, &percpu_count))
>                 return false;
> -       return !atomic_long_read(&ref->count);
> +       return !atomic_long_read_wrap(&ref->count);
>  }
>
>  #endif
> diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
> index 9ac959e..2849e06 100644
> --- a/lib/percpu-refcount.c
> +++ b/lib/percpu-refcount.c
> @@ -80,7 +80,7 @@ int percpu_ref_init(struct percpu_ref *ref, percpu_ref_func_t *release,
>         else
>                 start_count++;
>
> -       atomic_long_set(&ref->count, start_count);
> +       atomic_long_set_wrap(&ref->count, start_count);
>
>         ref->release = release;
>         ref->confirm_switch = NULL;
> @@ -134,7 +134,7 @@ static void percpu_ref_switch_to_atomic_rcu(struct rcu_head *rcu)
>                 count += *per_cpu_ptr(percpu_count, cpu);
>
>         pr_debug("global %ld percpu %ld",
> -                atomic_long_read(&ref->count), (long)count);
> +                atomic_long_read_wrap(&ref->count), (long)count);
>
>         /*
>          * It's crucial that we sum the percpu counters _before_ adding the sum
> @@ -148,11 +148,11 @@ static void percpu_ref_switch_to_atomic_rcu(struct rcu_head *rcu)
>          * reaching 0 before we add the percpu counts. But doing it at the same
>          * time is equivalent and saves us atomic operations:
>          */
> -       atomic_long_add((long)count - PERCPU_COUNT_BIAS, &ref->count);
> +       atomic_long_add_wrap((long)count - PERCPU_COUNT_BIAS, &ref->count);
>
> -       WARN_ONCE(atomic_long_read(&ref->count) <= 0,
> +       WARN_ONCE(atomic_long_read_wrap(&ref->count) <= 0,
>                   "percpu ref (%pf) <= 0 (%ld) after switching to atomic",
> -                 ref->release, atomic_long_read(&ref->count));
> +                 ref->release, atomic_long_read_wrap(&ref->count));
>
>         /* @ref is viewed as dead on all CPUs, send out switch confirmation */
>         percpu_ref_call_confirm_rcu(rcu);
> @@ -194,7 +194,7 @@ static void __percpu_ref_switch_to_percpu(struct percpu_ref *ref)
>         if (!(ref->percpu_count_ptr & __PERCPU_REF_ATOMIC))
>                 return;
>
> -       atomic_long_add(PERCPU_COUNT_BIAS, &ref->count);
> +       atomic_long_add_wrap(PERCPU_COUNT_BIAS, &ref->count);
>
>         /*
>          * Restore per-cpu operation.  smp_store_release() is paired with
> --
> 2.7.4
>



-- 
Kees Cook
Nexus Security
