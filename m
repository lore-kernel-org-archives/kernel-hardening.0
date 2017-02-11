Message-ID: <1486771260.2192.39.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Fri, 10 Feb 2017 16:01:00 -0800
In-Reply-To: <476DC76E7D1DF2438D32BFADF679FC562305DB6F@ORSMSX103.amr.corp.intel.com>
References: <1486755469-21573-1-git-send-email-william.c.roberts@intel.com>
	 <1486757549.2192.20.camel@perches.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305C559@ORSMSX103.amr.corp.intel.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305C5BA@ORSMSX103.amr.corp.intel.com>
	 <1486766996.2192.30.camel@perches.com>
	  <476DC76E7D1DF2438D32BFADF679FC562305DB6F@ORSMSX103.amr.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] checkpatch: add warning on %pk instead of %pK usage
To: "Roberts, William C" <william.c.roberts@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, Andew Morton <akpm@linux-foundation.org>
Cc: "keescook@chromium.org" <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 2017-02-10 at 23:54 +0000, Roberts, William C wrote:
> > The problem starts to get hairy when we think of how often folks roll their own
> > logging macros (see some small sampling at the end).

It's not just the "hairy" local macros.

In its current form, checkpatch could not find uses like:

	netif_<foo>(x, y, z,
		    "some string with %pk",
		    args);
and
	some_logging_function(arg, "string 1" CONSTANT "string 2", etc...)

if string 2 or CONSTANT had the "%pk" use.

and a bunch of other styles.

This really needs to be verified by the compiler.
