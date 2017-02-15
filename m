Date: Wed, 15 Feb 2017 22:16:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20170215203347.GA6981@bhelgaas-glaptop.roam.corp.google.com>
Message-ID: <alpine.DEB.2.20.1702152143520.3805@nanos>
References: <20170211013758.3288-1-me@jessfraz.com> <20170211013758.3288-3-me@jessfraz.com> <20170215203347.GA6981@bhelgaas-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v2 3/5] pci: set msi_domain_ops as __ro_after_init
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Jess Frazelle <me@jessfraz.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, Bjorn Helgaas <bhelgaas@google.com>, Keith Busch <keith.busch@intel.com>, "open list:Hyper-V CORE AND DRIVERS" <devel@linuxdriverproject.org>, "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 15 Feb 2017, Bjorn Helgaas wrote:
> We know at build-time what all the function pointers will be, so in
> principle we should be able to make the struct const, which would be
> even better than __ro_after_init.

Not everywhere unfortunately. In some instances it's a runtime decision, but
yes, they could be fixed. But there is a downside in doing this. See below.

> For example, we could require that callers set every function pointer
> before calling pci_msi_create_irq_domain(), using the default ones
> (pci_msi_domain_set_desc, pci_msi_domain_check_cap,
> pci_msi_domain_handle_error) if it doesn't need to override them,
> e.g.,
> 
>   static struct msi_domain_ops vmd_msi_domain_ops = {
>     .get_hwirq = vmd_get_hwirq,
>     .msi_check = pci_msi_domain_check_cap,
>   };
> 
> Or we could leave NULL pointers in the structure and have the code
> that calls through the function pointers check for NULL and call the
> default itself, e.g.,
> 
>   if (ops->msi_check)
>     ops->msi_check(...)
>   else
>     pci_msi_domain_check_cap(...)
> 
> It looks like the "USE_DEF_OPS" framework was added by Jiang Liu with
> the commits below.  I would CC: him for his thoughts, but I don't
> have a current email address.

Me neither :(

I think I suggested to Jiang to do that 'update with default functions' to

- avoid exporting the world and some more

- have the flexibility to add new functions to the ops w/o updating a
  gazillion of existing usage sites, which has saved us lots of chaising in
  the last years

- avoid the if (ops->ptr) ops->ptr(); else default_fn(); constructs all
  over the place.

I admit I did not think about the fact that this makes the structs non
const.

Mopping that up by exporting the default functions and setting all the
function pointers is tedious and requires a full tree sweep when we add new
stuff. There's also code shared between PCI/platform/DT based stuff, so
that becomes interesting.

Doing the if (ops->ptr) ops->ptr() else default_fn(); dance should be
simpler to pull off. There are not that many sites to look at, but then we
have some of the GICv3 code using the domain ops out of core.

For now doing the __ro_after_init is definitely the simplest and fastest
solution to tighten these statically allocated structures.

I have a look with Marc, what can be done in the long run.

Thanks,

	tglx
