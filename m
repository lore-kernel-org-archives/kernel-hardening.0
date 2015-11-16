Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <56496AB0.5070905@gmail.com>
References: <CAHfkTQF33M8eqAPUr3wTDe-yB4k_MLSfMtAfPWW=AhA9aQdtmQ@mail.gmail.com>
	<CAFLxGvxukmvg9jHWXO=-Bbn3eoNrqwFvWsS-v_R99McPU4n_sg@mail.gmail.com>
	<56496AB0.5070905@gmail.com>
Date: Mon, 16 Nov 2015 15:14:34 -0800
Message-ID: <CAGXu5jJLcJBjyA+2xMA63tCr_xg7xxEoLk=RHKXRXM7L23AD7Q@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening]
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Nov 15, 2015 at 9:33 PM, Daniel Micay <danielmicay@gmail.com> wrote:
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
>
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

That's precisely what my Kernel Summit presentation was doing: trying
to convince people that we need to look beyond just bugs, and to
accept the technical burden of these features (and their
infrastructure) the protect end-users. I think a lot of developers are
more convinced of that now, which is why this project exists. I don't
think our time is wasted any more: we can address the technical issues
finally, without having to fight as hard a social battle to see them
upstreamed.

> I think there's plenty that could be landed but going directly upstream
> may not be the way to go. I was considering spending time on doing most
> of the small features and submitting them to AOSP. No politics to deal

AOSP isn't enough, and even if people did submit them there, I would
be one of the AOSP reviewers asking that they be upstreamed instead.
;)

> with there, only technical issues. If something lands there, it becomes
> a lot easier to upstream it because it becomes part of trying to get
> Android to use a vanilla kernel. Android wants security features and
> Linux isn't delivering, so it might as well start diverging more. For
> example, they recently started improving their ASLR implementation
> towards matching PaX (not there yet). I'm sure they'd take features like
> USERCOPY as-is.

Sure, but those userspace ASLR improvements are being developed
_upstream_. They started their life as a proof-of-concept in AOSP, but
I (and others) who reviewed it there asked that it be taken upstream
first.

-Kees

-- 
Kees Cook
Chrome OS Security
