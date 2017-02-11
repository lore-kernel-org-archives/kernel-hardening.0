Date: Sat, 11 Feb 2017 10:14:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20170211013758.3288-1-me@jessfraz.com>
Message-ID: <alpine.DEB.2.20.1702110948030.3734@nanos>
References: <20170211013758.3288-1-me@jessfraz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v2 1/5] irq: set {msi_domain,syscore}_ops as
 __ro_after_init
To: Jess Frazelle <me@jessfraz.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, "open list:IRQ SUBSYSTEM" <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 10 Feb 2017, Jess Frazelle wrote:

> Marked msi_domain_ops structs as __ro_after_init when called only during init.
> Marked syscore_ops structs as __ro_after_init when register_syscore_ops was
> called only during init. Most of the caller functions were already annotated as
> __init.
> unregister_syscore_ops() was never called on these syscore_ops.
> This protects the data structure from accidental corruption.

Please be more careful with your changelogs. They should not start with
telling WHAT you have done. The WHAT we can see from the patch.

The interesting information which belongs into the changelog is: WHY and
which problem does it solve or which enhancement this is. Let me give you
an example:

  Function pointers are a target for attacks especially when they are
  located in statically allocated data structures. Some of these data
  structures are only modified during init and therefor can be made read
  only after init.

  struct msi_domain_ops can be made read only after init because they are
  only updated in the registration case.

  struct syscore_ops can be made read only after init when they are only
  registered, but never unregistered.

So this would be a proper change log explaning the patch.

Emphasis on WOULD, See below.

> -static struct syscore_ops irq_gc_syscore_ops = {
> +static struct syscore_ops irq_gc_syscore_ops __ro_after_init = {
>  	.suspend = irq_gc_suspend,
>  	.resume = irq_gc_resume,
>  	.shutdown = irq_gc_shutdown,

I seriously doubt that syscore_ops can be made __ro_after_init at all.

Assume the following:

last_init_function()
  register_syscore_ops(&a_ops)
    list_add(&a_ops->node, list);

apply_ro_after_init()
  // a_ops are now read only

cpuhotplug happens
  register_syscore_ops(&b_ops)
    list_add(&b_ops->node, list);

    ===> Kernel crashes with a write access on RO memory because it tries
    	 to link b_ops to a_ops.

The same is true for cpuhotunplug operations.

> -static struct msi_domain_ops msi_domain_ops_default = {
> +static struct msi_domain_ops msi_domain_ops_default __ro_after_init = {

This is pointless and just tells me that you did a mechanical search for
these ops and then blindly added __ro_after_init instead of analysing how
msi_domain_ops_default is used.

msi_domain_ops_default are never ever modified, so they should be made
'const' and not __ro_after_init. It's not that hard to figure that out from
the code.

Thanks,

	tglx
