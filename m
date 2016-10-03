Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1475476886-26232-14-git-send-email-elena.reshetova@intel.com>
References: <1475476886-26232-1-git-send-email-elena.reshetova@intel.com> <1475476886-26232-14-git-send-email-elena.reshetova@intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 3 Oct 2016 14:35:12 -0700
Message-ID: <CAGXu5jJTxtHChZc9rX-m68goW6QWebu9v57Yw5Pz1CTqgLhYAg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC PATCH 13/13] lkdtm: add tests for atomic over-/underflow
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Oct 2, 2016 at 11:41 PM, Elena Reshetova
<elena.reshetova@intel.com> wrote:
> From: Hans Liljestrand <ishkamiel@gmail.com>
>
> This adds additional tests for modified atomic
> functions.

Awesome.

I think in the next ldktm refactoring, I'm going to have to come up
with a way to generate tests programmatically. :)

In this case, I do wonder if some of these could be macro-ized? Really
only the function name is changing...

-Kees

>
> Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> Signed-off-by: David Windsor <dwindsor@gmail.com>
> ---
>  drivers/misc/lkdtm.h      |  17 ++++
>  drivers/misc/lkdtm_bugs.c | 205 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/misc/lkdtm_core.c |  17 ++++
>  3 files changed, 239 insertions(+)
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
> index f336206..f6a09c6 100644
> --- a/drivers/misc/lkdtm_bugs.c
> +++ b/drivers/misc/lkdtm_bugs.c
> @@ -140,6 +140,42 @@ void lkdtm_ATOMIC_UNDERFLOW(void)
>         atomic_dec(&under);
>  }
>
> +void lkdtm_ATOMIC_DEC_RETURN_UNDERFLOW(void)
> +{
> +       atomic_t under = ATOMIC_INIT(INT_MIN);
> +
> +       pr_info("attempting good atomic_dec_return\n");
> +       atomic_inc(&under);
> +       atomic_dec_return(&under);
> +
> +       pr_info("attempting bad atomic_dec_return\n");
> +       atomic_dec_return(&under);
> +}
> +
> +void lkdtm_ATOMIC_SUB_UNDERFLOW(void) {
> +       atomic_t under = ATOMIC_INIT(INT_MIN);
> +
> +       pr_info("attempting good atomic subtract\n");
> +       atomic_add(10, &under);
> +       atomic_sub(10, &under);
> +
> +       pr_info("attempting bad atomic subtract underflow\n");
> +       atomic_sub(10, &under);
> +}
> +
> +void lkdtm_ATOMIC_SUB_RETURN_UNDERFLOW(void)
> +{
> +       atomic_t under = ATOMIC_INIT(INT_MIN);
> +
> +       pr_info("attempting good atomic_sub_return\n");
> +       atomic_add(10, &under);
> +       atomic_sub_return(10, &under);
> +
> +       pr_info("attempting bad atomic_sub_return underflow\n");
> +       atomic_sub_return(10, &under);
> +
> +}
> +
>  void lkdtm_ATOMIC_OVERFLOW(void)
>  {
>         atomic_t over = ATOMIC_INIT(INT_MAX);
> @@ -214,3 +250,172 @@ void lkdtm_CORRUPT_LIST_DEL(void)
>         else
>                 pr_err("list_del() corruption not detected!\n");
>  }
> +
> +void lkdtm_ATOMIC_INC_RETURN_OVERFLOW(void)
> +{
> +       atomic_t over = ATOMIC_INIT(INT_MAX);
> +
> +       pr_info("attempting good atomic_inc_return\n");
> +       atomic_dec(&over);
> +       atomic_inc_return(&over);
> +
> +       pr_info("attempting bad atomic_inc_return overflow\n");
> +       atomic_inc_return(&over);
> +}
> +
> +void lkdtm_ATOMIC_ADD_OVERFLOW(void) {
> +       atomic_t over = ATOMIC_INIT(INT_MAX);
> +
> +       pr_info("attempting good atomic add\n");
> +       atomic_sub(10, &over);
> +       atomic_add(10, &over);
> +
> +       pr_info("attempting bad atomic add overflow\n");
> +       atomic_add(10, &over);
> +}
> +
> +void lkdtm_ATOMIC_ADD_RETURN_OVERFLOW(void)
> +{
> +       atomic_t over = ATOMIC_INIT(INT_MAX);
> +
> +       pr_info("attempting good atomic_add_return\n");
> +       atomic_sub(10, &over);
> +       atomic_add_return(10, &over);
> +
> +       pr_info("attempting bad atomic_add_return overflow\n");
> +       atomic_add_return(10, &over);
> +}
> +
> +void lkdtm_ATOMIC_ADD_UNLESS_OVERFLOW(void)
> +{
> +       atomic_t over = ATOMIC_INIT(INT_MAX);
> +
> +       pr_info("attempting good atomic_add_unless\n");
> +       atomic_sub(10, &over);
> +       atomic_add_unless(&over, 10, 0);
> +
> +       pr_info("attempting bad atomic_add_unless overflow\n");
> +       atomic_add_unless(&over, 10, 0);
> +}
> +
> +void lkdtm_ATOMIC_INC_AND_TEST_OVERFLOW(void)
> +{
> +       atomic_t over = ATOMIC_INIT(INT_MAX);
> +
> +       pr_info("attempting good atomic_inc_and_test\n");
> +       atomic_dec(&over);
> +       atomic_inc_and_test(&over);
> +
> +       pr_info("attempting bad atomic_inc_and_test overflow\n");
> +       atomic_inc_and_test(&over);
> +}
> +
> +void lkdtm_ATOMIC_LONG_UNDERFLOW(void)
> +{
> +       atomic_long_t under = ATOMIC_LONG_INIT(LONG_MIN);
> +
> +       pr_info("attempting good atomic_long_dec\n");
> +       atomic_long_inc(&under);
> +       atomic_long_dec(&under);
> +
> +       pr_info("attempting bad atomic_long_dec underflow\n");
> +       atomic_long_dec(&under);
> +}
> +
> +void lkdtm_ATOMIC_LONG_DEC_RETURN_UNDERFLOW(void)
> +{
> +       atomic_long_t under = ATOMIC_LONG_INIT(LONG_MIN);
> +
> +       pr_info("attempting good atomic_long_dec_return\n");
> +       atomic_long_inc(&under);
> +       atomic_long_dec_return(&under);
> +
> +       pr_info("attempting bad atomic_long_dec_return underflow\n");
> +       atomic_long_dec_return(&under);
> +}
> +
> +void lkdtm_ATOMIC_LONG_SUB_UNDERFLOW(void)
> +{
> +       atomic_long_t under = ATOMIC_INIT(LONG_MIN);
> +
> +       pr_info("attempting good atomic_long_sub\n");
> +       atomic_long_add(10, &under);
> +       atomic_long_sub(10, &under);
> +
> +       pr_info("attempting bad atomic_long_sub underflow\n");
> +       atomic_long_sub(10, &under);
> +
> +}
> +
> +void lkdtm_ATOMIC_LONG_SUB_RETURN_UNDERFLOW(void)
> +{
> +       atomic_long_t under = ATOMIC_INIT(LONG_MIN);
> +
> +       pr_info("attempting good atomic_long_sub_return \n");
> +       atomic_long_add(10, &under);
> +       atomic_long_sub_return(10, &under);
> +
> +       pr_info("attempting bad atomic_long_sub_return underflow\n");
> +       atomic_long_sub_return(10, &under);
> +
> +}
> +
> +void lkdtm_ATOMIC_LONG_OVERFLOW(void)
> +{
> +       atomic_long_t over = ATOMIC_LONG_INIT(LONG_MAX);
> +
> +       pr_info("attempting good atomic_long_inc\n");
> +       atomic_long_dec(&over);
> +       atomic_long_inc(&over);
> +
> +       pr_info("attempting bad atomic_long_inc overflow\n");
> +       atomic_long_inc(&over);
> +}
> +
> +void lkdtm_ATOMIC_LONG_INC_RETURN_OVERFLOW(void)
> +{
> +       atomic_long_t over = ATOMIC_LONG_INIT(LONG_MAX);
> +
> +       pr_info("attempting good atomic_ong_inc_return\n");
> +       atomic_long_dec(&over);
> +       atomic_long_inc_return(&over);
> +
> +       pr_info("attempting bad atomic_long_inc_return overflow\n");
> +       atomic_long_inc_return(&over);
> +}
> +
> +void lkdtm_ATOMIC_LONG_ADD_OVERFLOW(void)
> +{
> +       atomic_long_t over = ATOMIC_LONG_INIT(LONG_MAX);
> +
> +       pr_info("attempting good atomic_long_add\n");
> +       atomic_long_sub(10, &over);
> +       atomic_long_add(10, &over);
> +
> +       pr_info("attempting bad atomic_long_add overflow\n");
> +       atomic_long_add(10, &over);
> +}
> +
> +void lkdtm_ATOMIC_LONG_ADD_RETURN_OVERFLOW(void)
> +{
> +       atomic_long_t over = ATOMIC_LONG_INIT(LONG_MAX);
> +
> +       pr_info("attempting good atomic_long_add_return\n");
> +       atomic_long_sub(10, &over);
> +       atomic_long_add_return(10, &over);
> +
> +       pr_info("attempting bad atomic_long_add_return overflow\n");
> +       atomic_long_add_return(10, &over);
> +}
> +
> +void lkdtm_ATOMIC_LONG_SUB_AND_TEST(void)
> +{
> +       atomic_long_t over = ATOMIC_LONG_INIT(LONG_MIN);
> +
> +       pr_info("attempting good atomic_long_sub_and_test\n");
> +       atomic_long_add(10, &over);
> +       atomic_long_sub_and_test(10, &over);
> +
> +       pr_info("attempting bad atomic_long_sub_and_test overflow\n");
> +       atomic_long_sub_and_test(10, &over);
> +}
> diff --git a/drivers/misc/lkdtm_core.c b/drivers/misc/lkdtm_core.c
> index 7eeb71a..4b05803 100644
> --- a/drivers/misc/lkdtm_core.c
> +++ b/drivers/misc/lkdtm_core.c
> @@ -221,7 +221,24 @@ struct crashtype crashtypes[] = {
>         CRASHTYPE(WRITE_RO_AFTER_INIT),
>         CRASHTYPE(WRITE_KERN),
>         CRASHTYPE(ATOMIC_UNDERFLOW),
> +       CRASHTYPE(ATOMIC_DEC_RETURN_UNDERFLOW),
> +       CRASHTYPE(ATOMIC_SUB_UNDERFLOW),
> +       CRASHTYPE(ATOMIC_SUB_RETURN_UNDERFLOW),
>         CRASHTYPE(ATOMIC_OVERFLOW),
> +       CRASHTYPE(ATOMIC_INC_RETURN_OVERFLOW),
> +       CRASHTYPE(ATOMIC_ADD_OVERFLOW),
> +       CRASHTYPE(ATOMIC_ADD_RETURN_OVERFLOW),
> +       CRASHTYPE(ATOMIC_ADD_UNLESS_OVERFLOW),
> +       CRASHTYPE(ATOMIC_INC_AND_TEST_OVERFLOW),
> +       CRASHTYPE(ATOMIC_LONG_UNDERFLOW),
> +       CRASHTYPE(ATOMIC_LONG_DEC_RETURN_UNDERFLOW),
> +       CRASHTYPE(ATOMIC_LONG_SUB_UNDERFLOW),
> +       CRASHTYPE(ATOMIC_LONG_SUB_RETURN_UNDERFLOW),
> +       CRASHTYPE(ATOMIC_LONG_OVERFLOW),
> +       CRASHTYPE(ATOMIC_LONG_INC_RETURN_OVERFLOW),
> +       CRASHTYPE(ATOMIC_LONG_ADD_OVERFLOW),
> +       CRASHTYPE(ATOMIC_LONG_ADD_RETURN_OVERFLOW),
> +       CRASHTYPE(ATOMIC_LONG_SUB_AND_TEST),
>         CRASHTYPE(USERCOPY_HEAP_SIZE_TO),
>         CRASHTYPE(USERCOPY_HEAP_SIZE_FROM),
>         CRASHTYPE(USERCOPY_HEAP_FLAG_TO),
> --
> 2.7.4
>



-- 
Kees Cook
Nexus Security
