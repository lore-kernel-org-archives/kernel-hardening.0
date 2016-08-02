Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160802095546.GE6862@twins.programming.kicks-ass.net>
References: <1469630783-32413-1-git-send-email-jeffv@google.com> <20160802095546.GE6862@twins.programming.kicks-ass.net>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 2 Aug 2016 08:19:38 -0700
Message-ID: <CAGXu5jL3fLwEQBLa1iWQPJaKaujiCYY1p7n8AOsdnedFrcpxvw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH 2/2] security, perf: Add config
 option to restrict perf_event_open
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Jeff Vander Stoep <jeffv@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 2, 2016 at 2:55 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Jul 27, 2016 at 07:46:23AM -0700, Jeff Vander Stoep wrote:
>> +++ b/kernel/events/core.c
>> @@ -355,7 +355,11 @@ static struct srcu_struct pmus_srcu;
>>   *   2 - disallow kernel profiling for unpriv
>>   *   3 - disallow all unpriv perf event use
>>   */
>> +#ifdef CONFIG_SECURITY_PERF_EVENTS_RESTRICT
>> +int sysctl_perf_event_paranoid __read_mostly = 3;
>> +#else
>>  int sysctl_perf_event_paranoid __read_mostly = 2;
>> +#endif
>>
>>  /* Minimum for 512 kiB + 1 user control page */
>>  int sysctl_perf_event_mlock __read_mostly = 512 + (PAGE_SIZE / 1024); /* 'free' kiB per user */
>> diff --git a/security/Kconfig b/security/Kconfig
>> index df28f2b..2a93551 100644
>> --- a/security/Kconfig
>> +++ b/security/Kconfig
>> @@ -18,6 +18,15 @@ config SECURITY_DMESG_RESTRICT
>>
>>         If you are unsure how to answer this question, answer N.
>>
>> +config SECURITY_PERF_EVENTS_RESTRICT
>> +     bool "Restrict unprivileged use of performance events"
>> +     depends on PERF_EVENTS
>> +     help
>> +       If you say Y here, the kernel.perf_event_paranoid sysctl
>> +       will be set to 3 by default, and no unprivileged use of the
>> +       perf_event_open syscall will be permitted unless it is
>> +       changed.
>
> NAK.
>
> Apart from the fact that I hate the 3 thing this is not how you do
> default CONFIG knobs for !bool state variables.
>
> Use an "int" config not a "bool" config and allow all options to be
> default.

How about leaving off 2/2 and just keeping 1/2 of this series?

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
