From: "Roberts, William C" <william.c.roberts@intel.com>
Date: Wed, 15 Feb 2017 23:49:04 +0000
Message-ID: <476DC76E7D1DF2438D32BFADF679FC5623064D3F@ORSMSX103.amr.corp.intel.com>
References: <1486755469-21573-1-git-send-email-william.c.roberts@intel.com>
	 <1486757549.2192.20.camel@perches.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305C559@ORSMSX103.amr.corp.intel.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305C5BA@ORSMSX103.amr.corp.intel.com>
	 <1486766996.2192.30.camel@perches.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305DC7B@ORSMSX103.amr.corp.intel.com>
	 <1486783428.2192.44.camel@perches.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305F372@ORSMSX103.amr.corp.intel.com>
	 <1487016251.6214.6.camel@perches.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305F62F@ORSMSX103.amr.corp.intel.com>
 <1487024441.6214.12.camel@perches.com>
In-Reply-To: <1487024441.6214.12.camel@perches.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [PATCH] checkpatch: add warning on %pk instead of %pK usage
To: Joe Perches <joe@perches.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>



> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Monday, February 13, 2017 2:21 PM
> To: Roberts, William C <william.c.roberts@intel.com>
> Cc: linux-kernel@vger.kernel.org; apw@canonical.com; kernel-
> hardening@lists.openwall.com
> Subject: Re: [PATCH] checkpatch: add warning on %pk instead of %pK usage
>=20
> (Adding back the cc's)
>=20
> On Mon, 2017-02-13 at 21:28 +0000, Roberts, William C wrote:
> > <snip>
> > > No worries.
> > > No idea why it doesn't work for you.
> > > Maybe the hand applying was somehow
> > > faulty?
> > >
> > > The attached is on top of -next so it does have offsets on Linus'
> > > tree, but it seems to work.
> > >
> > > (on -linux)
> > >
> > > $ patch -p1 < cp_vsp.diff
> > > patching file scripts/checkpatch.pl
> > > Hunk #1 succeeded at 5634 (offset -36 lines).
> > >
> > > $ cat t_block.c
> > > {
> > > 	MY_DEBUG(drv->foo,
> > > 		=A0"%pk",
> > > 		=A0foo->boo);
> > > }
> > > $ ./scripts/checkpatch.pl -f t_block.c
> > > WARNING: Invalid vsprintf pointer extension '%pk'
> > > #2: FILE: t_block.c:2:
> > > +	MY_DEBUG(drv->foo,
> > > +		=A0"%pk",
> > > +		=A0foo->boo);
> > >
> > > total: 0 errors, 1 warnings, 5 lines checked
> > >
> > > NOTE: For some of the reported defects, checkpatch may be able to
> > > =A0=A0=A0=A0=A0=A0mechanically convert to the typical style using --f=
ix or --fix-inplace.
> > >
> > > t_block.c has style problems, please review.
> > >
> > > NOTE: If any of the errors are false positives, please report
> > > =A0=A0=A0=A0=A0=A0them to the maintainer, see CHECKPATCH in MAINTAINE=
RS.
> >
> >
> > Applied. It works fine with your example (see attached
> > 0001-tblock.patch) but it doesn't provide Output for me with
> > 0002-drv-hack.patch (attached as well)
> >
> > $ ./scripts/checkpatch.pl 0002-drv-hack.patch
> > total: 0 errors, 0 warnings, 10 lines checked
> >
> > 0002-drv-hack.patch has no obvious style problems and is ready for subm=
ission.
> >
> > ./scripts/checkpatch.pl 0001-tblock.patch
> > WARNING: added, moved or deleted file(s), does MAINTAINERS need
> updating?
> > #13:
> > new file mode 100644
> >
> > WARNING: Invalid vsprintf pointer extension '%pk'
> > #19: FILE: t_block.c:2:
> > +	MY_DEBUG(drv->foo,
> > +		"%pk",
> > +		 foo->boo);
> >
> > total: 0 errors, 2 warnings, 6 lines checked
> >
> > NOTE: For some of the reported defects, checkpatch may be able to
> >       mechanically convert to the typical style using --fix or --fix-in=
place.
> >
> > 0001-tblock.patch has style problems, please review.
> >
> > NOTE: If any of the errors are false positives, please report
> >       them to the maintainer, see CHECKPATCH in MAINTAINERS.
>=20
> This means _all_ the $stat checks aren't being done on patches that add j=
ust a
> single multi-line statement.
>=20
> Andrew?  Any thoughts on how to enable $stat appropriately for patch cont=
exts
> with a single multi-line statement?

I'm for merging your patch as is, and then take up the fact that $stat is n=
ot working correctly
as a separate change, does that seem reasonable?
