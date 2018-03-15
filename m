MIME-Version: 1.0
In-Reply-To: <CANiq72k4qvXBy-VbFc5uOh-wAMx0yui5JokzX=NXtgZJ6F_NEg@mail.gmail.com>
References: <1521143266-31350-1-git-send-email-keescook@chromium.org>
 <1521143266-31350-2-git-send-email-keescook@chromium.org> <CA+55aFzu+VU_FVZdbLCZttUspZdJCvBhkuo4V69H=XnqmLrpLA@mail.gmail.com>
 <CAGXu5jKtv=a8qTy1-AfbzNRB=Azb8V7Pt1M4QMVYNKg6+Ci7=Q@mail.gmail.com>
 <CA+55aFwDJ906oQ-98L2DNrjfKtb6cd5ykwMxpG942qxCFmAoEQ@mail.gmail.com>
 <CAGXu5jLHam5kz18k9uvhsz2WYodkF2v1tsEOV4Sx0O7jir4B3A@mail.gmail.com> <CANiq72k4qvXBy-VbFc5uOh-wAMx0yui5JokzX=NXtgZJ6F_NEg@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 16 Mar 2018 00:08:49 +0100
Message-ID: <CANiq72nEsno3JH=c_Xaf9gn1pJdM=ni6Z0ZUDqcEF07FT+SBSw@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] kernel.h: Introduce const_max() for VLA removal
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input <linux-input@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 15, 2018 at 11:58 PM, Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
> On Thu, Mar 15, 2018 at 11:46 PM, Kees Cook <keescook@chromium.org> wrote:
>>
>> By using this eye-bleed:
>>
>> size_t __error_not_const_arg(void) \
>> __compiletime_error("const_max() used with non-compile-time constant arg");
>> size_t __error_not_positive_arg(void) \
>> __compiletime_error("const_max() used with negative arg");
>> #define const_max(x, y)                                                 \
>>         __builtin_choose_expr(__builtin_constant_p(x) &&                \
>>                               __builtin_constant_p(y),                  \
>>                 __builtin_choose_expr((x) >= 0 && (y) >= 0,             \
>>                                       (typeof(x))(x) > (typeof(y))(y) ? \
>>                                         (x) : (y),                      \
>>                                       __error_not_positive_arg()),      \
>>                 __error_not_const_arg())
>>
>
> I was writing it like this:
>
> #define const_max(a, b) \
>     ({ \
>         if ((a) < 0) \
>             __const_max_called_with_negative_value(); \
>         if ((b) < 0) \
>             __const_max_called_with_negative_value(); \
>         if (!__builtin_types_compatible_p(typeof(a), typeof(b))) \
>             __const_max_called_with_incompatible_types(); \
>         __builtin_choose_expr((a) > (b), (a), (b)); \
> })

The full one, using your naming convention:

#define const_max(x, y)                                          \
    ({                                                           \
        if (!__builtin_constant_p(x))                            \
            __error_not_const_arg();                             \
        if (!__builtin_constant_p(y))                            \
            __error_not_const_arg();                             \
        if (!__builtin_types_compatible_p(typeof(x), typeof(y))) \
            __error_incompatible_types();                        \
        if ((x) < 0)                                             \
            __error_not_positive_arg();                          \
        if ((y) < 0)                                             \
            __error_not_positive_arg();                          \
        __builtin_choose_expr((x) > (y), (x), (y));              \
    })

Miguel
