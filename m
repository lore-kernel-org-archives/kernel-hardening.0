MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+55aFzO12QMFJHe8osoWfph8jnjgp_jLUQWmgbNmth_KwPxXw@mail.gmail.com>
References: <1521143266-31350-1-git-send-email-keescook@chromium.org>
 <1521143266-31350-2-git-send-email-keescook@chromium.org> <CA+55aFzu+VU_FVZdbLCZttUspZdJCvBhkuo4V69H=XnqmLrpLA@mail.gmail.com>
 <CAGXu5jKtv=a8qTy1-AfbzNRB=Azb8V7Pt1M4QMVYNKg6+Ci7=Q@mail.gmail.com>
 <CA+55aFwDJ906oQ-98L2DNrjfKtb6cd5ykwMxpG942qxCFmAoEQ@mail.gmail.com>
 <CAGXu5jLHam5kz18k9uvhsz2WYodkF2v1tsEOV4Sx0O7jir4B3A@mail.gmail.com> <CA+55aFzO12QMFJHe8osoWfph8jnjgp_jLUQWmgbNmth_KwPxXw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 15 Mar 2018 16:41:41 -0700
Message-ID: <CAGXu5jLHW00UmSDyAmdLpin6L636XbP3brH=pn4qh1bN87AirA@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] kernel.h: Introduce const_max() for VLA removal
Content-Type: text/plain; charset="UTF-8"
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input <linux-input@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 15, 2018 at 4:34 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Mar 15, 2018 at 3:46 PM, Kees Cook <keescook@chromium.org> wrote:
>>
>> So, AIUI, I can either get strict type checking, in which case, this
>> is rejected (which I assume there is still a desire to have):
>>
>> int foo[const_max(6, sizeof(whatever))];
>
> Ehh, yes, that looks fairly sane, and erroring out would be annoying.
>
> But maybe we should just make the type explicit, and make it "const_max_t()"?
>
> I think all the existing users are of type "max_t()" anyway due to the
> very same issue, no?

All but one are using max()[1]. One case uses max_t() to get u32.

> At least if there's an explicit type like 'size_t', then passing in
> "-1" becoming a large unsigned integer is understandable and clear,
> not just some odd silent behavior.
>
> Put another way: I think it's unacceptable that
>
>      const_max(-1,6)
>
> magically becomes a huge positive number like in that patch of yours, but
>
>      const_max_t(size_t, -1, 6)
>
> *obviously* is a huge positive number.
>
> The two things would *do* the same thing, but in the second case the
> type is explicit and visible.
>
>> due to __builtin_types_compatible_p() rejecting it, or I can construct
>> a "positive arguments only" test, in which the above is accepted, but
>> this is rejected:
>
> That sounds acceptable too, although the "const_max_t()" thing is
> presumably going to be simpler?

I much prefer explicit typing, but both you and Rasmus mentioned
wanting the int/sizeof_t mixing. I'm totally happy with const_max_t()
-- even if it makes my line-wrapping harder due to the longer name. ;)

I'll resend in a moment...

-Kees

[1] https://patchwork.kernel.org/patch/10285709/

-- 
Kees Cook
Pixel Security
