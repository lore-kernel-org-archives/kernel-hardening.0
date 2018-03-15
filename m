MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CANiq72m7GEZS=Wkzg5KLkTnzW8vYz8X90OwVs4r5vcCCAp1-Pg@mail.gmail.com>
References: <1521143266-31350-1-git-send-email-keescook@chromium.org>
 <1521143266-31350-2-git-send-email-keescook@chromium.org> <CA+55aFzu+VU_FVZdbLCZttUspZdJCvBhkuo4V69H=XnqmLrpLA@mail.gmail.com>
 <CAGXu5jKtv=a8qTy1-AfbzNRB=Azb8V7Pt1M4QMVYNKg6+Ci7=Q@mail.gmail.com>
 <CA+55aFwDJ906oQ-98L2DNrjfKtb6cd5ykwMxpG942qxCFmAoEQ@mail.gmail.com>
 <CAGXu5jLHam5kz18k9uvhsz2WYodkF2v1tsEOV4Sx0O7jir4B3A@mail.gmail.com>
 <CANiq72k4qvXBy-VbFc5uOh-wAMx0yui5JokzX=NXtgZJ6F_NEg@mail.gmail.com>
 <CANiq72nEsno3JH=c_Xaf9gn1pJdM=ni6Z0ZUDqcEF07FT+SBSw@mail.gmail.com> <CANiq72m7GEZS=Wkzg5KLkTnzW8vYz8X90OwVs4r5vcCCAp1-Pg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 15 Mar 2018 16:31:59 -0700
Message-ID: <CAGXu5j+T2v1R8monUJMdCYtU5hqB2mqxm_a1737bRQVAzwuC4Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] kernel.h: Introduce const_max() for VLA removal
Content-Type: text/plain; charset="UTF-8"
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input <linux-input@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 15, 2018 at 4:17 PM, Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>> The full one, using your naming convention:
>>
>> #define const_max(x, y)                                          \
>>     ({                                                           \
>>         if (!__builtin_constant_p(x))                            \
>>             __error_not_const_arg();                             \
>>         if (!__builtin_constant_p(y))                            \
>>             __error_not_const_arg();                             \
>>         if (!__builtin_types_compatible_p(typeof(x), typeof(y))) \
>>             __error_incompatible_types();                        \
>>         if ((x) < 0)                                             \
>>             __error_not_positive_arg();                          \
>>         if ((y) < 0)                                             \
>>             __error_not_positive_arg();                          \
>>         __builtin_choose_expr((x) > (y), (x), (y));              \
>>     })
>>
>
> Nevermind... gcc doesn't take that as a constant expr, even if it
> compiles as one at -O0.

Yeah, unfortunately. :(

-Kees

-- 
Kees Cook
Pixel Security
