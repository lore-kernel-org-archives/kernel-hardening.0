MIME-Version: 1.0
In-Reply-To: <CAGXu5jJCwAO1u4U0hAqAnd3ktgR-WcDzNUTpTeGoiUNVOzbYFg@mail.gmail.com>
References: <1531935483-30784-1-git-send-email-s.mesoraca16@gmail.com>
 <CAGXu5jK4q6HLDZ6jokTeDABbzVasY85Jo0HFNKYeaKWZYPjPKg@mail.gmail.com>
 <CAJHCu1+S_tv8Ju4m_QuWPm5Ke6rmByxT7jVhSo2kfVoCO_wMFg@mail.gmail.com> <CAGXu5jJCwAO1u4U0hAqAnd3ktgR-WcDzNUTpTeGoiUNVOzbYFg@mail.gmail.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Tue, 31 Jul 2018 09:43:26 +0200
Message-ID: <CAJHCu1LN4YkLqqT6TBEDw8YoW81VCvKnQam+v0NTvu1kDLMvsQ@mail.gmail.com>
Subject: Re: [RFC] kconfig: add hardened defconfig helpers
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Laura Abbott <labbott@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

2018-07-30 18:54 GMT+02:00 Kees Cook <keescook@chromium.org>:
> On Mon, Jul 30, 2018 at 9:11 AM, Salvatore Mesoraca
> <s.mesoraca16@gmail.com> wrote:
>> I'm sorry for the late response, I've been unexpectedly busy in the last week.
>>
>> 2018-07-20 7:15 GMT+02:00 Kees Cook <keescook@chromium.org>:
>>> +lkml, Masahiro, and linux-doc, just for wider review/thoughts.
>>>
>>> On Wed, Jul 18, 2018 at 10:38 AM, Salvatore Mesoraca
>>> <s.mesoraca16@gmail.com> wrote:
>>> [...]
>>>> +CONFIG_CC_STACKPROTECTOR_STRONG=y
>>>> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>> +
>>>> +**Negative side effects level:** Medium
>>>> +**- Protection type:** Self-protection
>>>> +
>>>> +Functions will have the stack-protector canary logic added in any
>>>> +of the following conditions:
>>>> +
>>>> +- local variable's address used as part of the right hand side of an
>>>> +assignment or function argument
>>>> +- local variable is an array (or union containing an array),
>>>> +regardless of array type or length
>>>> +- uses register local variables
>>>> +
>>>> +This feature requires gcc version 4.9 or above, or a distribution
>>>> +gcc with the feature backported ("-fstack-protector-strong").
>>>> +
>>>> +On an x86 "defconfig" build, this feature adds canary checks to
>>>> +about 20% of all kernel functions, which increases the kernel code
>>>> +size by about 2%.
>>>
>>> bikeshed: I think both stack protector items should be "Low", but
>>> that's just me.
>>
>> I tried to be cautious when selecting the levels, but if nobody is
>> against it, I can change the level.
>
> My thought about the "Low" stuff was: if a distro has it enabled by
> default, it must have been decided it was a sane default. So for
> things that distros have enabled, set it to "Low" here. (Which is why
> I cringed with KPTI: distros have it, but wow does it hurt...)

mmm, I think you are right.

>>>> [...]
>>>> +CONFIG_DEVMEM=n
>>>> +~~~~~~~~~~~~~~~
>>>> +
>>>> +**Negative side effects level:** Extreme
>>>
>>> Why is this extreme?
>>
>> I tried to be very cautious and I had the impression that this option
>> could break many programs,
>> isn't Xorg one of these?
>
> These days, (almost?) all graphics drivers run without needing
> userspace access to these things (and I think they never needed _RAM_
> access, just IO space). Setting this to Medium or High seems better to
> me. (The STRICT_DEVMEM, though, should be Low, since that's been a
> distro setting forever.)

Yes, agreed.

>>> [...]
>>>> +CONFIG_GCC_PLUGIN_LATENT_ENTROPY=y
>>>> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>> +
>>>> +**Negative side effects level:** High
>>>> +**- Protection type:** Self-protection
>>>> +
>>>> +With this pluging, the kernel will instrument some kernel code to
>>>> +extract some entropy from both original and artificially created
>>>> +program state. This will help especially embedded systems where
>>>> +there is little 'natural' source of entropy normally.  The cost
>>>> +is some slowdown of the boot process (about 0.5%) and fork and
>>>
>>> This doesn't feel like "high" to me.
>>
>> Medium maybe?
>
> Sounds good.
>
>>> [...]
>>>> +CONFIG_PAGE_POISONING=y
>>>> +~~~~~~~~~~~~~~~~~~~~~~~
>>>> +
>>>> +**Negative side effects level:** High
>>>> +**- Protection type:** Self-protection
>>>> +
>>>> +Fill the pages with poison patterns after free_pages() and verify
>>>> +the patterns before alloc_pages. The filling of the memory helps
>>>> +reduce the risk of information leaks from freed data. This does
>>>> +have a potential performance impact.
>>>> +Needs "page_poison=1" command line.
>>>> +
>>>> +
>>>> +CONFIG_PAGE_POISONING_NO_SANITY=y
>>>> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>> +
>>>> +**Negative side effects level:** High
>>>> +**- Protection type:** Self-protection
>>>> +
>>>> +Skip the sanity checking on alloc, only fill the pages with
>>>> +poison on free. This reduces some of the overhead of the
>>>> +poisoning feature.
>
> So, I spent some time looking at these again for unrelated reasons and
> rediscovered that enable CONFIG_PAGE_POISONING has virtual zero
> overhead since the actual poisoning doesn't happen unless you turn it
> on with a command line argument. So I would classify both of these as
> "Low".

Ah, OK.

>>>> +CONFIG_PAGE_POISONING_NO_SANITY=n
>>>> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>> +
>>>> +**Negative side effects level:** Extreme
>>>> +**- Protection type:** Self-protection
>>>> +
>>>> +Skip the sanity checking on alloc, only fill the pages with
>>>> +poison on free. This reduces some of the overhead of the
>>>> +poisoning feature.
>
> This one, though, yes, Extreme or High. It makes things much slower.
>
>>>> +CONFIG_PAGE_POISONING_ZERO=y
>>>> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>> +
>>>> +**Negative side effects level:** High
>>>> +**- Protection type:** Self-protection
>>>> +
>>>> +Instead of using the existing poison value, fill the pages with
>>>> +zeros. This makes it harder to detect when errors are occurring
>>>> +due to sanitization but the zeroing at free means that it is
>>>> +no longer necessary to write zeros when GFP_ZERO is used on
>>>> +allocation.
>
> This one is interesting: enabling it with poisoning means you gain
> back some of the performance hit (since now GFP_ZERO allocations don't
> need to do any work: the space was already freed), but you lose a bit
> of coverage since a write-after-free will not get zeroed at allocation
> time. So I think I would set this as:
>
> CONFIG_PAGE_POISONING_ZERO=y
> at Low
>
> CONFIG_PAGE_POISONING_ZERO=n
> at High (or Medium?)

Oh, I didn't think about this. OK.

>>> [...]
>>>> +CONFIG_STATIC_USERMODEHELPER=y
>>>> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>>> +
>>>> +**Negative side effects level:** Extreme
>>>
>>> I mean, this SHOULD be Low but no distro has actually implemented a
>>> helper to do this yet.
>>
>> Infact I set it as extreme because I expect very few people to make an
>> use of it.
>> Maybe I could just drop it.
>
> Until it's actually usable, yeah, I'd say drop it.
>
>> [...]
>> Thank you very very much for taking the time to look at this very long patch!
>
> You're welcome! Thanks for _writing_ it. :)
>
> -Kees
>
> --
> Kees Cook
> Pixel Security
