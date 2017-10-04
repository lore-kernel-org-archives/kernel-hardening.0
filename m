From: "Roberts, William C" <william.c.roberts@intel.com>
Date: Wed, 4 Oct 2017 16:17:54 +0000
Message-ID: <476DC76E7D1DF2438D32BFADF679FC563EAF4C9D@ORSMSX103.amr.corp.intel.com>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
 <20171004085850.GH28247@kroah.com>
In-Reply-To: <20171004085850.GH28247@kroah.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: RE: [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter
 options
To: Greg KH <gregkh@linuxfoundation.org>, "Tobin C. Harding" <me@tobin.cc>
Cc: Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian
 Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Wednesday, October 4, 2017 1:59 AM
> To: Tobin C. Harding <me@tobin.cc>
> Cc: Petr Mladek <pmladek@suse.com>; Joe Perches <joe@perches.com>; Ian
> Campbell <ijc@hellion.org.uk>; Sergey Senozhatsky
> <sergey.senozhatsky@gmail.com>; kernel-hardening@lists.openwall.com; linu=
x-
> kernel@vger.kernel.org; Catalin Marinas <catalin.marinas@arm.com>; Will
> Deacon <will.deacon@arm.com>; Steven Rostedt <rostedt@goodmis.org>;
> Roberts, William C <william.c.roberts@intel.com>; Chris Fries
> <cfries@google.com>; Dave Weinstein <olorin@google.com>
> Subject: Re: [kernel-hardening] [RFC V2 0/6] add more kernel pointer filt=
er
> options
>=20
> On Sun, Oct 01, 2017 at 11:06:44AM +1100, Tobin C. Harding wrote:
> > Version 2 of Greg's patch series with changes made as suggested by comm=
ents
> to V1.
> >
> > Applies on top of Linus' current development tree
> >
> > a8c964eacb21288b2dbfa9d80cee5968a3b8fb21
> >
> > V1 cover letter:
> >
> > Here's a short patch series from Chris Fries and Dave Weinstein that
> > implements some new restrictions when printing out kernel pointers, as
> > well as the ability to whitelist kernel pointers where needed.
> >
> > These patches are based on work from William Roberts, and also are
> > inspired by grsecurity's %pP to specifically whitelist a kernel
> > pointer, where it is always needed, like the last patch in the series
> > shows, in the UIO drivers (UIO requires that you know the address,
> > it's a hardware address, nothing wrong with seeing that...)
> >
> > I haven't done much to this patch series, only forward porting it from
> > an older kernel release (4.4) and a few minor tweaks. [snip]
>=20
> Nice!  Thanks for doing this work, looks great to me.  Care to resend the=
 next
> version as a "real" one (i.e. no RFC)?

It looks like the only gripe from others was on the debug output change, so
I'd drop that change out of the series. Otherwise, LGTM.

>=20
> thanks,
>=20
> greg k-h
