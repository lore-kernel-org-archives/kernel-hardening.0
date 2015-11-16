Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAEXv5_g-VJJweZKNuw5ozMfiVxMrfhw4biEkSu4A29-uuEmD6A@mail.gmail.com>
References: <CAHfkTQF33M8eqAPUr3wTDe-yB4k_MLSfMtAfPWW=AhA9aQdtmQ@mail.gmail.com>
	<CAFLxGvxukmvg9jHWXO=-Bbn3eoNrqwFvWsS-v_R99McPU4n_sg@mail.gmail.com>
	<56496AB0.5070905@gmail.com>
	<56496D65.8030903@gmail.com>
	<CAEXv5_g-VJJweZKNuw5ozMfiVxMrfhw4biEkSu4A29-uuEmD6A@mail.gmail.com>
Date: Mon, 16 Nov 2015 15:17:16 -0800
Message-ID: <CAGXu5jJieo3ZRje9z+4we_+dBqZO8xVP6-owS2NiY=o+-EUNVw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening]
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Nov 15, 2015 at 10:38 PM, David Windsor <dave@0x4141.net> wrote:
> On Mon, Nov 16, 2015 at 12:45 AM, Daniel Micay <danielmicay@gmail.com>
> wrote:
>>
>> > I really can't see Linus and others being okay with any GCC
>> > plugins with alterations to the semantics of C rather than just codegen
>> > like the KERNEXEC plugin.
>>
>> Oh and REFCOUNT is basically the same situation. I can't see any
>> possibility of that landing without switching to having a refcount_t
>> type and having separate functions for working with it, with a
>> configuration option like DEBUG_REFCOUNT to flip on overflow checks.
>> It's a whole bunch of busy-work and since it will touch so much code it
>> will run into the same problems that the previous attempts to upstream
>> constification did.
>>
> I'm currently in the process of preparing my earlier PAX_REFCOUNT patch set
> for resubmission, and I tend to agree with you - I'm not very hopeful of
> Linus, et al accepting them.  But, we will try again.

When you've got it ready, let's review it here first. I've had a lot
of experience navigating the upstreaming of unpopular things. :) We
can bikeshed and test it on this list first, and then when we think
it's ready, we can send it upstream.

> With respect to the issue of having a refcount_t type, PAX_REFCOUNT adds
> overflow protection to the already existing atomic_t type, and creates a new
> type, atomic_unchecked_t, for non-reference-counter types (i.e. statistical
> counters).

I'm looking forward to testing this! I was pondering a quick and dirty
LKDTM test to validate the results, too. Did you have anything already
designed to test it?

-Kees

-- 
Kees Cook
Chrome OS Security
