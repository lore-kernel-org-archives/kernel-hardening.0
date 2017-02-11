MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1702111222340.3734@nanos>
References: <20170211013758.3288-1-me@jessfraz.com> <alpine.DEB.2.20.1702110948030.3734@nanos>
 <DF37E0AB-7310-4D1C-A710-7A7EA60498E7@jessfraz.com> <alpine.DEB.2.20.1702111222340.3734@nanos>
From: Jessica Frazelle <me@jessfraz.com>
Date: Sat, 11 Feb 2017 04:17:39 -0800
Message-ID: <CAEk6tEyCrMHY9kwxMKupRAhvpV52J_JC5WHGW2fegqHuomGXOg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 1/5] irq: set {msi_domain,syscore}_ops as __ro_after_init
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>, "open list:IRQ SUBSYSTEM" <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Thanks, I'll check them out.

On Sat, Feb 11, 2017 at 4:00 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> On Sat, 11 Feb 2017, Jess Frazelle wrote:
> > On February 11, 2017 1:14:52 AM PST, Thomas Gleixner <tglx@linutronix.de> wrote:
> > >The same is true for cpuhotunplug operations.
> >
> > This makes sense. Will remove.
>
> That's true for all other patches touching sysops as well. But instead of
> giving up I'd recommend to look into the following:
>
> Go through all callsites which use un/register_syscore_ops() and figure out
> how many of them are possibly called post init. From a quick grep I can
> only find the KVM module, but there might be more.
>
> Lets assume it's KVM only. So you could do the following:
>
> Put something like this into virt/kvm/kvm_main.c, which is a builtin file
>
> static struct syscore_ops ops __ro_after_init = {
>        ....
> };
>
> int __init foo()
> {
>     register_ops(&ops);
> }
>
> and because we know that kvm is single instance you can just have:
>
> static struct syscore_ops *kvm_ops;
>
> void kvm_set_sysop(*vmx_ops)
> {
>         kvm_ops = ops;
> }
>
> and then have the kvm_syscore callbacks:
>
> static callback()
> {
>         if (kvm_ops)
>            kvm_ops->callback()
> }
>
> Sanity checks and serialization omitted. Then switch kvm_exit/init over to
> it.
>
> After that you can make all syscore_ops __ro_after_init, remove the export
> from (un)register_syscore_ops() and make that __init.
>
> Not much of an effort and probably worth the trouble.
>
> Thanks,
>
>         tglx
>
