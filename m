Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: rjwysocki@gmail.com
In-Reply-To: <alpine.LNX.2.00.1608102351140.22028@cbobk.fhfr.pm>
References: <2206547.eDj3RJQyE5@vostro.rjw.lan> <2010434.TyoHiO9eal@vostro.rjw.lan>
 <alpine.LNX.2.00.1608100948560.22028@cbobk.fhfr.pm> <1779906.DOHeuFCiDy@vostro.rjw.lan>
 <alpine.LNX.2.00.1608101517380.22028@cbobk.fhfr.pm> <CAJcbSZHGH8G01zXSE6y9A19ZxFYY0bzeqcfHBEAYZcn8ZeX3+g@mail.gmail.com>
 <alpine.LNX.2.00.1608101658070.22028@cbobk.fhfr.pm> <20160810163500.GA9424@nazgul.tnic>
 <CAJcbSZF6k0=NXvqMGedcSPiMLwGBG3tZGBwCMJWgMm2AXDY9hQ@mail.gmail.com> <alpine.LNX.2.00.1608102351140.22028@cbobk.fhfr.pm>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 10 Aug 2016 23:58:29 +0200
Message-ID: <CAJZ5v0iEEb2ZqsLjvvm0XoGaBiZ5MBD+PRGNqD-_MtkOqdGKeg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [Resend][PATCH] x86/power/64: Always create temporary identity
 mapping correctly
To: Jiri Kosina <jikos@kernel.org>
Cc: Thomas Garnier <thgarnie@google.com>, Borislav Petkov <bp@suse.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Rafael J. Wysocki" <rafael@kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Pavel Machek <pavel@ucw.cz>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 10, 2016 at 11:52 PM, Jiri Kosina <jikos@kernel.org> wrote:
> On Wed, 10 Aug 2016, Thomas Garnier wrote:
>
>> Ok, I want to know if the problem is the PUD alignment or the change
>> of PAGE_OFFSET based all together. Can you test the following change?
>> (on top of everything else with KASLR enabled). It will randomize the
>> memory sections only on PGD level.
>>
>> diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
>> index ec8654f..a8477b0 100644
>> --- a/arch/x86/mm/kaslr.c
>> +++ b/arch/x86/mm/kaslr.c
>> @@ -120,7 +120,7 @@ void __init kernel_randomize_memory(void)
>>                  */
>>                 entropy = remain_entropy / (ARRAY_SIZE(kaslr_regions) - i);
>>                 prandom_bytes_state(&rand_state, &rand, sizeof(rand));
>> -               entropy = (rand % (entropy + 1)) & PUD_MASK;
>> +               entropy = (rand % (entropy + 1)) & PGDIR_MASK;
>>                 vaddr += entropy;
>>                 *kaslr_regions[i].base = vaddr;
>>
>> @@ -129,7 +129,7 @@ void __init kernel_randomize_memory(void)
>>                  * randomization alignment.
>>                  */
>>                 vaddr += get_padding(&kaslr_regions[i]);
>> -               vaddr = round_up(vaddr + 1, PUD_SIZE);
>> +               vaddr = round_up(vaddr + 1, PGDIR_SIZE);
>>                 remain_entropy -= entropy;
>>         }
>>  }
>
> I applied this on top of both fixes from Rafael from this thread; still no
> change in behavior, i.e. reboot immediately after reading the hibernation
> image.

Same for me on the box where I can reproduce the problem now.
