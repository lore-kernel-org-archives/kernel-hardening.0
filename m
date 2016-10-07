Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 7 Oct 2016 17:15:41 +0200
From: Jann Horn <jann@thejh.net>
Message-ID: <20161007151541.GC14666@pc.thejh.net>
References: <1475690686-16138-1-git-send-email-william.c.roberts@intel.com>
 <CAGXu5j+EtVPabrwPXU0W8yJ5Fg0H0Nc6aPjJqqNOSx+m+TBu2Q@mail.gmail.com>
 <476DC76E7D1DF2438D32BFADF679FC561CD14829@ORSMSX103.amr.corp.intel.com>
 <CAGXu5jK6JFjnp25WopT=gqjMG2rb+MJJmsiX8t+D40jgs4640A@mail.gmail.com>
 <476DC76E7D1DF2438D32BFADF679FC561CD14B1C@ORSMSX103.amr.corp.intel.com>
 <20161007142955.GB14666@pc.thejh.net>
 <476DC76E7D1DF2438D32BFADF679FC561CD14FCA@ORSMSX103.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FhvelBhrd33NvMcY"
Content-Disposition: inline
In-Reply-To: <476DC76E7D1DF2438D32BFADF679FC561CD14FCA@ORSMSX103.amr.corp.intel.com>
Subject: Re: [kernel-hardening] RE: [PATCH] printk: introduce kptr_restrict
 level 3
To: "Roberts, William C" <william.c.roberts@intel.com>
Cc: Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


--FhvelBhrd33NvMcY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 07, 2016 at 03:05:43PM +0000, Roberts, William C wrote:
>=20
>=20
> > -----Original Message-----
> > From: Jann Horn [mailto:jann@thejh.net]
> > Sent: Friday, October 7, 2016 10:30 AM
> > To: Roberts, William C <william.c.roberts@intel.com>
> > Cc: Kees Cook <keescook@chromium.org>; kernel-
> > hardening@lists.openwall.com
> > Subject: Re: [kernel-hardening] RE: [PATCH] printk: introduce kptr_rest=
rict level 3
> >=20
> > On Fri, Oct 07, 2016 at 02:19:43PM +0000, Roberts, William C wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: keescook@google.com [mailto:keescook@google.com] On Behalf Of
> > > > Kees Cook
> > > > Sent: Thursday, October 6, 2016 5:05 PM
> > > > To: Roberts, William C <william.c.roberts@intel.com>
> > > > Cc: kernel-hardening@lists.openwall.com
> > > > Subject: Re: [PATCH] printk: introduce kptr_restrict level 3
> > > >
> > > > On Thu, Oct 6, 2016 at 8:18 AM, Roberts, William C
> > > > <william.c.roberts@intel.com>
> > > > wrote:
> > > > >
> > > > >
> > > > >> -----Original Message-----
> > > > >> From: keescook@google.com [mailto:keescook@google.com] On Behalf
> > > > >> Of Kees Cook
> > > > >> Sent: Wednesday, October 5, 2016 3:34 PM
> > > > >> To: Roberts, William C <william.c.roberts@intel.com>
> > > > >> Cc: kernel-hardening@lists.openwall.com; Jonathan Corbet
> > > > >> <corbet@lwn.net>; linux-doc@vger.kernel.org; LKML
> > > > >> <linux-kernel@vger.kernel.org>; Nick Desaulniers
> > > > >> <ndesaulniers@google.com>; Dave Weinstein <olorin@google.com>
> > > > >> Subject: Re: [PATCH] printk: introduce kptr_restrict level 3
> > > > >>
> > > > >> On Wed, Oct 5, 2016 at 11:04 AM,  <william.c.roberts@intel.com> =
wrote:
> > > > >> > From: William Roberts <william.c.roberts@intel.com>
> > > > >> >
> > > > >> > Some out-of-tree modules do not use %pK and just use %p, as
> > > > >> > it's the common C paradigm for printing pointers. Because of
> > > > >> > this, kptr_restrict has no affect on the output and thus, no
> > > > >> > way to contain the kernel address leak.
> > > > >>
> > > > >> Solving this is certainly a good idea -- I'm all for finding a s=
olid solution.
> > > > >>
> > > > >> > Introduce kptr_restrict level 3 that causes the kernel to treat
> > > > >> > %p as if it was %pK and thus always prints zeros.
> > > > >>
> > > > >> I'm worried that this could break kernel internals where %p is
> > > > >> being used and not exposed to userspace. Maybe those situations =
don't
> > exist...
> > > > >>
> > > > >> Regardless, I would rather do what Grsecurity has done in this
> > > > >> area, and whitelist known-safe values instead. For example, they
> > > > >> have %pP for approved pointers, and %pX for approved
> > > > >> dereference_function_descriptor() output. Everything else is
> > > > >> censored if it is a value in kernel memory and destined for a
> > > > >> user-space memory
> > > > >> buffer:
> > > > >>
> > > > >>         if ((unsigned long)ptr > TASK_SIZE && *fmt !=3D 'P' && *=
fmt
> > > > >> !=3D 'X' && *fmt !=3D 'K' && is_usercopy_object(buf)) {
> > > > >>                 printk(KERN_ALERT "grsec: kernel infoleak detect=
ed!
> > > > >> Please report this log to spender@grsecurity.net.\n");
> > > > >>                 dump_stack();
> > > > >>                 ptr =3D NULL;
> > > > >>         }
> > > > >>
> > > > >> The "is_usercopy_object()" test is something we can add, which is
> > > > >> testing for a new SLAB flag that is used to mark slab caches as
> > > > >> either used by user-space or not, which is done also through whi=
telisting.
> > > > >> (For more details on this, see:
> > > > >> http://www.openwall.com/lists/kernel-hardening/2016/06/08/10)
> > > > >>
> > > > >> Would you have time/interest to add the slab flags and
> > is_usercopy_object()?
> > > > >> The hardened usercopy part of the slab whitelisting can be
> > > > >> separate, since it likely needs a different usercopy interface to
> > > > >> sanely integrate with
> > > > upstream.
> > > > >
> > > > > A couple of questions off hand:
> > > > > 1. What about bss statics? I am assuming that when the loader
> > > > > loads up a
> > > > module
> > > > >      That it's dynamically allocating the .bss section or some eq=
uivalent. I
> > would
> > > > >      Also assume the method you describe would catch that, is tha=
t correct?
> > > > >
> > > > > 2. What about stack variables?
> > > >
> > > > It looks like what Grsecurity is doing is saying "if the address is
> > > > outside of user- space" (" > TASK_SIZE") and it's not whitelisted
> > > > ('P',
> > > > 'X') and it's going to land in a user-space buffer ("is_usercopy_ob=
ject()",
> > censor it.
> > > > ("K" is already censored -- they're just optimizing to avoid
> > > > re-checking it
> > > > needlessly.)
> > > >
> > > > So, in this case, all kernel memory, bss and stack included, would
> > > > be outside the user-space address range. (I am curious, however, how
> > > > to apply this to an architecture like s390 which has overlapping
> > > > address ranges... probably the TASK_SIZE test needs to use some
> > > > other "is in kernel memory" check that compiles down to TASK_SIZE on
> > > > non-s390, and DTRT on s390, etc.)
> > > >
> > >
> > > Before I go off and attempt this, I just have another dumb question t=
o ask:
> > >
> > > If the printk copies it into the kernel ring buffer, at some point,
> > > someone comes And asks for a copy into a userspace buffer either via =
dmesg or
> > proc/kmsg interfaces.
> >=20
> > IMO that's fine - I don't think pointers in the kernel ring buffer shou=
ld be
> > restricted.
> > Instead, access to dmesg / proc/kmsg should be restricted appropriately.
> >=20
> > I guess it depends on what the goal here is. Do we really want to stop =
root from
> > ever seeing a kernel pointer (in which case OOPS messages wouldn't real=
ly work
> > anymore)? My view is that restricting these interfaces so far that only=
 root can
> > access them and it's unlikely that root accidentally does so is suffici=
ent.
>=20
> I'm running Ubuntu 14.04, and perhaps they just got it wrong, but I can d=
o dmesg as
> an unprivileged user. I usually only work on Android, and its restricted =
to root. I'm
> not sure how other distro's set this up. Ideally, on non-debug systems, I=
'd like to
> see %p's filtered no matter what, I'd think opt in (whitelist) is ok. At =
least than,
> you did it intentionally. I verified that %p filtering gets us coredumps =
and kernel
> oops's have addresses.

On a system with panic_on_oops=3D0 and dmesg_restrict=3D0, if you want to l=
eak where the
kernel and data are to be able to exploit a memory corruption properly, you=
 can
probably often just trigger the bug, get the addresses from the resulting o=
ops, set up
the addresses in your exploit properly and retry the attack.


> Ideally on user images debug interfaces are closed, but I would like to m=
ake rogue %p's
> without opt in go away.


> I did a little research, and /proc/sys/kernel/dmesg_restrict seems to ena=
ble or disable this
> ability.
>=20
> After setting that to 1, it appears I got the restriction I wanted:
> $ dmesg
> dmesg: klogctl failed: Operation not permitted

Yup, exactly.


> One of my friends who does hypervisor development and is familiar with a =
few systems
> told me that Apple products just kill %p on production builds from logs.
>=20
> I'm kind of torn between the various approaches discussed on this thread.

--FhvelBhrd33NvMcY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX97wdAAoJED4KNFJOeCOo5ngQAIrORs0F/Xv/aAeJ+nM7I66C
XftPjL5KjYym2Lwf32UCmTuVof8OONoYyXcOdgD5x4AJ51gEjpsmLtfcQrcCVeAB
IzL2y1wQNjb+PcAnsySXJuacf8KP0QvJB7fZdNkRJCpXxWr4lt4O3dvJ+xWXBhlG
4b/ToWurXozkAZKv4h+6zidgXwVCU7l4JkN5NAnVNqogTgNOUmK7gZtnBAU5qI8u
gVYnEjvZxGT01WzvujUPYtQU0DjMbDOqO61GLMqfihRAE3mqj5oEIq3fISWEoAw8
KVlfWHFWCQ3IQyVcpDHxheSmfUdZB7dx9d1RLDxlIYnHPkNdxAKgq4Vg65s5kF/F
Mn19b5ue6ugEx2aYPorAnrl6WOWR1Du1xfya74ylNWe2tagEK4l79chcRA003hAU
tU7w/JXQo3jsYMWhAe6rzsr1g85fR4B6uzsx8nu6prFEG5RLxlNUawUjYuWCiJan
V+cbxuIQpSyChte2aa+QdCW98DXPbd2s11xZbI8nxjp7ZmpVKSJc6P5MylLfmwVn
k+qoBf/92IIFegGSmCgmNdRwAM4fBxIw0A00DF6HN3EKaMgHT0Ud5n77IY0v78P/
THA5ERFNoc1Y9S5I6/s+dSLKRZubvIVds3e6VjAZH1ZUX/9IkfUEWghCk5nY8Axu
d8Ph3GmrgoFBMUrLk1kS
=xPdi
-----END PGP SIGNATURE-----

--FhvelBhrd33NvMcY--
