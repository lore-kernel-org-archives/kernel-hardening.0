MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <f62b57d9-eec6-d2ab-9f78-a628fec7bb4c@linux.com>
References: <1515766769-9120-1-git-send-email-alex.popov@linux.com>
 <CAGXu5jKmOn7E04Y8pR9Tgn7usJYMhqWe9x929ZwEnu21MG=mZw@mail.gmail.com>
 <0c1950e9-626d-c7b8-5551-fcc233501025@linux.com> <fb67be6f-3691-0aef-fbc6-4e1093ddb8da@linux.com>
 <CAGXu5j+OSzYx61-NN8XcBAVvMpCrPc2TFN66esK+-gFQtp_5pg@mail.gmail.com>
 <9e6d74cf-ac51-463e-feae-b2df0e5fb85e@linux.com> <f62b57d9-eec6-d2ab-9f78-a628fec7bb4c@linux.com>
From: Kees Cook <keescook@chromium.org>
Date: Sun, 11 Feb 2018 13:35:58 -0800
Message-ID: <CAGXu5j+hoCKBkaknNFQvHYFNuj-FweCPuL2vngCYpb8rcR-qtw@mail.gmail.com>
Subject: Re: [PATCH RFC v7 0/6] Introduce the STACKLEAK feature and a test for it
Content-Type: text/plain; charset="UTF-8"
To: Alexander Popov <alex.popov@linux.com>
Cc: kernel-hardening@lists.openwall.com, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 25, 2018 at 7:13 AM, Alexander Popov <alex.popov@linux.com> wrote:
> On 20.01.2018 13:13, Alexander Popov wrote:
>> On 19.01.2018 00:13, Kees Cook wrote:
>>> On Thu, Jan 18, 2018 at 5:09 AM, Alexander Popov <alex.popov@linux.com> wrote:
>>>> So I don't think that (1) without (2) is actually a good feature. I would
>>>> propose to refrain from separating the stack erasing and the lowest_stack tracking.
>>>
>>> How about an option to clear the _entire_ stack, then, when the plugin
>>> isn't available? That gives us a range of options and provides an easy
>>> way to compare the performance of the tracking. i.e. can compare off,
>>> full, and smart.
>>
>> Yes, I should try it. I'll return with the results of the performance tests.
>> We'll discuss them; if full stack erasing is not too slow, I'll introduce it in
>> the 8'th version of the patch series.
>
> I've made a brief performance test on x86_64 (similar to the test described in
> the cover letter). I guess there might be workloads with higher performance penalty.
>
> Hardware: Intel Core i7-4770, 16 GB RAM
> Test: hackbench -s 4096 -l 2000 -g 15 -f 25 -P
>
> Average time on v4.14.15: 9.194s
> Average time on v4.14.15-stackleak-with-plugin: 9.490 (+3.22%)
> Average time on v4.14.15-stackleak-full-erasing: 12.149 (+32.14%)

Yeeeowch. Okay, I'm convinced. :)

> Honestly, I think, it is not worth having this full stack erasing as a separate
> feature. Moreover, it brings some #ifdef conditionals to the erase_kstack()
> code, which don't look nice.
>
> May I ask for your opinion?
>
> Best regards,
> Alexander

-Kees

-- 
Kees Cook
Pixel Security
