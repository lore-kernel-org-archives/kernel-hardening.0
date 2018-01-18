MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <fb67be6f-3691-0aef-fbc6-4e1093ddb8da@linux.com>
References: <1515766769-9120-1-git-send-email-alex.popov@linux.com>
 <CAGXu5jKmOn7E04Y8pR9Tgn7usJYMhqWe9x929ZwEnu21MG=mZw@mail.gmail.com>
 <0c1950e9-626d-c7b8-5551-fcc233501025@linux.com> <fb67be6f-3691-0aef-fbc6-4e1093ddb8da@linux.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 18 Jan 2018 13:13:33 -0800
Message-ID: <CAGXu5j+OSzYx61-NN8XcBAVvMpCrPc2TFN66esK+-gFQtp_5pg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH RFC v7 0/6] Introduce the STACKLEAK feature and a test for it
To: Alexander Popov <alex.popov@linux.com>
Cc: kernel-hardening@lists.openwall.com, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 18, 2018 at 5:09 AM, Alexander Popov <alex.popov@linux.com> wrote:
> Hello Kees,
>
> On 17.01.2018 14:37, Alexander Popov wrote:
>> On 15.01.2018 22:59, Kees Cook wrote:
>>> On Fri, Jan 12, 2018 at 6:19 AM, Alexander Popov <alex.popov@linux.com> wrote:
>>>> This is the 7th version of the patch series introducing STACKLEAK to the
>>>> mainline kernel. STACKLEAK is a security feature developed by Grsecurity/PaX
>>>> (kudos to them), which:
>>>>  - reduces the information that can be revealed through kernel stack leak bugs;
>>>>  - blocks some uninitialized stack variable attacks (e.g. CVE-2010-2963);
>>>>  - introduces some runtime checks for kernel stack overflow detection.
>>>
>>> I think this is really looking good. I had some thoughts while reading
>>> through the patches:
>>>
>>> There are really three features in this series, and it might make
>>> sense to separate them a bit more clearly (at least with CONFIG
>>> choices):
>>>
>>> 1) stack clearing (with depth searching)
>>>
>>> 2) runtime stack depth tracking (making 1 much more efficient)
>>>
>>> 3) alloca checking (an additional feature, not strictly part of
>>> clearing, but needs the same plugin infrastructure)
>>>
>>> It seems like it should be possible to get 1 without 2 and 3 (both of
>>> which happen in the gcc plugin), and might be good to separate for
>>> builds that don't have gcc plugins.
>>>
>>> Once compilers are doing alloca checking (or all VLAs are removed from
>>> the kernel), it'd be nice to be able to avoid the redundancy of 3.
>>
>> Agree with your point. I'll make this separation in the next version.
>
> I have more thoughts about this separation.
>
> Splitting (1) from (2)
> ----------------------
>
> It makes the stack erasing not only slow but also unreliable. For example, an
> attacker can craft some STACKLEAK_POISON values on the thread stack to deceive
> the poison search during the erasing.
>
> Of course, I can increase STACKLEAK_POISON_CHECK_DEPTH or change the default
> value of lowest_stack. It will make the stack erasing even slower, but will not
> give guarantees.

Yeah, that's true. I was hoping the depth check was sufficient.

> So I don't think that (1) without (2) is actually a good feature. I would
> propose to refrain from separating the stack erasing and the lowest_stack tracking.

How about an option to clear the _entire_ stack, then, when the plugin
isn't available? That gives us a range of options and provides an easy
way to compare the performance of the tracking. i.e. can compare off,
full, and smart.

> Splitting (2) and (3)
> ---------------------
>
> The STACKLEAK gcc plugin needs to search for alloca anyway (for the correct
> lowest_stack tracking). But I can introduce the "no-check-alloca" plugin
> parameter for disabling the check_alloca() call insertion.
>
> Is it worth providing something like CONFIG_GCC_PLUGIN_STACKLEAK_NO_CHECK_ALLOCA
> in the Kconfig?

Nah, we can cross that bridge when the compilers have sane alloca checking.

-Kees

-- 
Kees Cook
Pixel Security
