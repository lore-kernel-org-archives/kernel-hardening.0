From: "Tobin C. Harding" <me@tobin.cc>
Subject: [RFC 0/2] add macro VLA_SAFE
Date: Wed,  7 Mar 2018 16:27:29 +1100
Message-Id: <1520400451-11475-1-git-send-email-me@tobin.cc>
To: Kernel Hardening <kernel-hardening@lists.openwall.com>, Tycho Andersen <tycho@tycho.ws>
Cc: "Tobin C. Harding" <me@tobin.cc>, Kees Cook <keescook@chromium.org>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>, James Simmons <jsimmons@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

We would like to get rid of VLAs all together from the kernel but in the
mean time we can make their usage safer.

Patch 1 defines a macro for declaring a VLA.
Patch 2 shows example usage.

There are a number of issues with this set

1. It is opt-in security - that's bad.
2. The compiler still warns for VLA use.


thanks,
Tobin.


Tested with a test module - I'm not really sure if this sort of test
module should go into the kernel (in general I mean).  Posting here for
comment.

/*
 * Tests for VLA macro.
 */

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/printk.h>

/* newly added header file */
/* #include <linux/vla.h> */
#include "vla.h"

#define MAX_VLA_SIZE 32

static unsigned total_tests __initdata;
static unsigned failed_tests __initdata;

/* verify there are no compiler warnings */
static void __init verify_declaration(void)
{
	int size = 10;
	VLA_SAFE(int, myvla, size, VLA_DEFAULT_MAX);
	int dummy;

	VLA_WARN_OVERSIZE(myvla, size);

	/* quiet compiler */
	dummy = 1;
	myvla[0] = 'a';

}

static int __init test_vla_less_than_max(void)
{
	int want = MAX_VLA_SIZE / 2;
	VLA_SAFE(char, myvla, want, MAX_VLA_SIZE);
	int got = sizeof(myvla);

	total_tests++;

	if (want != got) {
		pr_warn("VLA_SAFE() declaration error: want=%d got=%d max=%d\n",
			want, got, MAX_VLA_SIZE);
		return 1;
	}

	/* quiet compiler warning */
	myvla[0] = 'a';

	return 0;
}

static int __init test_vla_greater_than_max(void)
{
	int want = MAX_VLA_SIZE * 2;
	VLA_SAFE(char, myvla, want, MAX_VLA_SIZE);
	int got = sizeof(myvla);

	total_tests++;

	if (got != MAX_VLA_SIZE) {
		pr_warn("VLA_SAFE() declaration error: want=%d got=%d max=%d\n",
			want, got, MAX_VLA_SIZE);
		return 1;
	}

	/* quiet compiler warning */
	myvla[0] = 'a';

	return 0;
}

static void __init test_vla_int_type_usage(void)
{
	int size = 100;
	VLA_SAFE(int, myvla, size, MAX_VLA_SIZE);
	int i;

	total_tests++;

	for (i = 0; i < size; i++)
		myvla[i] = 0;
}

static int __init test_vla_init(void)
{


	int err;

	verify_declaration();

	err = test_vla_less_than_max();
	if (err)
		failed_tests++;

	err = test_vla_greater_than_max();
	if (err)
		failed_tests++;

	test_vla_int_type_usage();

	if (failed_tests == 0)
		pr_info("all %u tests passed\n", total_tests);
	else
		pr_warn("failed %u out of %u tests\n",
			failed_tests, total_tests);

	return failed_tests ? -EINVAL : 0;
}
module_init(test_vla_init);

static void hello_exit(void)
{
	pr_alert("Removing module: vla\n");
}
module_exit(hello_exit);

MODULE_AUTHOR("Tobin C. Harding <me@tobin.cc>");
MODULE_LICENSE("GPL");


Tobin C. Harding (2):
  vla: define new safe vla macros
  lustre: use VLA_SAFE

 drivers/staging/lustre/lustre/llite/xattr.c |  4 +++-
 include/linux/vla.h                         | 15 +++++++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/vla.h

-- 
2.7.4
