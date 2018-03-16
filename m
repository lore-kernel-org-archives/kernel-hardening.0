MIME-Version: 1.0
In-Reply-To: <CAGXu5j+Dv_wQgHWgT=9eSoKX7AcqnumuRsNFUoZ765WWizKytw@mail.gmail.com>
References: <1521143266-31350-1-git-send-email-keescook@chromium.org>
 <1521143266-31350-2-git-send-email-keescook@chromium.org> <CA+55aFzu+VU_FVZdbLCZttUspZdJCvBhkuo4V69H=XnqmLrpLA@mail.gmail.com>
 <CAGXu5jKtv=a8qTy1-AfbzNRB=Azb8V7Pt1M4QMVYNKg6+Ci7=Q@mail.gmail.com>
 <CA+55aFwDJ906oQ-98L2DNrjfKtb6cd5ykwMxpG942qxCFmAoEQ@mail.gmail.com>
 <CAGXu5jLHam5kz18k9uvhsz2WYodkF2v1tsEOV4Sx0O7jir4B3A@mail.gmail.com>
 <CA+55aFzO12QMFJHe8osoWfph8jnjgp_jLUQWmgbNmth_KwPxXw@mail.gmail.com>
 <CAGXu5jLHW00UmSDyAmdLpin6L636XbP3brH=pn4qh1bN87AirA@mail.gmail.com>
 <CA+55aFyRV9KXzeQZpVYsZYVUJm-ASgu_4_1+8Y8-0KH-YT2M8Q@mail.gmail.com> <CAGXu5j+Dv_wQgHWgT=9eSoKX7AcqnumuRsNFUoZ765WWizKytw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 16 Mar 2018 04:05:55 +0100
Message-ID: <CANiq72m6OuzN_gDiEhpLXY+2=5=m=1s5U-kDe=xpJmOVyE+hSg@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] kernel.h: Introduce const_max() for VLA removal
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input <linux-input@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 16, 2018 at 12:49 AM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Mar 15, 2018 at 4:46 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> What I'm *not* so much ok with is "const_max(5,sizeof(x))" erroring
>> out, or silently causing insane behavior due to hidden subtle type
>> casts..
>
> Yup! I like it as an explicit argument. Thanks!
>

What about something like this?

#define INTMAXT_MAX LLONG_MAX
typedef int64_t intmax_t;

#define const_max(x, y)                                               \
        __builtin_choose_expr(                                        \
                !__builtin_constant_p(x) || !__builtin_constant_p(y), \
                __error_not_const_arg(),                              \
                __builtin_choose_expr(                                \
                        (x) > INTMAXT_MAX || (y) > INTMAXT_MAX,       \
                        __error_too_big(),                            \
                        __builtin_choose_expr(                        \
                                (intmax_t)(x) >= (intmax_t)(y),       \
                                (x),                                  \
                                (y)                                   \
                        )                                             \
                )                                                     \
        )

Works for different types, allows to mix negatives and positives and
returns the original type, e.g.:

  const_max(-1, sizeof(char));

is of type 'long unsigned int', but:

  const_max(2, sizeof(char));

is of type 'int'. While I am not a fan that the return type depends on
the arguments, it is useful if you are going to use the expression in
something that needs expects a precise (a printk() for instance?).

The check against the INTMAXT_MAX is there to avoid complexity (if we
do not handle those cases, it is safe to use intmax_t for the
comparison; otherwise you have to have another compile time branch for
the case positive-positive using uintmax_t) and also avoids odd
warnings for some cases above LLONG_MAX about comparisons with 0 for
unsigned expressions being always true. On the positive side, it
prevents using the macro for thing like "(size_t)-1".

Cheers,
Miguel
