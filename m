Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <2593753.nIyjnHh0BF@vostro.rjw.lan>
References: <2206547.eDj3RJQyE5@vostro.rjw.lan> <CAJZ5v0hVNh7oA+1MvDbx-GY+nd82Whb4=7AT+e=LicOxs0qzkg@mail.gmail.com>
 <CAJcbSZGWY1Hde3o36pLQrZLsdYNSZCcL1zprw7eMQEAA+CLWgQ@mail.gmail.com> <2593753.nIyjnHh0BF@vostro.rjw.lan>
From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 11 Aug 2016 14:32:44 -0700
Message-ID: <CAJcbSZEzUNoME3ND2UYhKOak+GJt2RQ_Wmh=h8c4q5WHs4dyjQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [Resend][PATCH] x86/power/64: Always create temporary identity
 mapping correctly
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Jiri Kosina <jikos@kernel.org>, Borislav Petkov <bp@suse.de>, Linux PM list <linux-pm@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Pavel Machek <pavel@ucw.cz>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Aug 11, 2016 at 2:33 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Thursday, August 11, 2016 11:47:27 AM Thomas Garnier wrote:
>> On Wed, Aug 10, 2016 at 6:35 PM, Rafael J. Wysocki <rafael@kernel.org> wrote:
>> > On Thu, Aug 11, 2016 at 3:17 AM, Thomas Garnier <thgarnie@google.com> wrote:
>> >> On Wed, Aug 10, 2016 at 5:35 PM, Rafael J. Wysocki <rafael@kernel.org> wrote:
>> >>> On Wed, Aug 10, 2016 at 11:59 PM, Jiri Kosina <jikos@kernel.org> wrote:
>> >>>> On Wed, 10 Aug 2016, Rafael J. Wysocki wrote:
>> >>>>
>> >>>>> So I used your .config to generate one for my test machine and with
>> >>>>> that I can reproduce.
>> >>>>
>> >>>> Was that the config I've sent, or did Boris provide one as well? Which one
>> >>>> are you able to reproduce with please?
>> >>>
>> >>> It's the Boris' one.
>> >>>
>> >>> Moreover, I have found the options that make the difference: unsetting
>> >>> CONFIG_PROVE_LOCKING and CONFIG_DEBUG_LOCK_ALLOC (which also will
>> >>> unset CONFIG_LOCKDEP AFAICS) in it makes hibernation work again with
>> >>> CONFIG_RANDOMIZE_MEMORY set and with the $subject patch applied.
>> >>>
>> >>> Unbelievable, but that's what I'm seeing.
>> >>
>> >> Nice find!
>> >>
>> >>>
>> >>> Now, that leads to a few questions:
>> >>>
>> >>> - How does lockdep change the picture so it matters for hibernation?
>> >>> - Why is hibernation the only piece that's affected?
>> >>> - Why is RANDOMIZE_MEMORY necessary to make this breakage show up?
>> >>>
>> >>> Thomas, any ideas?
>> >>
>> >> No idea so far. I will investigate though.
>> >>
>> >> We had an unrelated issue with CONFIG_DEBUG_PAGEALLOC on early boot. I
>> >> don't think it was related because it was on early boot and with
>> >> certain e820 memory layout (and PUD randomization that I disabled on
>> >> the previous patch test). The fix is on tip:
>> >> http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=fb754f958f8e46202c1efd7f66d5b3db1208117d
>> >
>> > Well, I don't think this is related.
>> >
>> > In the meantime, I went back to my original .config and verified that
>> > setting CONFIG_DEBUG_LOCK_ALLOC in it caused hibernation to fail (with
>> > CONFIG_RANDOMIZE_MEMORY set and with the $subject patch applied), so
>> > this really matters somehow.
>> >
>> > Besides, now that I have a reproducer, I can check various other
>> > things and for example this change (sorry for broken whitespace):
>> >
>> > Index: linux-pm/arch/x86/mm/kaslr.c
>> > ===================================================================
>> > --- linux-pm.orig/arch/x86/mm/kaslr.c
>> > +++ linux-pm/arch/x86/mm/kaslr.c
>> > @@ -122,7 +122,7 @@ void __init kernel_randomize_memory(void
>> >          prandom_bytes_state(&rand_state, &rand, sizeof(rand));
>> >          entropy = (rand % (entropy + 1)) & PUD_MASK;
>> >          vaddr += entropy;
>> > -        *kaslr_regions[i].base = vaddr;
>> > +        *kaslr_regions[i].base += PUD_SIZE;
>> >
>>
>> I think it works because the address is fixed now (just PUD aligned).
>
> That's exactly right.
>
>> >          /*
>> >           * Jump the region and add a minimum padding based on
>> >
>> > makes hibernation work for me again in the above configuration.  To
>> > me, this means that the $subject patch works as expected and the
>> > problem really is related to the vaddr value being too big.
>> >
>>
>> I managed to debug the restoration and found that a first access
>> violation happens here:
>
> So you were able to get a bit farther than I did. :-)
>
>> (gdb) x/20i 0xffffffffb20a46de
>>    0xffffffffb20a46de <trace_suspend_resume+14>:
>>     mov    eax,DWORD PTR gs:[rip+0x4df65a4b]        # 0xa130 <cpu_number>
>>
>> Handled by do_async_page_fault which will fault as well on this instruction:
>>
>> => 0xffffffffb2047ca1 <do_async_page_fault+1>:
>>     mov    eax,DWORD PTR gs:[rip+0x4dfc4e58]        # 0xcb00 <apf_reason+64>
>>
>> So there is a problem with the gs register not being restored
>> correctly at this stage.
>>
>> In create_image, there is tracing (trace_suspend_resume) before and
>> after the suspend. Except at this stage, gs was not yet restored. It
>> uses the old gs leading to the double fault.
>
> Nice catch!

Thanks, got lucky.

>
> I established that the problem happened when there was a difference between
> the page_offset_base values in the restore and image kernels, so my conclusion
> was that the code leaked some information related to virtual addresses from
> the restore kernel back to the mage one.  Which is exactly what you found. :-)
>
>> I tested this fix to be correct:
>>
>> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
>> index a881c6a..33c79b6 100644
>> --- a/kernel/power/hibernate.c
>> +++ b/kernel/power/hibernate.c
>> @@ -300,12 +300,12 @@ static int create_image(int platform_mode)
>>   save_processor_state();
>>   trace_suspend_resume(TPS("machine_suspend"), PM_EVENT_HIBERNATE, true);
>>   error = swsusp_arch_suspend();
>> + /* Restore control flow magically appears here */
>> + restore_processor_state();
>>   trace_suspend_resume(TPS("machine_suspend"), PM_EVENT_HIBERNATE, false);
>>   if (error)
>>   printk(KERN_ERR "PM: Error %d creating hibernation image\n",
>>   error);
>> - /* Restore control flow magically appears here */
>> - restore_processor_state();
>>   if (!in_suspend)
>>   events_check_enabled = false;
>>
>> Let me know if it works for you. Note that I don't know why this issue
>> popup with the different config.
>
> Yes, works like charm here (on top of 4.8-rc1 plus the $subject patch).
>
> Please resend with a changelog and sign-off (BTW, your email client
> damages whitespace in patches, any chance to avoid that?).

Will do.

I will see how I can fix the whitespace thing, that's odd. Thanks for
the heads-up.

>
> Thanks,
> Rafael
>
