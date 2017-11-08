From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date: Wed,  8 Nov 2017 23:30:14 +0100
Message-Id: <20171108223020.24487-1-linux@rasmusvillemoes.dk>
Subject: [kernel-hardening] [RFC 0/6] some compile- and run-time format checking
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
List-ID: <kernel-hardening.lists.openwall.com>

Consider these strictly RFC/POC.

I tried resurrecting my format_template plugin from two years ago, and
it rebased pretty cleanly. It also compiles with gcc 6.3, and has the
expected effect when one tries to trigger it, so it seems to work ok
(I think there was some build bot issue back then, maybe there still
is).

The last four patches are something I threw together rather quickly.
They compile and the few test cases pass, but I obviously need to find
some places to actually use fmtcheck() to see if it's worth adding.

Rasmus Villemoes (6):
  plugins: implement format_template attribute
  compiler.h: add __format_template
  compiler.h: add __attribute__((format_arg)) shorthand
  lib/vsprintf.c: add fmtcheck utility
  kernel.h: implement fmtmatch() wrapper around fmtcheck()
  lib/test_printf.c: add a few fmtcheck() test cases

 arch/Kconfig                                 |  18 ++
 drivers/hwmon/applesmc.c                     |   2 +-
 drivers/staging/speakup/spk_types.h          |   2 +-
 include/linux/compiler-gcc.h                 |   1 +
 include/linux/compiler.h                     |  10 +
 include/linux/kernel.h                       |  13 ++
 include/linux/smpboot.h                      |   2 +-
 include/linux/usb.h                          |   2 +-
 lib/test_printf.c                            |  41 ++++
 lib/vsprintf.c                               |  63 +++++
 scripts/Makefile.gcc-plugins                 |   2 +
 scripts/gcc-plugins/format_template_plugin.c | 331 +++++++++++++++++++++++++++
 12 files changed, 483 insertions(+), 4 deletions(-)
 create mode 100644 scripts/gcc-plugins/format_template_plugin.c

-- 
2.11.0
