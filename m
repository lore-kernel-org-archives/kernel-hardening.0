Message-ID: <1486767569.2192.31.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Fri, 10 Feb 2017 14:59:29 -0800
In-Reply-To: <1486766996.2192.30.camel@perches.com>
References: <1486755469-21573-1-git-send-email-william.c.roberts@intel.com>
	 <1486757549.2192.20.camel@perches.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305C559@ORSMSX103.amr.corp.intel.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305C5BA@ORSMSX103.amr.corp.intel.com>
	 <1486766996.2192.30.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] checkpatch: add warning on %pk instead of %pK usage
To: "Roberts, William C" <william.c.roberts@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, Andew Morton <akpm@linux-foundation.org>
Cc: "keescook@chromium.org" <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 2017-02-10 at 14:49 -0800, Joe Perches wrote:
> On Fri, 2017-02-10 at 22:26 +0000, Roberts, William C wrote:
> > <snip>
> > 
> > > > 
> > > > On Fri, 2017-02-10 at 11:37 -0800, william.c.roberts@intel.com wrote:
> > > > > From: William Roberts <william.c.roberts@intel.com>
> > > > > 
> > > > > Sample output:
> > > > > WARNING: %pk is close to %pK, did you mean %pK?.
> > > > > \#20: FILE: drivers/char/applicom.c:230:
> > > > > +			printk(KERN_INFO "Could not allocate IRQ %d for PCI
> > > > 
> > > > Applicom
> > > > > +device. %pk\n", dev->irq, pci_get_class);
> > > > 
> > > > There isn't a single instance of this in the kernel tree.

Just in case anyone else wondered why this came up.

https://googleprojectzero.blogspot.com/2017/02/lifting-hyper-visor-bypassing-samsungs.html
