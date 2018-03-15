MIME-Version: 1.0
In-Reply-To: <CAGXu5jLHam5kz18k9uvhsz2WYodkF2v1tsEOV4Sx0O7jir4B3A@mail.gmail.com>
References: <1521143266-31350-1-git-send-email-keescook@chromium.org>
 <1521143266-31350-2-git-send-email-keescook@chromium.org> <CA+55aFzu+VU_FVZdbLCZttUspZdJCvBhkuo4V69H=XnqmLrpLA@mail.gmail.com>
 <CAGXu5jKtv=a8qTy1-AfbzNRB=Azb8V7Pt1M4QMVYNKg6+Ci7=Q@mail.gmail.com>
 <CA+55aFwDJ906oQ-98L2DNrjfKtb6cd5ykwMxpG942qxCFmAoEQ@mail.gmail.com> <CAGXu5jLHam5kz18k9uvhsz2WYodkF2v1tsEOV4Sx0O7jir4B3A@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 15 Mar 2018 23:58:10 +0100
Message-ID: <CANiq72k4qvXBy-VbFc5uOh-wAMx0yui5JokzX=NXtgZJ6F_NEg@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] kernel.h: Introduce const_max() for VLA removal
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input <linux-input@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 15, 2018 at 11:46 PM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Mar 15, 2018 at 3:23 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Thu, Mar 15, 2018 at 3:16 PM, Kees Cook <keescook@chromium.org> wrote:
>>>
>>> size_t __error_not_const_arg(void) \
>>> __compiletime_error("const_max() used with non-compile-time constant arg");
>>> #define const_max(x, y)                                         \
>>>         __builtin_choose_expr(__builtin_constant_p(x) &&        \
>>>                               __builtin_constant_p(y),          \
>>>                               (typeof(x))(x) > (typeof(y))(y) ? \
>>>                                         (x) : (y),              \
>>>                               __error_not_const_arg())
>>>
>>> Is typeof() forcing enums to int? Regardless, I'll put this through
>>> larger testing. How does that look?
>>
>> Ok, that alleviates my worry about one class of insane behavior, but
>> it does raise a few other questions:
>>
>>  - what drugs is gcc on where (typeof(x)(x)) makes a difference? Funky.
>
> Yeah, that's why I didn't even try that originally. But in looking
> back at max() again, it seemed to be the only thing missing that would
> handle the enum evaluation, which turned out to be true.
>
>>  - this does have the usual "what happen if you do
>>
>>      const_max(-1,sizeof(x))
>>
>> where the comparison will now be done in 'size_t', and -1 ends up
>> being a very very big unsigned integer.
>>
>> Is there no way to get that type checking inserted? Maybe now is a
>> good point for that __builtin_types_compatible(), and add it to the
>> constness checking (and change the name of that error case function)?
>
> So, AIUI, I can either get strict type checking, in which case, this
> is rejected (which I assume there is still a desire to have):
>
> int foo[const_max(6, sizeof(whatever))];

Is it that bad to just call it with (size_t)6?

>
> due to __builtin_types_compatible_p() rejecting it, or I can construct
> a "positive arguments only" test, in which the above is accepted, but
> this is rejected:
>
> int foo[const_max(-1, sizeof(whatever))];

Do we need this case?

>
> By using this eye-bleed:
>
> size_t __error_not_const_arg(void) \
> __compiletime_error("const_max() used with non-compile-time constant arg");
> size_t __error_not_positive_arg(void) \
> __compiletime_error("const_max() used with negative arg");
> #define const_max(x, y)                                                 \
>         __builtin_choose_expr(__builtin_constant_p(x) &&                \
>                               __builtin_constant_p(y),                  \
>                 __builtin_choose_expr((x) >= 0 && (y) >= 0,             \
>                                       (typeof(x))(x) > (typeof(y))(y) ? \
>                                         (x) : (y),                      \
>                                       __error_not_positive_arg()),      \
>                 __error_not_const_arg())
>

I was writing it like this:

#define const_max(a, b) \
    ({ \
        if ((a) < 0) \
            __const_max_called_with_negative_value(); \
        if ((b) < 0) \
            __const_max_called_with_negative_value(); \
        if (!__builtin_types_compatible_p(typeof(a), typeof(b))) \
            __const_max_called_with_incompatible_types(); \
        __builtin_choose_expr((a) > (b), (a), (b)); \
})

Cheers,
Miguel


> -Kees
>
> --
> Kees Cook
> Pixel Security
