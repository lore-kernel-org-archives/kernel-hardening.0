Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: rjwysocki@gmail.com
In-Reply-To: <CAJcbSZExj2bGY5iN-2B8zOAYqhRZA-Gzbmc8NZzJzMsZ7LorLA@mail.gmail.com>
References: <2206547.eDj3RJQyE5@vostro.rjw.lan> <alpine.LRH.2.00.1608091121120.19185@gjva.wvxbf.pm>
 <CAJZ5v0iAiQwpBgY=4hH-RsBB54tD8FY4C8pWbjNNRmAjJ9Xg+Q@mail.gmail.com>
 <alpine.LNX.2.00.1608091457370.22028@cbobk.fhfr.pm> <alpine.LNX.2.00.1608091525540.22028@cbobk.fhfr.pm>
 <CAJcbSZHdTJC8ys-rhi19k+gmxe+U3m_e+i4aRTuuyV18r6ukCA@mail.gmail.com>
 <alpine.LNX.2.00.1608091702240.22028@cbobk.fhfr.pm> <CAJZ5v0hciyV01GMxBV6fQmdXRrZYbkDb9_JUoLPh1+EwG0oRow@mail.gmail.com>
 <CAJcbSZExj2bGY5iN-2B8zOAYqhRZA-Gzbmc8NZzJzMsZ7LorLA@mail.gmail.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Tue, 9 Aug 2016 22:50:18 +0200
Message-ID: <CAJZ5v0jSuNLkB6UQjF5zotY=Vuq_xtAi+29EVUZR2VxL8CCrRQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [Resend][PATCH] x86/power/64: Always create temporary identity
 mapping correctly
To: Thomas Garnier <thgarnie@google.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Jiri Kosina <jikos@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux PM list <linux-pm@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Pavel Machek <pavel@ucw.cz>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bpetkov@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 9, 2016 at 6:27 PM, Thomas Garnier <thgarnie@google.com> wrote:
> On Tue, Aug 9, 2016 at 9:18 AM, Rafael J. Wysocki <rafael@kernel.org> wrote:
>> On Tue, Aug 9, 2016 at 5:05 PM, Jiri Kosina <jikos@kernel.org> wrote:
>>> On Tue, 9 Aug 2016, Thomas Garnier wrote:
>>>
>>>> >> Okay, I did one-by-one reverts, and the one above, i.e.
>>>> >>
>>>> >>       commit 021182e52fe01c1f7b126f97fd6ba048dc4234fd
>>>> >>       Author: Thomas Garnier <thgarnie@google.com>
>>>> >>       Date:   Tue Jun 21 17:47:03 2016 -0700
>>>> >>
>>>> >>           x86/mm: Enable KASLR for physical mapping memory regions
>>>> >>
>>>> >> is the one that is the culprit on my machine. With this one reverted,
>>>> >> resume hibernation doesn't reboot (tripple fault?), but proceeds
>>>> >> succesfully.
>>>>
>>>> My .config is attached. It is basically defconfig (x86_64) + kvmconfig
>>>> plus the following:
>>>>
>>>> CONFIG_PHYSICAL_START=0x1000000
>>>> CONFIG_RELOCATABLE=y
>>>> CONFIG_RANDOMIZE_BASE=y
>>>> CONFIG_X86_NEED_RELOCS=y
>>>> CONFIG_PHYSICAL_ALIGN=0x1000000
>>>> CONFIG_RANDOMIZE_MEMORY=y
>>>> CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING=0xa
>>>> CONFIG_X86_PTDUMP_CORE=y
>>>> CONFIG_X86_PTDUMP=y
>>>> CONFIG_KALLSYMS=y
>>>> CONFIG_KALLSYMS_ALL=y
>>>> CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
>>>> CONFIG_KALLSYMS_BASE_RELATIVE=y
>>>> CONFIG_PANIC_ON_OOPS=y
>>>> CONFIG_KGDB=y
>>>> CONFIG_EARLY_PRINTK=y
>>>> CONFIG_EARLY_PRINTK_DBGP=y
>>>> CONFIG_DEBUG_INFO=y
>>>> CONFIG_DEBUG_INFO_DWARF4=y
>>>
>>> The config I am reproducing the bug with (on thinkpad x200s) can be found
>>> at
>>>
>>>         http://www.jikos.cz/jikos/junk/.config
>>>
>>> Either later today or tomorrow I could test with the same physical start
>>> and align values you're using to see whether that'd make any difference.
>>>
>>>> > As discussed with Rafael privately, I also tried this very patch
>>>> > (x86/power/64: Always create temporary identity mapping correctly) on top
>>>> > of the reverted revert of 021182e52fe01c1f7b1 (see the full log below),
>>>> > but such kernel triple faults on resume as well.
>>>> >
>>>> > 87c38d2 x86/power/64: Always create temporary identity mapping correctly
>>>> > 3cb504a Revert "Revert "x86/mm: Enable KASLR for physical mapping memory regions""
>>>> > 758850d Revert "x86/mm: Enable KASLR for physical mapping memory regions"
>>>> > 4a02dfb Revert "x86/mm: Enable KASLR for vmalloc memory regions"
>>>> > 037863f Revert "x86/mm: Add memory hotplug support for KASLR memory randomization"
>>>> > 3416a21 Revert "x86/mm: Do not reference phys addr beyond kernel"
>>>> > 69227be Revert "mm: reorganize SLAB freelist randomization"
>>>> > a1d8d71 Revert "mm: SLUB freelist randomization"
>>>> >
>>>> > IOW, 021182e52f introduces a bug for which there is no existing fix yet.
>>>>
>>>> You mean it is something different from the previous KASLR bugs we saw?
>>>
>>> No, I just wanted to explicitly point out that "x86/power/64: Always
>>> create temporary identity mapping correctly" is not a fix for this issue.
>>
>> It is better to say that the $subject patch is not sufficient to fix
>> it, because I'm quite confident that it is necessary for that. :-)
>>
>> Without the $subject patch kernel_ident_mapping_init() makes
>> assumptions that simply are not met in the randomized identity mapping
>> base case.  Moreover, hibernation works for Thomas with $subject patch
>> applied, but it doesn't without it.
>>
>> So there is something else that we are missing.
>>
>> I have a murky suspicion, but it is really weird.  Namely, what if
>> restore_jump_address in set_up_temporary_text_mapping() happens to be
>> covered by the restore kernel's identity mapping?  Then, the image
>> kernel's entry point may get overwritten by something else in
>> core_restore_code().
>>
>> But is this possible even?  Thomas?
>
> I had a similar theory before when I was investigating the original
> crash. How is it avoided even without KASLR?

It doesn't have to be actively avoided then.  restore_jump_address is
a kernel text address and if __PAGE_OFFSET is the same for both the
restore and image kernels, it is guaranteed to be above the identity
mapping in both of them.

If the base of the identity mapping is randomized in both of them,
though, that may not be guaranteed any more.

> Given the space for the physical memory mapping, I doubt this issue
> would happen all the time though.

It should not, but it's not impossible for it to happen every time, at
least in a small number of attempts.

Thanks,
Rafael
