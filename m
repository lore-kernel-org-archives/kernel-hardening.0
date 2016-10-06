Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 6 Oct 2016 06:31:47 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20161006133147.GA20206@infradead.org>
References: <1475690686-16138-1-git-send-email-william.c.roberts@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1475690686-16138-1-git-send-email-william.c.roberts@intel.com>
Subject: [kernel-hardening] Re: [PATCH] printk: introduce kptr_restrict level 3
To: william.c.roberts@intel.com
Cc: kernel-hardening@lists.openwall.com, corbet@lwn.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 05, 2016 at 02:04:46PM -0400, william.c.roberts@intel.com wrote:
> From: William Roberts <william.c.roberts@intel.com>
> 
> Some out-of-tree modules do not use %pK and just use %p, as it's
> the common C paradigm for printing pointers. Because of this,
> kptr_restrict has no affect on the output and thus, no way to
> contain the kernel address leak.

So what?  We a) don't care about out of tree modules and b) you could
just triviall fix them up if you care.

No need to bloat the kernel with crap like this.
