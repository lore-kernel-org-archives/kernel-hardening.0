Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161027093334.GK3102@twins.programming.kicks-ass.net>
References: <20161026204748.GA11177@amd> <20161027082801.GE3568@worktop.programming.kicks-ass.net>
 <20161027091104.GB19469@amd> <20161027093334.GK3102@twins.programming.kicks-ass.net>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 27 Oct 2016 13:40:55 -0700
Message-ID: <CAGXu5jL=xzyPRQgOp5ON2+X0=5z4-jg4NyFCrTSrRPm5puOm0Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: Getting interrupt every million cache misses
To: Peter Zijlstra <peterz@infradead.org>
Cc: Pavel Machek <pavel@ucw.cz>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 27, 2016 at 2:33 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Oct 27, 2016 at 11:11:04AM +0200, Pavel Machek wrote:
>> How to work around rowhammer, break my system _and_ make kernel perf
>> maintainers scream at the same time: (:-) )
>>
>> I think I got the place now. Let me try...
>
> Lol ;-)
>
>>
>> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
>> index d31735f..ce83f5e 100644
>> --- a/arch/x86/events/core.c
>> +++ b/arch/x86/events/core.c
>> @@ -1495,6 +1495,11 @@ perf_event_nmi_handler(unsigned int cmd, struct pt_regs *regs)
>>
>>       perf_sample_event_took(finish_clock - start_clock);
>>
>> +     /* Here */
>> +     {
>> +             udelay(58000);
>> +     }
>> +
>>       return ret;
>>  }
>>  NOKPROBE_SYMBOL(perf_event_nmi_handler);
>
> Like you guess, not quite ;-)
>
>
> I think you want to register a custom overflow handler with your event.
>
> So you get something like:
>
>
> struct perf_event_attr rh_attr = {
>         .type   = PERF_TYPE_HARDWARE,
>         .config = PERF_COUNT_HW_CACHE_MISSES,
>         .size   = sizeof(struct perf_event_attr),
>         .pinned = 1,
>         .sample_period = 1000000,
> };
>
> static DEFINE_PER_CPU(struct perf_event *, rh_event);
> static DEFINE_PER_CPU(u64, rh_timestamp);
>
> static void rh_overflow(struct perf_event *event, struct perf_sample_data *data, struct pt_regs *regs)
> {
>         u64 *ts = this_cpu_ptr(&rh_timestamp); /* this is NMI context */
>         u64 now = ktime_get_mono_fast_ns();
>         s64 delta = now - *ts;
>
>         *ts = now;
>
>         if (delta > 64 * NSEC_PER_USEC)
>                 udelay(58000);
> }
>
> __init int my_module_init()
> {
>         int cpu;
>
>         /* XXX borken vs hotplug */
>
>         for_each_online_cpu(cpu) {
>                 struct perf_event *event = per_cpu(event, cpu);
>
>                 event = perf_event_create_kernel_counter(&rh_attr, cpu, NULL, rh_overflow, NULL);
>                 if (!event)
>                         /* meh */
>                         ;
>
>         }
> }
>
> __exit void my_module_exit()
> {
>         int cpu;
>
>         for_each_online_cpu(cpu) {
>                 struct perf_event *event = per_cpu(event, cpu);
>
>                 if (event)
>                         perf_event_release_kernel(event);
>         }
> }

This is pretty cool. Are there workloads other than rowhammer that
could trip this, and if so, how bad would this delay be for them?

At the very least, this could be behind a CONFIG for people that don't
have a way to fix their RAM refresh timings, etc.

-Kees

-- 
Kees Cook
Nexus Security
