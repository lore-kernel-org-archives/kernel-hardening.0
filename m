MIME-Version: 1.0
In-Reply-To: <20171130012324.GZ729@wotan.suse.de>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
 <1511803118-2552-4-git-send-email-tixxdz@gmail.com> <20171130012324.GZ729@wotan.suse.de>
From: Djalal Harouni <tixxdz@gmail.com>
Date: Thu, 30 Nov 2017 13:22:05 +0100
Message-ID: <CAEiveUeK7UtxDdE52LOTH0cYKDOwb1hDORhSV_AWttU9VV3PfA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v5 next 3/5] modules:capabilities: automatic module
 loading restriction
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, James Morris <james.l.morris@oracle.com>, Ben Hutchings <ben.hutchings@codethink.co.uk>, Solar Designer <solar@openwall.com>, Serge Hallyn <serge@hallyn.com>, Jessica Yu <jeyu@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, linux-kernel <linux-kernel@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, kernel-hardening@lists.openwall.com, Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>, "David S. Miller" <davem@davemloft.net>, Network Development <netdev@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 30, 2017 at 2:23 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Mon, Nov 27, 2017 at 06:18:36PM +0100, Djalal Harouni wrote:
>> diff --git a/include/linux/module.h b/include/linux/module.h
>> index 5cbb239..c36aed8 100644
>> --- a/include/linux/module.h
>> +++ b/include/linux/module.h
>> @@ -261,7 +261,16 @@ struct notifier_block;
>>
>>  #ifdef CONFIG_MODULES
>>
>> -extern int modules_disabled; /* for sysctl */
>> +enum {
>> +     MODULES_AUTOLOAD_ALLOWED        = 0,
>> +     MODULES_AUTOLOAD_PRIVILEGED     = 1,
>> +     MODULES_AUTOLOAD_DISABLED       = 2,
>> +};
>> +
>
> Can you kdocify these and add a respective rst doc file?  Maybe stuff your
> extensive docs which you are currently adding to
> Documentation/sysctl/kernel.txt to this new file and in kernel.txt just refer
> to it. This way this can be also nicely visibly documented on the web with the
> new sphinx.
>
> This way you can take advantage of the kdocs you are already adding and refer
> to them.

Alright I'll do it in the next series next week, we'll change the
semantics as requested by Linus and Kees here:
http://www.openwall.com/lists/kernel-hardening/2017/11/29/38

To block the privilege escalation through the usermod helper.


>> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
>> index 2fb4e27..0b6f0c8 100644
>> --- a/kernel/sysctl.c
>> +++ b/kernel/sysctl.c
>> @@ -683,6 +688,15 @@ static struct ctl_table kern_table[] = {
>>               .extra1         = &one,
>>               .extra2         = &one,
>>       },
>> +     {
>> +             .procname       = "modules_autoload_mode",
>> +             .data           = &modules_autoload_mode,
>> +             .maxlen         = sizeof(int),
>> +             .mode           = 0644,
>> +             .proc_handler   = modules_autoload_dointvec_minmax,
>
> It would seem this is a unint ... so why not reflect that?
>
>> @@ -2499,6 +2513,20 @@ static int proc_dointvec_minmax_sysadmin(struct ctl_table *table, int write,
>>  }
>>  #endif
>>
>> +#ifdef CONFIG_MODULES
>> +static int modules_autoload_dointvec_minmax(struct ctl_table *table, int write,
>> +                             void __user *buffer, size_t *lenp, loff_t *ppos)
>> +{
>> +     /*
>> +      * Only CAP_SYS_MODULE in init user namespace are allowed to change this
>> +      */
>> +     if (write && !capable(CAP_SYS_MODULE))
>> +             return -EPERM;
>> +
>> +     return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
>> +}
>> +#endif
>
> We now have proc_douintvec_minmax().
>

Yes, however in that same response by Linus it was suggested to drop
the sysctl completely, so next iterations will not have this code.

Thank you for the review!

-- 
tixxdz
