From: "Tobin C. Harding" <tobin@kernel.org>
Subject: [PATCH v4 0/6] lib/string: Add strscpy_pad() function
Date: Fri,  5 Apr 2019 12:58:53 +1100
Message-Id: <20190405015859.32755-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Shuah Khan <shuah@kernel.org>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Randy Dunlap <rdunlap@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Stephen Rothwell <sfr@canb.auug.org.au>, Andy Lutomirski <luto@amacapital.net>, Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, kernel-hardening@lists.openwall.com, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi Shua,

Here is the set with cleanup as suggested by Kees on v3.

Configured, built, and tested all modules loaded by
tools/testing/selftests/lib/*.sh

>From previous cover letters ...

While doing the testing for strscpy_pad() it was noticed that there is
duplication in how test modules are being fed to kselftest and also in
the test modules themselves.

This set makes an attempt at adding a framework to kselftest for writing
kernel test modules.  It also adds a script for use in creating script
test runners for kselftest.  My macro-foo is not great, all criticism
and suggestions very much appreciated.  The design is based on test
modules lib/test_printf.c, lib/test_bitmap.c, lib/test_xarray.c.

Changes since last version:

 - Remove dependency on Bash (thanks Kees)
 - Use oneliner to implement kselftest test runners (thanks Kees)
 - Squash patch that adds kselftest script creator script with patch
   that uses it. 
 - Fix typos (thanks Randy)
 - Add Kees' Acked-by tags to all patches

thanks,
Tobin.


Tobin C. Harding (6):
  lib/test_printf: Add empty module_exit function
  kselftest: Add test runner creation script
  kselftest: Add test module framework header
  lib: Use new kselftest header
  lib/string: Add strscpy_pad() function
  lib: Add test module for strscpy_pad

 Documentation/dev-tools/kselftest.rst        |  94 +++++++++++-
 include/linux/string.h                       |   4 +
 lib/Kconfig.debug                            |   3 +
 lib/Makefile                                 |   1 +
 lib/string.c                                 |  47 +++++-
 lib/test_bitmap.c                            |  20 +--
 lib/test_printf.c                            |  17 +--
 lib/test_strscpy.c                           | 150 +++++++++++++++++++
 tools/testing/selftests/kselftest_module.h   |  48 ++++++
 tools/testing/selftests/kselftest_module.sh  |  84 +++++++++++
 tools/testing/selftests/lib/Makefile         |   2 +-
 tools/testing/selftests/lib/bitmap.sh        |  18 +--
 tools/testing/selftests/lib/config           |   1 +
 tools/testing/selftests/lib/prime_numbers.sh |  17 +--
 tools/testing/selftests/lib/printf.sh        |  19 +--
 tools/testing/selftests/lib/strscpy.sh       |   3 +
 16 files changed, 440 insertions(+), 88 deletions(-)
 create mode 100644 lib/test_strscpy.c
 create mode 100644 tools/testing/selftests/kselftest_module.h
 create mode 100755 tools/testing/selftests/kselftest_module.sh
 create mode 100755 tools/testing/selftests/lib/strscpy.sh

-- 
2.21.0
