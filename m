MIME-Version: 1.0
References: <20190225041534.27186-1-tobin@kernel.org> <20190225041534.27186-2-tobin@kernel.org>
In-Reply-To: <20190225041534.27186-2-tobin@kernel.org>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 25 Feb 2019 13:38:44 -0800
Message-ID: <CAGXu5jJ_OACAt8dmb7QiO9tT4i7+VPJnU+RFCCa98vQEvVsOLw@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] lib/string: Add strscpy_pad() function
Content-Type: text/plain; charset="UTF-8"
To: "Tobin C. Harding" <tobin@kernel.org>
Cc: Jann Horn <jannh@google.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Randy Dunlap <rdunlap@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Stephen Rothwell <sfr@canb.auug.org.au>, Andy Lutomirski <luto@amacapital.net>, Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Shuah Khan <shuah@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Feb 24, 2019 at 8:16 PM Tobin C. Harding <tobin@kernel.org> wrote:
>
> We have a function to copy strings safely and we have a function to copy
> strings and zero the tail of the destination (if source string is
> shorter than destination buffer) but we do not have a function to do
> both at once.  This means developers must write this themselves if they
> desire this functionality.  This is a chore, and also leaves us open to
> off by one errors unnecessarily.
>
> Add a function that calls strscpy() then memset()s the tail to zero if
> the source string is shorter than the destination buffer.
>
> Add test module for the new code.
>
> Signed-off-by: Tobin C. Harding <tobin@kernel.org>
> [...]
> +ssize_t strscpy_pad(char *dest, const char *src, size_t count)
> +{
> +       ssize_t written;
> +
> +       written = strscpy(dest, src, count);
> +       if (written < 0 || written == count - 1)
> +               return written;

*thread merge* Yeah, good point. written will be -E2BIG for both count
= 0 and count = 1.

> +
> +       memset(dest + written + 1, 0, count - written - 1);
> +
> +       return written;
> +}
> +EXPORT_SYMBOL(strscpy_pad);
> +
>  #ifndef __HAVE_ARCH_STRCAT
>  /**
>   * strcat - Append one %NUL-terminated string to another
> diff --git a/lib/test_strscpy.c b/lib/test_strscpy.c
> new file mode 100644
> index 000000000000..5ec6a196f4e2
> --- /dev/null
> +++ b/lib/test_strscpy.c
> @@ -0,0 +1,175 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/printk.h>
> +#include <linux/string.h>
> +
> +/*
> + * Kernel module for testing 'strscpy' family of functions.
> + */
> +
> +static unsigned total_tests __initdata;
> +static unsigned failed_tests __initdata;
> +
> +static void __init do_test(int count, char *src, int expected,
> +                          int chars, int terminator, int pad)
> +{
> +       char buf[6];

I would make this "6" a define, since you use it in more than one
place. Actually... no, never mind. The other places can use
"sizeof(buf)" instead of "6". Noted below...

But I'd add an explicit check for "expected + 1 < sizeof(buf)" just
for future test-addition sanity.

> +       int written;
> +       int poison;
> +       int index;
> +       int i;
> +       const char POISON = 'z';
> +
> +       total_tests++;
> +       memset(buf, POISON, sizeof(buf));
> +
> +       /* Verify the return value */
> +

Needless blank line.

> +       written = strscpy_pad(buf, src, count);
> +       if ((written) != (expected)) {
> +               pr_err("%d != %d (written, expected)\n", written, expected);
> +               goto fail;
> +       }
> +
> +       /* Verify the state of the buffer */
> +

Same.

> +       if (count && written == -E2BIG) {
> +               if (strncmp(buf, src, count - 1) != 0) {
> +                       pr_err("buffer state invalid for -E2BIG\n");
> +                       goto fail;
> +               }
> +               if (buf[count - 1] != '\0') {
> +                       pr_err("too big string is not null terminated correctly\n");
> +                       goto fail;
> +               }
> +       }
> +
> +       /* Verify the copied content */
> +       for (i = 0; i < chars; i++) {
> +               if (buf[i] != src[i]) {
> +                       pr_err("buf[i]==%c != src[i]==%c\n", buf[i], src[i]);
> +                       goto fail;
> +               }
> +       }
> +
> +       /* Verify the null terminator */
> +       if (terminator) {
> +               if (buf[count - 1] != '\0') {
> +                       pr_err("string is not null terminated correctly\n");
> +                       goto fail;
> +               }
> +       }
> +
> +       /* Verify the padding */
> +       for (i = 0; i < pad; i++) {
> +               index = chars + terminator + i;
> +               if (buf[index] != '\0') {
> +                       pr_err("padding missing at index: %d\n", i);
> +                       goto fail;
> +               }
> +       }
> +
> +       /* Verify the rest is left untouched */
> +       poison = 6 - chars - terminator - pad;

instead of "6", use "sizeof(buf)".

> +       for (i = 0; i < poison; i++) {
> +               index = 6 - 1 - i; /* Check from the end back */

Same.

> +               if (buf[index] != POISON) {
> +                       pr_err("poison value missing at index: %d\n", i);
> +                       goto fail;
> +               }
> +       }
> +
> +       return;
> +fail:
> +       pr_info("%s(%d, '%s', %d, %d, %d, %d)\n", __func__,
> +               count, src, expected, chars, terminator, pad);
> +       failed_tests++;
> +}
> +
> +static void __init test_fully(void)
> +{
> +       /* do_test(count, src, expected, chars, terminator, pad) */
> +
> +       do_test(0, "a", -E2BIG, 0, 0, 0);
> +       do_test(0, "", -E2BIG, 0, 0, 0);
> +
> +       do_test(1, "a", -E2BIG, 0, 1, 0);
> +       do_test(1, "", 0, 0, 1, 0);
> +
> +       do_test(2, "ab", -E2BIG, 1, 1, 0);
> +       do_test(2, "a", 1, 1, 1, 0);
> +       do_test(2, "", 0, 0, 1, 1);
> +
> +       do_test(3, "abc", -E2BIG, 2, 1, 0);
> +       do_test(3, "ab", 2, 2, 1, 0);
> +       do_test(3, "a", 1, 1, 1, 1);
> +       do_test(3, "", 0, 0, 1, 2);
> +
> +       do_test(4, "abcd", -E2BIG, 3, 1, 0);
> +       do_test(4, "abc", 3, 3, 1, 0);
> +       do_test(4, "ab", 2, 2, 1, 1);
> +       do_test(4, "a", 1, 1, 1, 2);
> +       do_test(4, "", 0, 0, 1, 3);
> +}
> +
> +static void __init test_basic(void)
> +{
> +       char buf[6];
> +       int written;
> +
> +       memset(buf, 'a', sizeof(buf));
> +
> +       total_tests++;
> +       written = strscpy_pad(buf, "bb", 4);
> +       if (written != 2)
> +               failed_tests++;
> +
> +       /* Correctly copied */
> +       total_tests++;
> +       if (buf[0] != 'b' || buf[1] != 'b')
> +               failed_tests++;
> +
> +       /* Correctly padded */
> +       total_tests++;
> +       if (buf[2] != '\0' || buf[3] != '\0')
> +               failed_tests++;
> +
> +       /* Only touched what it was supposed to */
> +       total_tests++;
> +       if (buf[4] != 'a' || buf[5] != 'a')
> +               failed_tests++;
> +}

I don't think you need to keep "test_basic". Anything it tests can be
rewritten in terms of do_test().

> +
> +static int __init test_strscpy_init(void)
> +{
> +       pr_info("loaded.\n");
> +
> +       test_basic();
> +       if (failed_tests)
> +               goto out;
> +
> +       test_fully();
> +
> +out:
> +       if (failed_tests == 0)
> +               pr_info("all %u tests passed\n", total_tests);
> +       else
> +               pr_warn("failed %u out of %u tests\n", failed_tests, total_tests);
> +
> +       return failed_tests ? -EINVAL : 0;
> +}
> +module_init(test_strscpy_init);
> +
> +static void __exit test_strscpy_exit(void)
> +{
> +       pr_info("unloaded.\n");
> +}
> +module_exit(test_strscpy_exit);
> +
> +MODULE_AUTHOR("Tobin C. Harding <tobin@kernel.org>");
> +MODULE_LICENSE("GPL");
> --
> 2.20.1
>

Otherwise, yes, looks good!

-- 
Kees Cook
