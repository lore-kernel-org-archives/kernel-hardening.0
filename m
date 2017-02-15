Date: Wed, 15 Feb 2017 14:33:47 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
Message-ID: <20170215203347.GA6981@bhelgaas-glaptop.roam.corp.google.com>
References: <20170211013758.3288-1-me@jessfraz.com>
 <20170211013758.3288-3-me@jessfraz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170211013758.3288-3-me@jessfraz.com>
Subject: [kernel-hardening] Re: [PATCH v2 3/5] pci: set msi_domain_ops as __ro_after_init
To: Jess Frazelle <me@jessfraz.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, Bjorn Helgaas <bhelgaas@google.com>, Keith Busch <keith.busch@intel.com>, "open list:Hyper-V CORE AND DRIVERS" <devel@linuxdriverproject.org>, "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Marc Zyngier <marc.zyngier@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

[+cc Kees, Thomas, Marc]

Hi Jess,

Thanks for the patch!

On Fri, Feb 10, 2017 at 05:37:56PM -0800, Jess Frazelle wrote:
> Marked msi_domain_ops structs as __ro_after_init when called only during init.
> This protects the data structure from accidental corruption.
> 
> Suggested-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Jess Frazelle <me@jessfraz.com>
> ---
>  drivers/pci/host/pci-hyperv.c | 2 +-
>  drivers/pci/host/vmd.c        | 2 +-
>  drivers/pci/msi.c             | 2 +-

I understand the value of __ro_after_init, but I'm not certain about
sprinkling it around in seemingly random places because it's hard to
know where to put it and whether we put it in all the right places.

How did you choose these three files to change?  There are other
instances of struct msi_domain_ops that use MSI_FLAG_USE_DEF_DOM_OPS.
Should they be changed, too?  If not, is there a rule to figure out
which ones should be made __ro_after_init?

I wonder if adding __ro_after_init is really the best solution.  I
looked at VMD to see how vmd_msi_domain_ops is updated.  Here are the
definitions:

  static struct msi_domain_ops vmd_msi_domain_ops = {
    .get_hwirq = vmd_get_hwirq,
    .msi_init  = vmd_msi_init,
    ...
  };

  static struct msi_domain_info vmd_msi_domain_info = {
    .flags = MSI_FLAG_USE_DEF_DOM_OPS | MSI_FLAG_USE_DEF_CHIP_OPS |
             MSI_FLAG_PCI_MSIX,
    .ops = &vmd_msi_domain_ops,
    ...
  };

Both vmd_msi_domain_ops and vmd_msi_domain_info are statically
initialized, but not completely.  Then we pass a pointer to
pci_msi_create_irq_domain(), which fills in defaults for some of the
function pointers that weren't statically initialized:

  vmd_enable_domain()
    pci_msi_create_irq_domain(NULL, &vmd_msi_domain_info, ...)
      if (info->flags & MSI_FLAG_USE_DEF_DOM_OPS)
        pci_msi_domain_update_dom_ops(info)
	  if (ops->set_desc == NULL)
	    ops->msi_check = pci_msi_domain_check_cap

We know at build-time what all the function pointers will be, so in
principle we should be able to make the struct const, which would be
even better than __ro_after_init.

For example, we could require that callers set every function pointer
before calling pci_msi_create_irq_domain(), using the default ones
(pci_msi_domain_set_desc, pci_msi_domain_check_cap,
pci_msi_domain_handle_error) if it doesn't need to override them,
e.g.,

  static struct msi_domain_ops vmd_msi_domain_ops = {
    .get_hwirq = vmd_get_hwirq,
    .msi_check = pci_msi_domain_check_cap,
  };

Or we could leave NULL pointers in the structure and have the code
that calls through the function pointers check for NULL and call the
default itself, e.g.,

  if (ops->msi_check)
    ops->msi_check(...)
  else
    pci_msi_domain_check_cap(...)

It looks like the "USE_DEF_OPS" framework was added by Jiang Liu with
the commits below.  I would CC: him for his thoughts, but I don't
have a current email address.

  aeeb59657c35 ("genirq: Provide default callbacks for msi_domain_ops")
  3878eaefb89a ("PCI/MSI: Enhance core to support hierarchy irqdomain")

Bjorn

>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/host/pci-hyperv.c b/drivers/pci/host/pci-hyperv.c
> index 3efcc7bdc5fb..f05b93689d8f 100644
> --- a/drivers/pci/host/pci-hyperv.c
> +++ b/drivers/pci/host/pci-hyperv.c
> @@ -958,7 +958,7 @@ static irq_hw_number_t hv_msi_domain_ops_get_hwirq(struct msi_domain_info *info,
>  	return arg->msi_hwirq;
>  }
> 
> -static struct msi_domain_ops hv_msi_ops = {
> +static struct msi_domain_ops hv_msi_ops __ro_after_init = {
>  	.get_hwirq	= hv_msi_domain_ops_get_hwirq,
>  	.msi_prepare	= pci_msi_prepare,
>  	.set_desc	= pci_msi_set_desc,
> diff --git a/drivers/pci/host/vmd.c b/drivers/pci/host/vmd.c
> index 18ef1a93c10a..152c461538e4 100644
> --- a/drivers/pci/host/vmd.c
> +++ b/drivers/pci/host/vmd.c
> @@ -253,7 +253,7 @@ static void vmd_set_desc(msi_alloc_info_t *arg, struct msi_desc *desc)
>  	arg->desc = desc;
>  }
> 
> -static struct msi_domain_ops vmd_msi_domain_ops = {
> +static struct msi_domain_ops vmd_msi_domain_ops __ro_after_init = {
>  	.get_hwirq	= vmd_get_hwirq,
>  	.msi_init	= vmd_msi_init,
>  	.msi_free	= vmd_msi_free,
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index 50c5003295ca..93141d5e2d1c 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -1413,7 +1413,7 @@ static void pci_msi_domain_set_desc(msi_alloc_info_t *arg,
>  #define pci_msi_domain_set_desc		NULL
>  #endif
> 
> -static struct msi_domain_ops pci_msi_domain_ops_default = {
> +static struct msi_domain_ops pci_msi_domain_ops_default __ro_after_init = {
>  	.set_desc	= pci_msi_domain_set_desc,
>  	.msi_check	= pci_msi_domain_check_cap,
>  	.handle_error	= pci_msi_domain_handle_error,
> --
> 2.11.0
> 
