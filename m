MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20171108223020.24487-1-linux@rasmusvillemoes.dk>
References: <20171108223020.24487-1-linux@rasmusvillemoes.dk>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 8 Nov 2017 17:11:23 -0800
Message-ID: <CAGXu5jKnv_mP1hGEe5FbLV_mYknCknZJjo=-Po0mjnWJSV7+_Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC 0/6] some compile- and run-time format checking
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 8, 2017 at 2:30 PM, Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:
> Consider these strictly RFC/POC.
>
> I tried resurrecting my format_template plugin from two years ago, and
> it rebased pretty cleanly. It also compiles with gcc 6.3, and has the
> expected effect when one tries to trigger it, so it seems to work ok
> (I think there was some build bot issue back then, maybe there still
> is).
>
> The last four patches are something I threw together rather quickly.
> They compile and the few test cases pass, but I obviously need to find
> some places to actually use fmtcheck() to see if it's worth adding.
>
> Rasmus Villemoes (6):
>   plugins: implement format_template attribute
>   compiler.h: add __format_template

Could you split these two off and send separately? This seems like a
fine thing to get in now. Probably the second patch should be split up
between adding __format_template, and additions of its usage. Do you
have any good ways to find and extract all the dynamic format strings
we need to mark?

>   compiler.h: add __attribute__((format_arg)) shorthand
>   lib/vsprintf.c: add fmtcheck utility
>   kernel.h: implement fmtmatch() wrapper around fmtcheck()
>   lib/test_printf.c: add a few fmtcheck() test cases

I like this approach a lot. Combined with checking if a format string
is in read-only memory, this could really close the door on format
string exposures.

Thanks!

-Kees

>
>  arch/Kconfig                                 |  18 ++
>  drivers/hwmon/applesmc.c                     |   2 +-
>  drivers/staging/speakup/spk_types.h          |   2 +-
>  include/linux/compiler-gcc.h                 |   1 +
>  include/linux/compiler.h                     |  10 +
>  include/linux/kernel.h                       |  13 ++
>  include/linux/smpboot.h                      |   2 +-
>  include/linux/usb.h                          |   2 +-
>  lib/test_printf.c                            |  41 ++++
>  lib/vsprintf.c                               |  63 +++++
>  scripts/Makefile.gcc-plugins                 |   2 +
>  scripts/gcc-plugins/format_template_plugin.c | 331 +++++++++++++++++++++++++++
>  12 files changed, 483 insertions(+), 4 deletions(-)
>  create mode 100644 scripts/gcc-plugins/format_template_plugin.c
>
> --
> 2.11.0
>



-- 
Kees Cook
Pixel Security
