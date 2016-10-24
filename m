Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1476959131-6153-14-git-send-email-elena.reshetova@intel.com>
References: <1476959131-6153-1-git-send-email-elena.reshetova@intel.com> <1476959131-6153-14-git-send-email-elena.reshetova@intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 24 Oct 2016 16:14:40 -0700
Message-ID: <CAGXu5jKZ=axK=vk4S4Ag3_s-f5=UY-4AJcgB85ozuFRcJW0bKQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC v2 PATCH 13/13] lkdtm: add tests for
 atomic over-/underflow
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Hans Liljestrand <ishkamiel@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 20, 2016 at 3:25 AM, Elena Reshetova
<elena.reshetova@intel.com> wrote:
> From: Hans Liljestrand <ishkamiel@gmail.com>
>
> This adds additional tests for modified atomic functions.
>
> Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> Signed-off-by: David Windsor <dwindsor@gmail.com>
> ---
>  drivers/misc/lkdtm.h      |  17 +++++++
>  drivers/misc/lkdtm_bugs.c | 122 +++++++++++++++++++++++++++++++++++++++-------
>  drivers/misc/lkdtm_core.c |  17 +++++++
>  3 files changed, 138 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/misc/lkdtm.h b/drivers/misc/lkdtm.h
> index cfa1039..224713a 100644
> --- a/drivers/misc/lkdtm.h
> +++ b/drivers/misc/lkdtm.h
> @@ -20,7 +20,24 @@ void lkdtm_HARDLOCKUP(void);
>  void lkdtm_SPINLOCKUP(void);
>  void lkdtm_HUNG_TASK(void);
>  void lkdtm_ATOMIC_UNDERFLOW(void);
> +void lkdtm_ATOMIC_DEC_RETURN_UNDERFLOW(void);
> +void lkdtm_ATOMIC_SUB_UNDERFLOW(void);
> +void lkdtm_ATOMIC_SUB_RETURN_UNDERFLOW(void);
>  void lkdtm_ATOMIC_OVERFLOW(void);
> +void lkdtm_ATOMIC_INC_RETURN_OVERFLOW(void);
> +void lkdtm_ATOMIC_ADD_OVERFLOW(void);
> +void lkdtm_ATOMIC_ADD_RETURN_OVERFLOW(void);
> +void lkdtm_ATOMIC_ADD_UNLESS_OVERFLOW(void);
> +void lkdtm_ATOMIC_INC_AND_TEST_OVERFLOW(void);
> +void lkdtm_ATOMIC_LONG_UNDERFLOW(void);
> +void lkdtm_ATOMIC_LONG_DEC_RETURN_UNDERFLOW(void);
> +void lkdtm_ATOMIC_LONG_SUB_UNDERFLOW(void);
> +void lkdtm_ATOMIC_LONG_SUB_RETURN_UNDERFLOW(void);
> +void lkdtm_ATOMIC_LONG_OVERFLOW(void);
> +void lkdtm_ATOMIC_LONG_INC_RETURN_OVERFLOW(void);
> +void lkdtm_ATOMIC_LONG_ADD_OVERFLOW(void);
> +void lkdtm_ATOMIC_LONG_ADD_RETURN_OVERFLOW(void);
> +void lkdtm_ATOMIC_LONG_SUB_AND_TEST(void);
>  void lkdtm_CORRUPT_LIST_ADD(void);
>  void lkdtm_CORRUPT_LIST_DEL(void);
>
> diff --git a/drivers/misc/lkdtm_bugs.c b/drivers/misc/lkdtm_bugs.c
> index f336206..bd79a88 100644
> --- a/drivers/misc/lkdtm_bugs.c
> +++ b/drivers/misc/lkdtm_bugs.c
> @@ -128,30 +128,116 @@ void lkdtm_HUNG_TASK(void)
>         schedule();
>  }
>
> -void lkdtm_ATOMIC_UNDERFLOW(void)
> -{
> -       atomic_t under = ATOMIC_INIT(INT_MIN);
> -
> -       pr_info("attempting good atomic increment\n");
> -       atomic_inc(&under);
> -       atomic_dec(&under);
> -
> -       pr_info("attempting bad atomic underflow\n");
> -       atomic_dec(&under);
> +#define ATOMIC_LKDTM_MIN(tag,fun) void lkdtm_ATOMIC_##tag(void)        \
> +{                                                                      \
> +       atomic_t atomic = ATOMIC_INIT(INT_MIN);                         \
> +                                                                       \
> +       pr_info("attempting good atomic_" #fun "\n");                   \
> +       atomic_inc(&atomic);                                            \
> +       TEST_FUNC(&atomic);                                             \
> +                                                                       \
> +       pr_info("attempting bad atomic_" #fun "\n");                    \
> +       TEST_FUNC(&atomic);                                             \
>  }
>
> -void lkdtm_ATOMIC_OVERFLOW(void)
> -{
> -       atomic_t over = ATOMIC_INIT(INT_MAX);
> +#define ATOMIC_LKDTM_MAX(tag,fun,...)                                  \
> +void lkdtm_ATOMIC_##tag(void)                                          \
> +{                                                                      \
> +       atomic_t atomic = ATOMIC_INIT(INT_MAX);                         \
> +                                                                       \
> +       pr_info("attempting good atomic_" #fun "\n");                   \
> +       atomic_dec(&atomic);                                            \
> +       TEST_FUNC(&atomic);                                             \
> +                                                                       \
> +       pr_info("attempting bad atomic_" #fun "\n");                    \
> +       TEST_FUNC(&atomic);                                             \
> +}
>
> -       pr_info("attempting good atomic decrement\n");
> -       atomic_dec(&over);
> -       atomic_inc(&over);
> +#define ATOMIC_LKDTM_LONG_MIN(tag,fun,...)                             \
> +void lkdtm_ATOMIC_LONG_##tag(void)                                     \
> +{                                                                      \
> +       atomic_long_t atomic  = ATOMIC_LONG_INIT(LONG_MIN);             \
> +                                                                       \
> +       pr_info("attempting good atomic_long_" #fun "\n");              \
> +       atomic_long_inc(&atomic);                                       \
> +       TEST_FUNC(&atomic);                                             \
> +                                                                       \
> +       pr_info("attempting bad atomic_long_" #fun "\n");               \
> +       TEST_FUNC(&atomic);                                             \
> +}
>
> -       pr_info("attempting bad atomic overflow\n");
> -       atomic_inc(&over);
> +#define ATOMIC_LKDTM_LONG_MAX(tag,fun,...)                             \
> +void lkdtm_ATOMIC_LONG_##tag(void)                                     \
> +{                                                                      \
> +       atomic_long_t atomic = ATOMIC_LONG_INIT(LONG_MAX);              \
> +                                                                       \
> +       pr_info("attempting good atomic_long_" #fun "\n");              \
> +       atomic_long_dec(&atomic);                                       \
> +       TEST_FUNC(&atomic);                                             \
> +                                                                       \
> +       pr_info("attempting bad atomic_long_" #fun "\n");               \
> +       TEST_FUNC(&atomic);                                             \
>  }
>
> +#define TEST_FUNC(x) atomic_dec(x)
> +ATOMIC_LKDTM_MIN(UNDERFLOW,dec)
> +#undef TEST_FUNC
> +#define TEST_FUNC(x) atomic_dec_return(x)
> +ATOMIC_LKDTM_MIN(DEC_RETURN_UNDERFLOW,dec_return);
> +#undef TEST_FUNC
> +#define TEST_FUNC(x) atomic_sub(1,x)

I wish there was some way to define the multi-arg test functions more
cleanly than this... I'll ponder some options.

-Kees

-- 
Kees Cook
Nexus Security
