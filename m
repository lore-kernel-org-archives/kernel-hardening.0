From: KY Srinivasan <kys@microsoft.com>
Date: Sun, 12 Feb 2017 04:08:24 +0000
Message-ID: <DM5PR03MB2490F0970E353CACB9D201F5A0460@DM5PR03MB2490.namprd03.prod.outlook.com>
References: <20170211013758.3288-1-me@jessfraz.com>
 <20170211013758.3288-3-me@jessfraz.com>
In-Reply-To: <20170211013758.3288-3-me@jessfraz.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [PATCH v2 3/5] pci: set msi_domain_ops as __ro_after_init
To: Jess Frazelle <me@jessfraz.com>, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, Bjorn Helgaas <bhelgaas@google.com>, Keith Busch <keith.busch@intel.com>, "open
 list:Hyper-V CORE AND DRIVERS" <devel@linuxdriverproject.org>, "open list:PCI
 SUBSYSTEM" <linux-pci@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>



> -----Original Message-----
> From: Jess Frazelle [mailto:me@jessfraz.com]
> Sent: Friday, February 10, 2017 5:38 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; Bjorn Helgaas <bhelgaas@google.com>; Keith
> Busch <keith.busch@intel.com>; open list:Hyper-V CORE AND DRIVERS
> <devel@linuxdriverproject.org>; open list:PCI SUBSYSTEM <linux-
> pci@vger.kernel.org>; open list <linux-kernel@vger.kernel.org>
> Cc: kernel-hardening@lists.openwall.com; Jess Frazelle <me@jessfraz.com>
> Subject: [PATCH v2 3/5] pci: set msi_domain_ops as __ro_after_init
>=20
> Marked msi_domain_ops structs as __ro_after_init when called only during
> init.
> This protects the data structure from accidental corruption.
>=20
> Suggested-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Jess Frazelle <me@jessfraz.com>

Acked-by: K. Y. Srinivasan <kys@microsoft.com>

K. Y

> ---
>  drivers/pci/host/pci-hyperv.c | 2 +-
>  drivers/pci/host/vmd.c        | 2 +-
>  drivers/pci/msi.c             | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/pci/host/pci-hyperv.c b/drivers/pci/host/pci-hyperv.=
c
> index 3efcc7bdc5fb..f05b93689d8f 100644
> --- a/drivers/pci/host/pci-hyperv.c
> +++ b/drivers/pci/host/pci-hyperv.c
> @@ -958,7 +958,7 @@ static irq_hw_number_t
> hv_msi_domain_ops_get_hwirq(struct msi_domain_info *info,
>  	return arg->msi_hwirq;
>  }
>=20
> -static struct msi_domain_ops hv_msi_ops =3D {
> +static struct msi_domain_ops hv_msi_ops __ro_after_init =3D {
>  	.get_hwirq	=3D hv_msi_domain_ops_get_hwirq,
>  	.msi_prepare	=3D pci_msi_prepare,
>  	.set_desc	=3D pci_msi_set_desc,
> diff --git a/drivers/pci/host/vmd.c b/drivers/pci/host/vmd.c
> index 18ef1a93c10a..152c461538e4 100644
> --- a/drivers/pci/host/vmd.c
> +++ b/drivers/pci/host/vmd.c
> @@ -253,7 +253,7 @@ static void vmd_set_desc(msi_alloc_info_t *arg,
> struct msi_desc *desc)
>  	arg->desc =3D desc;
>  }
>=20
> -static struct msi_domain_ops vmd_msi_domain_ops =3D {
> +static struct msi_domain_ops vmd_msi_domain_ops __ro_after_init =3D {
>  	.get_hwirq	=3D vmd_get_hwirq,
>  	.msi_init	=3D vmd_msi_init,
>  	.msi_free	=3D vmd_msi_free,
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index 50c5003295ca..93141d5e2d1c 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -1413,7 +1413,7 @@ static void
> pci_msi_domain_set_desc(msi_alloc_info_t *arg,
>  #define pci_msi_domain_set_desc		NULL
>  #endif
>=20
> -static struct msi_domain_ops pci_msi_domain_ops_default =3D {
> +static struct msi_domain_ops pci_msi_domain_ops_default __ro_after_init
> =3D {
>  	.set_desc	=3D pci_msi_domain_set_desc,
>  	.msi_check	=3D pci_msi_domain_check_cap,
>  	.handle_error	=3D pci_msi_domain_handle_error,
> --
> 2.11.0
