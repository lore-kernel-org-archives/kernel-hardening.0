From: "Roberts, William C" <william.c.roberts@intel.com>
Date: Fri, 19 May 2017 20:25:12 +0000
Message-ID: <476DC76E7D1DF2438D32BFADF679FC563362D5CD@ORSMSX103.amr.corp.intel.com>
References: <20170506040641.GA32707@kroah.com>
 <20170511013737.GD801@jagdpanzerIV.localdomain>
 <476DC76E7D1DF2438D32BFADF679FC563362B030@ORSMSX103.amr.corp.intel.com>
 <20170518141323.GD23654@kroah.com>
In-Reply-To: <20170518141323.GD23654@kroah.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [RFC 00/06] printk: add more new kernel pointer filter options.
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Petr Mladek <pmladek@suse.com>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, May 18, 2017 7:13 AM
> To: Roberts, William C <william.c.roberts@intel.com>
> Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>; kernel-
> hardening@lists.openwall.com; Petr Mladek <pmladek@suse.com>; Sergey
> Senozhatsky <sergey.senozhatsky@gmail.com>; linux-kernel@vger.kernel.org;
> Catalin Marinas <catalin.marinas@arm.com>; Will Deacon
> <will.deacon@arm.com>; Steven Rostedt <rostedt@goodmis.org>; Chris Fries
> <cfries@google.com>; Dave Weinstein <olorin@google.com>
> Subject: Re: [RFC 00/06] printk: add more new kernel pointer filter optio=
ns.
>=20
> On Tue, May 16, 2017 at 09:36:37PM +0000, Roberts, William C wrote:
> >
> >
> > > -----Original Message-----
> > > From: Sergey Senozhatsky [mailto:sergey.senozhatsky.work@gmail.com]
> > > Sent: Wednesday, May 10, 2017 6:38 PM
> > > To: Greg KH <gregkh@linuxfoundation.org>
> > > Cc: kernel-hardening@lists.openwall.com; Petr Mladek
> > > <pmladek@suse.com>; Sergey Senozhatsky
> > > <sergey.senozhatsky@gmail.com>; linux- kernel@vger.kernel.org;
> > > Catalin Marinas <catalin.marinas@arm.com>; Will Deacon
> > > <will.deacon@arm.com>; Steven Rostedt <rostedt@goodmis.org>;
> > > Roberts, William C <william.c.roberts@intel.com>; Chris Fries
> > > <cfries@google.com>; Dave Weinstein <olorin@google.com>
> > > Subject: Re: [RFC 00/06] printk: add more new kernel pointer filter o=
ptions.
> > >
> > > Hello Greg,
> > >
> > > On (05/05/17 21:06), Greg KH wrote:
> > > > Here's a short patch series from Chris Fries and Dave Weinstein
> > > > that implement some new restrictions when printing out kernel
> > > > pointers, as well as the ability to whitelist kernel pointers where=
 needed.
> > > >
> > > > These patches are based on work from William Roberts, and also is
> > > > inspired by grsecurity's %pP to specifically whitelist a kernel
> > > > pointer, where it is always needed, like the last patch in the
> > > > series shows, in the UIO drivers (UIO requires that you know the
> > > > address, it's a hardware address, nothing wrong with seeing
> > > > that...)
> > > >
> > > > I haven't done much to this patch series, only forward porting it
> > > > from an older kernel release (4.4) and a few minor tweaks.  It
> > > > applies cleanly on top of 4.11 as well as Linus's current
> > > > development tree
> > > > (10502 patches into the 4.12-rc1 merge window).  I'm posting it
> > > > now for comments if anyone sees anything wrong with this approach
> > >
> > > overall, I don't see anything wrong.
> > >
> > > > or thinks the things that are being whitelisted should not be?
> > >
> > > can't say for sure, sorry.
> > >
> > > 	-ss
> >
> > I almost missed this, none of the mail was delivered to my inbox...
>=20
> Why not?  Did I get the address wrong?

I don't think so. I've had weird issues with my Intel email address and mai=
ling
lists before. On the selinux mailing list they kept getting bounces when se=
nding
Me email, but it's only that list. I'm just going to blame it on something =
within
our corporate network.

>=20
> > Anyways, I am glad to see this revived and I don't have any Comments
> > besides thanks.
>=20
> Acks for the patches are always appreciated :)
>=20
> I'll revise this in the next few weeks and send out a new series.

I see some comments on clarifying the docs that seem spot on.
I'll look at the next series and I will test them, if they look good
to me, I'll ack away :-)

>=20
> thanks,
>=20
> greg k-h
