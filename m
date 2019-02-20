MIME-Version: 1.0
References: <20190218232308.11241-1-tobin@kernel.org> <20190218232308.11241-2-tobin@kernel.org>
In-Reply-To: <20190218232308.11241-2-tobin@kernel.org>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 20 Feb 2019 15:57:18 -0800
Message-ID: <CAGXu5j+ZbNu=6W2Srzbo7aYJZDcR_rRsEbVMOdcKdQXEGs1ZBw@mail.gmail.com>
Subject: Re: [PATCH 1/6] lib/string: Enable string selftesting
Content-Type: text/plain; charset="UTF-8"
To: "Tobin C. Harding" <tobin@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 18, 2019 at 3:24 PM Tobin C. Harding <tobin@kernel.org> wrote:
>
> Currently we have a test module but it is not tied into the kselftest
> infrastructure.  In preparation for adding string manipulation functions
> and testing we should enable kselftest to utilize the test module.
>
> Enable string testing via kselftest infrastructure.
>
> Signed-off-by: Tobin C. Harding <tobin@kernel.org>
> ---
>  lib/Kconfig.debug                     | 14 ++++++++++++++
>  lib/Makefile                          |  2 +-
>  lib/test_string.c                     |  4 ++--
>  tools/testing/selftests/lib/Makefile  |  2 +-
>  tools/testing/selftests/lib/config    |  1 +
>  tools/testing/selftests/lib/string.sh | 19 +++++++++++++++++++
>  6 files changed, 38 insertions(+), 4 deletions(-)
>  create mode 100755 tools/testing/selftests/lib/string.sh
>
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index d4df5b24d75e..0dca64c1d8a4 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1802,8 +1802,22 @@ config ASYNC_RAID6_TEST
>  config TEST_HEXDUMP
>         tristate "Test functions located in the hexdump module at runtime"
>
> +config TEST_STRING
> +       tristate "Perform selftest on string manipulation functions"
> +       default n
> +       help
> +        Enable this option to test string manipulation functions.
> +       Currently this only tests memset_{16,32,64}.
> +
> +       If unsure, say N.
> +
>  config TEST_STRING_HELPERS
>         tristate "Test functions located in the string_helpers module at runtime"
> +       default n
> +       help
> +        Enable this option to unit test code in lib/string_helpers.c
> +
> +        If unsure, say N.
>
>  config TEST_KSTRTOX
>         tristate "Test kstrto*() family of functions at runtime"
> diff --git a/lib/Makefile b/lib/Makefile
> index e1b59da71418..9c30e1fee27f 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -39,7 +39,7 @@ obj-y += bcd.o div64.o sort.o parser.o debug_locks.o random32.o \
>          bsearch.o find_bit.o llist.o memweight.o kfifo.o \
>          percpu-refcount.o rhashtable.o reciprocal_div.o \
>          once.o refcount.o usercopy.o errseq.o bucket_locks.o
> -obj-$(CONFIG_STRING_SELFTEST) += test_string.o
> +obj-$(CONFIG_TEST_STRING) += test_string.o

This patch should remove 'config STRING_SELFTEST' from lib/Kconfig too.

> diff --git a/tools/testing/selftests/lib/Makefile b/tools/testing/selftests/lib/Makefile
> index 70d5711e3ac8..2ee4559b277e 100644
> --- a/tools/testing/selftests/lib/Makefile
> +++ b/tools/testing/selftests/lib/Makefile
> @@ -3,6 +3,6 @@
>  # No binaries, but make sure arg-less "make" doesn't trigger "run_tests"
>  all:
>
> -TEST_PROGS := printf.sh bitmap.sh prime_numbers.sh
> +TEST_PROGS := printf.sh bitmap.sh prime_numbers.sh string.sh
>
>  include ../lib.mk
> diff --git a/tools/testing/selftests/lib/config b/tools/testing/selftests/lib/config
> index 126933bcc950..2032402ad409 100644
> --- a/tools/testing/selftests/lib/config
> +++ b/tools/testing/selftests/lib/config
> @@ -1,3 +1,4 @@
>  CONFIG_TEST_PRINTF=m
>  CONFIG_TEST_BITMAP=m
> +CONFIG_TEST_STRING=m
>  CONFIG_PRIME_NUMBERS=m
> diff --git a/tools/testing/selftests/lib/string.sh b/tools/testing/selftests/lib/string.sh
> new file mode 100755
> index 000000000000..99024b6f3a6a
> --- /dev/null
> +++ b/tools/testing/selftests/lib/string.sh
> @@ -0,0 +1,19 @@
> +#!/bin/sh
> +# SPDX-License-Identifier: GPL-2.0
> +# Runs string manipulation tests using test_string kernel module
> +
> +# Kselftest framework requirement - SKIP code is 4.
> +ksft_skip=4
> +
> +if ! /sbin/modprobe -q -n test_string; then
> +       echo "string: module test_string is not found [SKIP]"
> +       exit $ksft_skip
> +fi
> +
> +if /sbin/modprobe -q test_string; then
> +       /sbin/modprobe -q -r test_string
> +       echo "string: ok"
> +else
> +       echo "string: [FAIL]"
> +       exit 1
> +fi
> --
> 2.20.1
>

You mentioned "redundant scripts" here. You might want to refactor
first, and have a common tool that does the core testing, and then
have the scripts doing one line each:

i.e.:

#!/bin/bash
exec./test_module.sh prime_numbers selftest=65536

with "test_module.sh" doing all the rest.

I bet there are other test_*.ko tests we could wire up too, and this
refactor will make that much easier. And actually, maybe we should
just have a single test running that just reads the "config" file for
the list of test modules, and runs them with the correct output format
to show which are skipped, etc.

-- 
Kees Cook
