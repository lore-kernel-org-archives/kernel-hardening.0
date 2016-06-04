Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLT+GR8DEOYLaY4KgZJP=9HEX+w+=mz5fomAMTBr_2Zow@mail.gmail.com>
References: <20160111151958.GQ28542@decadent.org.uk> <20160111152355.GS28542@decadent.org.uk>
 <CAGXu5jLT+GR8DEOYLaY4KgZJP=9HEX+w+=mz5fomAMTBr_2Zow@mail.gmail.com>
From: Jeffrey Vander Stoep <jeffv@google.com>
Date: Sat, 4 Jun 2016 13:56:54 -0700
Message-ID: <CABXk95AO_nxb+xFqJuU8r3mzx+oVJrRcJcYBF3xM=c7krCapwQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH 2/2] security,perf: Allow further
 restriction of perf_event_open
To: kernel-hardening@lists.openwall.com
Cc: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Acked-by: Jeff Vander Stoep <jeffv@google.com>

In addition to Debian, this patch has been merged into AOSP and is a
requirement for Android:
https://android-review.googlesource.com/#/q/topic:CONFIG_SECURITY_PERF_EVENTS_RESTRICT

On Wed, Apr 13, 2016 at 9:12 AM, Kees Cook <keescook@chromium.org> wrote:
> On Mon, Jan 11, 2016 at 7:23 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
>> When kernel.perf_event_open is set to 3 (or greater), disallow all
>> access to performance events by users without CAP_SYS_ADMIN.
>> Add a Kconfig symbol CONFIG_SECURITY_PERF_EVENTS_RESTRICT that
>> makes this value the default.
>>
>> This is based on a similar feature in grsecurity
>> (CONFIG_GRKERNSEC_PERF_HARDEN).  This version doesn't include making
>> the variable read-only.  It also allows enabling further restriction
>> at run-time regardless of whether the default is changed.
>>
>> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
>
> Whoops, I entirely missed this email! Just found it now.
>
> Ben, can you resend this with Perf maintainers in CC? This seems
> sensible enough to me.
>
> -Kees
>
>> ---
>> I made a similar change to Debian's kernel packages in August,
>> including the more restrictive default, and no-one has complained yet.
>>
>> Ben.
>>
>>  Documentation/sysctl/kernel.txt | 4 +++-
>>  include/linux/perf_event.h      | 5 +++++
>>  kernel/events/core.c            | 8 ++++++++
>>  security/Kconfig                | 9 +++++++++
>>  4 files changed, 25 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
>> index 88a2c8e..76e2ca8 100644
>> --- a/Documentation/sysctl/kernel.txt
>> +++ b/Documentation/sysctl/kernel.txt
>> @@ -629,12 +629,14 @@ allowed to execute.
>>  perf_event_paranoid:
>>
>>  Controls use of the performance events system by unprivileged
>> -users (without CAP_SYS_ADMIN).  The default value is 1.
>> +users (without CAP_SYS_ADMIN).  The default value is 3 if
>> +CONFIG_SECURITY_PERF_EVENTS_RESTRICT is set, or 1 otherwise.
>>
>>   -1: Allow use of (almost) all events by all users
>>  >=0: Disallow raw tracepoint access by users without CAP_IOC_LOCK
>>  >=1: Disallow CPU event access by users without CAP_SYS_ADMIN
>>  >=2: Disallow kernel profiling by users without CAP_SYS_ADMIN
>> +>=3: Disallow all event access by users without CAP_SYS_ADMIN
>>
>>  ==============================================================
>>
>> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
>> index f9828a4..aa72940 100644
>> --- a/include/linux/perf_event.h
>> +++ b/include/linux/perf_event.h
>> @@ -989,6 +989,11 @@ extern int perf_cpu_time_max_percent_handler(struct ctl_table *table, int write,
>>                 loff_t *ppos);
>>
>>
>> +static inline bool perf_paranoid_any(void)
>> +{
>> +       return sysctl_perf_event_paranoid > 2;
>> +}
>> +
>>  static inline bool perf_paranoid_tracepoint_raw(void)
>>  {
>>         return sysctl_perf_event_paranoid > -1;
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index cfc227c..85bc810 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -175,8 +175,13 @@ static struct srcu_struct pmus_srcu;
>>   *   0 - disallow raw tracepoint access for unpriv
>>   *   1 - disallow cpu events for unpriv
>>   *   2 - disallow kernel profiling for unpriv
>> + *   3 - disallow all unpriv perf event use
>>   */
>> +#ifdef CONFIG_SECURITY_PERF_EVENTS_RESTRICT
>> +int sysctl_perf_event_paranoid __read_mostly = 3;
>> +#else
>>  int sysctl_perf_event_paranoid __read_mostly = 1;
>> +#endif
>>
>>  /* Minimum for 512 kiB + 1 user control page */
>>  int sysctl_perf_event_mlock __read_mostly = 512 + (PAGE_SIZE / 1024); /* 'free' kiB per user */
>> @@ -8265,6 +8270,9 @@ SYSCALL_DEFINE5(perf_event_open,
>>         if (flags & ~PERF_FLAG_ALL)
>>                 return -EINVAL;
>>
>> +       if (perf_paranoid_any() && !capable(CAP_SYS_ADMIN))
>> +               return -EACCES;
>> +
>>         err = perf_copy_attr(attr_uptr, &attr);
>>         if (err)
>>                 return err;
>> diff --git a/security/Kconfig b/security/Kconfig
>> index e452378..30a2603 100644
>> --- a/security/Kconfig
>> +++ b/security/Kconfig
>> @@ -18,6 +18,15 @@ config SECURITY_DMESG_RESTRICT
>>
>>           If you are unsure how to answer this question, answer N.
>>
>> +config SECURITY_PERF_EVENTS_RESTRICT
>> +       bool "Restrict unprivileged use of performance events"
>> +       depends on PERF_EVENTS
>> +       help
>> +         If you say Y here, the kernel.perf_event_paranoid sysctl
>> +         will be set to 3 by default, and no unprivileged use of the
>> +         perf_event_open syscall will be permitted unless it is
>> +         changed.
>> +
>>  config SECURITY
>>         bool "Enable different security models"
>>         depends on SYSFS
>
>
>
> --
> Kees Cook
> Chrome OS & Brillo Security
