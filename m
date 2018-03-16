Subject: Re: [PATCH v4 1/2] kernel.h: Introduce const_max() for VLA removal
References: <1521143266-31350-1-git-send-email-keescook@chromium.org>
 <1521143266-31350-2-git-send-email-keescook@chromium.org>
 <CA+55aFzu+VU_FVZdbLCZttUspZdJCvBhkuo4V69H=XnqmLrpLA@mail.gmail.com>
 <CAGXu5jKtv=a8qTy1-AfbzNRB=Azb8V7Pt1M4QMVYNKg6+Ci7=Q@mail.gmail.com>
 <CA+55aFwDJ906oQ-98L2DNrjfKtb6cd5ykwMxpG942qxCFmAoEQ@mail.gmail.com>
 <CAGXu5jLHam5kz18k9uvhsz2WYodkF2v1tsEOV4Sx0O7jir4B3A@mail.gmail.com>
 <CA+55aFzO12QMFJHe8osoWfph8jnjgp_jLUQWmgbNmth_KwPxXw@mail.gmail.com>
 <CAGXu5jLHW00UmSDyAmdLpin6L636XbP3brH=pn4qh1bN87AirA@mail.gmail.com>
 <CA+55aFyRV9KXzeQZpVYsZYVUJm-ASgu_4_1+8Y8-0KH-YT2M8Q@mail.gmail.com>
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <ea209e9e-33d0-45f6-5cad-23c2bb75bc6b@rasmusvillemoes.dk>
Date: Fri, 16 Mar 2018 15:15:34 +0100
MIME-Version: 1.0
In-Reply-To: <CA+55aFyRV9KXzeQZpVYsZYVUJm-ASgu_4_1+8Y8-0KH-YT2M8Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input <linux-input@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 2018-03-16 00:46, Linus Torvalds wrote:
> On Thu, Mar 15, 2018 at 4:41 PM, Kees Cook <keescook@chromium.org> wrote:
>>
>> I much prefer explicit typing, but both you and Rasmus mentioned
>> wanting the int/sizeof_t mixing.
> 
> Well, the explicit typing allows that mixing, in that you can just
> have "const_max_t(5,sizeof(x))"
> 
> So I'm ok with that.
> 
> What I'm *not* so much ok with is "const_max(5,sizeof(x))" erroring
> out, or silently causing insane behavior due to hidden subtle type
> casts..

I don't like const_max_t, at least not as the "primary" interface -
forcing the user to pass in a type, or equivalently passing in cast
expressions to a const_max(), can hide errors, e.g. if the -1 is really
SOME_MACRO or some complicated expression that is usually positive, but
that expression always gets cast to size_t because the user was forced to do

  const_max_t(size_t, SOME_MACRO, sizeof(foo))

to make the code compile. Not to mention that it's both easier to read
and write if one could just do

  const_max(SOME_MACRO, sizeof(foo))

Can we instead do one of the following:

(1) Effectively do the comparison in an infinitely wide signed integer,
i.e. implement

  x < 0 && y >= 0  -->  y
  x >= 0 && y < 0  -->  x
  otherwise, if both have the same sign (but not necessarily the same
signedness of their types), the type promotions do not alter either's
value, so __builtin_choose_expr(x > y, x, y) will do the right thing

with the resulting thing having the same type as the chosen one of x and
y. [Or having type typeof(x+y), which would just be a cast in the
macro.] This would allow const_max(-1, sizeof(foo)) and give
sizeof(foo), but perhaps that's too magic.

(2) Allow mixed types, but ensure the build fails if one of the values
is not representable in typeof(x+y) (i.e., one value is negative but the
common type is unsigned). That allows the const_max(SOME_MACRO,
sizeof()), but prevents silent failure in case some weird combination of
CONFIG options make SOME_MACRO evaluate to something negative.

The user can always pass in (size_t)-1 explicitly if needed, or cast the
sizeof() to int if that's what makes sense, but that's a case-by-case
thing. I'd really like that the simple case

  const_max(16, sizeof(foo))

Just Works. Then if a lot users turn up that do need some casting,
const_max_t can be implemented as a trivial const_max wrapper.

Rasmus

(1) something like __builtin_choose_expr((x >= 0 && y < 0) || \
(x >= 0 && y >= 0 && x > y) || \
(x < 0 && y < 0 && x > y), x, y)

(2) something like

// 1 or build error
#define __check_promotion(t, x) ( 1/(((t)(x) < 0) == ((x) < 0)) )

__builtin_choose_expr(__check_promotion(typeof((x)+(y)), x) && \
__check_promotion(typeof((x)+(y)), y) && \
(x) > (y), x, y)

Not sure how to get a more sensible error message, I'd like this to also
work outside functions.
