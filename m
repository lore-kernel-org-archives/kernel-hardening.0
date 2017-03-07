Date: Tue, 7 Mar 2017 13:07:31 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
Message-ID: <20170307190731.GD21358@bhelgaas-glaptop.roam.corp.google.com>
References: <20170211013758.3288-1-me@jessfraz.com>
 <20170211013758.3288-3-me@jessfraz.com>
 <20170215203347.GA6981@bhelgaas-glaptop.roam.corp.google.com>
 <alpine.DEB.2.20.1702152143520.3805@nanos>
 <20170216143509.GA22820@bhelgaas-glaptop.roam.corp.google.com>
 <alpine.DEB.2.20.1702161536150.3543@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1702161536150.3543@nanos>
Subject: [kernel-hardening] Re: [PATCH v2 3/5] pci: set msi_domain_ops as __ro_after_init
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jess Frazelle <me@jessfraz.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, Bjorn Helgaas <bhelgaas@google.com>, Keith Busch <keith.busch@intel.com>, "open list:Hyper-V CORE AND DRIVERS" <devel@linuxdriverproject.org>, "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 16, 2017 at 03:38:05PM +0100, Thomas Gleixner wrote:
> On Thu, 16 Feb 2017, Bjorn Helgaas wrote:
> > On Wed, Feb 15, 2017 at 10:16:32PM +0100, Thomas Gleixner wrote:
> > 
> > > I think I suggested to Jiang to do that 'update with default functions' to
> > > 
> > > - avoid exporting the world and some more
> > > 
> > > - have the flexibility to add new functions to the ops w/o updating a
> > >   gazillion of existing usage sites, which has saved us lots of chaising in
> > >   the last years
> > > 
> > > - avoid the if (ops->ptr) ops->ptr(); else default_fn(); constructs all
> > >   over the place.
> > > 
> > > I admit I did not think about the fact that this makes the structs non
> > > const.
> > > 
> > > Mopping that up by exporting the default functions and setting all the
> > > function pointers is tedious and requires a full tree sweep when we add new
> > > stuff. There's also code shared between PCI/platform/DT based stuff, so
> > > that becomes interesting.
> > 
> > It's legal to initialize a field multiple times, and the last one
> > takes precedence, so doing this might at least avoid the full tree
> > sweeps:
> > 
> >   static struct msi_domain_ops vmd_msi_domain_ops = {
> >     MSI_DOMAIN_DEFAULT_OPS,
> >     .get_hwirq = vmd_get_hwirq,
> >   };
> > 
> > The functions referenced by MSI_DOMAIN_DEFAULT_OPS would still have to
> > be exported, though.
> 
> Hmm, that'd work. Though it will fall apart for those pieces where we share
> code across backends. But I did not yet go through all the places and check
> them.
> 
> > > Doing the if (ops->ptr) ops->ptr() else default_fn(); dance should be
> > > simpler to pull off. There are not that many sites to look at, but then we
> > > have some of the GICv3 code using the domain ops out of core.
> > > 
> > > For now doing the __ro_after_init is definitely the simplest and fastest
> > > solution to tighten these statically allocated structures.
> > 
> > I'm OK with __ro_after_init, at least as an interim solution.
> > 
> > I do think it would be good to audit all the uses of
> > MSI_FLAG_USE_DEF_DOM_OPS and MSI_FLAG_USE_DEF_CHIP_OPS, since they
> > seem to be the primary indicator of when the struct might be modified.
> > I suspect we could add __ro_after_init to more than just pci-hyperv.c,
> > vmd.c, and msi.c
> 
> Agreed. I have it on my radar.

This seems like a worthwhile change, so I don't want to just drop this
patch.  But if we're going to do something, I'd like to do it
everywhere that it makes sense, all at the same time.

It looks like the v2 series was split up by subsystem, which is fine
with me.  I'll happily apply the PCI parts (or ack them, since it
might make sense to apply all of them via the same non-PCI tree).

But I *would* like to include the following users of
MSI_FLAG_USE_DEF_DOM_OPS and MSI_FLAG_USE_DEF_CHIP_OPS at the same
time (or explain why __ro_after_init won't work for them):

  pci-xgene-msi.c
  pcie-altera-msi.c
  pcie-iproc-msi.c
  pcie-xilinx-nwl.c

Bjorn
