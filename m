Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 6 Oct 2016 06:56:12 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20161006135612.GA21342@infradead.org>
References: <1475690686-16138-1-git-send-email-william.c.roberts@intel.com>
 <20161006133147.GA20206@infradead.org>
 <476DC76E7D1DF2438D32BFADF679FC561CD14651@ORSMSX103.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476DC76E7D1DF2438D32BFADF679FC561CD14651@ORSMSX103.amr.corp.intel.com>
Subject: [kernel-hardening] Re: [PATCH] printk: introduce kptr_restrict level 3
To: "Roberts, William C" <william.c.roberts@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "corbet@lwn.net" <corbet@lwn.net>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 06, 2016 at 01:47:47PM +0000, Roberts, William C wrote:
> Out of tree modules still affect core kernel security.

So don't use them.

> I would also bet money, that somewhere
> In-tree someone has put a %p when they wanted a %pK.

So fix them.

> So this method is just quite error
> prone. We currently have a blacklist approach versus whitelist.

Or fix the entire thing, get rid of %pK and always protect %p if you
can show that it doesn't break anything.

But stop posting patches with bullshit arguments like out of tree
modules.
