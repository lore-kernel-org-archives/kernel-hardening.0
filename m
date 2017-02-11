Date: Sat, 11 Feb 2017 10:48:59 +0000
In-Reply-To: <alpine.DEB.2.20.1702110948030.3734@nanos>
References: <20170211013758.3288-1-me@jessfraz.com> <alpine.DEB.2.20.1702110948030.3734@nanos>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Jess Frazelle <me@jessfraz.com>
Message-ID: <DF37E0AB-7310-4D1C-A710-7A7EA60498E7@jessfraz.com>
Subject: [kernel-hardening] Re: [PATCH v2 1/5] irq: set {msi_domain,syscore}_ops as __ro_after_init
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>, "open list:IRQ SUBSYSTEM" <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



On February 11, 2017 1:14:52 AM PST, Thomas Gleixner <tglx@linutronix=2Ede=
> wrote:
>On Fri, 10 Feb 2017, Jess Frazelle wrote:
>
>> Marked msi_domain_ops structs as __ro_after_init when called only
>during init=2E
>> Marked syscore_ops structs as __ro_after_init when
>register_syscore_ops was
>> called only during init=2E Most of the caller functions were already
>annotated as
>> __init=2E
>> unregister_syscore_ops() was never called on these syscore_ops=2E
>> This protects the data structure from accidental corruption=2E
>
>Please be more careful with your changelogs=2E They should not start with
>telling WHAT you have done=2E The WHAT we can see from the patch=2E
>
>The interesting information which belongs into the changelog is: WHY
>and
>which problem does it solve or which enhancement this is=2E Let me give
>you
>an example:
>
>  Function pointers are a target for attacks especially when they are
>  located in statically allocated data structures=2E Some of these data
> structures are only modified during init and therefor can be made read
>  only after init=2E
>
>struct msi_domain_ops can be made read only after init because they are
>  only updated in the registration case=2E
>
> struct syscore_ops can be made read only after init when they are only
>  registered, but never unregistered=2E
>
>So this would be a proper change log explaning the patch=2E

Thanks for the clarification=2E

>
>Emphasis on WOULD, See below=2E
>
>> -static struct syscore_ops irq_gc_syscore_ops =3D {
>> +static struct syscore_ops irq_gc_syscore_ops __ro_after_init =3D {
>>  	=2Esuspend =3D irq_gc_suspend,
>>  	=2Eresume =3D irq_gc_resume,
>>  	=2Eshutdown =3D irq_gc_shutdown,
>
>I seriously doubt that syscore_ops can be made __ro_after_init at all=2E
>
>Assume the following:
>
>last_init_function()
>  register_syscore_ops(&a_ops)
>    list_add(&a_ops->node, list);
>
>apply_ro_after_init()
>  // a_ops are now read only
>
>cpuhotplug happens
>  register_syscore_ops(&b_ops)
>    list_add(&b_ops->node, list);
>
>  =3D=3D=3D> Kernel crashes with a write access on RO memory because it t=
ries
>    	 to link b_ops to a_ops=2E
>
>The same is true for cpuhotunplug operations=2E

This makes sense=2E Will remove=2E

>
>> -static struct msi_domain_ops msi_domain_ops_default =3D {
>> +static struct msi_domain_ops msi_domain_ops_default __ro_after_init
>=3D {
>
>This is pointless and just tells me that you did a mechanical search
>for
>these ops and then blindly added __ro_after_init instead of analysing
>how
>msi_domain_ops_default is used=2E
>
>msi_domain_ops_default are never ever modified, so they should be made
>'const' and not __ro_after_init=2E It's not that hard to figure that out
>from
>the code=2E

Will change to a const=2E

>
>Thanks,
>
>	tglx
