Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 19 Jan 2016 09:54:09 -0800
From: Greg KH <greg@kroah.com>
Message-ID: <20160119175409.GB7485@kroah.com>
References: <20160119112812.GA10818@mwanda>
 <1453221128.3734.26.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1453221128.3734.26.camel@decadent.org.uk>
Subject: Re: [kernel-hardening] 2015 kernel CVEs
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 19, 2016 at 04:32:08PM +0000, Ben Hutchings wrote:
> As for USB descriptors, I'm somewhat more hopeful about hardening.  At
> the same time, it seems like it should be practical to put more low-
> performance USB drivers into userspace.

What drivers do we currently have in the kernel that should/could be
done in userspace instead?  I'll gladly drop them from the tree.

And yes, we need to do better about handling crazy USB descriptors, I
think the majority of this work is already done, but it takes
hand-auditing to verify it :(

thanks,

greg k-h
