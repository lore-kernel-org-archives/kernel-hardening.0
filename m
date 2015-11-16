Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <56496AB0.5070905@gmail.com>
References: <CAHfkTQF33M8eqAPUr3wTDe-yB4k_MLSfMtAfPWW=AhA9aQdtmQ@mail.gmail.com>
	<CAFLxGvxukmvg9jHWXO=-Bbn3eoNrqwFvWsS-v_R99McPU4n_sg@mail.gmail.com>
	<56496AB0.5070905@gmail.com>
Date: Mon, 16 Nov 2015 13:13:48 +0100
Message-ID: <CAFLxGvyUdURf8TkVOmzG0wraoGRUtLJH1+KsZUi8TJ-a4D9n4A@mail.gmail.com>
From: Richard Weinberger <richard.weinberger@gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening]
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 16, 2015 at 6:33 AM, Daniel Micay <danielmicay@gmail.com> wrote:
> On 15/11/15 03:59 PM, Richard Weinberger wrote:
>> On Fri, Nov 13, 2015 at 4:43 PM, west suhanic <west.suhanic@gmail.com> wrote:
>>> Hello All:
>>>
>>> I am a hardened gentoo user. How can we get the grsecurity code into the
>>> kernel?
>>
>> As soon all downsides and drawbacks are identified/resolved.
>> Which basically means that we have to redo a lot (it not all).
>
> You might not be familiar with the grsecurity/PaX features and their
> implementations but lots of people are. It's not unexplored territory
> without known trade-offs. It has active developers who are happy to
> answer questions about it (within reason).

I'll kindly ignore this personal attack.

> I think there's little that would need to be redone. There are many
> things that would need to be renamed and refactored in order to present
> them in a different light to deal with political issues. One good way to
> upstream stuff would be presenting it from the angle that it's useful
> for finding kernel bugs for *everyone* and just accepting that some of
> it is going to be misrepresented (i.e. CONFIG_DEBUG_*).
>
> Approaching this as if it's a technical issue is only going to lead to
> failure. I really can't see Linus and others being okay with any GCC
> plugins with alterations to the semantics of C rather than just codegen
> like the KERNEXEC plugin. Dropping time into extracting stuff like that
> rather than realistic things seems wasteful. If someone puts in the
> effort to do it, submits it and hits a wall then I wouldn't expect them
> to be motivated to do more.
>
> I think there's plenty that could be landed but going directly upstream
> may not be the way to go. I was considering spending time on doing most
> of the small features and submitting them to AOSP. No politics to deal
> with there, only technical issues. If something lands there, it becomes
> a lot easier to upstream it because it becomes part of trying to get
> Android to use a vanilla kernel. Android wants security features and
> Linux isn't delivering, so it might as well start diverging more. For
> example, they recently started improving their ASLR implementation
> towards matching PaX (not there yet). I'm sure they'd take features like
> USERCOPY as-is.

Sorry, I'm not that optimistic as I had already the pleasure to port various
PaX/grsecurity features and also tried to mainline some bits.

But I'm eager to read your patches and will happily contribute.

-- 
Thanks,
//richard
