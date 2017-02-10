From: "Roberts, William C" <william.c.roberts@intel.com>
Date: Fri, 10 Feb 2017 23:54:03 +0000
Message-ID: <476DC76E7D1DF2438D32BFADF679FC562305DB6F@ORSMSX103.amr.corp.intel.com>
References: <1486755469-21573-1-git-send-email-william.c.roberts@intel.com>
	 <1486757549.2192.20.camel@perches.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305C559@ORSMSX103.amr.corp.intel.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305C5BA@ORSMSX103.amr.corp.intel.com>
 <1486766996.2192.30.camel@perches.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [PATCH] checkpatch: add warning on %pk instead of %pK usage
To: Joe Perches <joe@perches.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, Andew Morton <akpm@linux-foundation.org>
Cc: "keescook@chromium.org" <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>



> -----Original Message-----
> From: Roberts, William C
> Sent: Friday, February 10, 2017 3:32 PM
> To: 'Joe Perches' <joe@perches.com>; linux-kernel@vger.kernel.org;
> apw@canonical.com; Andew Morton <akpm@linux-foundation.org>
> Cc: keescook@chromium.org; kernel-hardening@lists.openwall.com
> Subject: RE: [PATCH] checkpatch: add warning on %pk instead of %pK usage
>=20
>=20
>=20
> > -----Original Message-----
> > From: Joe Perches [mailto:joe@perches.com]
> > Sent: Friday, February 10, 2017 2:50 PM
> > To: Roberts, William C <william.c.roberts@intel.com>; linux-
> > kernel@vger.kernel.org; apw@canonical.com; Andew Morton <akpm@linux-
> > foundation.org>
> > Cc: keescook@chromium.org; kernel-hardening@lists.openwall.com
> > Subject: Re: [PATCH] checkpatch: add warning on %pk instead of %pK
> > usage
> >
> > On Fri, 2017-02-10 at 22:26 +0000, Roberts, William C wrote:
> > > <snip>
> > >
> > > > >
> > > > > On Fri, 2017-02-10 at 11:37 -0800, william.c.roberts@intel.com wr=
ote:
> > > > > > From: William Roberts <william.c.roberts@intel.com>
> > > > > >
> > > > > > Sample output:
> > > > > > WARNING: %pk is close to %pK, did you mean %pK?.
> > > > > > \#20: FILE: drivers/char/applicom.c:230:
> > > > > > +			printk(KERN_INFO "Could not allocate IRQ %d for
> > PCI
> > > > >
> > > > > Applicom
> > > > > > +device. %pk\n", dev->irq, pci_get_class);
> > > > >
> > > > > There isn't a single instance of this in the kernel tree.
> > > > >
> > > > > Maybe if this is really useful, then all the %p<foo> extensions
> > > > > should be enumerated and all unknown uses should have warnings.
> > > >
> > > > I was thinking of doing that, but I figured I would start with the
> > > > bare minimum patch.
> > > >
> > > > >
> > > > > Something like:
> > > > >
> > > > > ---
> > > > >  scripts/checkpatch.pl | 9 +++++++++
> > > > >  1 file changed, 9 insertions(+)
> > > > >
> > > > > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl index
> > > > > ad5ea5c545b2..8a90b457e8b5 100755
> > > > > --- a/scripts/checkpatch.pl
> > > > > +++ b/scripts/checkpatch.pl
> > > > > @@ -5305,6 +5305,15 @@ sub process {
> > > > >  			}
> > > > >  		}
> > > > >
> > > > > +# check for vsprintf extension %p<foo> misuses
> > > > > +		if ($line =3D~ /\b$logFunctions\s*\(.*$String/) {
> > >
> > > I don't see the normal string formatting routines in that list... I
> > > think this is too
> > restrictive.
> >
> > I don't.  There are no "normal" string formatting routines.
>=20
> By "normal" I'm referring to things that call into pointer(), just casual=
ly looking I
> see bstr_printf vsnprintf kvasprintf, which would be easy enough to add
>=20
> > What do you think is missing?  sn?printf ? That's easy to add.
>=20
> The problem starts to get hairy when we think of how often folks roll the=
ir own
> logging macros (see some small sampling at the end).
>=20
> I think we would want to add DEBUG DBG and sn?printf and maybe consider
> dropping the \b on the regex so it's a bit more matchy but still shouldn'=
t end up
> matching on any ASM as you pointed out in the V2 nack.
>=20
> Ill break this down into:
> 1. the patch as I know you'll take it, as you wrote it :-P 2. Adding to t=
he logging
> macros 3. exploring making it less matchy

Sent v3 --> Let me think on something better than items 2 and 3. We really =
want to
Know if were looking at at a string that is in a function or something ther=
e about.

Everyone has their own print routines... which is why I am in favor of neut=
ering %p
within vsprintf itself.

>=20
> Data:
> arch/alpha/kernel/pci_iommu.c:25:# define DBGA(args...)
> 	printk(KERN_DEBUG args)
> arch/alpha/kernel/pci_iommu.c:30:# define DBGA2(args...)
> 	printk(KERN_DEBUG args)
> arch/alpha/kernel/core_tsunami.c:50:# define DBG_CFG(args)	printk args
> arch/alpha/kernel/core_titan.c:50:# define DBG_CFG(args)	printk args
> arch/alpha/kernel/ptrace.c:34:#define DBG(fac,args)	{if ((fac) & DEBUG) p=
rintk
> args;}
> arch/alpha/kernel/core_apecs.c:42:# define DBGC(args)	printk args
> arch/alpha/kernel/core_irongate.c:38:# define DBG_CFG(args)	printk args
> arch/alpha/kernel/core_wildfire.c:30:# define DBG_CFG(args)	printk args
> arch/alpha/kernel/smc37c93x.c:18:# define DBG_DEVS(args)         printk a=
rgs
> arch/alpha/boot/misc.c:27:#define puts		srm_printk
> arch/alpha/mm/numa.c:27:#define DBGDCONT(args...) printk(args)
> arch/powerpc/sysdev/tsi108_pci.c:43:#define DBG(x...) printk(x)
> arch/powerpc/sysdev/ge/ge_pic.c:31:#define DBG(fmt...) do {
> printk(KERN_DEBUG "gef_pic: " fmt); } while (0)
> arch/powerpc/sysdev/tsi108_dev.c:34:#define DBG(fmt...) do { printk(fmt);=
 }
> while(0) arch/powerpc/sysdev/mpic.c:45:#define DBG(fmt...) printk(fmt)
> arch/powerpc/kernel/process.c:69:#define TM_DEBUG(x...) printk(KERN_INFO
> x) arch/powerpc/kernel/vdso.c:42:#define DBG(fmt...) printk(fmt)
> arch/powerpc/kernel/legacy_serial.c:21:#define DBG(fmt...) do { printk(fm=
t); }
> while(0) arch/powerpc/kernel/traps.c:89:#define TM_DEBUG(x...)
> printk(KERN_INFO x) arch/powerpc/kernel/prom.c:65:#define DBG(fmt...)
> printk(KERN_ERR fmt) arch/powerpc/kvm/book3s_paired_singles.c:33:#define
> dprintk printk
>=20
