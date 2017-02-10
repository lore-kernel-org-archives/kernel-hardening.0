MIME-Version: 1.0
In-Reply-To: <CAGXu5jKnf7NebFQp-w9gka9nR2V4Jc3aSfNK2yvvrYa=UUEh-g@mail.gmail.com>
References: <20170210100902.11765-1-me@jessfraz.com> <20170210100902.11765-2-me@jessfraz.com>
 <CAGXu5jKnf7NebFQp-w9gka9nR2V4Jc3aSfNK2yvvrYa=UUEh-g@mail.gmail.com>
From: Jessica Frazelle <me@jessfraz.com>
Date: Fri, 10 Feb 2017 14:02:01 -0800
Message-ID: <CAEk6tEw5VbSzzfQDZ_TO4piGGfKa5M4uza8m3x=tm4N1v2seiw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH 1/4] irq: set {msi_domain,syscore}_ops
 as __ro_after_init
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 10, 2017 at 1:55 PM, Kees Cook <keescook@chromium.org> wrote:
> On Fri, Feb 10, 2017 at 2:08 AM, Jess Frazelle <me@jessfraz.com> wrote:
>> Marked msi_domain_ops structs as __ro_after_init when called only during init.
>> Marked syscore_ops structs as __ro_after_init when register_syscore_ops was
>> called only during init. Most of the caller functions were already annotated as
>> __init.
>> This protects the data structure from accidental corruption.
>>
>> Suggested-by: Kees Cook <keescook@chromium.org>
>> Signed-off-by: Jess Frazelle <me@jessfraz.com>
>> ---
>>  drivers/staging/fsl-mc/bus/irq-gic-v3-its-fsl-mc-msi.c | 2 +-
>>  kernel/irq/generic-chip.c                              | 2 +-
>>  kernel/irq/msi.c                                       | 2 +-
>>  kernel/irq/pm.c                                        | 2 +-
>>  4 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/staging/fsl-mc/bus/irq-gic-v3-its-fsl-mc-msi.c b/drivers/staging/fsl-mc/bus/irq-gic-v3-its-fsl-mc-msi.c
>> index 6b1cd574644f..0e2c1b5e13b7 100644
>> --- a/drivers/staging/fsl-mc/bus/irq-gic-v3-its-fsl-mc-msi.c
>> +++ b/drivers/staging/fsl-mc/bus/irq-gic-v3-its-fsl-mc-msi.c
>> @@ -51,7 +51,7 @@ static int its_fsl_mc_msi_prepare(struct irq_domain *msi_domain,
>>         return msi_info->ops->msi_prepare(msi_domain->parent, dev, nvec, info);
>>  }
>>
>> -static struct msi_domain_ops its_fsl_mc_msi_ops = {
>> +static struct msi_domain_ops its_fsl_mc_msi_ops __ro_after_init = {
>>         .msi_prepare = its_fsl_mc_msi_prepare,
>>  };
>>
>> diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
>> index ee32870079c9..cca63dbaabea 100644
>> --- a/kernel/irq/generic-chip.c
>> +++ b/kernel/irq/generic-chip.c
>> @@ -623,7 +623,7 @@ static void irq_gc_shutdown(void)
>>         }
>>  }
>>
>> -static struct syscore_ops irq_gc_syscore_ops = {
>> +static struct syscore_ops irq_gc_syscore_ops __ro_after_init = {
>>         .suspend = irq_gc_suspend,
>>         .resume = irq_gc_resume,
>>         .shutdown = irq_gc_shutdown,
>> diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
>> index ee230063f033..0e5b723f710f 100644
>> --- a/kernel/irq/msi.c
>> +++ b/kernel/irq/msi.c
>> @@ -217,7 +217,7 @@ static int msi_domain_ops_check(struct irq_domain *domain,
>>         return 0;
>>  }
>>
>> -static struct msi_domain_ops msi_domain_ops_default = {
>> +static struct msi_domain_ops msi_domain_ops_default __ro_after_init = {
>>         .get_hwirq      = msi_domain_ops_get_hwirq,
>>         .msi_init       = msi_domain_ops_init,
>>         .msi_check      = msi_domain_ops_check,
>> diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
>> index cea1de0161f1..d6b889bed323 100644
>> --- a/kernel/irq/pm.c
>> +++ b/kernel/irq/pm.c
>> @@ -185,7 +185,7 @@ static void irq_pm_syscore_resume(void)
>>         resume_irqs(true);
>>  }
>>
>> -static struct syscore_ops irq_pm_syscore_ops = {
>> +static struct syscore_ops irq_pm_syscore_ops __ro_after_init = {
>>         .resume         = irq_pm_syscore_resume,
>>  };
>
> Cool! How'd you end up choosing these? Did you just go looking for
> one-sided initializations? (i.e. register_syscore_ops() without
> unregister_syscore_ops() call?)

I first made the mistake of making them all __ro_after_init and I
broke the kvm module, so I had to track down how that happened since I
didn't touch that code path... I ended up digging a bit into the call
stack that ultimately leads to these and this is my initial "safe
set". I am still digging into the others. But almost all the functions
that call `syscore_ops` structs were already marked as __init.

>
> (It may help the commit message to explicitly state that
> unregister_syscore_ops() is never called on these ops.)

Will fix!

>
> -Kees
>
> --
> Kees Cook
> Pixel Security



-- 


Jessie Frazelle
4096R / D4C4 DD60 0D66 F65A 8EFC  511E 18F3 685C 0022 BFF3
pgp.mit.edu
