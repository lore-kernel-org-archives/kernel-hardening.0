Date: Tue, 7 Feb 2017 08:36:07 +0100
From: Pavel Machek <pavel@ucw.cz>
Message-ID: <20170207073607.GA32054@amd>
References: <1486144343-24998-1-git-send-email-labbott@redhat.com>
 <1486144343-24998-2-git-send-email-labbott@redhat.com>
 <CAGXu5jK6_y=dWHUDBto7ykN_sSOQ6Gx+sZs_gQ1Hoh5DjP-fTw@mail.gmail.com>
 <20170203202919.GE27312@n2100.armlinux.org.uk>
 <CAGXu5j+HOTHRrFJFMsMaAvqcTAUoEBuphzrYAr7VAjJQU9_RYA@mail.gmail.com>
 <f88765d3-4c45-542e-892b-33a6c3c3c4d2@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <f88765d3-4c45-542e-892b-33a6c3c3c4d2@redhat.com>
Subject: [kernel-hardening] Re: [PATCHv2 1/2] arch: Move CONFIG_DEBUG_RODATA and
 CONFIG_SET_MODULE_RONX to be common
To: Laura Abbott <labbott@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Russell King - ARM Linux <linux@armlinux.org.uk>, Jason Wessel <jason.wessel@windriver.com>, Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, Rob Herring <robh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Mark Rutland <mark.rutland@arm.com>, Jessica Yu <jeyu@redhat.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-parisc <linux-parisc@vger.kernel.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Robin Murphy <robin.murphy@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2017-02-06 10:47:45, Laura Abbott wrote:
> On 02/03/2017 01:08 PM, Kees Cook wrote:
> > On Fri, Feb 3, 2017 at 12:29 PM, Russell King - ARM Linux
> > <linux@armlinux.org.uk> wrote:
> >> On Fri, Feb 03, 2017 at 11:45:56AM -0800, Kees Cook wrote:
> >>> On Fri, Feb 3, 2017 at 9:52 AM, Laura Abbott <labbott@redhat.com> wro=
te:
> >>>> diff --git a/arch/Kconfig b/arch/Kconfig
> >>>> index 99839c2..22ee01e 100644
> >>>> --- a/arch/Kconfig
> >>>> +++ b/arch/Kconfig
> >>>> @@ -781,4 +781,32 @@ config VMAP_STACK
> >>>>           the stack to map directly to the KASAN shadow map using a =
formula
> >>>>           that is incorrect if the stack is in vmalloc space.
> >>>>
> >>>> +config ARCH_NO_STRICT_RWX_DEFAULTS
> >>>> +       def_bool n
> >>>> +
> >>>> +config ARCH_HAS_STRICT_KERNEL_RWX
> >>>> +       def_bool n
> >>>> +
> >>>> +config DEBUG_RODATA
> >>>> +       def_bool y if !ARCH_NO_STRICT_RWX_DEFAULTS
> >>>> +       prompt "Make kernel text and rodata read-only" if ARCH_NO_ST=
RICT_RWX_DEFAULTS
> >>>
> >>> Ah! Yes, perfect. I totally forgot about using conditional "prompt"
> >>> lines. Nice!
> >>
> >> It's no different from the more usual:
> >>
> >>         bool "Make kernel text and rodata read-only" if ARCH_NO_STRICT=
_RWX_DEFAULTS
> >>         default y if !ARCH_NO_STRICT_RWX_DEFAULTS
> >>         depends on ARCH_HAS_STRICT_KERNEL_RWX
> >>
> >> But... I really don't like this - way too many negations and negatives
> >> which make it difficult to figure out what's going on here.
> >>
> >> The situation we have today is:
> >>
> >> -config DEBUG_RODATA
> >> -       bool "Make kernel text and rodata read-only"
> >> -       depends on MMU && !XIP_KERNEL
> >> -       default y if CPU_V7
> >>
> >> which is "allow the user to select DEBUG_RODATA if building a MMU non-=
XIP
> >> kernel", suggesting that the user turns it on for ARMv7 CPUs.
> >>
> >> That changes with this and the above:
> >>
> >> +       select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
> >> +       select ARCH_HAS_STRICT_MODULE_RWX if MMU
> >> +       select ARCH_NO_STRICT_RWX_DEFAULTS if !CPU_V7
> >>
> >> This means that ARCH_HAS_STRICT_KERNEL_RWX is set for a MMU non-XIP
> >> kernel, which carries the same pre-condition for DEBUG_RODATA - no
> >> problem there.
> >>
> >> However, ARCH_NO_STRICT_RWX_DEFAULTS is set for non-ARMv7 CPUs, which
> >> means the "Make kernel text and rodata read-only" prompt _is_ provided
> >> for those.  However, for all ARMv7 systems, we go from "suggesting that
> >> the user enables the option" to "you don't have a choice, you get this
> >> whether you want it or not."
> >>
> >> I'd prefer to keep it off for my development systems, where I don't
> >> care about kernel security.  If we don't wish to do that as a general
> >> rule, can we make it dependent on EMBEDDED?
> >>
> >> Given that on ARM it can add up to 4MB to the kernel image - there
> >> _will_ be about 1MB before the .text section, the padding on between
> >> __modver and __ex_table which for me is around 626k, the padding
> >> between .notes and the init sections start with .vectors (the space
> >> between __ex_table and end of .notes is only 4124, which gets padded
> >> up to 1MB) and lastly the padding between the .init section and the
> >> data section (for me around 593k).  This all adds up to an increase
> >> in kernel image size of 3.2MB on 14.2MB - an increase of 22%.
> >>
> >> So no, I'm really not happy with that.
> >=20
> > Ah yeah, good point. We have three cases: unsupported, mandatory,
> > optional, but we have the case of setting the default for the optional
> > case. Maybe something like this?
> >=20
> > config STRICT_KERNEL_RWX
> >   bool "Make kernel text and rodata read-only" if ARCH_OPTIONAL_KERNEL_=
RWX
> >   depends on ARCH_HAS_STRICT_KERNEL_RWX
> >   default ARCH_OPTIONAL_KERNEL_RWX_DEFAULT
> >=20
> > unsupported:
> > !ARCH_HAS_STRICT_KERNEL_RWX
> >=20
> > mandatory:
> > ARCH_HAS_STRICT_KERNEL_RWX
> > !ARCH_OPTIONAL_KERNEL_RWX
> >=20
> > optional:
> > ARCH_HAS_STRICT_KERNEL_RWX
> > ARCH_OPTIONAL_KERNEL_RWX
> > with default controlled by ARCH_OPTIONAL_KERNEL_RWX_DEFAULT
> >=20
> > Then arm is:
> >   select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
> >   select ARCH_HAS_STRICT_MODULE_RWX if MMU
> >   select ARCH_OPTIONAL_KERNEL_RWX if ARCH_HAS_STRICT_KERNEL_RWX
> >   select ARCH_OPTIONAL_KERNEL_RWX_DEFAULT if CPU_V7
> >=20
> > x86 and arm64 are:
> >   select ARCH_HAS_STRICT_KERNEL_RWX
> >   select ARCH_HAS_STRICT_MODULE_RWX
> >=20
> > ?
> >=20
> > -Kees
> >=20
>=20
> Yes, that looks good. I wanted it to be mandatory to avoid the
> mindset of "optional means we don't need it" but I see there
> are some cases where it's better to turn it off. I'll see if
> I can emphasize this properly in the help text ("Say Y here
> unless you love security exploits running in production")

What about fixing the memory wastage, instead? If you want something
almost-always-on, it should not waste megabytes of memory.

And BTW it is help text, not advertising for your favourite feature.
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAliZeOcACgkQMOfwapXb+vIc1QCdGBBKU2hn8xN42ay0JGRyEQOp
ihIAn0k+i064RqrbuZPkvyOSl/mzNcnF
=eSsv
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
