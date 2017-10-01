Date: Sun, 1 Oct 2017 11:11:05 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171001001105.GA10409@eros>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1506816410-10230-1-git-send-email-me@tobin.cc>
Subject: Re: [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter
 options
To: Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Oct 01, 2017 at 11:06:44AM +1100, Tobin C. Harding wrote:
> Version 2 of Greg's patch series with changes made as suggested by comments to V1.

Patch set tested by setting /proc/sys/kernel/kptr_restrict and inserting the following module

#include <linux/init.h>
#include <linux/module.h>

#define DRIVER_AUTHOR "Tobin C. Harding <me@tobin.cc>"
#define DRIVER_DESC "Testing module"

static void test_printk(void)
{
	char *ptr = "";

	pr_alert("printing with p: %p\n", ptr);
	pr_alert("printing with pK: %pK\n", ptr);
	pr_alert("printing with pP: %pP\n", ptr);

	pr_alert("printing with pa: %pa\n", ptr);
	pr_alert("printing with pad: %pad\n", ptr);
	pr_alert("printing with pap: %pap\n", ptr);

	pr_alert("printing with paP: %paP\n", ptr);
	pr_alert("printing with padP: %padP\n", ptr);
	pr_alert("printing with papP: %papP\n", ptr);

	pr_alert("printing with pr: %pr\n", ptr);
	pr_alert("printing with pR: %pR\n", ptr);
}

static int hello_init(void)
{
	pr_alert("Hello, world\n");

	test_printk();

	return 0;
}
module_init(hello_init);

static void hello_exit(void)
{
	pr_alert("Goodbye, world\n");
}
module_exit(hello_exit);

MODULE_DESCRIPTION(DRIVER_DESC);
MODULE_AUTHOR(DRIVER_AUTHOR);
MODULE_LICENSE("GPL");
