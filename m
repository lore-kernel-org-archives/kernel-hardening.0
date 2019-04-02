MIME-Version: 1.0
References: <20190306214226.14598-1-tobin@kernel.org> <20190306214226.14598-5-tobin@kernel.org>
In-Reply-To: <20190306214226.14598-5-tobin@kernel.org>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 2 Apr 2019 14:31:09 -0700
Message-ID: <CAGXu5j+Ux+w5KMYvGV+N_ZC-+tMQ=TpM3i5z-p1kCFnF0Ld9eA@mail.gmail.com>
Subject: Re: [PATCH v3 4/7] kselftest: Add test module framework header
Content-Type: text/plain; charset="UTF-8"
To: "Tobin C. Harding" <tobin@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, Jann Horn <jannh@google.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Randy Dunlap <rdunlap@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Stephen Rothwell <sfr@canb.auug.org.au>, Andy Lutomirski <luto@amacapital.net>, Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 6, 2019 at 1:43 PM Tobin C. Harding <tobin@kernel.org> wrote:
>
> kselftest runs as a userspace process.  Sometimes we need to test things
> from kernel space.  One way of doing this is by creating a test module.
> Currently doing so requires developers to write a bunch of boiler plate
> in the module if kselftest is to be used to run the tests.  This means
> we currently have a load of duplicate code to achieve these ends.  If we
> have a uniform method for implementing test modules then we can reduce
> code duplication, ensure uniformity in the test framework, ease code
> maintenance, and reduce the work required to create tests.  This all
> helps to encourage developers to write and run tests.
>
> Add a C header file that can be included in test modules.  This provides
> a single point for common test functions/macros.  Implement a few macros
> that make up the start of the test framework.
>
> Add documentation for new kselftest header and script to kselftest
> documentation.
>
> Signed-off-by: Tobin C. Harding <tobin@kernel.org>

I like this!

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  Documentation/dev-tools/kselftest.rst      | 108 ++++++++++++++++++++-
>  tools/testing/selftests/kselftest_module.h |  48 +++++++++
>  2 files changed, 154 insertions(+), 2 deletions(-)
>  create mode 100644 tools/testing/selftests/kselftest_module.h
>
> diff --git a/Documentation/dev-tools/kselftest.rst b/Documentation/dev-tools/kselftest.rst
> index 7756f7a7c23b..fb7790d47147 100644
> --- a/Documentation/dev-tools/kselftest.rst
> +++ b/Documentation/dev-tools/kselftest.rst
> @@ -14,6 +14,10 @@ in safe mode with a limited scope. In limited mode, cpu-hotplug test is
>  run on a single cpu as opposed to all hotplug capable cpus, and memory
>  hotplug test is run on 2% of hotplug capable memory instead of 10%.
>
> +kselftest runs as a userspace process.  Tests that can be written/run in
> +userspace may wish to use the `Test Harness`_.  Tests that need to be
> +run in kernel space may wish to use a `Test Module`_.
> +
>  Running the selftests (hotplug tests are run in limited mode)
>  =============================================================
>
> @@ -161,11 +165,111 @@ Contributing new tests (details)
>
>     e.g: tools/testing/selftests/android/config
>
> +Test Module
> +===========
> +
> +Kselftest tests the kernel from userspace.  Sometimes things need
> +testing from within the kernel, one method of doing this is to create a
> +test module.  We can tie the module into the kselftest framework by
> +using a shell script test runner.  ``kselftest_module.sh`` is designed
> +to facilitate this process.  There is also a header file provided to
> +assist writing kernel modules that are for use with kselftest:
> +
> +- ``tools/testing/kselftest/kselftest_module.h``
> +- ``tools/testing/kselftest/kselftest_module.sh``
> +
> +How to use
> +----------
> +
> +Here we show the typical steps to create a test module and tie it into
> +kselftest.  We use kselftests for lib/ as an example.
> +
> +1. Create the test module
> +
> +2. Create the test script that will run (load/unload) the module
> +   e.g. ``tools/testing/selftests/lib/printf.sh``
> +
> +3. Add line to config file e.g. ``tools/testing/selftests/lib/config``
> +
> +4. Add test script to makefile  e.g. ``tools/testing/selftests/lib/Makefile``
> +
> +5. Verify it works:
> +
> +.. code-block:: sh
> +
> +   # Assumes you have booted a fresh build of this kernel tree
> +   cd /path/to/linux/tree
> +   make kselftest-merge
> +   make modules
> +   sudo make modules_install
> +   make TARGETS=lib kselftest
> +
> +Example Module
> +--------------
> +
> +A bare bones test module might look like this:
> +
> +.. code-block:: c
> +
> +   // SPDX-License-Identifier: GPL-2.0+
> +
> +   #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +   #include "../tools/testing/selftests/kselftest_module.h"
> +
> +   KSTM_MODULE_GLOBALS();
> +
> +   /*
> +    * Kernel module for testing the foobinator
> +    */
> +
> +   static int __init test_function()
> +   {
> +           ...
> +   }
> +
> +   static void __init selftest(void)
> +   {
> +           KSTM_CHECK_ZERO(do_test_case("", 0));
> +   }
> +
> +   KSTM_MODULE_LOADERS(test_foo);
> +   MODULE_AUTHOR("John Developer <jd@fooman.org>");
> +   MODULE_LICENSE("GPL");
> +
> +Example test script
> +-------------------
> +
> +.. code-block:: sh
> +
> +    #!/bin/bash
> +    # SPDX-License-Identifier: GPL-2.0+
> +
> +    module_name="test_foo"             # Module name (without the .ko).
> +    description="foo"                  # Output prefix.
> +
> +    #
> +    # Shouldn't need to edit anything below here.
> +    #
> +
> +    file="kselftest_module.sh"
> +    path="../$file"
> +    if [[ ! $KBUILD_SRC == "" ]]; then
> +        path="${KBUILD_SRC}/tools/testing/selftests/$file"
> +    fi
> +
> +    $path $module_name $description
> +
> +
>  Test Harness
>  ============
>
> -The kselftest_harness.h file contains useful helpers to build tests.  The tests
> -from tools/testing/selftests/seccomp/seccomp_bpf.c can be used as example.
> +The kselftest_harness.h file contains useful helpers to build tests.  The
> +test harness is for userspace testing, for kernel space testing see `Test
> +Module`_ above.
> +
> +The tests from tools/testing/selftests/seccomp/seccomp_bpf.c can be used as
> +example.
>
>  Example
>  -------
> diff --git a/tools/testing/selftests/kselftest_module.h b/tools/testing/selftests/kselftest_module.h
> new file mode 100644
> index 000000000000..e8eafaf0941a
> --- /dev/null
> +++ b/tools/testing/selftests/kselftest_module.h
> @@ -0,0 +1,48 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +#ifndef __KSELFTEST_MODULE_H
> +#define __KSELFTEST_MODULE_H
> +
> +#include <linux/module.h>
> +
> +/*
> + * Test framework for writing test modules to be loaded by kselftest.
> + * See Documentation/dev-tools/kselftest.rst for an example test module.
> + */
> +
> +#define KSTM_MODULE_GLOBALS()                  \
> +static unsigned int total_tests __initdata;    \
> +static unsigned int failed_tests __initdata
> +
> +#define KSTM_CHECK_ZERO(x) do {                                                \
> +       total_tests++;                                                  \
> +       if (x) {                                                        \
> +               pr_warn("TC failed at %s:%d\n", __func__, __LINE__);    \
> +               failed_tests++;                                         \
> +       }                                                               \
> +} while (0)
> +
> +static inline int kstm_report(unsigned int total_tests, unsigned int failed_tests)
> +{
> +       if (failed_tests == 0)
> +               pr_info("all %u tests passed\n", total_tests);
> +       else
> +               pr_warn("failed %u out of %u tests\n", failed_tests, total_tests);
> +
> +       return failed_tests ? -EINVAL : 0;
> +}
> +
> +#define KSTM_MODULE_LOADERS(__module)                  \
> +static int __init __module##_init(void)                        \
> +{                                                      \
> +       pr_info("loaded.\n");                           \
> +       selftest();                                     \
> +       return kstm_report(total_tests, failed_tests);  \
> +}                                                      \
> +static void __exit __module##_exit(void)               \
> +{                                                      \
> +       pr_info("unloaded.\n");                         \
> +}                                                      \
> +module_init(__module##_init);                          \
> +module_exit(__module##_exit)
> +
> +#endif /* __KSELFTEST_MODULE_H */
> --
> 2.20.1
>


-- 
Kees Cook
