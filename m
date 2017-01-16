Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 16 Jan 2017 17:51:13 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20170116165113.GD29693@kroah.com>
References: <20170116164944.GA28984@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170116164944.GA28984@kroah.com>
Subject: [kernel-hardening] Re: [PATCH 0/4] make call_usermodehelper a bit more "safe"
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Thomas Sailer <t.sailer@alumni.ethz.ch>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, David Howells <dhowells@redhat.com>, NeilBrown <neilb@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 16, 2017 at 05:49:44PM +0100, Greg KH wrote:
> Hi all,
> 
> Here's a second cut at my attempt to make call_usermodehelper a bit more
> "safe".  It includes some patches from my previous series, and one new
> one.  In all, this is a much smaller patchset, with better functionality
> in the end.

And of course, I miscounted the patches, there are only 3 patches in
this series, yet I said 0/4 in this email, sorry about that.

greg k-h
