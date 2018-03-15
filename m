MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+55aFzu+VU_FVZdbLCZttUspZdJCvBhkuo4V69H=XnqmLrpLA@mail.gmail.com>
References: <1521143266-31350-1-git-send-email-keescook@chromium.org>
 <1521143266-31350-2-git-send-email-keescook@chromium.org> <CA+55aFzu+VU_FVZdbLCZttUspZdJCvBhkuo4V69H=XnqmLrpLA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 15 Mar 2018 15:16:51 -0700
Message-ID: <CAGXu5jKtv=a8qTy1-AfbzNRB=Azb8V7Pt1M4QMVYNKg6+Ci7=Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] kernel.h: Introduce const_max() for VLA removal
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input <linux-input@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 15, 2018 at 2:42 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Mar 15, 2018 at 12:47 PM, Kees Cook <keescook@chromium.org> wrote=
:
>>
>> To gain the ability to compare differing types, the arguments are
>> explicitly cast to size_t.
>
> Ugh, I really hate this.
>
> It silently does insane things if you do
>
>    const_max(-1,6)
>
> and there is nothing in the name that implies that you can't use
> negative constants.

Yeah, I didn't like that effect either. I was seeing this:

./include/linux/kernel.h:836:14: warning: comparison between =E2=80=98enum
<anonymous>=E2=80=99 and =E2=80=98enum <anonymous>=E2=80=99 [-Wenum-compare=
]
          (x) > (y) ? \
              ^
./include/linux/kernel.h:838:7: note: in definition of macro =E2=80=98const=
_max=E2=80=99
      (y),  \
       ^
net/ipv6/proc.c:34:11: note: in expansion of macro =E2=80=98const_max=E2=80=
=99
           const_max(IPSTATS_MIB_MAX, ICMP_MIB_MAX))
           ^~~~~~~~~

But it turns out that just doing a typeof() fixes this, and there's no
need for the hard cast to size_t:

size_t __error_not_const_arg(void) \
__compiletime_error("const_max() used with non-compile-time constant arg");
#define const_max(x, y)                                         \
        __builtin_choose_expr(__builtin_constant_p(x) &&        \
                              __builtin_constant_p(y),          \
                              (typeof(x))(x) > (typeof(y))(y) ? \
                                        (x) : (y),              \
                              __error_not_const_arg())

Is typeof() forcing enums to int? Regardless, I'll put this through
larger testing. How does that look?

-Kees

--=20
Kees Cook
Pixel Security
