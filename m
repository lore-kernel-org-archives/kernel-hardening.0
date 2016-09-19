Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 19 Sep 2016 14:59:54 +0100
From: James Hogan <james.hogan@imgtec.com>
Message-ID: <20160919135954.GJ18931@jhogan-linux.le.imgtec.org>
References: <20160916203819.GA29767@roeck-us.net>
 <20160916212720.GA18931@jhogan-linux.le.imgtec.org>
 <20160916213718.GA32384@roeck-us.net>
 <20160916233249.GB18931@jhogan-linux.le.imgtec.org>
 <CAGXu5jLYGcSq0Sdm4Mmd12dAJUbiyrkU-+4RwbHoo=OpWfvNFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="BOmey7/79ja+7F5w"
Content-Disposition: inline
In-Reply-To: <CAGXu5jLYGcSq0Sdm4Mmd12dAJUbiyrkU-+4RwbHoo=OpWfvNFg@mail.gmail.com>
Subject: [kernel-hardening] Re: qemu:metag image runtime failure in -next due to 'kthread: allow
 to cancel kthread work'
To: Kees Cook <keescook@chromium.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Petr Mladek <pmladek@suse.com>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, linux-metag@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

--BOmey7/79ja+7F5w
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 16, 2016 at 07:58:12PM -0700, Kees Cook wrote:
> On Fri, Sep 16, 2016 at 4:32 PM, James Hogan <james.hogan@imgtec.com> wro=
te:
> > On Fri, Sep 16, 2016 at 02:37:18PM -0700, Guenter Roeck wrote:
> >> On Fri, Sep 16, 2016 at 10:27:20PM +0100, James Hogan wrote:
> >> > On Fri, Sep 16, 2016 at 01:38:19PM -0700, Guenter Roeck wrote:
> >> > > Hi,
> >> > >
> >> > > I see the following runtime error in -next when running a metag qe=
mu emulation.
> >> > >
> >> > > [ ... ]
> >> > > workingset: timestamp_bits=3D30 max_order=3D16 bucket_order=3D0
> >> > > io scheduler noop registered (default)
> >> > > brd: module loaded
> >> > > Warning: unable to open an initial console.
> >> > > List of all partitions:
> >> > > 0100           16384 ram0  (driver?)
> >> > > No filesystem could mount root, tried:
> >> > > Kernel panic - not syncing: VFS: Unable to mount root fs on unknow=
n-block(1,0)
> >> > >
> >> > > An example for a complete log is at:
> >> > > http://kerneltests.org/builders/qemu-metag-next/builds/489/steps/q=
emubuildcommand/logs/stdio
> >> > >
> >> > > bisect points to commit ef98de028afde ("kthread: allow to cancel k=
thread work").
> >> > > I don't know (yet) if other architectures are affected. bisect log=
 is attached.
> >> > >
> >> > > The scripts to run this test are available at
> >> > > https://github.com/groeck/linux-build-test/tree/master/rootfs/meta=
g.
> >> > >
> >> > > Guenter
> >> >
> >> > Thanks Guenter,
> >> >
> >> > It appears to be related to the command line. After that commit the
> >> > command line is shown as empty (rather than your "rdinit=3D/sbin/init
> >> > doreboot"), but it can still be overridden in the config and then it
> >> > continues to work.
> >> >
> >> Weird.
> >
> > Previously the Elf had a single load program header:
> >
> > Program Headers:
> >   Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Ali=
gn
> >   LOAD           0x004000 0x40000000 0x40000000 0x34b304 0x376230 RWE 0=
x4000
> >   NOTE           0x1ecc08 0x401e8c08 0x401e8c08 0x00000 0x00000 R   0x4
> >
> > QEMU puts the args at 40376230, straight after the load region (unlike a
> > real Meta Linux bootloader).
> >
> > After the above commit the ELF gets two load program headers, with a
> > small alignment gap in the middle:
> >
> > Program Headers:
> >   Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Ali=
gn
> >   LOAD           0x004000 0x40000000 0x40000000 0x18f118 0x18f118 R E 0=
x4000
> >   LOAD           0x194000 0x40190000 0x40190000 0x1bd304 0x1e8230 RWE 0=
x4000
> >   NOTE           0x1eec08 0x401eac08 0x401eac08 0x00000 0x00000 R   0x4
> >
> > Here this version of QEMU puts the args at where it thinks the end of
> > the loaded image is, which is based on the number of bytes copied from
> > the ELF, i.e. the total MemSiz's, not taking into account the alignment
> > gap in between, so it puts them at 0x40377348.
> >
> > But of course:
> > 40378230 B ___bss_stop
> >
> > so it wipes them out while clearing bss during early init.
> >
> > Previously:
> > 4018ebd0 T __sdata
> > 4018f000 R ___start_rodata
> >
> > now:
> > 4018ed98 T __sdata
> > 40190000 R ___start_rodata
> >
> > So I'm thinking this may have been triggered by c74ba8b3480d ("arch:
> > Introduce post-init read-only memory").
> >
> > The hack below does indeed reduce it to a single load section and this
> > version of QEMU then succeeds:
> >
> > Program Headers:
> >   Type           Offset   VirtAddr   PhysAddr   FileSiz MemSiz  Flg Ali=
gn
> >   LOAD           0x004000 0x40000000 0x40000000 0x34d304 0x378230 RWE 0=
x4000
> >   NOTE           0x1eec88 0x401eac88 0x401eac88 0x00000 0x00000 R   0x4
> >
> > diff --git a/arch/metag/include/asm/cache.h b/arch/metag/include/asm/ca=
che.h
> > index a43b650cfdc0..b5c7364a94da 100644
> > --- a/arch/metag/include/asm/cache.h
> > +++ b/arch/metag/include/asm/cache.h
> > @@ -20,4 +20,6 @@
> >
> >  #define __read_mostly __attribute__((__section__(".data..read_mostly")=
))
> >
> > +#define __ro_after_init        __read_mostly
> > +
> >  #endif
> >
> > Kees: Is it expected to get multiple load headers like this since your
> > patch c74ba8b3480d ("arch: Introduce post-init read-only memory"),
> > depending on alignment of the read only section?
>=20
> I'm not expecting that, and I'm especially not expecting any LOAD to
> have "RWE" flags. It looks like metag's vmlinux.lds.S is using the
> common RO_DATA_SECTION, so that doesn't jump out at me as a reason for
> RO_AFTER_INIT_DATA to end up in the wrong place. Also the second LOAD
> in the ELF is really huge, so it's not just the RO_AFTER_INIT_DATA
> section (which is currently very small).
>=20
> Could the metag linker be failing to override the section flags when
> putting RO_AFTER_INIT_DATA into RO_DATA_SECTION and this cuts the LOAD
> in half? This smells like a linker glitch.

Where is that section flags override supposed to be happening?

The .rodata section is indeed becoming slightly larger to fit the
ptmx_fops __ro_after_init, and in the process changing from flag A to
flag WA (presumably means becoming writable).

This then appears to be hitting the condition in the linker whereby a
new segment is started if a writable section is found after a readonly
section, and the sections are on separate pages:

https://sourceware.org/git/?p=3Dbinutils.git;a=3Dblob;f=3Dbfd/elf.c;h=3D8df=
38ee37923c020994715f111a0ffc6bae83c8c;hb=3DHEAD#l3952

>=20
> However, since metag doesn't support CONFIG_DEBUG_RODATA, your above
> patch is likely correct. If metag marks memory read-only at kernel
> load time, it's doing it early enough that __ro_after_init will fail
> to work. If it never marks memory read-only, then __ro_after_init will
> have no effect.

Yes, metag doesn't make that memory read only yet, although it would be
possible to do so (maybe delaying the switch to 4MB pages until
afterwards).

Either way it doesn't sound that unreasonable to have multiple load
segments generated.

> (i.e. Both situations need the proposed patch).

purely to avoid the curious linker segment behaviour (which only trips
up that QEMU because its broken), or for other reasons too?

Thanks
James

>=20
> Probably the best solution for all architectures is to invent a new
> CONFIG_ARCH_HAS... to identify the style of kernel memory protection a
> given architecture has so that the default for __ro_after_init can be
> more sensible (and the warnings about mark_rodata_ro() can better
> reflect reality).
>=20
> -Kees
>=20
> --=20
> Kees Cook
> Nexus Security

--BOmey7/79ja+7F5w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJX3+9aAAoJEGwLaZPeOHZ6/ogQAJ7ayE6lItKF68R2A0PqdXPX
ZoslbSl+QRNVNIsVsbMXFx2lvZIMtGhjtTeZu8Bdei0UOkERBt04pdkuvno6HMtv
+n4YAIXhpX3c6s+y27a3DqRxWhW1rYoWvU+X7nAEdGrOmmI6WPmNN8pn3j9tSrRE
4LSeeF3biav9SI6fbeI2HgYYfKbQezVvXxJlDbfg4f9oJ5QDogtdU2ZZV99MRaT6
NwKR4pZy1/JWTCcq7HFspLer4D0FNqYZjDCBZ3tQ97gXc4LMUoJXdq265Urqmjqq
n/z1SEg2KLEhKt8OSgvm8gfp8oYa6brkj+jhZNvAFoqaPVUcJyY7vzsW5ygYUmo8
iGrRX7qfW/v7pBKoKmffzMY68gWKoWvTG/Ybgbb0D2R1pQnXqXs5i7MT/8gnAP8r
keiTekbVfZs7Xvn+7E+cDtxOWZOqyQKsx0RsBv+QS/H4zUwnNkrSceacOPtfLFGn
SHudd4wXfpiifE3aVvm/Pt8U/3Ifi/P3fOahVLOM+8CMnfprFHblEjn5OezOg1RU
DOIWItxrBNQpXXvLhhEcpyCB/5ETQ2c2MgkfxMqIEVle8McdBXxbJG6sqjQuK9hh
450wt6Fti/A5d9mx+pWJRVEIFAgiLAm04j3PmCCFDj4zx0AkQz8p0B0EGfj7e0Yt
58/SRYHZAZXvH5m7ylA8
=wWDL
-----END PGP SIGNATURE-----

--BOmey7/79ja+7F5w--
