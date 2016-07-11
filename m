Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAHgaXdLPLCiggTrKGcFZzmGiBUmdmNGAt0_nO9BS5aGoP=bVmw@mail.gmail.com>
References: <CAHgaXdKW4=y-PviWudtMAThuB=GEW-73RejSHRMYNVzLyxP+iA@mail.gmail.com>
 <CAGXu5jLA+ri_RwWSOoZwAtv6a6pXL_EzUx6BZ0Mmc-n0+We9vg@mail.gmail.com> <CAHgaXdLPLCiggTrKGcFZzmGiBUmdmNGAt0_nO9BS5aGoP=bVmw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 11 Jul 2016 14:52:40 -0400
Message-ID: <CAGXu5jJofXU-KsZ+1vxHHKHQFcVv5YSi1wtx3DR0sAZto-NvsQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Looking for something to WORK ON
To: Shubham Bansal <illusionist.neo@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, Daniel Borkmann <daniel@iogearbox.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jul 10, 2016 at 12:04 PM, Shubham Bansal
<illusionist.neo@gmail.com> wrote:
> Hi Kees,
>
> Sorry for the late reply. I am having some problems with arranging a lot of
> mails from the list.

No worries! Glad to have you interested in the discussions. :)

>
> On Wed, Jul 6, 2016 at 11:05 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Wed, Jul 6, 2016 at 10:40 AM, Shubham Bansal
>> <illusionist.neo@gmail.com> wrote:
>>> Hi guys,
>>>
>>> I want to start with linux kernel development and looking for some
>>> project
>>> where I can contribute. I was looking at
>>> http://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project which
>>> asked
>>> to introduce myself on the list if I am looking for some work (thats what
>>> I
>>> am doing :) ). It would be highly appreciated if any of you guys have
>>> something where I can contribute.
>>>
>>> Best,
>>> Shubham Bansal
>>
>> Welcome to the fun! :)
>>
>> What things are you generally interested in?
>
> Well, I don't have any preference as such. I am open to any work that is
> related to security. I have just graduated from the college. I have
> background in Crypto, Reverse engg. and exploit development. But if you need
> a specific topic, I would say I want to add some features from grsecurity to
> main linux kernel.

That's ultimately where a lot of the work comes from: most of the
interesting protections have an implementation in the grsecurity
patch, but tends not to be in a form that is easily upstreamed.

>> Do you have familiarity
>> with a specific architecture (or do you want to _gain_ familiarity
>> with a specific architecture)?
>
> I have a good familiarity with x86,x86-64 but I also know arm. Although, its
> not a problem if there is a need, I will read about it.

If you want to poke at tricky/hard arch-specific issues, I'd love to
see ARMv8.1's PAN emulated on ARMv8.0. That one looks to be possible,
but tricky to find all the right ways to handle it.

If you're really feeling adventurous, I'd love to see the PaX's UDEREF
feature on x86_64 implemented in upstream.

>> There's a small list of stuff that is related to the larger project
>> pieces that I try to keep up to date, of varying difficulty:
>>
>>
>> http://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project#Specific_TODO_Items
>
> All of these sounds interesting to me. Although I didn't fully understand
> some of the TODO items but few of these which I think I would like to work :
>
> Move kernel stack to vmap area

This one is under way by Andy Lutomirski for x86, but it'd be great to
see it done on arm and arm64 or other architectures.

> Split thread_info off of kernel stack

This is in progress for x86 too, but again, we need it for other architectures.

> Convert remaining BPF JITs to eBPF JIT (with blinding)

This would be nice for gaining BPF performance on the architectures
that don't support the JIT currently.

> Write lib/test_bpf.c tests for eBPF constant blinding

And this is good for testing the eBPF JIT blinding -- right now it's
kind of a manual check, and that makes me nervous since it's harder to
notice regressions.

(I've added Daniel Borkmann and Elena Reshetova to CC, since they
could help direct you with the BPF work.)

> But, I can work on other things also, whatever you think is appropriate. I
> would prefer working on challenging project though.

If you can solve the PAN emulation on ARMv8.0, that would be very
valuable -- most newer phones and tablets are moving to arm64, and
none are ARMv8.1, so they only have PXN and no PAN (where as 32-bit
arm can do full PAN emulation with Domains right now, so there's this
weird gap where we're actually going to regress in memory protections
for a few years until everything is shipping with ARMv8.1 devices).

> Hoping for a quick reply. I want to start working as soon as possible.

Hopefully this is quick enough. :)

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
