Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161028023027.GD19531@linaro.org>
References: <20161025204303.GA36052@beast> <2236FBA76BA1254E88B949DDB74E612B41BF8C0A@IRSMSX102.ger.corp.intel.com>
 <CAGXu5jJ2MmY=qDT420F9_hbKtkdRvXC+Juf0J8WKJmtZN4jC0g@mail.gmail.com>
 <20161027124652.2pys4h7tug5wmqge@thigreal> <CAGXu5jLnuny-rEcck5SKnORqFU0=Jqt8Pzomv+KdL7JRrB=S5A@mail.gmail.com>
 <20161028023027.GD19531@linaro.org>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 28 Oct 2016 10:21:52 -0700
Message-ID: <CAGXu5jJyQSfkN3LTbCL9+dH4QX2VGdE36kwe75j2McEiZekv+Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [RFC v2 PATCH 13.1/13] lkdtm: add tests
 for atomic over-/underflow
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Hans Liljestrand <ishkamiel@gmail.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 27, 2016 at 7:30 PM, AKASHI Takahiro
<takahiro.akashi@linaro.org> wrote:
> On Thu, Oct 27, 2016 at 02:36:25PM -0700, Kees Cook wrote:
>> On Thu, Oct 27, 2016 at 5:46 AM, Hans Liljestrand <ishkamiel@gmail.com> wrote:
>> > On Wed, Oct 26, 2016 at 01:41:34PM -0700, Kees Cook wrote:
>> >> On Wed, Oct 26, 2016 at 12:29 AM, Reshetova, Elena
>> >> <elena.reshetova@intel.com> wrote:
>> >> > Thank you Kees! I applied the commit to our hardened_atomic_on_next branch and it will be included into the next rfc.
>> >>
>> >> Cool, thanks. I assume this should get atomic64_t and local_t tests as well?
>> >>
>> >
>> > Yes, I'm currently compiling a build with atomic64_t and local_t tests added.
>> > With the improved lkdtm macros its much easier to add the extra types, thank
>> > you Kees!
>>
>> Sure thing! I may have yet-another patch for this, as I didn't like
>> repeating the same things in three files whenever a new test was
>> added. Moar macro magick!
>
> It would be nice to expose atomic* variables to userspace via debugfs
> so that we can confirm that the values will not be changed if overflowed.
> See the attached patch.
>
> We will be able to check the test result:
>
>  # /bin/echo ATOMIC_ADD_OVERFLOW > /debug/provoke-crash/DIRECT
>  # echo $?
>  # if [ cat /debug/provoke-crash/atomic -eq INT_MAX ]; then
>  # echo PASS ; fi
>
> Thanks,
> -Takahiro AKASHI
>
>>
>> -Kees
>>
>> --
>> Kees Cook
>> Nexus Security
> ===8<===
> From c516b50b4764c5c1ba0dd39e3a5022d026e35514 Mon Sep 17 00:00:00 2001
> From: AKASHI Takahiro <takahiro.akashi@linaro.org>
> Date: Fri, 28 Oct 2016 10:55:50 +0900
> Subject: [PATCH] lkdtm: expose atomic variables via debugfs
>
> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
> ---
>  drivers/misc/lkdtm.h      |  2 ++
>  drivers/misc/lkdtm_bugs.c | 75 +++++++++++++++++++++++++++++++++++++----------
>  drivers/misc/lkdtm_core.c |  3 ++
>  3 files changed, 64 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/misc/lkdtm.h b/drivers/misc/lkdtm.h
> index 0ef66ff..b4dd231 100644
> --- a/drivers/misc/lkdtm.h
> +++ b/drivers/misc/lkdtm.h
> @@ -3,10 +3,12 @@
>
>  #define pr_fmt(fmt) "lkdtm: " fmt
>
> +#include <linux/fs.h>
>  #include <linux/kernel.h>
>
>  /* lkdtm_bugs.c */
>  void __init lkdtm_bugs_init(int *recur_param);
> +void __init lkdtm_bugs_init2(struct dentry *parent);
>  void lkdtm_PANIC(void);
>  void lkdtm_BUG(void);
>  void lkdtm_WARNING(void);
> diff --git a/drivers/misc/lkdtm_bugs.c b/drivers/misc/lkdtm_bugs.c
> index 7b4067b..dd5003f 100644
> --- a/drivers/misc/lkdtm_bugs.c
> +++ b/drivers/misc/lkdtm_bugs.c
> @@ -5,6 +5,8 @@
>   * test source files.
>   */
>  #include "lkdtm.h"
> +#include <linux/debugfs.h>
> +#include <linux/fs.h>
>  #include <linux/sched.h>
>
>  /*
> @@ -35,6 +37,33 @@ static int recursive_loop(int remaining)
>                 return recursive_loop(remaining - 1);
>  }
>
> +/* from fs/debugfs/file.c */
> +static int debugfs_atomic_long_t_set(void *data, u64 val)
> +{
> +       atomic_long_set((atomic_long_t *)data, val);
> +       return 0;
> +}

Ah yes! Thanks; I had been pondering how to correctly validate that
the values were correct after the protection triggered. Thanks!

I'll get a version of this into my hyper-macro-ized version of the
lkdtm patch and get it sent to Hans. :)

-Kees

-- 
Kees Cook
Nexus Security
