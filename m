MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CAGXu5jKtv=a8qTy1-AfbzNRB=Azb8V7Pt1M4QMVYNKg6+Ci7=Q@mail.gmail.com>
References: <1521143266-31350-1-git-send-email-keescook@chromium.org>
 <1521143266-31350-2-git-send-email-keescook@chromium.org> <CA+55aFzu+VU_FVZdbLCZttUspZdJCvBhkuo4V69H=XnqmLrpLA@mail.gmail.com>
 <CAGXu5jKtv=a8qTy1-AfbzNRB=Azb8V7Pt1M4QMVYNKg6+Ci7=Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 15 Mar 2018 15:23:16 -0700
Message-ID: <CA+55aFwDJ906oQ-98L2DNrjfKtb6cd5ykwMxpG942qxCFmAoEQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] kernel.h: Introduce const_max() for VLA removal
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input <linux-input@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 15, 2018 at 3:16 PM, Kees Cook <keescook@chromium.org> wrote:
>
> size_t __error_not_const_arg(void) \
> __compiletime_error("const_max() used with non-compile-time constant arg");
> #define const_max(x, y)                                         \
>         __builtin_choose_expr(__builtin_constant_p(x) &&        \
>                               __builtin_constant_p(y),          \
>                               (typeof(x))(x) > (typeof(y))(y) ? \
>                                         (x) : (y),              \
>                               __error_not_const_arg())
>
> Is typeof() forcing enums to int? Regardless, I'll put this through
> larger testing. How does that look?

Ok, that alleviates my worry about one class of insane behavior, but
it does raise a few other questions:

 - what drugs is gcc on where (typeof(x)(x)) makes a difference? Funky.

 - this does have the usual "what happen if you do

     const_max(-1,sizeof(x))

where the comparison will now be done in 'size_t', and -1 ends up
being a very very big unsigned integer.

Is there no way to get that type checking inserted? Maybe now is a
good point for that __builtin_types_compatible(), and add it to the
constness checking (and change the name of that error case function)?

          Linus
