From: "Tobin C. Harding" <tobin@kernel.org>
Subject: [PATCH v3 0/7] lib/string: Add strscpy_pad() function
Date: Thu,  7 Mar 2019 08:42:19 +1100
Message-Id: <20190306214226.14598-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Kees Cook <keescook@chromium.org>, Shuah Khan <shuah@kernel.org>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Jann Horn <jannh@google.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Randy Dunlap <rdunlap@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Stephen Rothwell <sfr@canb.auug.org.au>, Andy Lutomirski <luto@amacapital.net>, Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, kernel-hardening@lists.openwall.com, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

strscpy_pad() patch set now with added test shenanigans. 

This version adds 5 initial patches to the set and splits the single
patch from v2 into two separate patches (6 and 7).

While doing the testing for strscpy_pad() it was noticed that there is
duplication in how test modules are being fed to kselftest and also in
the test modules themselves.

This set makes an attempt at adding a framework to kselftest for writing
kernel test modules.  It also adds a script for use in creating script
test runners for kselftest.  My macro-foo is not great, all criticism
and suggestions very much appreciated.  The design is based on test
modules lib/test_printf.c, lib/test_bitmap.c, lib/test_xarray.c. 

Shua, I'm by no means a kselftest expert, if this approach does not fit
in with your general direction please say so.

Kees, I put the strscpy_pad() addition patch separate so if this goes in
through Shua's tree (and if it goes in at all) its a single patch to
grab if we want to start playing around with strscpy_pad().

 
Patch 1 fixes module unload for lib/test_printf in preparation for the
        rest of the series.

Patch 2 Adds a shell script that can be used to create shell script test
        runners. 

Patch 3 Converts current shell script runners in
        tools/testing/selftests/lib/ to use the script introduced in
        patch 2.

Patch 4 Adds the test framework by way of a header file (inc. documentation)

Patch 5 Converts a couple of current test modules to make some use of
        the newly added test framework.

Patch 6 Adds strscpy_pad()

Patch 7 Adds test module for strscpy_pad() using the new framework and script.


If you are a testing geek and you would like to play with this; if you
are already running a kernel built recently from your tree you may
want to just apply the first 5 patches then you don't need to build/boot
a new kernel, just config and build the lib/ test modules (test_printf
etc.) and then:

	sudo make TARGETS=lib kselftest

Late in the development of this I found that a bunch of boiler plate had
to be added to the script to handle running tests with:

	make O=/path/to/kout kselftest

The reason is that during the build we are in the output directory but
the script is in the source directory.  I get the feeling that a better
understanding of how the kernel build process works would provide a
better solution to this.  The current solution is disappointing since
removing duplication and boiler plate was the point of the whole
exercise.  I'd love a better way to solve this?

One final interesting note: there are 36 test modules in lib/ only 3 of
them are run by kselftest from tools/testing/selfests/lib?


Thanks for looking at this,
Tobin.



Tobin C. Harding (7):
  lib/test_printf: Add empty module_exit function
  kselftest: Add test runner creation script
  kselftest/lib: Use new shell runner to define tests
  kselftest: Add test module framework header
  lib: Use new kselftest header
  lib/string: Add strscpy_pad() function
  lib: Add test module for strscpy_pad

 Documentation/dev-tools/kselftest.rst        | 108 ++++++++++++-
 include/linux/string.h                       |   4 +
 lib/Kconfig.debug                            |   3 +
 lib/Makefile                                 |   1 +
 lib/string.c                                 |  47 +++++-
 lib/test_bitmap.c                            |  20 +--
 lib/test_printf.c                            |  17 +--
 lib/test_strscpy.c                           | 150 +++++++++++++++++++
 tools/testing/selftests/kselftest_module.h   |  48 ++++++
 tools/testing/selftests/kselftest_module.sh  |  75 ++++++++++
 tools/testing/selftests/lib/Makefile         |   2 +-
 tools/testing/selftests/lib/bitmap.sh        |  25 ++--
 tools/testing/selftests/lib/config           |   1 +
 tools/testing/selftests/lib/prime_numbers.sh |  23 ++-
 tools/testing/selftests/lib/printf.sh        |  25 ++--
 tools/testing/selftests/lib/strscpy.sh       |  17 +++
 16 files changed, 490 insertions(+), 76 deletions(-)
 create mode 100644 lib/test_strscpy.c
 create mode 100644 tools/testing/selftests/kselftest_module.h
 create mode 100755 tools/testing/selftests/kselftest_module.sh
 create mode 100755 tools/testing/selftests/lib/strscpy.sh

-- 
2.20.1
