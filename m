Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 21 Jan 2016 16:18:05 +0100 (CET)
From: Jiri Kosina <jikos@kernel.org>
In-Reply-To: <20160120180447.GA31532@kroah.com>
Message-ID: <alpine.LRH.2.00.1601211617380.18746@gjva.wvxbf.pm>
References: <20160119112812.GA10818@mwanda> <1453221128.3734.26.camel@decadent.org.uk> <20160119175409.GB7485@kroah.com> <1453309539.3734.52.camel@decadent.org.uk> <20160120180447.GA31532@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: Re: [kernel-hardening] 2015 kernel CVEs
To: Greg KH <greg@kroah.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 20 Jan 2016, Greg KH wrote:

> Except for those drivers that abuse the HID interface due to the 
> decisions the Windows developers made years ago, and are not reall HID 
> devices, those should all be done in userspace, just like Windows does. 
> Hopefully we have been good in keeping those types of drivers out of the 
> kernel.

This has been one of the motivations for creating hidraw interface. So my 
hope here is that we're doing reasonably well in this respect.

-- 
Jiri Kosina
SUSE Labs
