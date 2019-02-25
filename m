From: "Tobin C. Harding" <tobin@kernel.org>
Subject: [PATCH v2 0/1] lib/string: Add strscpy_pad() function
Date: Mon, 25 Feb 2019 15:15:33 +1100
Message-Id: <20190225041534.27186-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Jann Horn <jannh@google.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Randy Dunlap <rdunlap@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Stephen Rothwell <sfr@canb.auug.org.au>, Andy Lutomirski <luto@amacapital.net>, Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Shuah Khan <shuah@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

This patch set was formerly

	Subject: [PATCH 0/6] lib: Add safe string funtions[sic]

And FTR can be seen here:

	https://lkml.org/lkml/2019/2/18/1428


The v1 patch set has been reduced to a single patch by dropping the
strscpy_from_user() stuff and by rolling all the docs changes into the
main patch as suggested.

This patch adds the function strscpy_pad() named after consensus was
reached on the v1 email thread (linked to above).

Thanks to Kees for the extreme test case coverage.  test_basic() is
probably redundant but is left in for the benefit of any poor sucker who
has to debug a regression using test_fully().

The test module is _not_ tied into kselftest.  As discussed on v1, there
are some issues with tools/testing/selftest/lib/ at the moment.  I intend
on working on those issues as suggested but it does not seem totally
relevant to this patch so instead of slowing this one down with my poor
knowledge of how kselftest works it seems better to do this separately. 

thanks for looking at this,
Tobin.


Tobin C. Harding (1):
  lib/string: Add strscpy_pad() function

 include/linux/string.h |   4 +
 lib/Kconfig.debug      |   3 +
 lib/Makefile           |   1 +
 lib/string.c           |  47 +++++++++--
 lib/test_strscpy.c     | 175 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 223 insertions(+), 7 deletions(-)
 create mode 100644 lib/test_strscpy.c

-- 
2.20.1
