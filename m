Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 20 Jan 2016 10:04:47 -0800
From: Greg KH <greg@kroah.com>
Message-ID: <20160120180447.GA31532@kroah.com>
References: <20160119112812.GA10818@mwanda>
 <1453221128.3734.26.camel@decadent.org.uk>
 <20160119175409.GB7485@kroah.com>
 <1453309539.3734.52.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1453309539.3734.52.camel@decadent.org.uk>
Subject: Re: [kernel-hardening] 2015 kernel CVEs
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 20, 2016 at 05:05:39PM +0000, Ben Hutchings wrote:
> On Tue, 2016-01-19 at 09:54 -0800, Greg KH wrote:
> > On Tue, Jan 19, 2016 at 04:32:08PM +0000, Ben Hutchings wrote:
> > > As for USB descriptors, I'm somewhat more hopeful about hardening.  At
> > > the same time, it seems like it should be practical to put more low-
> > > performance USB drivers into userspace.
> > 
> > What drivers do we currently have in the kernel that should/could be
> > done in userspace instead?  I'll gladly drop them from the tree.
> 
> An obvious example would be HID drivers.  (I'll grant you that putting
> those in user-space would complicate the boot process when a disk
> encryption passphrase is needed.)

That and for userspace that expects to get an input device stream,
combining serial, ps2, bluetooth, and USB devices all at the same time.
So while it might be possible, keeping input devices and HID support in
the kernel makes sense.

Except for those drivers that abuse the HID interface due to the
decisions the Windows developers made years ago, and are not reall HID
devices, those should all be done in userspace, just like Windows does.
Hopefully we have been good in keeping those types of drivers out of the
kernel.

thanks,

greg k-h
