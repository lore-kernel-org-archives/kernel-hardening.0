Message-ID: <1487204389.6214.68.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Wed, 15 Feb 2017 16:19:49 -0800
In-Reply-To: <476DC76E7D1DF2438D32BFADF679FC5623064D3F@ORSMSX103.amr.corp.intel.com>
References: <1486755469-21573-1-git-send-email-william.c.roberts@intel.com>
	 <1486757549.2192.20.camel@perches.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305C559@ORSMSX103.amr.corp.intel.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305C5BA@ORSMSX103.amr.corp.intel.com>
	 <1486766996.2192.30.camel@perches.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305DC7B@ORSMSX103.amr.corp.intel.com>
	 <1486783428.2192.44.camel@perches.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305F372@ORSMSX103.amr.corp.intel.com>
	 <1487016251.6214.6.camel@perches.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305F62F@ORSMSX103.amr.corp.intel.com>
	 <1487024441.6214.12.camel@perches.com>
	 <476DC76E7D1DF2438D32BFADF679FC5623064D3F@ORSMSX103.amr.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] checkpatch: add warning on %pk instead of %pK usage
To: "Roberts, William C" <william.c.roberts@intel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 2017-02-15 at 23:49 +0000, Roberts, William C wrote:
> > 
> > This means _all_ the $stat checks aren't being done on patches that add just a
> > single multi-line statement.
> > 
> > Andrew?  Any thoughts on how to enable $stat appropriately for patch contexts
> > with a single multi-line statement?
> 
> I'm for merging your patch as is, and then take up the fact that $stat is not working correctly
> as a separate change, does that seem reasonable?

Sure, Andrew Morton is the typical upstream path for checkpatch.
(cc'd)

Andy Whitcroft?  Any chance to look at this?
