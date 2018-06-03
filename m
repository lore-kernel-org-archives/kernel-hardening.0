Date: Sun, 3 Jun 2018 15:37:35 +0200
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Nethammer and kernel network drivers
Message-ID: <20180603133735.GA10274@kroah.com>
References: <078f9b83-44d9-e7b2-6608-41a88e23b63e@riseup.net>
 <20180602094327.GA16667@kroah.com>
 <db41b7e2-cf14-51e3-a2f7-12cffc467bdf@riseup.net>
 <617047d2-8bdd-fc57-d3b1-f1404138c474@riseup.net>
 <20180603063130.GA28847@kroah.com>
 <4b4c83d9-832d-dfd1-ee4a-3aba78edab50@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b4c83d9-832d-dfd1-ee4a-3aba78edab50@riseup.net>
To: procmem <procmem@riseup.net>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 03, 2018 at 01:23:28PM +0000, procmem wrote:
> 
> 
> Greg KH:
> > On Sat, Jun 02, 2018 at 05:41:09PM +0000, procmem wrote:
> >> Hello. Daniel provided more details on the problematic areas of the
> >> kernel and I quote what he said verbatim:
> >>
> >>
> >>> We have only found very outdated network drivers using clflush (old
> >>> windows ndis code). On ARM there are many drivers using uncached memory.
> >>> However, we have so far failed to produce enough memory traffic on ARM
> >>> to trigger a bit flip with Nethammer on any ARM device.
> >>> It should be possible though if you can make the ARM device handle
> >>>> =300MBit/s.
> >>> And that's the most plausible scenario.
> >>>
> >>> Anyway, searching for clflush or use of uncached memory is a good idea
> >>> to locate the critical spots.
> >>>
> >>> Intel CAT is (we believe) not used anywhere yet. And we must be careful
> >>> when it gets to the point where we introduce usage of CAT for QoS
> >>> mechanisms.
> >>>
> >>> However, my intuition tells me that most systems are not even vulnerable
> >>> to Rowhammer in the first place. Although the only prevalence studies we
> >>> have suggest otherwise (they find 60-80% are affected).
> >
> > So Linux is not vulnerable to this at all?  That's good to know, thanks
> > for following up with this.
> >
> > greg k-h
> >
> 
> I interpreted this to mean that there is a major problem with ARM
> drivers but the only backstop is the current gen of hardware being
> underpowered.

Really?  There are ARM servers now that can do really fast networking,
yet those drivers do not seem to have this problem from what I can see.
Am I missing something here?

> Also it would be best to put a kernel comment about sec implications
> of Intel CAT for those who want to enable/use it IMHO.

Patches are always gladly accepted :)

thanks,

greg k-h
